# Order Emulator

## Purpose

The Order Emulator is a high-performance in-memory order emulation system designed to simulate the execution behavior of complex order types that are not natively supported by exchange venues. It provides client-side emulation for advanced order types, enabling traders to use sophisticated order strategies without relying on exchange-specific order types.

## Problem Resolved

Many cryptocurrency exchanges and trading venues lack support for advanced order types such as:
- **Stop orders** (StopMarket, StopLimit)
- **Stop-If-Touched orders** (MarketIfTouched, LimitIfTouched)
- **Trailing Stop orders** (TrailingStopMarket, TrailingStopLimit)
- **Contingent orders** (One-Cancels-Other, One-Triggers-Other)

The Order Emulator solves this problem by:
1. Emulating these order types locally on the client side
2. Subscribing to market data (quotes/trades) to monitor trigger conditions
3. Automatically releasing market/limit orders to the exchange when conditions are met
4. Managing order lifecycle and state transitions
5. Handling order lists and contingency relationships

## Techniques Used

### 1. Order Matching Core

The emulator uses an efficient order matching core (`OrderMatchingCore`) that maintains separate order books for each instrument:

- **Limit Book**: BTreeMap<Price, OrderBucket> keyed by limit price
- **Stop Book**: BTreeMap<Price, OrderBucket> keyed by trigger price
- **Pending Bucket**: SmallVec for orders without keys (e.g., MarketToLimit before conversion)

Key features:
- **Price-Time Priority**: Orders matched in FIFO order within price levels
- **Bid Processing**: Best (highest) price first via `iter().rev()`
- **Ask Processing**: Best (lowest) price first via `iter()`
- **Stop Processing**: Closest trigger first (bids: lowest trigger, asks: highest trigger)
- **O(log L + B)** complexity where L is distinct price levels and B is orders per level
- **SmallVec optimization**: Inline capacity for 4 orders per level before heap allocation

### 2. Trigger Types

The emulator supports multiple trigger types for order activation:

- **BidAsk**: Uses bid/ask prices for trigger evaluation
- **LastPrice**: Uses last traded price for trigger evaluation
- **Default**: Falls back to BidAsk behavior
- **LastOrBidAsk**: Combines both for best trigger detection

### 3. Market Data Subscription

Automatic subscription to required market data based on trigger type:
- BidAsk triggers → Subscribe to QuoteTick
- LastPrice triggers → Subscribe to TradeTick

### 4. Trailing Stop Calculation

Specialized algorithms for trailing stop orders (`trailing.rs`):
- **Price offset**: Fixed price difference
- **Basis points**: Percentage-based offset
- **Ticks**: Tick-size based offset

The calculation ensures triggers only move in the favorable direction:
- Buy orders: Trigger decreases as price decreases
- Sell orders: Trigger increases as price increases

### 5. Order Lifecycle Management

Integration with OrderManager for comprehensive lifecycle handling:
- Command caching for order submission
- State transition tracking
- Event publishing to message bus
- Re-entrant event handling protection

### 6. Contingency Handling

Support for complex order relationships:
- **OTO (One-Triggers-Other)**: Parent order triggers child orders
- **OCO (One-Cancels-Other)**: Orders cancel when one fills
- **OUO (One-Updates-Other)**: Order updates trigger updates to linked orders

## File Tree

```
crates/execution/src/order_emulator/
├── mod.rs              # Module declarations
├── emulator.rs         # Main OrderEmulator implementation (2521 lines)
├── handlers.rs         # Message bus event handlers
├── adapter.rs          # Public adapter interface
└── config.rs           # Configuration struct

Related modules:
├── matching_core/
│   └── mod.rs         # OrderMatchingCore implementation
├── trailing.rs         # Trailing stop calculation algorithms
└── order_manager/
    └── mod.rs         # Order lifecycle management
```

## Data Flow

### 1. Order Submission Flow

```
Strategy/Client
    ↓
TradingCommand::SubmitOrder
    ↓
OrderEmulator.execute()
    ↓
handle_submit_order()
    ├─→ Get order from cache
    ├─→ Validate emulation trigger
    ├─→ Get/create matching core
    ├─→ Update trailing stop (if applicable)
    ├─→ Check immediate marketability
    ├─→ Subscribe to market data (if needed)
    ├─→ Add order to matching core
    ├─→ Publish OrderEmulated event
    └─→ Hold order for trigger evaluation
```

