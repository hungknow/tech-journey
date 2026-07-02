# SimulatedExchange

The `SimulatedExchange` is a comprehensive simulation of a trading venue designed for realistic trading execution during backtesting. It provides a complete exchange environment with order matching engines, account management, and configurable execution models to accurately simulate real market conditions.

## Overview

The `SimulatedExchange` serves as the core venue simulation component in NautilusTrader's backtesting infrastructure. It maintains order books, processes market data, executes trades, and manages account state with configurable models for fees, fills, and latency to provide realistic backtesting scenarios.

### Key Features

- **Multi-instrument order matching** with realistic execution
- **Configurable fee, fill, and latency models** for accurate simulation
- **Support for various order types** and execution options
- **Account balance and position management**
- **Market data processing** and order book maintenance
- **Simulation modules** for custom venue behaviors
- **Network latency simulation** with priority queue processing

## Implementation

The `SimulatedExchange` is implemented in Rust:

- **Rust implementation**: `crates/backtest/src/exchange.rs`
- **Python/Cython interface**: `nautilus_trader/backtest/engine.pyx`

## Core Submodules

The `SimulatedExchange` integrates several key submodules to provide its functionality:

### 1. OrderMatchingEngine

**Purpose**: Handles order matching and execution for individual instruments.

**Location**: `crates/execution/src/matching_engine/engine.rs`

**Responsibilities**:

- Maintains an order book for a single instrument
- Processes order submissions, modifications, and cancellations
- Executes orders against market data (quotes, trades, bars, order book deltas)
- Applies fill models to determine execution probabilities
- Calculates fees using fee models
- Generates order events (filled, rejected, canceled, etc.)

**State Managed**:

- Order book state (`OrderBook`)
- Open orders (bid and ask sides)
- Market status (open/closed)
- Target prices (bid, ask, last) for bar execution
- Cached filled quantities
- Account ID mappings

### 2. BacktestExecutionClient

**Purpose**: Provides the execution client interface for backtesting, bridging trading commands from strategies to the simulated exchange.

**Location**: `crates/backtest/src/execution_client.rs`

**Responsibilities**:

- Receives trading commands from strategies
- Forwards commands to `SimulatedExchange` via `send()` method
- Manages account state generation
- Tracks connection status
- Generates order submitted events

**State Managed**:

- Connection status
- Account ID and client ID
- Reference to the exchange (weak reference)

### 3. SimulationModule

**Purpose**: Allows custom extensions to the backtesting simulation environment.

**Location**: `crates/backtest/src/modules/mod.rs`

**Responsibilities**:

- Pre-processes market data before main simulation
- Implements custom venue behaviors (e.g., market makers, price impact)
- Processes simulation logic at specific timestamps
- Resets module state between backtest runs

**State Managed**: Module-specific state (varies by implementation)

### 4. Cache

**Purpose**: Provides shared data access for instruments, accounts, and other market data.

**Location**: `crates/common/src/cache.rs`

**Responsibilities**:

- Stores instrument definitions
- Maintains account information
- Provides indexed access to market data

**State Managed**:

- Instrument registry
- Account registry
- Market data indexes

### 5. Clock

**Purpose**: Provides time management for the simulation.

**Location**: `crates/common/src/clock.rs`

**Responsibilities**:
- Tracks current simulation timestamp
- Provides time-based operations

**State Managed**:
- Current timestamp (`UnixNanos`)

## Core State and Data Management

The `SimulatedExchange` manages the following state:

### Exchange Configuration

- **`id`**: Venue identifier
- **`oms_type`**: Order management system type (Netting/Hedging)
- **`account_type`**: Account type (Cash/Margin)
- **`book_type`**: Order book type (L1_MBP, L2_MBP, L3_MBO)
- **`base_currency`**: Base currency for single-currency accounts
- **`default_leverage`**: Default leverage for margin accounts
- **`leverages`**: Instrument-specific leverage configuration

### Execution Models

