# Backtest Engine

## Purpose

The `BacktestEngine` is the core component responsible for running event-driven strategy backtests on historical market data. It provides a high-fidelity simulation environment that processes historical data chronologically through an event-driven architecture, enabling strategies to be tested exactly as they would run in live trading.

## Problem Resolved

The engine addresses several critical challenges in algorithmic trading backtesting:


- **Deterministic replay**: Ensures strategies can be tested on historical data in a predictable, repeatable manner
- **Realistic order matching**: Provides accurate simulation of exchange behavior including order book dynamics, fills, and execution
- **Multi-venue support**: Handles multiple trading venues with different account types, book types, and configurations
- **Event-driven architecture**: Processes data and events in chronological order with proper timing semantics
- **State management**: Maintains consistent state across iterations while allowing resets for strategy optimization
- **Performance analysis**: Enables comprehensive portfolio and strategy performance analysis
- **Live trading transition**: Provides a seamless path from backtesting to live deployment using identical strategy code

## Techniques Used

The engine implements several sophisticated techniques to achieve realistic backtesting:


### Event-Driven Architecture
- Data is processed chronologically through an event loop
- Each data point triggers updates to exchanges, order books, and strategy callbacks
- Timer events are handled through a `TimeEventAccumulator` that schedules and executes time-based operations

### Simulated Exchange System
- Multiple `SimulatedExchange` instances model different venues with realistic order matching
- Fill models can be customized per venue to simulate different exchange behaviors
- Order book processing includes delta updates, depth snapshots, and trade ticks

### Time Management
- `TestClock` provides deterministic time advancement through the backtest
- Timer events (bar aggregation, alerts, expirations) are accumulated and fired at appropriate timestamps
- Clock synchronization across all components ensures consistent time perception

### Command Queue Processing
- Synchronous command senders handle trading and data commands
- Cascading re-entrancy is handled through iterative queue draining
- Latency models can defer command execution to simulate network delays

### Data Streaming
- `BacktestDataIterator` merges multiple data streams by timestamp
- Supports both batch and streaming backtest workflows
- Data validation ensures instruments exist and aggregation sources are correct

## File Tree

```
crates/backtest/src/
├── engine.rs                 # Core BacktestEngine implementation
├── config.rs                 # BacktestEngineConfig and SimulatedVenueConfig
├── exchange.rs               # SimulatedExchange for venue simulation
├── accumulator.rs            # TimeEventAccumulator for timer management
├── data_iterator.rs          # BacktestDataIterator for data streaming
├── execution_client.rs       # BacktestExecutionClient for order submission
├── data_client.rs            # BacktestDataClient for data routing
├── result.rs                 # BacktestResult for performance metrics
├── node.rs                   # BacktestNode for application-level orchestration
└── modules/
    └── mod.rs                # Venue modules (e.g., FX rollover)
```

## Data Flow

### Setup Phase

1. **Engine Creation**: `BacktestEngine::new()` creates the kernel, cache, and initial state
2. **Venue Addition**: `add_venue()` creates `SimulatedExchange` and `BacktestExecutionClient` instances
3. **Instrument Addition**: `add_instrument()` registers instruments and sets up expiration timers
4. **Data Addition**: `add_data()` loads historical data into the `BacktestDataIterator`

### Execution Phase

```
Historical Data → Data Iterator
                      ↓
        Route to Exchange (if applicable)
                      ↓
        Process in Data Engine → Strategies/Actors
                      ↓
        Drain Command Queues
                      ↓
        Settle Venues → Process Orders → Generate Fills
                      ↓
        Run Venue Modules (e.g., FX rollover)
                      ↓
        Run Venue Liquidations (if needed)
                      ↓
        Advance Timer Events → Schedule Next Data
```

### Result Phase

1. **Result Collection**: `get_result()` builds performance metrics and statistics
2. **Portfolio Analysis**: `PortfolioAnalyzer` calculates PnL, returns, and general statistics
3. **Performance Logging**: Detailed performance metrics are logged to console

## Logic Flow

### Initialization

```
BacktestEngine::new()
    ├── Create NautilusKernel
    ├── Initialize TimeEventAccumulator
    ├── Create empty BacktestDataIterator
    └── Set initial state fields
```

### Configuration

