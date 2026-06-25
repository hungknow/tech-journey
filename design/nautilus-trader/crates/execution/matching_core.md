# OrderMatchingCore

## Purpose

`OrderMatchingCore` is a common order matching core for the `OrderMatchingEngine` and other components. It provides a standardized mechanism for storing, retrieving, and matching orders with proper price-time priority ordering, mirroring real-venue architecture.

## Problem Solved

The matching core resolves several key problems:

1. **Order Storage and Retrieval**: Provides efficient storage and lookup of orders across bid/ask sides
2. **Price-Time Priority**: Ensures orders are matched in the correct order (best price first, then FIFO within price)
3. **Order Type Support**: Handles both limit orders and stop orders with different matching semantics
4. **Performance Optimization**: Uses efficient data structures to minimize memory allocation and lookup time
5. **Real-Venue Behavior**: Mimics real exchange architecture with dual book system (limit + stop per side)

## Technical Approach

### Data Structures

1. **BTreeMap for Price-Level Ordering**: Each side has two BTreeMaps (limit and stop books) keyed by price, providing O(log L) lookup where L is the number of distinct price levels
2. **SmallVec for Per-Level Buckets**: Orders at each price level are stored in SmallVec with inline capacity (4 orders), avoiding heap allocation for common cases
3. **AHashMap for Fast Order Lookup**: Index maps client_order_id to (side, BookKind, Price) for O(1) point queries

### Book Architecture

Each side has separate books mirroring real-venue design:

- **Limit Book**: `BTreeMap<Price, OrderBucket>` keyed by limit price. Holds plain `LIMIT` orders
- **Stop Book**: `BTreeMap<Price, OrderBucket>` keyed by trigger price. Holds `STOP_*`, `*_IF_TOUCHED`, and `TRAILING_STOP_*` orders
- **Pending Bucket**: `SmallVec<[RestingOrder; 2]>` for orders without a key (e.g., `MARKET_TO_LIMIT` before conversion)

### Ordering Invariant

Orders follow strict price-time priority:

- **Bid limits**: Best (highest) price first via `iter().rev()`
- **Ask limits**: Best (lowest) price first via `iter()`
- **Bid stops**: Closest trigger first via `iter()` (lowest trigger crosses first as ask climbs)
- **Ask stops**: Closest trigger first via `iter().rev()` (highest trigger crosses first as bid drops)

Within each price level, orders maintain FIFO ordering through insertion order in SmallVec.

## File Tree

```
matching_core/
└── mod.rs (1798 lines)
```

## Data Flow

```
Order Entry
    ↓
add_order(RestingOrder)
    ↓
Determine BookKind and Key via locate()
    ├─ is_stop()? → Stop Book (trigger_price as key)
    ├─ limit_price? → Limit Book (limit_price as key)
    └─ Neither? → Pending Bucket
    ↓
Insert into appropriate book + order_index
    ↓
┌─────────────────────────────────────┐
│  Order Storage                       │
│  ├─ bid_limits: BTreeMap            │
│  ├─ ask_limits: BTreeMap            │
│  ├─ bid_stops: BTreeMap             │
│  ├─ ask_stops: BTreeMap             │
│  ├─ pending_bid: SmallVec           │
│  └─ pending_ask: SmallVec           │
└─────────────────────────────────────┘
    ↓
Market Update (bid/ask/last)
    ↓
iterate() / iterate_bids() / iterate_asks()
    ↓
match_order() checks:
    ├─ is_stop()? → match_stop_order()
    │              └─ is_stop_matched()
    ├─ is_limit()? → match_limit_order()
    │               └─ is_limit_matched()
    └─ Neither → skip
    ↓
MatchAction Output
    ├─ FillLimit(client_order_id)
    └─ TriggerStop(client_order_id)
```

## Logic Flow

### Order Addition

1. **Determine Location**: `locate()` examines the order to determine:
   - If it has a trigger_price → Stop book, keyed by trigger_price
   - If it has a limit_price (but no trigger) → Limit book, keyed by limit_price
   - If neither → Pending bucket

2. **Insert**: Order is inserted into the appropriate bucket at its price level:
   ```rust
   book.entry(price).or_default().push(order)
   ```

