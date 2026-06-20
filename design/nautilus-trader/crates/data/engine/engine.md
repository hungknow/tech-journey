# Data Engine Structs Documentation

This document describes the structs defined in the `crates/data/src/engine/mod.rs` file of the NautilusTrader data engine module.

## DataEngine

The `DataEngine` is the central component of the entire data stack, responsible for orchestrating interactions between `DataClient` instances and the rest of the platform.

### Purpose

Provides a high-performance engine for all environments that:

- Sends requests to, and receives responses from, data endpoints via registered data clients
- Employs a fan-in fan-out messaging pattern to execute `DataCommand` messages
- Processes `DataResponse` messages and market data objects
- Manages bar aggregators, book updaters, and various subscriptions
- Handles continuous futures, option chains, and synthetic instruments

### Data Storage

The struct stores extensive state including:

1. **Core Components**:

   - `clock: Rc<RefCell<dyn Clock>>` - Reference to the system clock
   - `cache: Rc<RefCell<Cache>>` - Reference to the data cache
   - `clients: IndexMap<ClientId, DataClientAdapter>` - Registered data clients
   - `default_client: Option<DataClientAdapter>` - Default fallback client

2. **Subscription Management**:

   - `external_clients: AHashSet<ClientId>` - Set of external client IDs
   - `routing_map: IndexMap<Venue, ClientId>` - Maps venues to clients
   - `book_deltas_counts: IndexMap<BookDeltasKey, usize>` - Delta subscription counts
   - `book_depth10_subs: AHashSet<InstrumentId>` - Depth10 subscriptions
   - `book_snapshot_counts: IndexMap<BookSnapshotKey, usize>` - Snapshot counts

3. **Book Management**:

   - `book_updaters: AHashMap<InstrumentId, Rc<BookUpdater>>` - Book updaters
   - `book_snapshotters: AHashMap<NonZeroUsize, Rc<BookSnapshotter>>` - Snapshot timers
   - `book_intervals: AHashMap<NonZeroUsize, BookSnapshotInfos>` - Interval configurations

4. **Bar Aggregation**:

   - `bar_aggregators: IndexMap<BarAggregatorKey, Rc<RefCell<Box<dyn BarAggregator>>>>` - Active aggregators
   - `bar_aggregator_handlers: AHashMap<BarAggregatorKey, Vec<BarAggregatorSubscription>>` - Handlers

5. **Request Processing**:

   - `request_bar_aggregations: AHashMap<UUID4, RequestBarAggregation>` - Request aggregations
   - `request_pipeline_parent_request: AHashMap<UUID4, RequestCommand>` - Parent requests
   - `time_range_pipeline_requests: AHashMap<UUID4, TimeRangePipelineState>` - Time range pipelines

6. **Continuous Futures**:

   - `continuous_future_requests: AHashMap<UUID4, ContinuousFutureRequestState>` - Active requests
   - `continuous_future_subscriptions: AHashMap<BarType, ContinuousFutureSubscriptionState>` - Subscriptions

7. **Option Chains**:

   - `option_chain_managers: AHashMap<OptionSeriesId, Rc<RefCell<OptionChainManager>>>` - Chain managers

8. **Synthetic Instruments**:

   - `synthetic_quote_feeds: AHashMap<InstrumentId, Vec<SyntheticInstrument>>` - Quote feeds
   - `synthetic_trade_feeds: AHashMap<InstrumentId, Vec<SyntheticInstrument>>` - Trade feeds

9. **Counters**:

   - `command_count: u64` - Total commands received
   - `data_count: u64` - Total data objects received
   - `request_count: u64` - Total requests received
   - `response_count: u64` - Total responses received

**Example**:

```rust
let engine = DataEngine {
    clock: Rc::new(RefCell::new(clock)),
    cache: Rc::new(RefCell::new(cache)),
    external_clients: AHashSet::new(),
    clients: IndexMap::new(),
    default_client: Some(client),
    routing_map: IndexMap::new(),
    command_count: 0,
    data_count: 0,
    // ... other fields
    msgbus_priority: 10,
    config: DataEngineConfig::default(),
};
```

### Features and Methods

The DataEngine provides comprehensive functionality organized into the following features:

#### 1. Lifecycle Management

**Purpose**: Manage the engine lifecycle including starting, stopping, resetting, and disposing of the engine and its components.

Use these methods when:

- Initializing the engine and connecting to external systems
- Shutting down the engine cleanly
- Resetting state between tests or trading sessions
- Cleaning up resources

**Usage Example**:

```rust
// Initialize all clients and restart bar aggregator timers for live operation
engine.start();

// Stop all clients and aggregator timers cleanly without disconnecting
engine.stop();

// Clear all state and reset clients for clean test environment
engine.reset();

// Terminate all clients and cancel pending timers permanently
engine.dispose();
```

#### 2. Client and Connection Management

**Purpose**: Manage data client registration, connection status, and routing of commands to appropriate clients.

Use these methods when:

- Adding new data sources (exchanges) to the engine
- Checking connectivity status
- Routing commands to specific clients

