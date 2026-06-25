# Matching Engine

## Purpose

The matching engine module provides a complete order matching engine that simulates real trading venue behavior for backtesting and simulation purposes. It enables strategies to be tested against realistic order matching, fill simulation, and order book dynamics.

## Problem It Resolves

- **Realistic Order Execution**: Strategies need realistic execution simulation that accounts for order book depth, queue position, and liquidity consumption
- **Order Book Management**: Efficiently maintain and update order books from various market data sources (quotes, trades, order book deltas, depth10 snapshots)
- **Order Lifecycle Management**: Handle complete order lifecycles including submission, validation, modification, cancellation, and expiration
- **Fill Simulation**: Determine when and how orders get filled based on market conditions, order types, and configurable fill models
- **Multi-Order Type Support**: Support various order types (market, limit, stop, stop-limit, trailing-stop, market-if-touched, etc.)
- **Price-Time Priority Matching**: Implement proper matching algorithms that respect price and time priority
- **Queue Position Tracking**: Track order queue positions for L1 books to simulate realistic fill timing
- **Fee Calculation**: Compute trading fees based on configurable fee models
- **Instrument Expiration**: Handle instrument expiration and option exercise/cash settlement
- **Position Liquidation**: Support emergency position liquidation scenarios

## Techniques Used

### Core Data Structures

#### OrderMatchingCore
- **BTreeMap-based Order Books**: Separate limit and stop books for both bid and ask sides
    - Limit books keyed by limit price for O(log L) lookups
    - Stop books keyed by trigger price for O(log L) lookups
- **SmallVec Buckets**: Per-level order storage with inline capacity (4 orders) to avoid heap allocations for typical cases
- **AHashMap Index**: O(1) order lookup by client order ID across all books
- **Price-Time Priority**: Orders within each level maintained in insertion order (FIFO)

#### OrderMatchingEngine
- **OrderBook**: Efficient order book storage and delta application from `nautilus_model`
- **FillModel**: Configurable fill simulation (bar execution, trade execution, slippage models)
- **FeeModel**: Pluggable fee calculation (tiered, percentage, flat)
- **IdsGenerator**: Deterministic or random ID generation with caching
- **Cache**: Shared order and position cache from `nautilus_common`
- **Queue Position Maps**: Track queue positions, ahead quantity, and excess fills for L1 books
- **Liquidity Consumption Maps**: Track consumed liquidity per price level to prevent over-filling

### Matching Algorithm

#### Price-Time Priority Matching
- **Bid Side Processing**:
    - Iterate bid limits from best (highest) to worst price
    - Iterate bid stops from nearest trigger (lowest) to farthest
    - FIFO within each price level

- **Ask Side Processing**:
    - Iterate ask limits from best (lowest) to worst price
    - Iterate ask stops from nearest trigger (highest) to farthest
    - FIFO within each price level

#### Limit Order Matching

- **Cross Spread**: Buy limit fills if `ask <= limit_price`, Sell limit fills if `bid >= limit_price`
- **Inside Spread** (optional): Buy limit fills at or above bid, Sell limit fills at or below ask

#### Stop Order Matching

- **Stop Market/Limit**: Buy stop triggers if `ask >= stop_price`, Sell stop triggers if `bid <= stop_price`
- **If-Touched Orders**: Buy if-touched triggers if `ask <= trigger_price`, Sell if-touched triggers if `bid >= trigger_price`
- **Trailing Stop**: Dynamic stop price tracking with activation state

### Market Data Processing

#### Order Book Data
- **OrderBookDelta**: Incremental updates (Add, Update, Delete, Clear) for L2/L3 books
- **OrderBookDeltas**: Batch delta processing
- **OrderBookDepth10**: Full depth snapshots (top 10 levels)
- **QuoteTick**: Best bid/ask updates for L1 books

#### Trade Data
- **TradeTick**: Individual trade updates with aggressor side
- **Trade Execution**: Optional fill simulation on trade ticks
- **Liquidity Seeding**: Pre-consume liquidity from external trades to prevent double-filling

#### Bar Data
- **Bar Processing**: Synthetic tick generation from OHLC bars
- **Execution Modes**: Trade tick generation (Last/Mid price) or Quote tick generation (Bid/Ask price)
- **High/Low Ordering**: Configurable O-H-L-C or adaptive ordering based on price distance from open

### Queue Position Tracking (L1 Books)

#### Initialization
- **Snapshot Queue Position**: Track depth ahead of each order when order is added
- **Behind-BBO Detection**: Identify orders behind best bid/ask for delayed queue initialization

