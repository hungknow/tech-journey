# Execution Engine Documentation

## Purpose

The Execution Engine (`ExecutionEngine`) is the central orchestration layer for order management and execution in the Nautilus Trader system. It serves as the bridge between trading strategies and exchange venues, managing the complete order lifecycle from submission to completion while maintaining consistency between local state and venue reality.

## Problems Resolved and Techniques Used

### Core Problems

1. **Multi-venue Order Routing**: Strategies need to submit orders to different exchanges without worrying about venue-specific connection details
2. **State Consistency**: Local order/position state must match what venues report, handling network delays, reordering, and missing events
3. **Order Management System (OMS) Variants**: Different venues use different position management approaches (HEDGING vs NETTING)
4. **External Order Handling**: Venue-generated orders (liquidations, ADL, settlements) need proper integration without manual submission
5. **Event-driven Architecture**: Orders generate multiple events (Accepted, Filled, Canceled, etc.) that must be processed and routed correctly
6. **Position Management**: Fills create/modify/close positions with proper PnL calculation and event generation
7. **Reconciliation**: System must detect and resolve discrepancies between local and venue state
8. **Resource Management**: Timers, cleanup, and proper lifecycle management for long-running trading operations

### Techniques Employed

#### 1. **Adapter Pattern with Venue Routing**
- Uses `ExecutionClientAdapter` to wrap venue-specific clients
- Maintains routing maps: `Venue -> ClientId` for automatic client selection
- Supports default clients for fallback routing
- Allows external clients for offline command processing

#### 2. **Event Sourcing with Order State Machine**
- Orders maintain immutable event history: `OrderAny::from_events(vec![events])`
- State transitions validated by order objects themselves
- Events published to message bus for strategy consumption
- Snapshots for persistence and recovery

#### 3. **Dual OMS Support (HEDGING vs NETTING)**
- **HEDGING**: Each fill creates new position with unique IDs (`PositionIdGenerator`)
- **NETTING**: Single position per instrument-strategy pair: `{instrument_id}-{strategy_id}`
- Position flipping handles overfills by splitting fills and creating new positions
- OMS type can be overridden per-strategy

#### 4. **Reconciliation with External Order Bootstrapping**
- Venue reports (`OrderStatusReport`, `FillReport`, `PositionStatusReport`) compared to cache
- Missing orders materialized as external orders with synthetic `OrderInitialized` events
- Inferred fills created when venue reports quantities without fill details
- Mass status reconciliation handles startup synchronization

#### 5. **Position State Management**
- Positions track fills, PnL, and lifecycle (Open → Changed → Closed)
- Commission splitting for position flips preserves cost accounting
- Snapshots at state changes for persistence
- Unrealized PnL calculation with current market data

#### 6. **Message Bus Integration**
- Commands received via `exec_engine_execute` endpoint
- Events processed via `exec_engine_process` endpoint  
- Reports reconciled via `exec_engine_reconcile_execution_report` endpoint
- Queued execution for re-entrancy safety in live trading

#### 7. **Timer-based Maintenance**
- Position snapshot timer for periodic PnL updates
- Purge timers cleanup closed orders/positions/account events
- Configurable intervals with buffer periods

#### 8. **Own Order Book Management**
- Optional own order book tracking per instrument
- Updated on order state changes
- Useful for strategy visibility of own liquidity

## File Tree

```
crates/execution/src/engine/
├── mod.rs           # Main ExecutionEngine implementation (3730 lines)
├── config.rs        # ExecutionEngineConfig configuration
└── stubs.rs         # StubExecutionClient for testing
```

**Key Dependencies:**
- `client/` - ExecutionClient trait and implementations
- `reconciliation/` - Pure functions for state reconciliation
- `order_emulator/` - Backtest/sandbox order matching
- `../common/cache/` - Order/position/account storage
- `../common/msgbus/` - Message bus integration
- `../model/` - Domain objects (Order, Position, Account, etc.)