**Usage Example**:

```rust
// Create and register client with venue mapping for routing
let binance = BinanceDataClient::new(/* ... */);
let coinbase = CoinbaseDataClient::new(/* ... */);

// Map BINANCE venue to this client for command routing
engine.register_client(binance, Some(Venue::new("BINANCE")));

// Set fallback client when no venue mapping exists
engine.register_default_client(coinbase);

// Concurrently connect to all external data endpoints
engine.connect().await;

// Check each client's connection status individually
for (client_id, connected) in engine.client_connection_status() {
    if !connected {
        log::warn!("Client {client_id} is not connected");
    }
}

// Disconnect all clients concurrently with error aggregation
engine.disconnect().await?;
```

#### 3. Command Execution

**Purpose**: Entry point for executing data commands (subscribe, unsubscribe, request) that drive all engine functionality.

Use these methods when:

- Subscribing to live market data feeds
- Unsubscribing from data feeds
- Requesting historical data

**Usage Example**:

```rust
// Delegate subscribe command to internal handlers and update state
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(subscribe_cmd)));

// Send request directly to appropriate data client by venue/client ID
engine.execute_request(RequestCommand::Bars(request_cmd));

// Clean up internal state and forward unsubscribe to client
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::Quotes(unsubscribe_cmd)));
```

#### 4. Data Processing

**Purpose**: Process live and historical market data messages, updating cache and publishing to message bus.

Use these methods when:

- Data arrives from clients and needs to be processed
- Running historical data replays
- Processing responses from data requests

**Usage Example**:

```rust
// Dispatch live data to appropriate handlers with cache updates and publishing
engine.process_data(Data::Quote(quote));

// Process data from any source using dynamic type dispatch
engine.process(&data_any);

// Process historical data without live-only side effects like synthetic generation
engine.process_pipeline(Data::Quote(quote));

// Handle client response and publish to waiting requestors
engine.response(response);
```

#### 5. Bar Aggregation

**Purpose**: Manage bar aggregators for converting raw market data into aggregated bar data of various types (time-based, tick-based, volume-based, etc.).

Use these methods when:

- You need to create custom bar aggregators
- Requesting historical data with on-the-fly aggregation
- Managing bar aggregator lifecycle

**Usage Example**:

```rust
// Example 1: Automatic internal bar aggregation
// When you subscribe to internally aggregated bars, the engine creates aggregators automatically
let bar_type = BarType::from_str("BTCUSDT.BINANCE-1-MIN-LAST-INTERNAL").unwrap();
let subscribe_cmd = SubscribeBars::new(
    bar_type,  // Internal aggregation
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    None,
    None,
);

// Internally, this will:
// 1. start_live_bar_aggregator - checks if already running
// 2. start_bar_aggregator - creates aggregator, subscribes handlers
// 3. subscribe_bar_aggregator - subscribes to underlying trades
// 4. Aggregator converts trades to 1-minute bars
engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(subscribe_cmd)));

// Example 2: Request with on-the-fly aggregation
let bar_type = BarType::from_str("BTCUSDT.BINANCE-5-MIN-MID-INTERNAL").unwrap();
let request_cmd = RequestBars::new(
    bar_type,
    Some(start_dt),
    Some(end_dt),
    Some(1000),
    Some(ClientId::new("BINANCE")),
    request_id,
    clock.borrow().timestamp_ns(),
    None,
);

// Internally, this will:
// 1. prepare_request_bar_aggregators - sets up aggregators from request params
// 2. can_start_request_bar_aggregators - validates no conflicts
// 3. init_request_bar_aggregators - creates and configures aggregators
// 4. set_request_bar_aggregator_chain_handlers - sets up composite bar handlers
// 5. Request underlying data (quotes/trades) from client
// 6. update_request_bar_aggregators_from_quote/trade - processes responses
// 7. process_request_bar_aggregation_response - finalizes bars
// 8. cleanup_request_bar_aggregators - cleans up when done
engine.execute_request(RequestCommand::Bars(request_cmd));

// Example 3: Composite bar aggregation (aggregating aggregations)
// Create 5-minute bars from 1-minute bars
let one_min_type = BarType::from_str("BTCUSDT.BINANCE-1-MIN-LAST-INTERNAL").unwrap();
let five_min_type = BarType::from_str("BTCUSDT.BINANCE-5-MIN-LAST-INTERNAL").unwrap();

// First, subscribe to 1-minute bars (source)
let source_cmd = SubscribeBars::new(
    one_min_type,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    None,
    None,
);
engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(source_cmd)));

// Then, subscribe to 5-minute composite bars
// The composite aggregator subscribes to the 1-minute bar topic
let composite_cmd = SubscribeBars::new(
    five_min_type,  // Will be marked as composite
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    None,
    None,
);
engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(composite_cmd)));

// Internally for composite bars:
// 1. create_bar_aggregator creates a composite aggregator
// 2. BarBarHandler is registered to subscribe to 1-minute bar topic
// 3. When 1-minute bars arrive, they're aggregated into 5-minute bars
// 4. set_request_bar_aggregator_chain_handlers sets up handler chains

// Example 4: Different aggregation types
// Time-based aggregation (1-minute bars)
let time_bar_type = BarType::from_str("BTCUSDT.BINANCE-1-MIN-LAST-INTERNAL").unwrap();

// Tick-based aggregation (100-tick bars)
let tick_bar_type = BarType::from_str("BTCUSDT.BINANCE-100-TICK-LAST-INTERNAL").unwrap();

// Volume-based aggregation (1000-volume bars)
let volume_bar_type = BarType::from_str("BTCUSDT.BINANCE-1000-VOL-LAST-INTERNAL").unwrap();

// Value-based aggregation (50000-value bars)
let value_bar_type = BarType::from_str("BTCUSDT.BINANCE-50000-VAL-LAST-INTERNAL").unwrap();

// Subscribe to each type
for bar_type in [time_bar_type, tick_bar_type, volume_bar_type, value_bar_type] {
    let cmd = SubscribeBars::new(
        bar_type,
        Some(ClientId::new("BINANCE")),
        Some(Venue::new("BINANCE")),
        UUID4::new(),
        clock.borrow().timestamp_ns(),
        None,
        None,
    );
    engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(cmd)));
}

// Each aggregator type is created by create_bar_aggregator with appropriate parameters:
// - TimeBarAggregator: needs clock, time_bars_origin_offset, build_with_no_updates, etc.
// - TickBarAggregator: needs tick count threshold
// - VolumeBarAggregator: needs volume threshold
// - ValueBarAggregator: needs value threshold
// - RenkoBarAggregator: needs brick size (from price_increment)

// Example 5: Cleaning up aggregators
let unsubscribe_cmd = UnsubscribeBars::new(
    bar_type,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    None,
    None,
);

// Internally, this will:
// 1. unsubscribe_bars calls unsubscribe_bar_aggregator
// 2. If composite, unsubscribes from source bar type
// 3. stop_bar_aggregator removes the aggregator
// 4. Unsubscribes message bus handlers
// 5. Cancels timers for time-based aggregators
// 6. If source becomes orphaned (no more subscribers), cleans up source too
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::Bars(unsubscribe_cmd)));

// Example 6: Historical bar aggregation with TestClock
// When processing historical data, each aggregator gets its own TestClock
let request_id = UUID4::new();
let historical_bar_type = BarType::from_str("BTCUSDT.BINANCE-1-HOUR-MID-INTERNAL").unwrap();

let historical_request = RequestBars::new(
    historical_bar_type,
    Some(historical_start),
    Some(historical_end),
    Some(1000),
    Some(ClientId::new("BINANCE")),
    request_id,
    clock.borrow().timestamp_ns(),
    None,
);

// Internally, setup_bar_aggregator with historical=true will:
// 1. Create independent TestClock for this aggregator
// 2. Set historical mode (no publishing, only cache writes)
// 3. Clock advances based on data timestamps
// 4. Bars close correctly at interval boundaries based on test clock
engine.execute_request(RequestCommand::Bars(historical_request));
```

#### 6. Book Management

**Purpose**: Manage order book state, updates, and periodic snapshots for subscribed instruments.

Use these methods when:

- Subscribing to order book data
- Managing book state in cache
- Taking periodic book snapshots

**Usage Example**:

```rust
// Example 1: Basic managed book subscription
let instrument_id = InstrumentId::from_str("BTCUSDT.BINANCE").unwrap();
let subscribe_cmd = SubscribeBookDeltas::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),  // depth
    true,    // managed=true
    Some(command_id),
    None,
);

// Internally, this will:
// 1. subscribe_book_deltas - increments subscription count
// 2. setup_book_updater - creates BookUpdater for the instrument
// 3. BookUpdater subscribes to deltas and depth10 topics
// 4. When deltas arrive, BookUpdater maintains the order book in cache
// 5. You can query the book from cache: cache.order_book(&instrument_id)
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDeltas(subscribe_cmd)));

// Example 2: Parent subscription (subscribe to all instruments in a class)
// Subscribe to all BTC options using parent subscription pattern
let parent_instrument_id = InstrumentId::from_str("BTC.PERP.BINANCE").unwrap();

let mut params = Params::new();
params.insert("is_parent", "true");

let parent_subscribe = SubscribeBookDeltas::new(
    parent_instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),
    true,
    Some(command_id),
    Some(params),
);

// Internally:
// 1. resolve_parent_components parses parent pattern and expands to underlyings
// 2. setup_book_updater creates BookUpdaters for each underlying instrument
// 3. Each BookUpdater maintains its own book state
// 4. Subscription count is tracked per parent, but manages all underlyings
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDeltas(parent_subscribe)));

// Example 3: Periodic book snapshots
let instrument_id = InstrumentId::from_str("BTCUSDT.BINANCE").unwrap();
let interval_ms = std::num::NonZeroUsize::new(5000).unwrap();  // 5 seconds

let snapshot_cmd = SubscribeBookSnapshots::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    interval_ms,
    Some(command_id),
    None,
);

// Internally:
// 1. subscribe_book_snapshots increments snapshot subscription count
// 2. increment_book_snapshot_subscription checks if new interval
// 3. schedule_book_snapshotter creates BookSnapshotter with timer
// 4. BookSnapshotter publishes book snapshots every interval
// 5. Snapshots are published to data.book_snapshots.<interval_ms>.<instrument_id> topic
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookSnapshots(snapshot_cmd)));

// Example 4: Mixed delta and depth10 subscriptions
// When you subscribe to depth10, BookUpdater also subscribes to deltas
let depth10_cmd = SubscribeBookDepth10::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(command_id),
    None,
);

// Internally:
// 1. subscribe_book_depth10 adds instrument to depth10_subs set
// 2. setup_book_updater with only_deltas=false
// 3. BookUpdater subscribes to both deltas and depth10 topics
// 4. When depth10 arrives, BookUpdater updates L1/L2 levels
// 5. When deltas arrive, BookUpdater updates full book
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDepth10(depth10_cmd)));

// Example 5: Unsubscription with multiple subscribers
// Multiple subscribers can subscribe to the same instrument
let subscribe1 = SubscribeBookDeltas::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),
    true,
    Some(command_id_1),
    None,
);

let subscribe2 = SubscribeBookDeltas::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),
    true,
    Some(command_id_2),
    None,
);

engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDeltas(subscribe1)));
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDeltas(subscribe2)));

// Now unsubscribe only the first subscription
let unsubscribe1 = UnsubscribeBookDeltas::new(
    instrument_id,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(command_id_1),
    None,
);

// Internally:
// 1. unsubscribe_book_deltas calls decrement_book_delta_subscription
// 2. BookDeltasUnsubscribeResult::Decremented returned
// 3. maintain_book_updater checks if still wanted
// 4. Since second subscriber exists, BookUpdater is kept alive
// 5. Client stays subscribed because there are still delta subscriptions
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::BookDeltas(unsubscribe1)));

// Example 6: Unsubscription when last subscriber leaves
let unsubscribe2 = UnsubscribeBookDeltas::new(
    instrument_id,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(command_id_2),
    None,
);

// Internally:
// 1. decrement_book_delta_subscription returns BookDeltasUnsubscribeResult::Removed
// 2. maintain_book_updater finds no more subscribers
// 3. BookUpdater handlers are unsubscribed from message bus
// 4. BookUpdater is removed from book_updaters map
// 5. Client is unsubscribed because no more delta subscriptions exist
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::BookDeltas(unsubscribe2)));

// Example 7: Book snapshot replay for historical requests
// When requesting historical book deltas that start with a snapshot
let request_id = UUID4::new();
let request_cmd = RequestBookDeltas::new(
    instrument_id,
    Some(start_dt),  // Might align with UTC day boundary
    Some(end_dt),
    Some(1000),
    Some(ClientId::new("BINANCE")),
    request_id,
    clock.borrow().timestamp_ns(),
    None,
);

// Internally:
// 1. If first delta is F_SNAPSHOT on UTC day boundary
// 2. book_deltas_snapshot_replay rebuilds book from pre-start deltas
// 3. Replaces pre-start deltas with single snapshot at original start
// 4. Forwards remaining deltas after start time
// 5. This ensures accurate book state at request start
engine.execute_request(RequestCommand::BookDeltas(request_cmd));

// Example 8: Checking subscription state
let has_deltas = engine.has_book_delta_subscriptions(&instrument_id);
let has_snapshots = engine.has_book_snapshot_subscriptions(&instrument_id);
let owned_by_subscription = engine.cache_is_owned_by_live_subscription(&instrument_id);

log::info!("Has delta subscriptions: {}", has_deltas);
log::info!("Has snapshot subscriptions: {}", has_snapshots);
log::info!("Book owned by live subscription: {}", owned_by_subscription);

// Example 9: Parent expansion cleanup
// When unsubscribing from a parent, all underlying books are cleaned up
let parent_unsubscribe = UnsubscribeBookDeltas::new(
    parent_instrument_id,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(command_id),
    None,
);

// Internally:
// 1. maintain_book_updater detects parent subscription
// 2. Iterates through all target_ids from parent expansion
// 3. Checks is_underlying_wanted_for_deltas for each target
// 4. Cleans up BookUpdaters that are no longer needed
// 5. Removes parent expansion maps
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::BookDeltas(parent_unsubscribe)));

// Example 10: Managed vs unmanaged books
// Managed books: BookUpdater maintains book state in cache
// Unmanaged books: No BookUpdater, cache writes are direct

let managed_subscribe = SubscribeBookDeltas::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),
    true,   // managed=true
    Some(command_id),
    None,
);

let unmanaged_subscribe = SubscribeBookDeltas::new(
    instrument_id,
    BookType::L2_MBP,
    Some(ClientId::new("BINANCE")),
    Some(Venue::new("BINANCE")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    Some(5),
    false,  // managed=false
    Some(command_id),
    None,
);

// For managed books:
// - cache_is_owned_by_live_subscription returns true
// - Historical book responses skip cache writes (to avoid conflicts)
// - BookUpdater maintains the authoritative book state

// For unmanaged books:
// - cache_is_owned_by_live_subscription returns false
// - Historical book responses write to cache
// - No BookUpdater, cache is authoritative
```

