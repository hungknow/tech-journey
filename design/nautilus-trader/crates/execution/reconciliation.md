# Execution State Reconciliation

## Purpose

The reconciliation module provides pure functions for aligning the engine's local order, fill, and position state with the venue's reported state. It operates at two key points:

1. **Startup reconciliation**: Processes `ExecutionMassStatus` to reconstruct missing position history
2. **Runtime reconciliation**: Continuously checks open orders and positions during operation

The module ensures deterministic behavior across restarts, allowing proper deduplication of reconciliation events during replay.

## Problem Resolved

### State Divergence Issues

When trading systems connect to venues, several scenarios can cause state divergence:

- **Connection interruptions**: Missed fills while disconnected
- **Partial reconciliation windows**: Venue APIs that return limited fill history
- **External order discovery**: Orders placed outside the system that appear at startup
- **Event reordering**: Network delays causing out-of-order event arrival
- **Missing lifecycle events**: Incomplete sequences of order status changes

### Specific Problems

1. **Incomplete position history**: Fills retrieved don't fully account for current venue position
2. **Missing opening fills**: Position reconciliation window starts after initial position was opened
3. **Position flips**: Long→Short or Short→Long transitions without proper fill accounting
4. **Duplicate fill processing**: Replayed reconciliation events creating duplicate fills
5. **Price discrepancies**: Average prices not matching due to missing fills
6. **Quantity mismatches**: Local filled quantity differing from venue reported quantity

## Techniques Used

### 1. Deterministic ID Generation

Uses FNV-1a 64-bit hashing to create stable IDs that survive restarts:

- **Trade IDs**: Hashed from fill fields, instrument, account, and timestamps
- **Venue Order IDs**: Hashed similarly for synthetic orders
- **Format**: `S-{hex_timestamp}-{hash_suffix}`

This ensures replayed reconciliation events generate identical IDs, allowing the duplicate-fill sanitizer to dedupe them.

### 2. Partial Window Reconstruction

Analyzes fills and venue position to detect incomplete lifecycles:

- Simulates position from available fills using netting logic
- Detects zero-crossings (Long→Flat→Short transitions)
- Compares simulated position against venue snapshot
- Synthesizes missing opening fills when needed
- Filters to current lifecycle after last zero-crossing

### 3. Position Simulation

Implements netting logic to track position state:

```rust
// Accumulation: same direction
value += fill.qty * fill.px

// Partial close: reduce proportionally
value *= 1 - (close_qty / abs(current_qty))

// Full close and flip: reset value
qty = direction * remaining_qty
value = remaining_qty * fill.px
```

### 4. Tolerance-Based Matching

Allows small differences in position reconciliation:

- Default tolerance: 0.01% (0.0001)
- Single-unit tolerance for quantity precision noise
- Prevents spurious warnings due to floating-point arithmetic

### 5. Venue-Temporal Event Sequencing

Ensures events are emitted in correct order:

1. `OrderAccepted` (if missing)
2. `OrderUpdated` (for confirmed amendments)
3. Status event (`Canceled`, `Expired`, `Rejected`, `Triggered`, or fill event)

This prevents issues where fills would incorrectly close orders with stale quantities.

## File Tree

```
crates/execution/src/reconciliation/
├── mod.rs           # Public API and module documentation
├── types.rs         # Shared value types (FillSnapshot, VenuePositionSnapshot, etc.)
├── ids.rs           # Deterministic ID generation (TradeId, VenueOrderId)
├── orders.rs        # Order and fill reconciliation logic
├── positions.rs     # Position reconciliation and simulation
├── tests.rs         # Unit tests
└── proptests.rs     # Property-based tests
```

## Data Flow

### Startup Reconciliation Flow

```
ExecutionMassStatus
    ├── PositionReports
    ├── OrderReports
    └── FillReports
           ↓
    extract_fills_for_instrument()
           ↓
    [FillSnapshot] (chronologically sorted)
           ↓
    adjust_fills_for_partial_window()
           ├── simulate_position()
           ├── detect_zero_crossings()
           └── check_position_match()
           ↓
    FillAdjustmentResult
    ├── NoAdjustment → Return unchanged
    ├── AddSyntheticOpening → Create synthetic fill
    ├── ReplaceCurrentLifecycle → Replace with single fill
    └── FilterToCurrentLifecycle → Remove old lifecycle fills
           ↓
    create_synthetic_order_report()
    create_synthetic_fill_report()
           ↓
    ReconciliationResult {
        orders: IndexMap<VenueOrderId, OrderStatusReport>,
        fills: IndexMap<VenueOrderId, Vec<FillReport>>,
    }
```