- **`fill_model`**: Fill model for order execution probability
- **`fee_model`**: Fee model for calculating trading fees
- **`latency_model`**: Optional latency model for network delay simulation

### Instrument and Engine Management

- **`instruments`**: HashMap of registered instruments (`InstrumentId` → `InstrumentAny`)
- **`matching_engines`**: HashMap of order matching engines, where each engine manages a single instrument's order book (`InstrumentId` → `OrderMatchingEngine`)
- **`modules`**: Vector of simulation modules for custom behaviors

**Architecture Notes**:

- One `OrderMatchingEngine` per instrument (1:1 mapping)
- One `OrderBook` per matching engine (independent order books)
- Multi-instrument support enables simultaneous trading on different markets
- The exchange routes all operations to the appropriate matching engine based on `InstrumentId`

### Command Processing

- **`message_queue`**: Queue for immediate command processing (`VecDeque<TradingCommand>`)
- **`inflight_queue`**: Priority queue for latency-delayed commands (`BinaryHeap<InflightCommand>`)
- **`inflight_counter`**: Counter for commands at the same timestamp (`HashMap<UnixNanos, u32>`)

### Account Management

- **`starting_balances`**: Initial account balances for backtest runs
- **`exec_client`**: Reference to the execution client for account operations
- **`frozen_account`**: Flag indicating if account balances should not change

### Execution Options

- **`bar_execution`**: Whether bars should move the market
- **`reject_stop_orders`**: Whether to reject stop orders if already in the market
- **`support_gtd_orders`**: Whether to support Good-Till-Date orders
- **`support_contingent_orders`**: Whether to support contingent orders
- **`use_position_ids`**: Whether to generate venue position IDs
- **`use_random_ids`**: Whether to use random UUIDs for venue IDs
- **`use_reduce_only`**: Whether to support reduce-only orders
- **`use_message_queue`**: Whether to use internal message queue
- **`allow_cash_borrowing`**: Whether cash accounts can borrow

## Operational Contexts

### 1. Initialization

**Submodules Involved**:

- `Cache`: Provides instrument and account data
- `Clock`: Provides initial timestamp
- `BacktestExecutionClient`: Registers with exchange

**Actions**:

1. Validates starting balances and base currency configuration
2. Initializes empty data structures (instruments, matching engines, queues)
3. Sets execution options and models
4. Registers execution client (via `register_client()`)
5. Initializes account state (via `initialize_account()`)

**State Changes**:

- Creates fresh account state with starting balances
- Sets default and instrument-specific leverages
- Clears all queues and counters

### 2. Instrument Registration

**Submodules Involved**:

- `OrderMatchingEngine`: Creates new matching engine for instrument
- `Cache`: Retrieves instrument definition if needed

**Actions**:

1. Validates instrument venue matches exchange venue
2. Validates account type compatibility (cash accounts cannot trade futures/perpetuals)
3. Inserts instrument into `instruments` HashMap
4. Creates `OrderMatchingEngine` with configuration
5. Inserts matching engine into `matching_engines` HashMap

**Multi-Order Book Architecture**:

The `SimulatedExchange` supports multiple order books through a one-to-one mapping:

- Each instrument gets exactly one `OrderMatchingEngine`
- Each matching engine maintains exactly one `OrderBook`
- The `matching_engines` HashMap stores all engines keyed by `InstrumentId`
- Order books operate independently with their own market state
- The exchange routes commands to the appropriate matching engine based on the instrument ID

**State Changes**:

- Adds new entry to `instruments` HashMap
- Adds new entry to `matching_engines` HashMap
- Matching engine initializes its own order book and state

### 3. Market Data Processing

#### 3.1 Quote Tick Processing

**Submodules Involved**:

- `SimulationModule`: Pre-processes quote tick data
- `OrderMatchingEngine`: Processes quote tick and updates order book

**Actions**:

1. All modules call `pre_process()` with quote tick data
2. If instrument not registered, retrieves from cache and registers it
3. Matching engine processes quote tick via `process_quote_tick()`
4. Matching engine updates order book bid/ask prices

**State Changes**:

- Order book bid/ask prices updated in matching engine
- Target prices may be updated for execution

#### 3.2 Trade Tick Processing

**Submodules Involved**:

- `SimulationModule`: Pre-processes trade tick data
- `OrderMatchingEngine`: Processes trade tick and executes orders

**Actions**:

1. All modules call `pre_process()` with trade tick data
2. If instrument not registered, retrieves from cache and registers it
3. Matching engine processes trade tick via `process_trade_tick()`
4. Matching engine updates last trade price and executes matching orders

**State Changes**:

- Order book last price updated
- Orders may be filled or partially filled
- Account balances updated via execution client

#### 3.3 Bar Processing

**Submodules Involved**:

- `SimulationModule`: Pre-processes bar data
- `OrderMatchingEngine`: Processes bar and executes orders (if `bar_execution` enabled)

**Actions**:

1. All modules call `pre_process()` with bar data
2. If instrument not registered, retrieves from cache and registers it
3. Matching engine processes bar via `process_bar()`
4. If `bar_execution` is enabled, matching engine updates market prices and executes orders

**State Changes**:

- Order book prices updated based on bar close price
- Orders may be filled based on bar execution logic
- Last bar state stored in matching engine

#### 3.4 Order Book Delta Processing

**Submodules Involved**:

- `SimulationModule`: Pre-processes delta data
- `OrderMatchingEngine`: Processes delta and updates order book

**Actions**:

1. All modules call `pre_process()` with delta data
2. If instrument not registered, retrieves from cache and registers it
3. Matching engine processes single delta via `process_order_book_delta()`
   OR processes batch deltas via `process_order_book_deltas()`
4. Matching engine updates order book with add/update/delete operations

**State Changes**:

- Order book depth updated (for L2/L3 books)
- Best bid/ask prices may change
- Order book sequence number incremented

#### 3.5 Instrument Status Processing

**Submodules Involved**:

- `OrderMatchingEngine`: Updates market status

**Actions**:

1. If instrument not registered, retrieves from cache and registers it
2. Matching engine processes status via `process_status()`
3. Market status updated (open/closed/pre-open/etc.)

**State Changes**:
- Matching engine market status updated
- May affect order acceptance/rejection

### 4. Trading Command Processing

#### 4.1 Command Submission

**Submodules Involved**:

- `BacktestExecutionClient`: Receives command from strategy
- `SimulatedExchange`: Routes command to appropriate queue
- `LatencyModel`: Calculates latency delay (if enabled)

**Actions**:

1. Execution client receives command and calls `exchange.send()`
2. If `use_message_queue` is false, command processed immediately
3. If latency model exists, command added to `inflight_queue` with delayed timestamp
4. Otherwise, command added to `message_queue` for immediate processing

**State Changes**:

- Command added to appropriate queue
- Inflight counter incremented if using latency model

#### 4.2 Command Processing (with Latency)

**Submodules Involved**:

- `SimulatedExchange`: Processes commands from queues
- `OrderMatchingEngine`: Executes command against order book

**Actions**:

1. `process()` called with current timestamp
2. Commands from `inflight_queue` with timestamp <= current time are processed
3. Commands from `message_queue` are processed in order
4. Each command routed to appropriate matching engine
5. Matching engine processes command (submit/modify/cancel)

**State Changes**:

- Commands removed from queues
- Orders added/modified/removed in matching engine
- Order events generated and sent via message bus

#### 4.3 Order Submission

**Submodules Involved**:

- `OrderMatchingEngine`: Validates and processes order
- `FillModel`: Determines fill probability
- `FeeModel`: Calculates fees on fills

**Actions**:

1. Matching engine receives order via `process_order()`
2. Order validated (price, quantity, time in force, etc.)
3. Order added to order book or executed immediately
4. Fill model applied to determine execution
5. Fees calculated on fills
6. Order events generated (accepted, filled, rejected)