#### 7. Subscription Management

**Purpose**: Handle subscription lifecycle for all data types, including counting, forwarding to clients, and managing internal state.

Use these methods when:

- Subscribing to different types of market data
- Managing subscription counts (multiple subscribers)
- Unsubscribing from data feeds

**Usage Example**:

```rust
// Subscribe to multiple data types for an instrument
let instrument_id = InstrumentId::from_str("BTCUSDT.BINANCE").unwrap();

// Send quote subscription command to client via message bus
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(quote_cmd)));

// Send trade subscription command with instrument tracking
engine.execute(DataCommand::Subscribe(SubscribeCommand::Trades(trade_cmd)));

// Subscribe to managed book deltas with automatic book state maintenance
engine.execute(DataCommand::Subscribe(SubscribeCommand::BookDeltas(delta_cmd)));

// Track subscription counts, only unsubscribing client when last subscriber leaves
```

#### 8. Continuous Futures Management

**Purpose**: Manage continuous futures (perpetual contracts) that automatically roll from one contract segment to another at predefined transition points.

Use these methods when:
- Trading continuous futures (e.g., ES.GLBXC-CME)
- Need automatic contract rolling without manual intervention
- Requesting historical continuous futures data

**Usage Example**:

```rust
// Subscribe to continuous futures with automatic rolling
let bar_type = BarType::from_str("ES.GLBXC-CME.L2_MBP-100-TICK-MID-INTERNAL").unwrap();

// Define roll schedule and adjustments
let mut params = Params::new();
params.insert(
    "continuous_future_transitions",
    serde_json::json!([
        {
            "transition_time_ns": 1703596800000000000,  // 2023-12-25 00:00:00 UTC
            "pre_instrument_id": "ESH4.CME",
            "post_instrument_id": "ESM4.CME",
            "adjustment": 0.0,
        },
        {
            "transition_time_ns": 1706275200000000000,  // 2024-01-26 00:00:00 UTC
            "pre_instrument_id": "ESM4.CME",
            "post_instrument_id": "ESU4.CME",
            "adjustment": 5.25,
        },
    ]),
);
params.insert("continuous_future_adjustment_mode", "proportional");

let subscribe_cmd = SubscribeBars::new(
    bar_type,
    Some(ClientId::new("CME")),
    Some(Venue::new("CME")),
    UUID4::new(),
    clock.borrow().timestamp_ns(),
    None,
    Some(params),
);

// Internally, this will:
// 1. Create aggregator for target continuous bar type
// 2. Determine active segment (e.g., ESH4.CME)
// 3. Subscribe to segment's underlying data (e.g., ESH4 trades)
// 4. Schedule timer for next roll (to ESM4)
// 5. When timer fires: unsubscribe from ESH4, subscribe to ESM4, apply 5.25 adjustment
engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(subscribe_cmd)));

// Request historical continuous futures data
let mut params = Params::new();
params.insert("continuous_future_transitions", /* ... */);
params.insert("continuous_future_adjustment_mode", "proportional");

let request_cmd = RequestBars::new(
    bar_type,
    Some(start_dt),
    Some(end_dt),
    Some(1000),
    Some(ClientId::new("CME")),
    request_id,
    clock.borrow().timestamp_ns(),
    Some(params),
);

// Internally, this will:
// 1. Split request across segments (ESH4, ESM4, ESU4)
// 2. Apply appropriate adjustments to each segment
// 3. Aggregate into continuous bars
// 4. Return unified response
engine.execute_request(RequestCommand::Bars(request_cmd));
```

#### 9. Option Chain Management

**Purpose**: Manage option chain subscriptions, including instrument discovery, greeks calculation, and expiration handling.

Use these methods when:

- Trading options and need greeks calculations
- Need to discover option instruments for a series
- Managing option chain lifecycle and expiration

**Usage Example**:

```rust
// Initialize option chain with strike range around ATM price
engine.execute(DataCommand::Subscribe(SubscribeCommand::OptionChain(cmd)));

// When forward prices arrive, instant ATM bootstrap occurs
// Otherwise, bootstrap from live data quotes
```

#### 10. Synthetic Instrument Management

**Purpose**: Generate synthetic instrument data by combining component instrument data using pricing formulas.

Use these methods when:

- Trading spread instruments (calendar spreads, butterflies, etc.)
- Need synthetic instruments calculated from components
- Generating synthetic quotes and trades from component data

**Usage Example**:

```rust
// Register spread instrument and subscribe to component data feeds
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(subscribe_cmd)));

// Subscribe to component instruments to feed the spread calculation
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(esu4_cmd)));
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(esh4_cmd)));

// Synthetic quotes are calculated automatically when component data arrives
```

#### 11. Request Pipeline Management