## Data Flow

### Order Submission Flow

```
TradingCommand (SubmitOrder)
    ↓
ExecutionEngine.execute()
    ↓
find_client_for_command() - Venue routing lookup
    ↓
ExecutionClient.submit_order()
    ↓
[Venue Network]
    ↓
ExecutionReport received
    ↓
ExecutionEngine.reconcile_execution_report()
    ↓
generate_reconciliation_order_events() or materialize_external_order()
    ↓
handle_event() - Apply to cached order
    ↓
update_cached_order() - Update order state
    ↓
handle_order_fill() - If fill event
    ↓
handle_position_update() - Create/update position
    ↓
publish_order_event() - To strategy via message bus
    ↓
publish_position_events() - Position events to strategy
```

### Event Processing Flow

```
OrderEvent (e.g., OrderFilled)
    ↓
ExecutionEngine.process()
    ↓
handle_event()
    ↓
validate_fill_for_order() - Deduplication & overfill checks
    ↓
determine_position_id() - HEDGING vs NETTING logic
    ↓
update_cached_order() - Apply event to order
    ↓
handle_position_update() - Position lifecycle management
    ↓
    ├─ open_position() - Create new position
    ├─ update_position() - Update existing
    └─ flip_position() - Handle overfill (split fill)
    ↓
create_position_state_snapshot() - If enabled
    ↓
publish_events() - Via message bus
```

### Reconciliation Flow

```
ExecutionReport (from venue)
    ↓
ExecutionEngine.reconcile_execution_report()
    ↓
├─ OrderStatusReport:
│   ├─ Order in cache? → generate_reconciliation_order_events()
│   └─ Not in cache? → materialize_external_order_from_status()
├─ FillReport:
│   ├─ Order in cache? → reconcile_fill_report()
│   └─ Not in cache? → materialize_external_order_from_fill()
├─ OrderWithFills:
│   └─ reconcile_order_with_fills() - Real fills + inferred fills
├─ PositionReport:
│   └─ reconcile_position_report() - HEDGING vs NETTING checks
└─ MassStatus:
    └─ reconcile_execution_mass_status() - Startup sync
```

## Logic Flow

### Initialization Flow

```rust
ExecutionEngine::new(clock, cache, config)
    ↓
register_msgbus_handlers() - Setup message bus endpoints
    ↓
register_client() - Add venue clients
    ↓
register_venue_routing() - Configure routing
    ↓
start() - Connect clients, start timers
    ↓
connect() - Async client connections
```

### Command Routing Logic

```rust
execute_command(TradingCommand)
    ↓
┌─────────────────────────────────────┐
│ Is external client?                 │
│ └─ Yes: Publish to bus, return      │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Find client for command:            │
│ 1. Command has client_id?           │
│ 2. Account ID in command?           │
│ 3. Instrument ID venue routing?     │
│ 4. Default client fallback          │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ No client found?                    │
│ └─ Deny order with reason           │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Route to appropriate handler:       │
│ • handle_submit_order()             │
│ • handle_modify_order()             │
│ • handle_cancel_order()             │
│ • handle_cancel_all_orders()        │
│ • handle_batch_cancel_orders()      │
│ • handle_query_order()              │
│ • handle_query_account()            │
└─────────────────────────────────────┘
```

### Order State Update Logic

```rust
handle_event(OrderEvent)
    ↓
┌─────────────────────────────────────┐
│ Find order in cache:                │
│ 1. By client_order_id               │
│ 2. By venue_order_id (fallback)     │
│ └─ Not found? → Error/return        │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Is OrderFilled?                     │
│ └─ Yes: Special fill handling       │
└─────────────────────────────────────┘
    ↓
update_cached_order()
    ↓
┌─────────────────────────────────────┐
│ Apply event to order:               │
│ • Validate state transition         │
│ • Check for duplicate fills         │
│ • Check for overfills               │
│ └─ Error? → Log & cleanup           │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Update own order book (if enabled)  │
│ Create order snapshot (if enabled)  │
│ Send to portfolio                   │
│ Publish to message bus              │
└─────────────────────────────────────┘
```

