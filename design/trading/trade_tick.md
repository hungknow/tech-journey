# TradeTick

## Overview

A `TradeTick` represents a single executed trade in a market, containing information about a unique trade that matched buyer and seller counterparties.

**Example:**
```
instrument_id: ETHUSDT-PERP.BINANCE
price: 10000.5000
size: 1.25000000
aggressor_side: BUYER
trade_id: 123456789
ts_event: 0
ts_init: 1
```

## Data Structure

| Field | Description | Example |
|-------|-------------|---------|
| `instrument_id` | Instrument identifier | `EURUSD.SIM`, `BTCUSDT.BINANCE` |
| `price` | Executed trade price | `1.0500` |
| `size` | Executed trade quantity | `100000` |
| `aggressor_side` | Side of the aggressing order | `BUYER`, `SELLER`, `NO_AGGRESSOR` |
| `trade_id` | Trade match ID (assigned by venue) | `"123456789"` |
| `ts_event` | Event timestamp (nanoseconds) | `1000000000` |
| `ts_init` | Initialization timestamp (nanoseconds) | `2000000000` |

**Requirements:**
- Size must be positive (> 0)
- Trade ID must be a valid string (max 36 characters)

**AggressorSide Values:**
- `NO_AGGRESSOR` (0): No specific aggressor identified
- `BUYER` (1): The buy order was the aggressor (market buy)
- `SELLER` (2): The sell order was the aggressor (market sell)

## Where TradeTick is Used

### 1. Order Book Management

TradeTick updates Level 1 (L1) order books with last trade price when book type is `L1_MBP`.

**Data Flow:** `TradeTick` → `MatchingEngine.process_trade_tick()` → `OrderBook.update_trade_tick()` → `OrderBook (L1_MBP)`

**Example:**

| State | bid_price | bid_size | ask_price | ask_size |
|-------|-----------|----------|-----------|----------|
| **Before** | 99.00 | 100.0 | 100.00 | 100.0 |
| **TradeTick** | price=99.50, size=200.0, aggressor=BUYER | - | - | - |
| **After** | 99.50 | 200.0 | 99.50 | 200.0 |

The trade price becomes both bid and ask when updating L1 order book from trades.

### 2. Data Aggregation (TradeTick → Bar)

Multiple TradeTicks aggregate into OHLCV bars using trade prices and sizes.

**Data Flow:** `TradeTick[]` → `BarAggregator.handle_trade_tick()` → `Bar`

**Example: Tick-based aggregation (100 ticks per bar)**

| Input (Sample TradeTicks) | Output (Bar) |
|---------------------------|--------------|
| Tick 1: price=0.670340, size=1000<br>Tick 2: price=0.670345, size=1500<br>Tick 3: price=0.670225, size=2000<br>...<br>Tick 100: price=0.670230, size=1200 | open: 0.670340<br>high: 0.670345<br>low: 0.670225<br>close: 0.670230<br>volume: 150000 |

### 3. Bar Converts to TradeTick (Backtesting)

Bars synthesize into TradeTicks for backtesting when only bar data is available. Typically generates 4 trades (OHLC) with quarter volume each.

**Data Flow:** `Bar` → `BacktestEngine._process_trade_ticks_from_bar()` → `TradeTick[]` (4 ticks: OHLC)

**Example:**

| Input Bar | Generated TradeTicks |
|-----------|----------------------|
| open: 1.12120<br>high: 1.12130<br>low: 1.12110<br>close: 1.12125<br>volume: 100000 | **Tick 1 (Open):**<br>price=1.12120, size=25000, aggressor=BUYER<br><br>**Tick 2 (High):**<br>price=1.12130, size=25000, aggressor=BUYER<br><br>**Tick 3 (Low):**<br>price=1.12110, size=25000, aggressor=SELLER<br><br>**Tick 4 (Close):**<br>price=1.12125, size=25000, aggressor=BUYER |

### 4. CSV Data Processing

CSV files are parsed into TradeTicks and flow through the system.

**Data Flow:** `CSV` → `TradeTickDataWrangler.process()` → `TradeTick[]` → `DataEngine._handle_trade_tick()` → `OrderBook.update_trade_tick()` / `BarAggregator.handle_trade_tick()`

**Example from `trade_tick_data.csv`:**

| CSV Row | Parsed TradeTick | Impact |
|---------|------------------|--------|
| `20200101 170000065,1.121200,100000,BUYER,12345` | instrument_id: EURUSD.SIM<br>price: 1.121200<br>size: 100000<br>aggressor_side: BUYER<br>trade_id: 12345<br>ts_event: 20200101 170000065 | Last price updated<br>Order book updated (if L1_MBP)<br>Published to subscribers |
| `20200101 170010447,1.121300,75000,SELLER,12346` | instrument_id: EURUSD.SIM<br>price: 1.121300<br>size: 75000<br>aggressor_side: SELLER<br>trade_id: 12346<br>ts_event: 20200101 170010447 | Price increased (buyer aggressor)<br>Bar aggregator receives tick<br>Volume accumulated |