### 2. Market Data Processing Flow

```
Data Engine
    ↓
QuoteTick / TradeTick
    ↓
Message bus (quotes.* / trades.* topic)
    ↓
QuoteTickHandler / TradeTickHandler
    ↓
on_quote_tick() / on_trade_tick()
    ├─→ Update matching core prices
    ├─→ Iterate orders
    └─→ Process match actions
         ├─→ FillLimit → fill_limit_order()
         └─→ TriggerStop → trigger_stop_order()
```

### 3. Order Trigger Flow

```
Matching Core detects trigger
    ↓
MatchAction::TriggerStop or MatchAction::FillLimit
    ↓
trigger_stop_order() / fill_limit_order()
    ├─→ Validate market data availability
    ├─→ Pop submit order command
    ├─→ Delete from matching core
    ├─→ Transform order (set emulation_trigger to NoTrigger)
    ├─→ Update cache with transformed order
    ├─→ Publish OrderReleased event
    └─→ Send to execution engine or algorithm
         ├─→ Execution Engine: send_exec_command()
         └─→ Algorithm: send_algo_command()
```

### 4. Order Cancellation Flow

```
TradingCommand::CancelOrder
    ↓
handle_cancel_order()
    ├─→ Check if order in emulator
    ├─→ If in emulator: cancel locally
    │   ├─→ Remove from matching core
    │   ├─→ Remove command cache
    │   ├─→ Set pending_cancel_local
    │   └─→ Publish OrderCanceled event
    └─→ If not in emulator: forward to execution engine
         └─→ send_exec_command(TradingCommand::CancelOrder)
```

## Logic Flow

### Initialization Flow

1. **Creation**: `OrderEmulator::new(clock, cache)` initializes core components
2. **Handler Registration**: `register_msgbus_handlers()` sets up message bus endpoints
   - TradingCommand endpoint for order operations
   - QuoteTick and TradeTick handlers for market data
   - OrderEvent handler for re-entrant event handling
3. **Start**: `start()` calls `on_start()` to reactivate emulated orders from cache

### Order Processing Flow

#### Stop Order Processing

```
Stop order submitted
    ↓
Validate trigger type (Default/BidAsk/LastPrice)
    ↓
Get or create matching core for trigger instrument
    ↓
Subscribe to market data based on trigger type
    ↓
Add RestingOrder to stop book
    ↓
Publish OrderEmulated event
    ↓
Wait for market data updates
    ↓
On market data update:
    ├─→ Update matching core prices
    ├─→ Check stop condition (BUY: ask >= trigger, SELL: bid <= trigger)
    ├─→ If triggered:
    │   ├─→ Transform to Market or Limit order
    │   ├─→ Publish OrderReleased event
    │   └─→ Submit to execution engine
    └─→ If not triggered:
        └─→ Continue monitoring
```

#### Trailing Stop Processing

```
Trailing stop order submitted
    ↓
Calculate initial trigger price
    ↓
Add to matching core (activated = true if market data available)
    ↓
On each market data update:
    ├─→ Call trailing_stop_calculate()
    ├─→ Compute new trigger based on offset type:
    │   ├─→ Price offset: basis ± offset
    │   ├─→ Basis points: basis ± (basis * offset / 10000)
    │   └─→ Ticks: basis ± (offset * price_increment)
    ├─→ Check if new trigger improves position:
    │   ├─→ BUY: new_trigger < current_trigger
    │   └─→ SELL: new_trigger > current_trigger
    ├─→ If improved:
    │   ├─→ Update order trigger price
    │   ├─→ Publish OrderUpdated event
    │   └─→ Update matching core
    └─→ Continue monitoring
```

#### Limit Order Processing

```
Limit order submitted (with emulation trigger)
    ↓
Add to matching core limit book
    ↓
On each market data update:
    ├─→ Check if marketable:
    │   ├─→ BUY: ask <= limit_price
    │   └─→ SELL: bid >= limit_price
    ├─→ If marketable:
    │   ├─→ Publish OrderReleased event
    │   └─→ Submit to execution engine
    └─→ If not marketable:
        └─→ Continue monitoring
```

### Order List Processing