#### Updates
- **Quote Tick Updates**: Adjust queue positions when BBO changes
- **Trade Tick Consumption**: Decrement queue positions based on trade size and aggressor side
- **Crossed Order Resolution**: Resolve orders crossed by price moves (bid drops for buys, ask rises for sells)

#### Fill Allocation
- **Determine Fill Quantity**: Cap fills by available trade volume and queue excess
- **Shared Budget Allocation**: Distribute limited trade volume across multiple orders in queue
- **Excess Tracking**: Track unfulfilled quantity from partial fills

### Liquidity Consumption

#### Book-Level Tracking
- **Per-Price-Level Consumption**: Track consumed liquidity at each price level
- **Original Size Tracking**: Detect level changes and reset consumption on fresh data
- **Trade Seeding**: Pre-consume from external trades when book was updated after trade timestamp

#### Fill Adjustment
- **Available Quantity Calculation**: `available = original_size - consumed`
- **Fill Capping**: Adjust fills to respect available liquidity
- **Multiple Fill Handling**: Track consumption across multiple fills in single order

### Instrument Expiration Handling

#### General Instruments
- **Expiration Detection**: Check instrument expiration timestamp
- **Order Cancellation**: Cancel all open orders
- **Position Closing**: Generate synthetic market orders to close positions
- **Settlement Price**: Use provided settlement price or fallback to last known

#### Options
- **Exercise Determination**: Call if `spot > strike`, Put if `spot < strike`
- **Cash Settlement**: Index options with cash payout equal to intrinsic value
- **Physical Settlement**: Generate synthetic fills for both option and underlying

## File Tree

```
matching_engine/
├── mod.rs              # Module exports
├── engine.rs           # Main OrderMatchingEngine implementation
├── config.rs           # OrderMatchingEngineConfig configuration
├── ids_generator.rs    # Venue order ID, position ID, trade ID generation
└── adapter.rs          # OrderEngineAdapter for Rc<RefCell<>> wrapping
```

## Data Flow

### Initialization Flow

```
1. Create OrderMatchingEngine
   ├─ Create OrderBook
   ├─ Create OrderMatchingCore
   ├─ Create FillModel
   ├─ Create FeeModel
   ├─ Create IdsGenerator
   └─ Initialize state (market_status, queues, consumption maps)

2. Create OrderEngineAdapter
   └─ Wrap engine in Rc<RefCell<OrderMatchingEngine>>
```

### Market Data Processing Flow

```
Market Data Input
├─ OrderBookDelta / OrderBookDeltas
│  ├─ Validate price/size precision
│  ├─ Apply delta to OrderBook (skip for L1_MBP)
│  ├─ Update queue positions (if enabled)
│  └─ Call iterate() for order matching
├─ OrderBookDepth10
│  ├─ Validate price/size precision
│  ├─ Apply depth to OrderBook or update quote (L1_MBP)
│  ├─ Update queue positions (if enabled)
│  └─ Call iterate() for order matching
├─ QuoteTick
│  ├─ Validate price/size precision
│  ├─ Update OrderBook (L1_MBP only)
│  ├─ Update queue positions (if enabled)
│  └─ Call iterate() for order matching
└─ TradeTick
   ├─ Validate price/size precision
   ├─ Update OrderBook (L1_MBP only)
   ├─ Update bid/ask/last in OrderMatchingCore
   ├─ Seed liquidity consumption (if enabled)
   ├─ Update queue positions (if enabled)
   ├─ Call iterate() for order matching (if trade_execution enabled)
   └─ Restore non-aggressor side bid/ask

Bar Data Flow
├─ Bar
│  ├─ Validate price/size precision
│  ├─ Check bar execution enabled and L1_MBP book type
│  └─ Route by price_type:
│     ├─ Last/Mid → process_trade_ticks_from_bar()
│     │  ├─ Generate synthetic trade ticks at O, H, L, C
│     │  └─ Process each through TradeTick flow
│     └─ Bid/Ask → process_quote_ticks_from_bar()
│        ├─ Wait for paired bid/ask bars
│        ├─ Generate synthetic quote ticks at O, H, L, C
│        └─ Process each through QuoteTick flow
```

### Order Processing Flow