**Purpose**: Manage complex multi-leg data requests that need to be combined into a single response. This feature enables efficient retrieval of data across multiple instruments, segments, or time ranges by parallelizing requests and aggregating results.

Use these methods when:

- Requesting data for multiple instruments that should be returned as a single response
- Splitting requests across time segments or data sources for better performance
- Implementing custom data joining logic for complex queries

**Usage Example**:

```rust
// Example 1: Using RequestJoin to get data from multiple instruments
// RequestJoin allows joining data from multiple instruments into one response

let instruments = vec![
    InstrumentId::from_str("BTCUSDT.BINANCE").unwrap(),
    InstrumentId::from_str("ETHUSDT.BINANCE").unwrap(),
    InstrumentId::from_str("SOLUSDT.BINANCE").unwrap(),
];

let start_dt = chrono::Utc::now() - chrono::Duration::hours(24);
let end_dt = chrono::Utc::now();

let request_id = UUID4::new();
let join_request = RequestJoin::new(
    RequestDataKind::Quotes,  // Request quotes for all instruments
    instruments,
    Some(start_dt),
    Some(end_dt),
    None,  // No limit
    Some(ClientId::new("BINANCE")),
    request_id,
    clock.borrow().timestamp_ns(),
    None,
    None,
);

// Internally, this will:
// 1. handle_request_join creates dated version of the join
// 2. new_request_pipeline registers parent with n_components = instruments.len()
// 3. register_request_pipeline_leg links each leg request to parent
// 4. Dispatches separate quote requests for each instrument
// 5. handle_request_pipeline_response accumulates responses
// 6. finalize_request_join rebuilds combined response when all legs arrive
engine.execute_request(RequestCommand::Join(join_request));

// Example 2: Manual pipeline management for complex data retrieval
// Suppose you want to fetch data from multiple time ranges in parallel

let mut time_ranges = vec![
    (start_dt, start_dt + chrono::Duration::hours(6)),
    (start_dt + chrono::Duration::hours(6), start_dt + chrono::Duration::hours(12)),
    (start_dt + chrono::Duration::hours(12), end_dt),
];

let parent_id = UUID4::new();
let instrument_id = InstrumentId::from_str("BTCUSDT.BINANCE").unwrap();

// Register parent pipeline
let parent_request = RequestQuotes::new(
    instrument_id,
    Some(start_dt),
    Some(end_dt),
    Some(1000),
    Some(ClientId::new("BINANCE")),
    parent_id,
    clock.borrow().timestamp_ns(),
    None,
);
engine.new_request_pipeline(
    RequestCommand::Quotes(parent_request),
    time_ranges.len(),
);

// Dispatch leg requests for each time range
for (start, end) in time_ranges {
    let leg_id = UUID4::new();
    engine.register_request_pipeline_leg(leg_id, parent_id);

    let leg_request = RequestQuotes::new(
        instrument_id,
        Some(start),
        Some(end),
        Some(1000 / time_ranges.len() as u64),  // Split limit across legs
        Some(ClientId::new("BINANCE")),
        leg_id,
        clock.borrow().timestamp_ns(),
        None,
    );

    // The response will be handled by handle_request_pipeline_response
    engine.execute_request(RequestCommand::Quotes(leg_request));
}

// When all leg responses arrive, handle_request_pipeline_response will:
// 1. Accumulate all leg responses
// 2. Sort by timestamp
// 3. Rebuild single response with combined data
// 4. Trim to original parent bounds
// 5. Return via response() method

// Example 3: Monitoring pipeline state
let active_pipelines = engine.request_pipeline_count();
let pending_joins = engine.pending_join_request_count();

log::info!("Active request pipelines: {}", active_pipelines);
log::info!("Pending join requests: {}", pending_joins);

// Use get_clients to check if clients are processing requests
let clients = engine.get_clients();
for client in clients {
    if client.is_connected() {
        log::info!("Client {} is processing pipeline requests", client.client_id());
    }
}
```

#### 12. Time Range Pipeline Management

**Purpose**: Manage time-split data requests that automatically handle date ranges across multiple segments or data sources. This feature optimizes historical data retrieval by breaking large time ranges into manageable chunks.

Use these methods when:

- Requesting historical data spanning long time periods
- Working with data sources that have per-request limits
- Need efficient parallelization of time-based data retrieval

**Usage Example**:

```rust
// Request historical data spanning multiple days/months
// The engine automatically splits the request into time-based segments

let start_dt = chrono::Utc::now() - chrono::Duration::days(30);
let end_dt = chrono::Utc::now();

let instrument_id = InstrumentId::from_str("BTCUSDT.BINANCE").unwrap();

let bar_type = BarType::from_str("BTCUSDT.BINANCE-1-HOUR-LAST-EXTERNAL").unwrap();
let request_id = UUID4::new();

let mut params = Params::new();
params.insert("time_range_segment_days", "7");  // Split into 7-day segments

let request_cmd = RequestBars::new(
    bar_type,
    Some(start_dt),
    Some(end_dt),
    Some(1000),
    Some(ClientId::new("BINANCE")),
    request_id,
    clock.borrow().timestamp_ns(),
    Some(params),
);

// Internally, this will:
// 1. execute_time_range_pipeline_request detects time range parameters
// 2. Splits the 30-day range into 7-day segments (4-5 segments total)
// 3. Creates child requests for each segment
// 4. Registers each child as a pipeline leg
// 5. Dispatches child requests in parallel
// 6. handle_time_range_pipeline_child_response accumulates results
// 7. Combines all segments into final response sorted by time
engine.execute_request(RequestCommand::Bars(request_cmd));

// Monitor pipeline progress
let time_range_pipelines = engine.time_range_pipeline_count();
log::info!("Active time range pipelines: {}", time_range_pipelines);

// The engine handles segment boundaries automatically:
// - Ensures no data gaps between segments
// - Removes duplicates at segment boundaries
// - Maintains correct time ordering
// - Applies consistent trimming to all segments
```

#### 13. Spread Quote Management

**Purpose**: Manage spread instrument quote aggregation by combining component instrument data. Spread instruments (like calendar spreads) calculate their price as a weighted combination of their leg instruments.

Use these methods when:

- Trading spread instruments (calendar spreads, butterflies, etc.)
- Need real-time spread quote generation from component data
- Managing spread quote aggregation lifecycle

**Usage Example**:

```rust
// Configure and start spread quote aggregator for automatic calculation
engine.execute(DataCommand::Subscribe(SubscribeCommand::Quotes(subscribe_cmd)));

// Stop aggregator and unsubscribe all component legs automatically
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::Quotes(unsubscribe_cmd)));
```

#### 14. Deferred Command Management

**Purpose**: Manage deferred execution of subscribe/unsubscribe commands that need to be queued and executed after certain conditions are met (e.g., after instrument discovery completes).

Use these methods when:

- Implementing option chain auto-discovery
- Handling subscription dependencies
- Managing command execution order

**Usage Example**:

```rust
// Option chain discovery queues subscribe commands until ATM price determined
engine.execute(DataCommand::Subscribe(SubscribeCommand::OptionChain(cmd)));

// When instrument expires, deferred unsubscribe commands clean up resources
```

#### 15. Subscription Query

**Purpose**: Query methods to retrieve current subscription state and engine statistics.

Use these methods when:

- Monitoring engine state
- Debugging subscription issues
- Getting statistics for reporting

**Usage Example**:

```rust
// Query current subscription state and engine statistics
let quote_instruments = engine.subscribed_quotes();
let bar_types = engine.subscribed_bars();

// Retrieve cumulative message counts and operational metrics
log::info!("Commands: {}, Data: {}, Requests: {}, Responses: {}",
    engine.command_count(), engine.data_count(),
    engine.request_count(), engine.response_count());

// Check pipeline and option chain operational status
log::info!("Pending option chains: {}, Request pipelines: {}, Time range pipelines: {}, Join requests: {}",
    engine.pending_option_chain_request_count(), engine.request_pipeline_count(),
    engine.time_range_pipeline_count(), engine.pending_join_request_count());

// Access engine cache and clock for direct data queries
let cache = engine.get_cache();
let clock = engine.get_clock();

// Get registered clients for status monitoring
let clients = engine.get_clients();
for client in clients {
    log::info!("Client {} connected: {}", client.client_id(), client.is_connected());
}
```

## BookDeltasUnsubscribeResult

An enum that represents the result of attempting to unsubscribe from order book delta subscriptions.

### Purpose

Provides status information about the outcome of an unsubscribe operation, allowing the engine to determine whether to proceed with client-level unsubscription or keep the client subscribed due to remaining subscribers.

### Data Storage

The enum has three variants with no associated data:

1. `NotSubscribed` - Indicates the subscription was not found
2. `Decremented` - Indicates the subscription count was decremented but still has subscribers
3. `Removed` - Indicates the subscription was completely removed

**Example**:

```rust
let result = BookDeltasUnsubscribeResult::Decremented;
match result {
    BookDeltasUnsubscribeResult::NotSubscribed => {
        // Log warning about non-existent subscription
    }
    BookDeltasUnsubscribeResult::Decremented => {
        // Keep client subscribed, other subscribers remain
    }
    BookDeltasUnsubscribeResult::Removed => {
        // Unsubscribe from client
    }
}
```

### Actions and I/O

**Action: Unsubscribe Operation**

- Input: `(InstrumentId, Option<ClientId>, Option<Venue>)` - Subscription key
- Output: `BookDeltasUnsubscribeResult` - Operation result

**Example**:

```rust
fn decrement_book_delta_subscription(
    &mut self,
    instrument_id: InstrumentId,
    client_id: Option<ClientId>,
    venue: Option<Venue>,
) -> BookDeltasUnsubscribeResult {
    let key = (instrument_id, client_id, venue);

    let Some(count) = self.book_deltas_counts.get_mut(&key) else {
        return BookDeltasUnsubscribeResult::NotSubscribed;
    };

    if *count > 1 {
        *count -= 1;
        return BookDeltasUnsubscribeResult::Decremented;
    }

    self.book_deltas_counts.shift_remove(&key);
    BookDeltasUnsubscribeResult::Removed
}
```

