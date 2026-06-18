# NautilusTrader Backtest Crate Documentation

## Purpose

The `nautilus-backtest` crate provides a high-fidelity, event-driven backtesting framework for the NautilusTrader trading system. It enables quantitative traders and researchers to test and validate trading strategies on historical data with realistic market simulation, providing seamless transition from backtesting to live trading.

## Problem Solved

The backtest crate addresses several critical challenges in algorithmic trading research and development:

- **Realistic Market Simulation**: Traditional backtesting often lacks realistic order matching, execution latency, and market impact modeling, leading to over-optimistic performance estimates.
- **Research-to-Production Gap**: Trading strategies often behave differently in backtesting versus live environments due to architectural differences and simulation inaccuracies.
- **Complex Market Dynamics**: Modern markets involve multi-asset, multi-venue trading with complex order types, margin requirements, and risk management that need accurate simulation.
- **Deterministic Testing**: Ensuring reproducible results across multiple runs while maintaining realistic execution behavior.
- **Performance Analysis**: Comprehensive metrics and analytics needed to properly evaluate strategy performance.

## Technical Solutions

The crate implements several sophisticated techniques to solve these problems:

### Event-Driven Architecture

- **Time-Ordered Data Replay**: Uses a priority-based data iterator (`BacktestDataIterator`) that merges multiple data streams chronologically, handling ties with configurable priority rules.
- **Timer Event Accumulation**: Implements a binary heap-based time event scheduler (`TimeEventAccumulator`) for precise timer management across multiple components.
- **Deterministic Clock Management**: Uses `TestClock` for precise control over simulation time, enabling reproducible results.

### Realistic Market Simulation

- **Order Matching Engines**: Per-instrument `OrderMatchingEngine` instances that process various order types (limit, market, stop, etc.) with realistic fill logic.
- **Configurable Execution Models**: Pluggable fill models, fee models, and latency models to simulate different venue behaviors.
- **Market Impact Simulation**: Tracks liquidity consumption and can simulate price impact from large orders.
- **Order Book Management**: Maintains full order book state with L1/L2/L3 depth support for realistic price discovery.

### Risk and Position Management

- **Account Types**: Supports Cash, Margin, and Betting accounts with appropriate balance tracking.
- **Liquidation Engine**: Monitors margin requirements and triggers liquidations when maintenance margins are breached.
- **Funding Rate Settlement**: Handles periodic funding rate calculations and settlements for perpetual contracts.
- **Position Tracking**: Comprehensive position management with P&L calculations and position snapshots.

### Extensibility Framework

- **Simulation Modules**: Plugin architecture for custom venue behaviors (e.g., FX rollover interest, market making).
- **Exchange Context**: Read-only access to exchange state for module implementations.
- **Streaming Mode**: Supports chunk-based data loading for large datasets.

### Performance Optimization

- **Efficient Data Structures**: Uses `AHashMap` and `BinaryHeap` for high-performance data processing.
- **Memory Management**: Careful use of `Rc<RefCell<>>` for shared state without excessive memory overhead.
- **Batch Processing**: Efficient handling of large data volumes through streaming and chunking.

## File Tree

```
crates/backtest/
├── src/
│   ├── engine.rs              # Core backtest engine implementation
│   ├── exchange.rs            # Simulated exchange with order matching
│   ├── config.rs              # Configuration types for engine, venues, data
│   ├── data_client.rs         # Backtest-specific data client
│   ├── data_iterator.rs       # Multi-stream time-ordered data iterator
│   ├── execution_client.rs    # Backtest execution client for order management
│   ├── accumulator.rs         # Time event accumulation and scheduling
│   ├── result.rs              # Backtest results and metrics
│   ├── modules/
│   │   ├── mod.rs            # Simulation module trait and implementations
│   │   └── fx_rollover.rs    # FX rollover interest module
│   ├── defi/                  # DeFi-specific backtesting (optional feature)
│   │   ├── mod.rs
│   │   ├── engine.rs
│   │   └── replay.rs
│   ├── python/                # Python bindings (optional feature)
│   │   ├── mod.rs
│   │   ├── engine.rs
│   │   ├── config.rs
│   │   ├── result.rs
│   │   └── node.rs
│   ├── ffi/                   # C FFI bindings (optional feature)
│   │   ├── mod.rs
│   │   └── accumulator.rs
│   ├── lib.rs                 # Public API and module exports
│   └── node.rs                # Streaming backtest node (optional feature)
├── tests/                     # Integration tests
├── examples/                  # Example backtest implementations
├── Cargo.toml                 # Dependencies and features
├── build.rs                   # Build configuration
├── README.md                  # Documentation
└── cbindgen.toml             # C binding generation config
```

## Data Flow

The backtest engine follows a sophisticated event-driven data flow:

### 1. Setup Phase