### 5. Strategies Use TradeTick

Strategies subscribe to TradeTicks and implement `on_trade_tick()` to make trading decisions based on executed trades.

**Data Flow:** `MessageBus` → `Strategy.on_trade_tick()` → `Indicator.handle_trade_tick()` / `Order Management`

**Example 1: Volume-Based Strategy**

| Step | Action | TradeTick Data Used |
|------|--------|---------------------|
| 1. Subscribe | `strategy.subscribe_trade_ticks(instrument_id)` | - |
| 2. Receive TradeTick | `on_trade_tick(tick: TradeTick)` | price: 10000.5000<br>size: 1.25000000<br>aggressor_side: BUYER |
| 3. Analyze Volume | Calculate cumulative volume<br>Check if volume spike detected | size, aggressor_side |
| 4. Submit Orders | Submit orders based on volume analysis | - |

**Example 2: Strategy with Indicator**

| Step | Action | TradeTick Data Used |
|------|--------|---------------------|
| 1. Subscribe | `strategy.subscribe_trade_ticks(instrument_id)` | - |
| 2. Receive TradeTick | `on_trade_tick(tick: TradeTick)` | price: 1.0500<br>size: 100000 |
| 3. Update Indicator | `macd.handle_trade_tick(tick)` | price: 1.0500 |
| 4. Check Signal | `if macd.initialized: check_signals()` | Indicator value from TradeTick |

### 6. Indicators Use TradeTick

Indicators implement `handle_trade_tick()` to update their calculations using trade prices and sizes.

**Data Flow:** `Strategy.on_trade_tick()` → `Indicator.handle_trade_tick()` → `Indicator.update()`

**Example: Volume-Weighted Average Price (VWAP)**

| TradeTick Input | Indicator Processing | Output |
|-----------------|----------------------|--------|
| price: 1.121200<br>size: 100000 | Calculate: `cumulative_price_volume += price * size`<br>`cumulative_volume += size`<br>Update VWAP: `cumulative_price_volume / cumulative_volume` | vwap: 1.121200 |

**Example: MACD Indicator**

| TradeTick Input | Indicator Processing | Output |
|-----------------|----------------------|--------|
| price: 1.0500<br>size: 50000 | Extract price: 1.0500<br>Update MACD calculation<br>Check if initialized | macd_value: 0.0012<br>signal: 0.0008<br>histogram: 0.0004 |

### 7. Order Emulator Uses TradeTick

Order emulator processes TradeTicks to update matching core and iterate orders for execution.

**Data Flow:** `TradeTick` → `OrderEmulator.on_trade_tick()` → `MatchingCore.set_last_raw()` → `MatchingCore.iterate()` → `Order Execution`

**Processing steps:**
1. TradeTick received by order emulator
2. Matching core updates last price: `set_last_raw(trade.price)`
3. If no quote subscriptions, bid/ask set to trade price
4. Orders are iterated and checked for execution
5. Trailing stop orders are updated if applicable

**Example:**

| TradeTick | Matching Core Update | Order Impact |
|-----------|----------------------|--------------|
| price: 10000.5000<br>size: 1.25000000<br>aggressor: BUYER | last: 10000.5000<br>bid: 10000.5000 (if no quotes)<br>ask: 10000.5000 (if no quotes) | Market orders may execute<br>Stop orders checked<br>Trailing stops updated |

### 8. Market Data Processing

TradeTicks flow through the data engine to subscribers.

**Data Flow:** `Exchange` → `Adapter._handle_data()` → `TradeTick` → `DataEngine._handle_trade_tick()` → `Cache.add_trade_tick()` / `MessageBus.publish()` → `Strategy.on_trade_tick()` / `Indicator.handle_trade_tick()`

**Processing steps:**
1. Exchange sends trade data
2. Adapter converts to TradeTick via `parse_trade_msg()` or similar
3. DataEngine calls `_handle_trade_tick()` which caches and publishes
4. Strategies receive TradeTick via `on_trade_tick()` callback
5. Indicators receive TradeTick via `handle_trade_tick()` method

### 9. Data Persistence

TradeTicks are stored in databases for historical analysis.

**Data Flow:** `TradeTick` → `Persistence Layer` → `PostgreSQL/Parquet`

**Storage format:**
- PostgreSQL: Table `trade` with columns: `instrument_id`, `price`, `quantity`, `aggressor_side`, `venue_trade_id`, `ts_event`, `ts_init`
- Parquet: Columnar format for efficient querying

## Comparison with Other Data Types

| Data Type | Description | Relationship |
|-----------|-------------|--------------|
| **TradeTick** | Executed trade prices | Source for aggregation |
| **QuoteTick** | Top-of-book bid/ask prices | Complementary (willing vs actual) |
| **OrderBook** | Multiple price levels (L2/L3) | TradeTick updates L1 order book |
| **Bar** | Aggregated OHLCV data | TradeTick → Bar (many-to-one)<br>Bar → TradeTick (one-to-many, backtesting) |