**State Changes**:

- Order added to matching engine's order book
- Account balances updated on fills
- Position state updated (if applicable)

#### 4.4 Order Modification

**Submodules Involved**:

- `OrderMatchingEngine`: Processes modification request

**Actions**:

1. Matching engine receives modify command via `process_modify()`
2. Existing order located
3. Order parameters updated (price, quantity, etc.)
4. Order re-evaluated for execution
5. Order updated event generated

**State Changes**:

- Order parameters updated in matching engine
- Order may be re-executed if new price matches market

#### 4.5 Order Cancellation

**Submodules Involved**:

- `OrderMatchingEngine`: Processes cancellation request

**Actions**:

1. Matching engine receives cancel command via `process_cancel()`
   OR `process_cancel_all()` for all orders
   OR `process_batch_cancel()` for specific orders
2. Order(s) located and removed from order book
3. Order canceled event generated

**State Changes**:

- Order removed from matching engine's order book
- Order state updated to canceled

### 5. Account Management

#### 5.1 Account Initialization

**Submodules Involved**:

- `BacktestExecutionClient`: Generates account state
- `Cache`: Stores account information

**Actions**:

1. `initialize_account()` called
2. Starting balances converted to `AccountBalance` objects
3. Execution client generates account state via `generate_account_state()`
4. Default leverage set for margin accounts
5. Instrument-specific leverages applied

**State Changes**:

- Account created in cache with starting balances
- Leverage settings applied
- Account state event published

#### 5.2 Account Adjustment

**Submodules Involved**:

- `BacktestExecutionClient`: Updates account state
- `Cache`: Retrieves current account state

**Actions**:

1. `adjust_account()` called with adjustment amount
2. If account frozen, no action taken
3. Current balance retrieved from cache
4. Balance adjusted (added to total and free)
5. New account state generated via execution client

**State Changes**:

- Account balance updated
- Account state event published with new balances

### 6. Query Operations

**Submodules Involved**:

- `OrderMatchingEngine`: Provides order book and order information
- `Cache`: Provides account information

**Actions**:

- `best_bid_price()`: Returns best bid price from matching engine
- `best_ask_price()`: Returns best ask price from matching engine
- `get_book()`: Returns order book snapshot
- `get_open_orders()`: Returns all open orders (optionally filtered by instrument)
- `get_account()`: Returns account from execution client

**State Changes**: None (read-only operations)

### 7. Reset Operations

**Submodules Involved**:

- `SimulationModule`: Resets module state
- `OrderMatchingEngine`: Resets matching engine state
- `BacktestExecutionClient`: Resets account state

**Actions**:

1. `reset()` called
2. All modules call `reset()`
3. Fresh account state generated
4. All matching engines call `reset()`
5. Queues cleared (TODO: currently not fully implemented)

**State Changes**:

- All trading state reset to initial values
- Account balances reset to starting balances
- Order books cleared
- All open orders removed

## Data Flow

### Market Data Flow

```
Market Data (QuoteTick/TradeTick/Bar/OrderBookDelta)
    ↓
SimulationModule.pre_process() [optional custom processing]
    ↓
SimulatedExchange.process_*()
    ↓
OrderMatchingEngine.process_*()
    ↓
OrderBook.update() + Order Execution
    ↓
Order Events (OrderFilled, etc.)
    ↓
MessageBus → Portfolio → Account Updates
```

### Trading Command Flow

```
Strategy
    ↓
BacktestExecutionClient.submit_order/modify_order/cancel_order()
    ↓
SimulatedExchange.send()
    ↓
[LatencyModel] → InflightQueue OR MessageQueue
    ↓
SimulatedExchange.process()
    ↓
SimulatedExchange.process_trading_command()
    ↓
OrderMatchingEngine.process_order/modify/cancel()
    ↓
Order Events (OrderAccepted, OrderFilled, etc.)
    ↓
MessageBus → Strategy + Portfolio
```