```
Order Submission
├─ process_order(order, account_id)
│  ├─ Check for duplicate (idempotent)
│  ├─ Check instrument expiration
│  ├─ Validate order:
│  │  ├─ Market status (open/closed)
│  │  ├─ Instrument activation/expiration
│  │  ├─ Contingent orders (OTO parent status)
│  │  ├─ Linked orders (OCO validity)
│  │  └─ Order type-specific checks
│  ├─ Reject if validation fails
│  ├─ Generate venue order ID via IdsGenerator
│  ├─ Generate position ID (hedging) or lookup (netting)
│  ├─ Add to Cache
│  ├─ Generate OrderInitialized event
│  ├─ Generate OrderSubmitted event
│  ├─ Market orders:
│  │  ├─ Generate OrderAccepted event
│  │  ├─ Fill via fill_market_order()
│  │  └─ Cancel remaining (if any)
│  └─ Passive orders:
│     ├─ Add to OrderMatchingCore
│     ├─ Snapshot queue position (if L1_MBP and queue_position enabled)
│     ├─ Generate OrderAccepted event
│     └─ Rest until triggered/filled

Order Matching (iterate loop)
├─ OrderMatchingCore.iterate()
│  ├─ Iterate bids (limits best first, then stops)
│  ├─ Iterate asks (limits best first, then stops)
│  └─ Return Vec<MatchAction>
├─ For each MatchAction:
│  ├─ FillLimit(client_order_id)
│  │  ├─ Lookup order in Cache
│  │  ├─ Calculate fill quantity (respect queue position, liquidity consumption)
│  │  ├─ Get fill prices from FillModel
│  │  ├─ Apply fills via apply_fills()
│  │  ├─ Delete from OrderMatchingCore
│  │  └─ Trigger contingent orders (OTO, OCO)
│  └─ TriggerStop(client_order_id)
│     ├─ Lookup order in Cache
│     ├─ Generate OrderTriggered event
│     ├─ Stop-Limit/Stop-Market → Convert and add to appropriate book
│     ├─ Market-If-Touched/Stop-Market → Fill via fill_market_order()
│     └─ Trailing-Stop → Update stop price
├─ Check GTD order expiration
├─ Check trailing stop activation
└─ Check instrument expiration

Fill Application (apply_fills)
├─ For each fill (price, quantity):
│  ├─ Calculate fees via FeeModel
│  ├─ Generate OrderFilled event
│  ├─ Update position (create new or update existing)
│  └─ Track partial fills
├─ Generate OrderUpdated event (if partial fill)
└─ Generate OrderCanceled event (if fully filled)
```

### Order Modification Flow

```
Order Modify Request
├─ process_modify_order(modify_order)
├─ Validate:
│  ├─ Order exists and is open
│  ├─ Reduce-only order not increasing quantity
│  └─ Trigger price for stop orders
├─ Generate OrderUpdated event (modify event)
├─ Delete from OrderMatchingCore
├─ Update order in Cache
├─ Add back to OrderMatchingCore with new parameters
├─ Re-snapshot queue position (if L1_MBP)
└─ Generate OrderModified event
```

### Order Cancellation Flow

```
Order Cancel Request
├─ process_cancel_order(cancel_order)
├─ Validate order exists
├─ For single order:
│  ├─ Delete from OrderMatchingCore
│  ├─ Update order in Cache
│  ├─ Generate OrderCanceled event
│  └─ Cancel linked orders (OCO)
└─ For batch/cancel all:
   ├─ Iterate all open orders
   ├─ Filter by criteria (instrument, strategy, etc.)
   └─ Cancel each matching order
```

### Position Liquidation Flow

```
Liquidation Triggered
├─ liquidate_open_positions(ts_now, cancel_open_orders, settlement_currency)
├─ Check settlement currency matches instrument
├─ Cancel open orders (if enabled)
├─ Iterate all open positions:
│  ├─ Determine closing side (opposite of position side)
│  ├─ Check price available (best bid/ask or settlement price)
│  ├─ Generate synthetic market order:
│  │  ├─ Client order ID: "LIQUIDATION-{venue}-{uuid}"
│  │  ├─ TimeInForce: IOC
│  │  ├─ Reduce-only: true
│  │  └─ Tags: ["LIQUIDATION_{venue}_CLOSE"]
│  ├─ Generate venue order ID via IdsGenerator
│  ├─ Add to Cache
│  ├─ Generate OrderInitialized event
│  ├─ Generate OrderSubmitted event
│  ├─ Generate OrderAccepted event
│  └─ Fill via fill_market_order() (uses fill model for slippage)
```

### Instrument Expiration Flow