## ContinuousFutureRoller

A helper struct that routes continuous-future transition timer events back to the data engine.

### Purpose

Prevents reference cycles between the clock's timer callbacks and the engine. The clock owns the timer's callback closure, which needs to call back into the engine without creating an Rc cycle. The roller holds a weak reference to the engine and upgrades it on each timer event.

### Data Storage

- `engine: WeakCell<DataEngine>` - A weak reference to the data engine

**Example**:

```rust
let roller = ContinuousFutureRoller {
    engine: WeakCell::from(Rc::downgrade(&engine_rc)),
};
```

### Actions and I/O

**Action: Handle Timer Event**

- Input: `&TimeEvent` - Timer event with transition information
- Output: Side effects (updates engine state)

**Example**:

```rust
impl ContinuousFutureRoller {
    fn handle_transition(&self, event: &TimeEvent) {
        if let Some(engine) = self.engine.upgrade() {
            engine
                .borrow_mut()
                .handle_continuous_future_subscription_transition(event);
        }
    }
}
```

**Usage Pattern**:

```rust
// Created during engine initialization
engine.borrow_mut().continuous_future_roller = Some(Rc::new(
    ContinuousFutureRoller::new(&engine)
));

// Timer callback references the roller
let callback_fn: Rc<dyn Fn(TimeEvent)> = Rc::new(move |event| {
    roller.handle_transition(&event);
});
let callback = TimeEventCallback::from(callback_fn);

// Clock schedules the timer with this callback
clock.borrow_mut().set_time_alert_ns(
    &timer_name,
    UnixNanos::from(transition_ns),
    Some(callback),
    Some(true),
)?;
```

## ContinuousFutureSubscriptionState

Maintains the state for an active continuous future bar subscription.

### Purpose

Tracks the current segment, data source, and transition timing for continuous futures (perpetual contracts that roll from one future contract to another at predefined transition points). This enables automatic subscription management and smooth transitions between contract segments.

### Data Storage

1. **Subscription Details**:

   - `target_bar_type: BarType` - The continuous future bar type being subscribed
   - `client_id: Option<ClientId>` - Client ID making the request
   - `venue: Option<Venue>` - Venue for the subscription
   - `command_id: UUID4` - Original command ID

2. **Parameters**:

   - `params: Option<Params>` - Subscription parameters
   - `request: ContinuousFutureRequest` - Request configuration with transitions

3. **Active Segment**:

   - `active_segment_instrument_id: InstrumentId` - Currently active contract segment
   - `active_source: ContinuousFutureSource` - Data source for current segment (Bars/Trades/Quotes)
   - `active_source_subscription: Option<BarAggregatorSubscription>` - Current subscription handler

4. **Transition State**:

   - `next_transition_index: Option<usize>` - Index of next transition in transitions array
   - `timer_name: Option<String>` - Name of scheduled transition timer

**Example**:

```rust
ContinuousFutureSubscriptionState {
    target_bar_type: BarType::from_str("ES.GLBXC-CME.L2_MBP-100-TICK-MID-INTERNAL").unwrap(),
    client_id: Some(ClientId::new("BINANCE")),
    venue: Some(Venue::new("CME")),
    command_id: UUID4::new(),
    params: Some(params),
    request: ContinuousFutureRequest { /* ... */ },
    active_segment_instrument_id: InstrumentId::from_str("ESH4.CME").unwrap(),
    active_source: ContinuousFutureSource::Bars(/* source bar type */),
    active_source_subscription: Some(BarAggregatorSubscription::Bar { /* ... */ }),
    next_transition_index: Some(1),
    timer_name: Some("continuous-future-roll:ES.GLBXC-CME.L2_MBP-100-TICK-MID-INTERNAL:1".to_string()),
}
```

### Actions and I/O

**Action: Transition to Next Segment**

- Input: `&TimeEvent` - Timer event triggering transition
- Output: Side effects (updates subscription state, unsubscribes old, subscribes new)

**Action: Subscription Creation**

- Input: `&SubscribeBars` command with continuous future parameters
- Output: `anyhow::Result<()>` - Success or error

**Action: Subscription Removal**

- Input: `&UnsubscribeBars` command
- Output: Side effects (cleans up state, cancels timer, stops aggregator)

**Example Usage**:

```rust
// Subscribe to continuous future bars
let cmd = SubscribeBars::new(
    bar_type,
    Some(client_id),
    Some(venue),
    UUID4::new(),
    ts_init,
    None,
    Some(params_with_transitions),
);
engine.execute(DataCommand::Subscribe(SubscribeCommand::Bars(cmd)));

// Transition occurs automatically at scheduled time
// via ContinuousFutureRoller calling handle_transition

// Unsubscribe when done
let unsub = UnsubscribeBars::new(
    bar_type,
    Some(client_id),
    Some(venue),
    UUID4::new(),
    ts_init,
    None,
    None,
);
engine.execute(DataCommand::Unsubscribe(UnsubscribeCommand::Bars(unsub)));
```