### Runtime Order Reconciliation Flow

```
OrderAny (local state)
    +
OrderStatusReport (venue report)
    +
InstrumentAny
    +
ts_now
           ↓
    generate_reconciliation_order_events()
           ├── should_accept_before_reconciliation()
           ├── create_reconciliation_accepted()
           ├── should_reconciliation_update()
           ├── create_reconciliation_updated()
           └── reconcile_order_report()
                  ├── OrderStatus::Accepted → create_reconciliation_accepted()
                  ├── OrderStatus::Rejected → create_reconciliation_rejected()
                  ├── OrderStatus::Triggered → create_reconciliation_triggered()
                  ├── OrderStatus::Canceled → create_reconciliation_canceled()
                  ├── OrderStatus::Expired → create_reconciliation_expired()
                  ├── OrderStatus::Filled/PartiallyFilled → reconcile_fill_quantity_mismatch()
                  │    └── create_incremental_inferred_fill()
                  └── PendingUpdate/PendingCancel → None
           ↓
    Vec<OrderEventAny>
```

### Fill Reconciliation Flow

```
OrderAny (local state)
    +
FillReport (venue fill)
    +
InstrumentAny
    +
allow_overfills (bool)
           ↓
    reconcile_fill_report()
           ├── Check duplicate trade_id → None
           ├── Check overfill → None or warn
           └── Create OrderFilled
           ↓
    OrderEventAny::Filled
```

## Logic Flow

### Position Reconciliation Logic

#### 1. Zero-Crossing Detection

```
running_qty = 0
for each fill in chronological order:
    prev_qty = running_qty
    running_qty += direction * fill.qty

    if prev_qty != 0:
        if running_qty == 0:
            // Landed exactly on FLAT
            zero_crossings.push(fill.ts_event)
        elif sign(prev_qty) != sign(running_qty):
            // Flipped without landing on zero
            zero_crossings.push(fill.ts_event)
```

#### 2. Lifecycle Separation

When zero-crossings exist:
- Find last zero-crossing that lands on FLAT
- Separate fills into "old lifecycles" and "current lifecycle"
- Current lifecycle = fills after last FLAT crossing
- Simulate position from current lifecycle fills only
- If matches venue: filter out old lifecycles
- If doesn't match: replace with synthetic fill

#### 3. Synthetic Fill Calculation

For single lifecycle with missing opening fill:

```
current_qty = simulate_position(available_fills)
venue_qty = venue_report.qty (with sign)

if current_qty == venue_qty:
    // No adjustment needed
    return NoAdjustment

// Calculate what opening fill is needed
qty_diff = venue_qty - current_qty
reconciliation_px = calculate_reconciliation_price(
    current_qty,
    current_avg_px,
    venue_qty,
    venue_avg_px
)

create synthetic fill:
    qty = abs(qty_diff)
    px = reconciliation_px
    side = if qty_diff > 0 then Buy else Sell
    ts_event = first_fill.ts_event - 1
```

#### 4. Reconciliation Price Calculation

```rust
calculate_reconciliation_price(current_qty, current_avg_px, target_qty, target_avg_px):
    qty_diff = target_qty - current_qty

    if qty_diff == 0: return None
    if target_qty == 0: return current_avg_px  // Closing to flat
    if current_qty == 0: return target_avg_px  // Opening from flat

    // Check for flip (sign change)
    if sign(current_qty) != sign(target_qty):
        return target_avg_px  // Flips reset value in simulation

    // Accumulation/reduction: weighted average
    // (target_qty * target_avg_px) = (current_qty * current_avg_px) + (qty_diff * recon_px)
    target_value = target_qty * target_avg_px
    current_value = current_qty * current_avg_px
    diff_value = target_value - current_value
    recon_px = diff_value / qty_diff

    if recon_px > 0: return Some(recon_px)
    return None
```

### Order Reconciliation Logic

#### 1. Venue-Temporal Sequencing