### Position ID Determination Logic

```rust
determine_position_id(fill, oms_type, order)
    ↓
┌─────────────────────────────────────┐
│ Position ID already cached?         │
│ └─ Yes: Return cached ID            │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Check execution spawn orders        │
│ └─ Parent has position_id?          │
│     └─ Yes: Inherit from parent     │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Generate based on OMS type:         │
│                                     │
│ HEDGING:                            │
│ • Use fill.position_id if provided  │
│ • Check spawned orders              │
│ • Generate unique ID                │
│                                     │
│ NETTING:                            │
│ • "{instrument_id}-{strategy_id}"   │
└─────────────────────────────────────┘
```

### Position Update Logic

```rust
handle_position_update(instrument, fill, oms_type)
    ↓
┌─────────────────────────────────────┐
│ Position exists?                    │
│ └─ No: open_position()              │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Position is closed?                 │
│ └─ Yes: reopen_position() → open    │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Position is open:                   │
│ └─ will_flip_position()?            │
│     ├─ Yes: flip_position()         │
│     └─ No: update_position()        │
└─────────────────────────────────────┘
```

### Position Flip Logic

```rust
flip_position(instrument, position, fill, oms_type)
    ↓
┌─────────────────────────────────────┐
│ Calculate difference:               │
│ difference = |fill.qty - pos.qty|   │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Split commission:                   │
│ fill_percent = pos.qty / fill.qty   │
│ commission1 = commission * percent  │
│ commission2 = commission - comm1    │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Close existing position:            │
│ • Apply fill with pos.qty           │
│ • Generate PositionClosed event     │
│ • Snapshot position (NETTING)       │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Open new position:                  │
│ • Apply fill with difference        │
│ • Generate PositionOpened event     │
│ • Use new position ID (HEDGING)     │
│   or same ID (NETTING)              │
└─────────────────────────────────────┘
```

### External Order Materialization

```
Resolve strategy ID
    └─ Check external_order_claims
    └─ Default to "EXTERNAL" if not found

Check if should filter unclaimed orders
    └─ If yes and order unclaimed: Return None (log filter)

Create OrderInitialized event
    └─ Use report fields
    └─ Mark as reconciliation=true

Create order from events
    └─ order = OrderAny::from_events(init)

Add to cache
    └─ cache.add_order(order)
    └─ cache.add_venue_order_id()

Register with adapter
    └─ adapter.register_external_order()
```

### Handler Logic Flows

#### handle_submit_order

```
Check if order already exists in cache by client_order_id
    └─ If yes: Return early (don't resubmit)

Create order from OrderInitialized event
    └─ If creation fails: Early return

Add order to cache
    └─ Register client_order_id mapping

Create order state snapshot if configured

Validate that client handles the order's venue
    └─ If no venue match: Generate OrderDenied event

Validate position ID against OMS type settings
    └─ If invalid ID for NETTING: Generate OrderDenied event

Get instrument from cache
    └─ If not found: Log error, generate OrderDenied

Update own order book if enabled and order qualifies

Submit order to execution client
    └─ If submission fails: Log error, generate OrderDenied

Generate OrderAccepted event

Publish to message bus
```

#### handle_modify_order

```
Forward modify command to execution client
    └─ client.modify_order(cmd)

If error occurs: Log error
No return value
```

#### handle_cancel_order

```
Forward cancel command to execution client
    └─ client.cancel_order(cmd)

If error occurs: Log error
No return value
```

#### handle_cancel_all_orders

```
Forward cancel_all command to execution client
    └─ client.cancel_all_orders(cmd)

If error occurs: Log error
No return value
```

#### handle_batch_cancel_orders