3. **Index**: Order is indexed in `order_index` for fast lookup:
   ```rust
   order_index.insert(client_order_id, (side, location))
   ```

### Order Deletion

1. **Lookup**: Remove from index to get location:
   ```rust
   let (side, location) = order_index.remove(&client_order_id)?
   ```

2. **Remove**: Find and remove from appropriate book/pending bucket

3. **Cleanup**: If bucket becomes empty, remove the price level from BTreeMap

### Order Matching

#### Bid Side Iteration
```
iterate_bids()
    ↓
1. bid_limits.iter().rev()  // Best (highest) price first
   .flat_map(|(_, b)| b.iter())  // FIFO within level
    ↓
2. bid_stops.iter()  // Closest (lowest) trigger first
   .flat_map(|(_, b)| b.iter())  // FIFO within level
    ↓
3. pending_bid.iter()  // Orders without keys (skipped in matching)
    ↓
filter_map(|order| match_order(order))
```

#### Ask Side Iteration
```
iterate_asks()
    ↓
1. ask_limits.iter()  // Best (lowest) price first
   .flat_map(|(_, b)| b.iter())  // FIFO within level
    ↓
2. ask_stops.iter().rev()  // Closest (highest) trigger first
   .flat_map(|(_, b)| b.iter())  // FIFO within level
    ↓
3. pending_ask.iter()  // Orders without keys (skipped in matching)
    ↓
filter_map(|order| match_order(order))
```

#### Order Matching Logic

```rust
match_order(order)
    ↓
if order.is_stop():
    if !order.is_activated: return None
    if is_stop_matched(side, trigger_price):
        return TriggerStop(client_order_id)
    else: return None
elif order.is_limit():
    if is_limit_matched(side, limit_price):
        return FillLimit(client_order_id)
    else: return None
else:
    return None  // No prices set (e.g., MARKET_TO_LIMIT)
```

#### Limit Order Matching

- **Buy Limit**: Fillable if `ask <= limit_price`
- **Sell Limit**: Fillable if `bid >= limit_price`

Additional mode: `fill_limit_inside_spread` allows filling at-or-inside spread:
- **Buy**: `price >= bid` (requires both bid and ask present)
- **Sell**: `price <= ask` (requires both bid and ask present)

#### Stop Order Matching

- **Buy Stop**: Triggered if `ask >= trigger_price`
- **Sell Stop**: Triggered if `bid <= trigger_price`

#### Touch Order Matching

- **Buy If Touched**: Triggered if `ask <= trigger_price`
- **Sell If Touched**: Triggered if `bid >= trigger_price`

### Modify Semantics

The core does not provide in-place modify API. All modifications must be:
1. `delete_order()` to remove the original
2. `add_order()` to add the modified order

This matches real-venue behavior where:
- Price-changing modifies lose queue position
- Quantity-only modifies lose queue position (current limitation)

### Known Limitations

1. **Limits-then-stops Emission**: In real venues, stops trigger as price crosses them and only then aggress against limit book. The current core emits all matchable limits before stops, which cannot perfectly reconstruct temporal order for certain gap scenarios.

2. **Queue Position Loss**: Quantity-only modifies lose queue position since they require delete+re-add.

3. **Duplicate Inserts**: `add_order()` does not deduplicate; callers must ensure each `client_order_id` appears at most once.

## Performance Characteristics

- **Add Order**: O(log L) for BTreeMap lookup + O(1) for push to SmallVec
- **Delete Order**: O(1) for index lookup + O(B) for bucket scan/shift
- **Get Order**: O(1) for index lookup + O(B) for bucket scan
- **Iterate**: O(L * B) where L is price levels and B is average orders per level
- **Match Check**: O(1) constant time comparison with current bid/ask

Where L is typically small (10-100 levels) and B is very small (1-3 orders per level).

## Key Types

### RestingOrder

`RestingOrder` is a lightweight, copy-optimized representation of a passive order used for matching and trigger checking. It contains only the essential fields needed for order matching logic, making it significantly smaller than full `Order` objects and enabling efficient storage and copying in the matching core.

**Purpose:**

The primary design goals of `RestingOrder` are:

1. **Memory Efficiency**: Stores only the minimal data required for matching decisions (price comparison and trigger checking), avoiding the overhead of full order state (quantity, fees, timestamps, etc.)