```
add_venue()
    ├── Create SimulatedExchange
    ├── Create BacktestExecutionClient
    ├── Register exchange endpoints
    └── Register client with ExecutionEngine

add_instrument()
    ├── Validate venue exists
    ├── Add instrument to exchange
    ├── Set expiration timer if applicable
    ├── Register market data client
    └── Process instrument through DataEngine

add_data()
    ├── Sort data by timestamp (if requested)
    ├── Validate instruments and data types
    ├── Track data availability (has_data, has_book_data)
    ├── Add to BacktestDataIterator
    └── Update time bounds (ts_first, ts_last_data)
```

### Main Execution Loop

```
run()
    ├── Determine time boundaries (start_ns, end_ns)
    ├── Collect and set all component clocks
    ├── Initialize venues and accounts
    ├── Start kernel and trader
    └── Execute run_impl()

run_impl()
    ├── Skip data before start_ns
    ├── Loop:
    │   ├── Check shutdown/force_stop
    │   ├── Advance time if timestamp changed
    │   │   ├── Process timer events
    │   │   ├── Settle venues
    │   │   ├── Run venue modules
    │   │   └── Run venue liquidations
    │   ├── Route data to exchange
    │   ├── Process data through DataEngine
    │   ├── Drain command queues
    │   ├── Settle venues
    │   ├── Flush timer events
    │   └── Advance to next data point
    └── Post-run settlement
```

### Time Advancement

```
advance_time_impl()
    ├── Advance all clocks through accumulator
    ├── Process timer events < ts_now
    │   ├── Settle venues
    │   ├── Run venue modules
    │   ├── Run venue liquidations
    │   ├── Set clock to event time
    │   ├── Execute event handler
    │   └── Drain command queues
    └── Set final clock time
```

### Command Processing

```
drain_command_queues()
    ├── Loop until all queues empty
    │   ├── Drain trading command queue
    │   ├── Drain data command queue
    │   └── Drain execution client events
    └── Return when quiescent

settle_venues()
    ├── Advance all venue clocks
    ├── Loop until no pending commands
    │   ├── Drain command queues
    │   ├── Process venue commands
    │   ├── Iterate matching engines
    │   └── Drain command queues again
```

### Timer Management

```
TimeEventAccumulator
    ├── advance_clock(TestClock) to accumulate events
    ├── pop_next_at_or_before(ts) to get next event
    └── Execute event callbacks

Timer Types:
    ├── Bar aggregation timers
    ├── Time alerts
    ├── Instrument expiration timers
    └── Funding settlement timers
```

### Result Generation

```
get_result()
    ├── Calculate elapsed time
    ├── Collect orders from cache
    ├── Collect positions and snapshots
    ├── Build summary statistics
    ├── Build PortfolioAnalyzer
    ├── Calculate performance metrics
    │   ├── PnL statistics per currency
    │   ├── Returns statistics
    │   └── General statistics
    └── Return BacktestResult
```

### Reset and Cleanup

```
reset()
    ├── Stop trader if running
    ├── Stop and reset all engines
    ├── Reset exchanges
    ├── Reset trader and portfolio
    ├── Clear run state
    ├── Clear accumulator
    └── Reset data iterator cursors

dispose()
    ├── Clear data
    ├── Clear accumulator
    └── Dispose kernel
```

## Key Features


- **Multi-venue Support**: Handle different exchange configurations and account types
- **Streaming Backtest**: Support for incremental data loading for large datasets
- **Event Store Replay**: Integration with persistent event stores for state restoration
- **Latency Simulation**: Configurable latency models for realistic order execution
- **Venue Modules**: Pluggable modules for venue-specific logic (e.g., FX rollover)
- **Comprehensive Analysis**: Portfolio and strategy performance metrics with multiple currencies
- **Deterministic Execution**: Repeatable backtests with identical results
- **Reset Capability**: Efficient re-running with different strategies without reloading data

## State Management

The engine maintains several important state fields:


- **Run State**: `run_config_id`, `run_id`, `run_started`, `run_finished`
- **Time State**: `backtest_start`, `backtest_end`, `last_ns`, `end_ns`
- **Data State**: `data_len`, `data_stream_counter`, `ts_first`, `ts_last_data`, `sorted`
- **Tracking State**: `has_data`, `has_book_data`, `iteration`, `force_stop`
- **Module State**: `last_module_ns`, `last_liquidation_ns`

This state is preserved during runs and cleared on reset, enabling efficient strategy optimization workflows.