```
Forward batch cancel command to execution client
    └─ client.batch_cancel_orders(cmd)

If error occurs: Log error
No return value
```
│ client.batch_cancel_orders(cmd)     │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Error? → Log error                  │
│ No return value                     │
└─────────────────────────────────────┘
```

#### handle_query_order

```
Forward query order command to execution client
    └─ client.query_order(cmd)

If error occurs: Log error
No return value
```

#### handle_query_account

```
Forward query account command to execution client
    └─ client.query_account(cmd)

If error occurs: Log error
No return value
```

## Key Data Structures

### ExecutionEngine (mod.rs:120-136)

```rust
pub struct ExecutionEngine {
    clock: Rc<RefCell<dyn Clock>>,
    cache: Rc<RefCell<Cache>>,
    clients: IndexMap<ClientId, ExecutionClientAdapter>,
    default_client: Option<ExecutionClientAdapter>,
    routing_map: HashMap<Venue, ClientId>,
    oms_overrides: HashMap<StrategyId, OmsType>,
    external_order_claims: HashMap<InstrumentId, StrategyId>,
    external_clients: HashSet<ClientId>,
    pos_id_generator: PositionIdGenerator,
    config: ExecutionEngineConfig,
    command_count: Cell<u64>,
    event_count: u64,
    report_count: u64,
    filtered_unclaimed_external_order_count: u64,
    snapshot_anchorer: Option<SnapshotAnchorer>,
}
```

### ExecutionEngineConfig (config.rs:34-99)

```rust
pub struct ExecutionEngineConfig {
    pub load_cache: bool,
    pub manage_own_order_books: bool,
    pub snapshot_orders: bool,
    pub snapshot_positions: bool,
    pub snapshot_positions_interval_secs: Option<f64>,
    pub allow_overfills: bool,
    pub filter_unclaimed_external_orders: bool,
    pub external_clients: Option<Vec<ClientId>>,
    pub purge_closed_orders_interval_mins: Option<u32>,
    pub purge_closed_orders_buffer_mins: Option<u32>,
    pub purge_closed_positions_interval_mins: Option<u32>,
    pub purge_closed_positions_buffer_mins: Option<u32>,
    pub purge_account_events_interval_mins: Option<u32>,
    pub purge_account_events_lookback_mins: Option<u32>,
    pub purge_from_database: bool,
    pub debug: bool,
}
```

## Timer Management

The engine manages several timers for periodic operations:

### Position Snapshot Timer (mod.rs:700-741)
- Configurable interval (`snapshot_positions_interval_secs`)
- Publishes `PositionStateSnapshot` for open positions
- Includes unrealized PnL calculation

### Purge Timers (mod.rs:764-878)
- **Closed orders purge**: Removes fully closed orders after buffer period
- **Closed positions purge**: Removes closed positions after buffer period  
- **Account events purge**: Removes old account events with lookback window
- All timers configurable with intervals and buffer periods

## Message Bus Endpoints

### Command Endpoints
- `exec_engine_execute` - Direct command execution
- `exec_engine_queue_execute` - Queued execution (re-entrancy safe)

### Event Endpoints
- `exec_engine_process` - Order event processing
- `exec_engine_reconcile_execution_report` - Report reconciliation

### Published Topics
- `events.orders.{strategy_id}` - Order events to strategies
- `events.positions.{strategy_id}` - Position events to strategies
- `orders.fills.{instrument_id}` - Fill events
- `orders.cancels.{instrument_id}` - Cancel events
- `snapshots.positions.{position_id}` - Position state snapshots
- `reconciliation.raw.order_status_report` - Raw venue reports
- `reconciliation.raw.fill_report` - Raw fill reports
- `reconciliation.raw.position_status_report` - Raw position reports

## Error Handling

### Command Execution Errors
- No execution client found → OrderDenied event generated
- Client venue mismatch → OrderDenied event
- Invalid position ID for NETTING → OrderDenied event
- Submit order failed → OrderDenied event

### Event Processing Errors
- Order not found → Warning logged, event not applied
- Invalid state transition → Warning logged, event not applied
- Duplicate fill → Warning logged, fill skipped
- Overfill detected → Error or warning based on config

### Reconciliation Errors
- Instrument not found → External order not created
- Account not found → Fill not processed
- Position mismatch → Error logged, discrepancy tracked

## Testing Support

### StubExecutionClient (stubs.rs:44-276)
- Minimal `ExecutionClient` implementation for testing
- Tracks received instruments, submitted orders, queried accounts
- Configurable error injection for failure scenarios
- Connection state simulation

## Configuration Best Practices

### Production Settings
```rust
ExecutionEngineConfig {
    load_cache: true,                    // Load persisted state
    manage_own_order_books: true,        // Track own liquidity
    snapshot_orders: true,               // Persist order state
    snapshot_positions: true,            // Persist position state
    snapshot_positions_interval_secs: Some(60.0), // Every minute
    allow_overfills: false,              // Strict fill validation
    filter_unclaimed_external_orders: true, // Ignore noise
    purge_closed_orders_interval_mins: Some(60), // Cleanup old orders
    purge_closed_orders_buffer_mins: Some(30),  // Keep 30 min buffer
    purge_closed_positions_interval_mins: Some(60),
    purge_closed_positions_buffer_mins: Some(30),
    purge_account_events_interval_mins: Some(60),
    purge_account_events_lookback_mins: Some(1440), // Keep 24h
    purge_from_database: true,           // Clean up database
    debug: false,                        // Production logging
}
```

### Backtest Settings
```rust
ExecutionEngineConfig {
    load_cache: false,                   // No persistence
    manage_own_order_books: true,
    snapshot_orders: false,              // No snapshots needed
    snapshot_positions: false,
    snapshot_positions_interval_secs: None,
    allow_overfills: false,
    filter_unclaimed_external_orders: false, // All orders matter
    external_clients: None,
    purge_closed_orders_interval_mins: None, // No cleanup
    purge_closed_orders_buffer_mins: None,
    purge_closed_positions_interval_mins: None,
    purge_closed_positions_buffer_mins: None,
    purge_account_events_interval_mins: None,
    purge_account_events_lookback_mins: None,
    purge_from_database: false,
    debug: true,                         // Detailed logging
}
```

## Performance Considerations

### Cache Access Patterns
- Minimize `borrow_mut()` duration to reduce lock contention
- Batch operations when possible (e.g., mass status)
- Use `order_owned()` for clones instead of repeated borrows

### Message Bus Throughput
- Events published asynchronously
- Topic-based routing reduces receiver overhead
- Raw reconciliation reports published for audit trail

### Memory Management
- Purge timers prevent unbounded growth
- Closed orders/positions eventually cleaned up
- Own order books only for active instruments

### Concurrency
- Engine uses `Rc<RefCell<>>` for single-threaded event loop
- Multiple execution clients can connect concurrently
- Timer callbacks run in same thread as event processing

## Integration Points

### With Order Manager
- Order manager creates `OrderInitialized` events
- Engine validates and routes to venues
- Engine applies resulting `OrderAccepted`, `OrderFilled`, etc.

### With Portfolio
- Fill events sent to portfolio for PnL calculation
- Position events update portfolio state
- Account state managed by portfolio

### With Data Engine
- Instrument updates subscribed per venue
- Quotes used for unrealized PnL calculation
- Market data drives position valuations

### With Risk Engine
- Pre-submission validation (though not in engine code)
- Position limits enforcement
- Margin requirement checks

## Future Enhancements

Potential areas for improvement:
- Multi-threaded event processing for high-throughput venues
- Custom position ID strategies beyond HEDGING/NETTING
- Advanced reconciliation with partial fill reconstruction
- Position batching for bulk operations
- Streaming position updates instead of event-based
- Custom event filters per strategy