```
Expiration Check (triggered by market data or explicit call)
├─ check_instrument_expiration(timestamp_ns)
├─ Check if already processed
├─ Check expiration timestamp or instrument close event
├─ For general instruments:
│  ├─ Mark expiration processed
│  ├─ Cancel all open orders
│  └─ Close all positions:
│     ├─ Generate synthetic market order for each position
│     ├─ Use settlement price or fallback to close price from event
│     ├─ If no price available → fill via fill_market_order()
│     └─ Apply fills
└─ For options (OptionContract, CryptoOption):
   ├─ Determine if should exercise (ITM)
   ├─ For ITM options:
   │  ├─ Index instruments → Cash settlement
   │  │  └─ Create synthetic fill at intrinsic value
   │  └─ Physical instruments → Physical settlement
   │     ├─ Close option position (synthetic fill)
   │     └─ Open/close underlying position (synthetic fills)
   └─ For OTM options:
      └─ Create synthetic fill at zero price
```

## Logic Flow

### Main Event Loop

The matching engine follows a reactive event-driven pattern:

```
- Receive market data (quote, trade, order book delta, bar)
- Update internal state (order book, bid/ask/last)
- Trigger matching iteration
- Process match actions (fills, triggers)
- Emit order events
- Repeat for next market data update
```

### Matching Engine State Machine

```
OrderMatchingEngine States:
├─ Market Status: Open | Closed | Paused | Suspended
├─ Expiration State: Active | Pending Resolution | Processed
├─ Order Book: Updated via deltas/quotes/trades
├─ Queue Positions: Tracked per order (L1 only)
├─ Liquidity Consumption: Tracked per price level
├─ Target Prices: For order routing (target_bid, target_ask, target_last)
├─ Bar State: Last processed bid/ask bars for bar execution
└─ Cache: Orders, positions, IDs
```

### Order Lifecycle

```
OrderCreated → Submitted → Accepted → [Triggered] → (Filled | Cancelled | Rejected | Expired)
                                  ↑                              │
                                  └── TrailingStop update ───────┘

Order Status Transitions:
├─ Initialized: Order created, not yet submitted
├─ Submitted: Order sent to venue
├─ Rejected: Order rejected by venue (validation failed)
├─ Accepted: Order accepted and resting
├─ PendingCancel: Cancel request submitted
├─ PendingUpdate: Modify request submitted
├─ Cancelled: Order cancelled (no or partial fill)
├─ Expired: Order expired (GTD order or instrument)
├─ Triggered: Stop order triggered
├─ PendingNew: OTO child order pending parent trigger
├─ Updated: Order modified
├─ PartiallyFilled: Order partially filled
└─ Filled: Order completely filled
```

### Contingent Order Processing

```
OTO (One-Triggers-Other):
├─ Parent order submitted and accepted
├─ Child order in PendingNew state
├─ Parent fully filled → Child order submitted
└─ Parent rejected/cancelled → Child order cancelled

OCO (One-Cancels-Other):
├─ Both orders submitted and accepted
├─ One order fills → Other cancelled automatically
└─ One order cancelled → Other remains active
```

### Queue Position Logic (L1 Books)

```
Order Addition:
├─ Get quantity at order's price level from order book
├─ If L1_MBP and quantity == 0 and price behind BBO:
│  └─ Mark as pending (deferred queue snapshot)
└─ Otherwise:
   └─ Store (price_raw, quantity_ahead) in queue_ahead map

Quote Tick Update:
├─ Detect price moves (bid drops for buys, ask rises for sells)
├─ For each order at affected price:
│  ├─ If price crossed: Set queue_ahead to 0
│  └─ If price unchanged and size decreased: Cap queue_ahead
└─ Resolve pending orders when BBO reaches their price

Trade Tick Update:
├─ Identify orders at trade price with queue_ahead > 0
├─ Sort orders by queue position (earliest first)
├─ Allocate trade volume across orders:
│  ├─ Consume gap between positions
│  ├─ Fill up to order's leaves_qty
│  └─ Track excess for next trade
└─ Update queue_ahead (set to 0 for filled orders)

Fill Determination:
├─ If order in queue_pending: Block fill (awaiting snapshot)
├─ If queue_ahead > 0: Block fill (orders ahead)
├─ Calculate available = min(leaves_qty, trade_remaining, queue_excess)
└─ If available == 0: Block fill
```

### Liquidity Consumption Logic