2. **Performance**: Implements `Copy` trait, allowing it to be passed and stored without cloning overhead, which is critical for the high-frequency iteration patterns in matching

3. **Order Identity**: Maintains the `client_order_id` as the primary key for indexing and lookup in the matching core's order index

4. **Matching Semantics**: Provides methods like `is_stop()` and `is_limit()` to quickly determine matching behavior

**Field Details:**

```rust
pub struct RestingOrder {
    pub client_order_id: ClientOrderId,  // Unique order identifier
    pub order_side: OrderSideSpecified,  // BUY or SELL
    pub order_type: OrderType,           // Full order type (LIMIT, STOP_MARKET, STOP_LIMIT, etc.)
    pub trigger_price: Option<Price>,    // Stop trigger or touch price (for stop orders)
    pub limit_price: Option<Price>,      // Limit execution price (for limit orders)
    pub is_activated: bool,              // Trailing stop activation state
}
```

**Key Invariants:**

- `trigger_price.is_some()` indicates a stop-style order (stop book)
- `limit_price.is_some()` with `trigger_price.is_none()` indicates a limit order (limit book)
- Both prices `None` indicates an order in pending bucket (e.g., MARKET_TO_LIMIT before conversion)
- `is_activated` is only meaningful for trailing stops; other order types always use `true`

**Usage Patterns:**

1. **Storage**: Stored in `OrderBucket = SmallVec<[RestingOrder; 4]>` at each price level, avoiding heap allocation for typical 1-3 orders per level

2. **Creation**: Typically created via `From<&PassiveOrderAny>` conversion from full order objects, but can also be constructed directly via `RestingOrder::new()` for testing or special cases

3. **Matching**: Passed to `match_order()` for trigger/fill checking against current market prices

4. **Indexing**: Used as values in `order_index: AHashMap<ClientOrderId, (side, BookKind, Price)>` for O(1) lookup

5. **Iteration**: Yielded by iterators (`iterate_bids()`, `iterate_asks()`) for batch matching operations

**Design Trade-offs:**

- **Pros**: Minimal memory footprint, Copy semantics enable zero-copy iteration, simple matching logic
- **Cons**: Does not store quantity information (managed externally), separate from full order state (requires synchronization)

**Order Type Mapping:**

| Order Type | trigger_price | limit_price | Book Kind |
|------------|---------------|-------------|-----------|
| LIMIT | None | Some(price) | Limit |
| STOP_MARKET | Some(trigger) | None | Stop |
| STOP_LIMIT | Some(trigger) | Some(price) | Stop |
| MARKET_IF_TOUCHED | Some(trigger) | None | Stop |
| LIMIT_IF_TOUCHED | Some(trigger) | Some(price) | Stop |
| TRAILING_STOP_MARKET | Some(trigger) | None | Stop |
| TRAILING_STOP_LIMIT | Some(trigger) | Some(price) | Stop |
| MARKET_TO_LIMIT | None | None | Pending |

**Example:**

```rust
// Create from full order
let resting: RestingOrder = RestingOrder::from(&PassiveOrderAny::try_from(order).unwrap());

// Create directly (e.g., for testing)
let resting = RestingOrder::new(
    ClientOrderId::new("O-123"),
    OrderSideSpecified::Buy,
    OrderType::StopLimit,
    Some(Price::from("100.00")),  // trigger_price
    Some(Price::from("99.50")),   // limit_price
    false,                         // is_activated
);

// Check matching behavior
if resting.is_stop() {
    // Handle trigger checking
}
```

### MatchAction

Result of order matching:
```rust
pub enum MatchAction {
    FillLimit(ClientOrderId),
    TriggerStop(ClientOrderId),
}
```

### BookKind

Identifies which book an order belongs to:
```rust
enum BookKind {
    Limit,  // Plain LIMIT order
    Stop,   // Stop-style order
}
```

## Testing

Comprehensive test coverage includes:
- Order addition and deletion on both sides
- Reset functionality
- Limit and stop matching logic
- Price ordering verification
- FIFO ordering within price levels
- Mixed limit and stop order scenarios
- Pending order handling
- Modify semantics (queue position loss)
- Trailing stop activation states
- Stop-Limit routing to stop book
- Inside-spread filling mode