## Configuration Examples

### Basic Exchange Setup

```rust
let exchange = SimulatedExchange::new(
    Venue::new("SIM"),
    OmsType::Netting,
    AccountType::Margin,
    vec![Money::new(10000.0, Currency::USD())],
    Some(Currency::USD()),
    Decimal::from(1),
    HashMap::new(),
    vec![],
    cache,
    clock,
    FillModel::default(),
    FeeModelAny::MakerTaker(MakerTakerFeeModel),
    BookType::L2_MBP,
    None,
    None, // bar_execution
    None, // reject_stop_orders
    None, // support_gtd_orders
    None, // support_contingent_orders
    None, // use_position_ids
    None, // use_random_ids
    None, // use_reduce_only
    None, // use_message_queue
    None, // allow_cash_borrowing
    None, // frozen_account
)?;
```

### Exchange with Latency Model

```rust
let latency_model = LatencyModel::new(
    UnixNanos::from(100),  // base_latency
    UnixNanos::from(200),  // insert_latency
    UnixNanos::from(300),  // update_latency
    UnixNanos::from(100),  // delete_latency
);

let mut exchange = SimulatedExchange::new(...)?;
exchange.set_latency_model(latency_model);
```

### Exchange with Custom Fill Model

```rust
let fill_model = FillModel::new(0.8, 0.0, 0.1); // prob_fill_on_limit, prob_fill_on_stop, prob_slippage

let mut exchange = SimulatedExchange::new(
    ...,
    fill_model,
    ...,
)?;
```

### Multi-Instrument Exchange with Multiple Order Books

```rust
let mut exchange = SimulatedExchange::new(
    Venue::new("BINANCE"),
    OmsType::Netting,
    AccountType::Margin,
    vec![Money::new(100000.0, Currency::USDT())],
    Some(Currency::USDT()),
    Decimal::from(1),
    HashMap::new(),
    vec![],
    cache,
    clock,
    FillModel::default(),
    FeeModelAny::MakerTaker(MakerTakerFeeModel),
    BookType::L2_MBP,
    None,
    None,
)?;

// Add multiple instruments - each gets its own matching engine and order book
exchange.add_instrument(btc_usdt_instrument)?;
exchange.add_instrument(eth_usdt_instrument)?;
exchange.add_instrument(sol_usdt_instrument)?;

// Now exchange.matching_engines contains:
// - InstrumentId("BINANCE", "BTCUSDT") -> OrderMatchingEngine (with BTC/USDT order book)
// - InstrumentId("BINANCE", "ETHUSDT") -> OrderMatchingEngine (with ETH/USDT order book)
// - InstrumentId("BINANCE", "SOLUSDT") -> OrderMatchingEngine (with SOL/USDT order book)

// Query prices for different instruments
let btc_bid = exchange.best_bid_price(instrument_id!("BINANCE", "BTCUSDT"));
let eth_ask = exchange.best_ask_price(instrument_id!("BINANCE", "ETHUSDT"));

// Each order book operates independently
```

## Best Practices

1. **Instrument Registration**: Register all instruments before processing market data to avoid runtime panics
2. **Account Initialization**: Always call `initialize_account()` after registering the execution client
3. **Latency Models**: Use latency models for more realistic backtesting, especially for high-frequency strategies
4. **Fill Models**: Adjust fill model parameters based on your strategy's expected queue position
5. **Reset Between Runs**: Call `reset()` between backtest runs to ensure clean state
6. **Module Usage**: Use simulation modules for venue-specific behaviors (e.g., market makers, price impact)

## Related Documentation

- [Backtesting](backtesting.md) - Overview of backtesting infrastructure
- [FillModel](fill_model.md) - Order execution probability modeling
- [Order Book](order_book.md) - Order book structure and operations
- [Execution](execution.md) - Execution client and order management