```
Liquidity Seeding (from external trades):
├─ If book updated after trade timestamp: Skip (already reflected)
├─ Identify levels up to trade price (buy trades → asks, sell trades → bids)
├─ For each level:
│  ├─ Get current level size
│  ├─ Stale level: Reset consumption
│  ├─ Available = level_size - consumed
│  ├─ Consume = min(remaining, available)
│  └─ Update consumption and remaining
└─ Prevents over-filling from simulated orders

Fill Adjustment (for simulated orders):
├─ For each fill price level:
│  ├─ Get current level size from order book
│  ├─ Get original_size and consumed from tracking map
│  ├─ If level_size changed: Reset consumption (fresh data)
│  ├─ Available = original_size - consumed
│  ├─ AdjustedQty = min(fill_qty, available, leaves_qty)
│  ├─ Update consumption
│  └─ Use adjusted_qty for fill
└─ Ensures total fills ≤ original book depth
```

### Configuration Options

```rust
OrderMatchingEngineConfig:
├─ bar_execution: bool              // Enable bar-based fill simulation
├─ bar_adaptive_high_low_ordering: bool  // Adaptive O-H-L-C ordering
├─ trade_execution: bool            // Enable trade-based fill simulation
├─ liquidity_consumption: bool      // Track and respect liquidity limits
├─ reject_stop_orders: bool         // Reject market stop orders (reject marketable)
├─ support_gtd_orders: bool         // Support Good-Til-Date orders
├─ support_contingent_orders: bool  // Support OTO/OCO orders
├─ use_position_ids: bool           // Generate position IDs (hedging mode)
├─ use_random_ids: bool             // Use random IDs vs deterministic
├─ use_reduce_only: bool            // Support reduce-only orders
├─ use_market_order_acks: bool      // Emit ack events for market orders
├─ queue_position: bool             // Track queue positions (L1 only)
├─ oto_full_trigger: bool           // OTO triggers on partial fill
└─ price_protection_points: Option<u32>  // Max ticks away from mid-price
```

## Key Algorithms

### Fill Price Calculation

The fill model determines fill prices based on order type and market conditions:

```rust
// Market orders: Fill against best bid/ask or slippage model
fill_price = match order_side {
    Buy => ask_price ± slippage,
    Sell => bid_price ± slippage,
}

// Limit orders: Fill at limit or better
fill_price = min(limit_price, ask_price) // for buy orders

// Stop orders: Trigger then fill like market or limit order
if triggered {
    if stop_limit {
        fill_price = min(limit_price, current_market)
    } else {
        fill_price = current_market ± slippage
    }
}
```

### Fee Calculation

```rust
fee = match fee_model {
    // Percentage of notional value
    Percentage(rate) => price * quantity * rate,

    // Fixed per-lot fee
    PerLot(fee_per_lot) => fee_per_lot * (quantity / lot_size),

    // Tiered based on volume
    Tiered(tiers) => calculate_tiered_fee(volume, tiers),

    // Flat fee per order
    Flat(fee) => fee,
}
```

### Trade ID Generation (FNV-1a Hash)

```rust
fn generate_trade_id(venue, raw_id, ts_init) -> TradeId {
    // FNV-1a 64-bit hash
    hash = FNV_OFFSET_BASIS
    for byte in venue.as_str().bytes() + raw_id.to_le_bytes() + ts_init.to_le_bytes() {
        hash ^= byte
        hash = hash.wrapping_mul(FNV_PRIME)
    }
    counter += 1
    TradeId::from(format!("T-{hash:016x}-{counter:03}"))
}
```

This ensures deterministic trade IDs within a session while handling resets gracefully.

## Performance Considerations

- **O(log L) Operations**: Order add/delete is O(log L) for BTreeMap lookup plus O(B) for bucket operations
- **Inline Allocation**: SmallVec with 4 inline slots avoids heap allocation for typical 1-3 orders per level
- **Hash-Based Lookup**: AHashMap provides O(1) order lookups by client order ID
- **Precision Mismatch Handling**: Rate-limited logging to prevent spam on instrument updates
- **Queue Position Optimization**: Only enabled for L1 books to minimize overhead
- **Liquidity Consumption**: Optional feature for backtesting accuracy vs performance tradeoff
- **Event Dispatch**: Supports both direct message bus and async handler routing to avoid RefCell re-entracy

## Testing

The module includes comprehensive unit tests covering:

- Order matching across all order types
- Queue position tracking and fill allocation
- Liquidity consumption and fill adjustment
- ID generation (deterministic and random modes)
- Order lifecycle (submit, modify, cancel, expire)
- Contingent orders (OTO, OCO)
- Option expiration and exercise
- Position liquidation
- Price-time priority invariant
- Edge cases (stale data, precision mismatches, missing market data)

Tests are written using `rstest` for parameterized test cases and ensure parity between Rust and Python implementations.