- **Configuration Loading**: `BacktestEngineConfig` and `SimulatedVenueConfig` define engine behavior
- **Venue Registration**: `add_venue()` creates `SimulatedExchange` instances with matching engines
- **Instrument Registration**: `add_instrument()` registers trading instruments and initializes matching engines
- **Data Loading**: `add_data()` loads historical market data into the `BacktestDataIterator`

### 2. Execution Phase

**Data Iteration**:

- `BacktestDataIterator` merges multiple data streams chronologically
- Uses priority-based ordering for simultaneous events
- Supports both single-stream fast path and multi-stream heap merging

**Event Processing Loop**:
```
Historical Data → Data Iterator → Time Advancement
                                      ↓
                            Timer Event Processing
                                      ↓
                      ┌────────────────┴────────────────┐
                      ↓                                 ↓
              Market Data → Simulated Exchange     Trading Commands
                      ↓                                 ↓
              Order Matching                      Order Routing
                      ↓                                 ↓
              Fill Generation                    Latency Simulation
                      ↓                                 ↓
              Execution Events ←─────────────────┘
                      ↓
              Portfolio Updates
                      ↓
              Strategy Callbacks
```

**Detailed Processing Steps**:

1. **Time Advancement**: Engine advances clock to next data timestamp
2. **Timer Events**: Process all timers due at or before current time
3. **Market Data**: Route quotes, trades, order book updates to exchanges
4. **Order Matching**: Exchanges match orders against current market state
5. **Command Processing**: Process queued trading commands with latency simulation
6. **Event Generation**: Generate fills, order updates, account state changes
7. **Portfolio Updates**: Update positions, balances, and P&L
8. **Strategy Execution**: Call strategy callbacks with new market data
9. **Module Processing**: Run simulation modules (e.g., funding, rollovers)
10. **Settlement**: Finalize pending operations and prepare for next iteration

### 3. Result Phase

- **Metrics Collection**: Gather performance statistics from portfolio and analyzer
- **Result Generation**: Create `BacktestResult` with comprehensive metrics
- **Analysis**: Calculate returns, Sharpe ratios, drawdowns, and other analytics

## Logic Flow

### Engine Initialization

1. **Kernel Setup**: Create `NautilusKernel` with data, execution, and risk engines
2. **Clock Configuration**: Initialize `TestClock` for deterministic time management
3. **Cache Setup**: Configure cache with appropriate settings (instruments persist across resets)
4. **Venue Configuration**: Register simulated exchanges with matching engines
5. **Instrument Setup**: Add instruments and initialize matching engines
6. **Data Loading**: Load and sort historical data streams

### Main Backtest Loop

**Time Management**:

- Determine start/end timestamps from data or configuration
- Skip data points before start time
- Process data points within time range
- Handle timer events between data points

**Event Ordering**:

- Priority-based resolution of simultaneous events
- DeFi data ordered by block position within same timestamp
- Market data processed before trading commands at same timestamp

**State Management**:

- Maintain consistent state across all engines
- Handle command queues and inflight commands
- Process simulation modules at each timestamp
- Manage funding settlements and liquidations

### Exchange Processing

**Order Matching Logic**:

- Process order books: deltas, depth snapshots, quotes, trades
- Match orders against current market state
- Apply fill models for execution simulation
- Calculate fees and update account balances

**Account Management**:

- Track balances across multiple currencies
- Calculate margins for leveraged trading
- Handle funding rate settlements
- Trigger liquidations when margin requirements breached

**Market Impact**:

- Track liquidity consumption at each price level
- Adjust order book state based on executed trades
- Simulate partial fills for large orders

### Risk Management

- **Pre-Trade Checks**: Validate orders against risk limits
- **Position Limits**: Enforce maximum position sizes
- **Margin Requirements**: Calculate and monitor margin levels
- **Liquidation**: Close positions when margin is insufficient

### Result Generation

- **Performance Metrics**: Calculate returns, volatility, Sharpe ratio, etc.
- **Trade Analysis**: Analyze win rate, average win/loss, profit factor
- **Risk Metrics**: Calculate maximum drawdown, VaR, exposure
- **Account Summary**: Generate final account states and P&L breakdown

## Key Features

### Multi-Asset Support

- Equity, FX, futures, options, perpetual contracts
- Multiple account types (Cash, Margin, Betting)
- Cross-asset position and risk management

### Realistic Execution

- Various order types (limit, market, stop, trailing stop, etc.)
- Order emulation for venues lacking specific order types
- Latency simulation for realistic execution timing
- Fee models for different venue structures

### Advanced Analytics

- Real-time performance metrics during backtest
- Comprehensive post-run analysis
- Position-level P&L tracking
- Risk-adjusted performance measures

### Research Integration

- Seamless transition from backtesting to live trading
- Same strategy code runs in both environments
- Configuration-driven environment switching

### Extensibility

- Custom simulation modules for venue-specific behaviors
- Pluggable fill, fee, and latency models
- Support for custom data types and venues
- Python and C FFI bindings for integration

This architecture ensures that strategies tested in the backtest environment behave consistently when deployed to production, significantly reducing the risk of unexpected behavior differences between testing and live trading.