```
working = order.clone()
events = []

// Step 1: Accept if needed
if order.status == Submitted && report.status != Rejected:
    working.apply(OrderAccepted)
    events.push(OrderAccepted)

// Step 2: Update if confirmed
if report.is_confirmed() && working.accepts_amendment():
    if should_reconciliation_update(working, report):
        working.apply(OrderUpdated)
        events.push(OrderUpdated)

// Step 3: Reconcile final state
if final_event = reconcile_order_report(working, report):
    events.push(final_event)

return events
```

#### 2. Fill Quantity Mismatch Handling

```
if report.filled_qty < order.filled_qty:
    // Venue below cached - preserve cached state
    // Check for precision noise tolerance
    if is_within_tolerance(report.filled_qty, order.filled_qty):
        return None
    // Log warning, preserve cached

if report.filled_qty > order.filled_qty:
    // Venue has more fills
    if order.is_closed():
        // Skip to avoid invalid state
        return None

    // Generate inferred fill for difference
    last_qty = report.filled_qty - order.filled_qty
    last_px = calculate_incremental_fill_price()
    return create_incremental_inferred_fill()

if quantities match but status differs:
    // Quantity same but status changed (e.g. partial cancel)
    if should_reconciliation_update():
        return create_reconciliation_updated()
```

#### 3. Inferred Fill Price Calculation

For incremental fills (venue reports more filled quantity):

```rust
calculate_incremental_fill_price():
    if order.filled_qty == 0:
        // First fill
        return report.avg_px or report.price or order.price

    // Subsequent fill - use weighted average
    if report.avg_px:
        report_notional = report.avg_px * report.filled_qty
        order_notional = order.avg_px * order.filled_qty
        last_notional = report_notional - order_notional
        last_qty = report.filled_qty - order.filled_qty
        return last_notional / last_qty

    return report.price or order.price
```

### Invariants Maintained

1. **Position quantity accuracy**: Final position matches venue within instrument precision
2. **Average price accuracy**: Position average price matches within tolerance (default 0.01%)
3. **PnL preservation**: Generated fills maintain correct unrealized PnL
4. **Deterministic IDs**: Synthetic IDs are stable across restarts for deduplication
5. **Temporal ordering**: Events emitted in venue-temporal sequence
6. **No overfills**: Fill reconciliation prevents overfills unless explicitly allowed

## Public Entry Points

### Position Reconciliation

- `process_mass_status_for_reconciliation()` - Partial-window fill reconstruction at startup
- `check_position_reconciliation()` - Final quantity/price tolerance check
- `calculate_reconciliation_price()` - Price needed for reconciliation order

### Order Reconciliation

- `generate_reconciliation_order_events()` - Venue-temporal event sequence for report
- `reconcile_order_report()` - Core order-state reconciliation
- `reconcile_fill_report()` - Apply venue fill with deduplication

### External Order Support

- `generate_external_order_status_events()` - Synthesize events for external order

### ID Generation

- `create_inferred_reconciliation_trade_id()` - Deterministic trade ID for reconciliation fills
- `create_position_reconciliation_venue_order_id()` - Deterministic venue order ID for position reconciliation

## Key Concepts

### Partial Reconciliation Window

Many venue APIs don't return full fill history. When connecting, you might only get:
- Current position (quantity, average price)
- Last N fills (e.g., last 100 fills)
- Active orders

If the position was opened long ago, the fills in the window won't account for the full position. The reconciliation module detects this and synthesizes the missing opening fill.

### Zero-Crossing and Lifecycles

A position lifecycle is the sequence of fills from opening to closing (FLAT):

```
Lifecycle 1: Buy 10 @ 100 → Sell 10 @ 105 (FLAT)
Lifecycle 2: Sell 5 @ 110 → Buy 5 @ 115 (FLAT)
```

When fills span multiple lifecycles, the module:
1. Detects zero-crossings (FLAT points)
2. Identifies current lifecycle (fills after last FLAT)
3. Filters out old lifecycles if current matches venue
4. Otherwise synthesizes a fill representing the current lifecycle

### Tolerance Handling

Financial systems have precision requirements:
- Size precision: typically 8 decimal places for crypto, 2 for equities
- Price precision: varies by instrument
- Floating-point arithmetic can introduce small errors

The reconciliation module uses single-unit tolerance for quantity comparison to avoid spurious warnings from precision noise while still detecting genuine discrepancies.