```
OrderList submitted (OCO/OTO)
    ↓
handle_submit_order_list()
    ↓
For each order in list:
    ├─→ Check parent order for OTO
    │   └─→ Skip if parent not yet triggered
    ├─→ Create SubmitOrder command
    ├─→ Dispatch to appropriate destination:
    │   ├─→ SubmitToEmulator (has trigger)
    │   ├─→ SubmitToRisk (normal order)
    │   └─→ SubmitToAlgorithm (exec algorithm)
    └─→ Handle contingency actions
```

### Startup Recovery Flow

```
on_start() called
    ↓
Fetch all emulated orders from cache
    ↓
For each emulated order:
    ├─→ Check status (Initialized/Emulated)
    ├─→ Check parent order for OTO
    ├─→ Check if parent position closed
    ├─→ Create new SubmitOrder command
    ├─→ Cache command
    └─→ Call handle_submit_order()
```

### Cleanup Flow

```
reset() called
    ↓
Reset order manager
    ↓
Clear all matching cores
    ↓
Unsubscribe all market data
    ├─→ Unsubscribe quotes
    └─→ Unsubscribe trades
    ↓
Unsubscribe strategy order events
    ↓
Clear monitored positions
    ↓
Clear subscription trackers
```

## Key Data Structures

### RestingOrder

Lightweight order representation for matching:
```rust
pub struct RestingOrder {
    pub client_order_id: ClientOrderId,
    pub order_side: OrderSideSpecified,
    pub order_type: OrderType,
    pub trigger_price: Option<Price>,
    pub limit_price: Option<Price>,
    pub is_activated: bool,
}
```

### OrderMatchingCore

Per-instrument matching engine:
```rust
pub struct OrderMatchingCore {
    pub instrument_id: InstrumentId,
    pub price_increment: Price,
    pub bid: Option<Price>,
    pub ask: Option<Price>,
    pub last: Option<Price>,
    bid_limits: BTreeMap<Price, OrderBucket>,
    ask_limits: BTreeMap<Price, OrderBucket>,
    bid_stops: BTreeMap<Price, OrderBucket>,
    ask_stops: BTreeMap<Price, OrderBucket>,
    order_index: AHashMap<ClientOrderId, Location>,
}
```

### OrderEmulator

Main emulator orchestrator:
```rust
pub struct OrderEmulator {
    clock: Rc<RefCell<dyn Clock>>,
    cache: Rc<RefCell<Cache>>,
    manager: OrderManager,
    matching_cores: AHashMap<InstrumentId, OrderMatchingCore>,
    subscribed_quotes: AHashSet<InstrumentId>,
    subscribed_trades: AHashSet<InstrumentId>,
    subscribed_strategies: AHashSet<StrategyId>,
    quote_tick_handler: Option<TypedHandler<QuoteTick>>,
    trade_tick_handler: Option<TypedHandler<TradeTick>>,
    on_event_handler: Option<TypedHandler<OrderEventAny>>,
}
```

## Integration Points

### Message Bus Endpoints

- `OrderEmulator.execute()` - Receives trading commands
- `quotes.{instrument_id}` - Receives quote ticks
- `trades.{instrument_id}` - Receives trade ticks
- `events.order.{strategy_id}` - Receives order events

### Message Bus Publishers

- `DataEngine.queue_execute` - Subscribes/unsubscribes market data
- `RiskEngine.queue_execute` - Submits orders for risk checking
- `ExecEngine.queue_execute` - Submits orders for execution
- `{exec_algorithm_id}.execute` - Submits to execution algorithms
- `events.order.{strategy_id}` - Publishes order events
- `RiskEngine.process` - Publishes risk events
- `ExecEngine.process` - Publishes execution events

## Performance Characteristics

- **Order Lookup**: O(1) via AHashMap index
- **Order Matching**: O(log L + B) per iteration
- **Memory Efficiency**: SmallVec inline storage for price levels
- **Scalability**: One matching core per instrument
- **Deterministic**: BTreeMap provides consistent ordering

## Testing

The module includes comprehensive unit tests covering:
- Order submission and emulation
- Market data processing and trigger evaluation
- Order cancellation and modification
- Order list handling
- Startup recovery scenarios
- Trailing stop calculations
- Re-entrant event handling protection