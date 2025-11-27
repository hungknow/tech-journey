# QuoteTick

## Overview

A `QuoteTick` represents a snapshot of the best bid and ask prices (top-of-book) for a financial instrument at a specific point in time.

**Example:**
```
instrument_id: ETHUSDT-PERP.BINANCE
bid_price: 10000.0000
ask_price: 10001.0000
bid_size: 1.00000000
ask_size: 1.00000000
ts_event: 0
ts_init: 1
```

## Data Structure

| Field | Description | Example |
|-------|-------------|---------|
| `instrument_id` | Instrument identifier | `EURUSD.SIM`, `BTCUSDT.BINANCE` |
| `bid_price` | Best bid price | `1.0500` |
| `ask_price` | Best ask price | `1.0505` |
| `bid_size` | Quantity at bid price | `100000` |
| `ask_size` | Quantity at ask price | `75000` |
| `ts_event` | Event timestamp (nanoseconds) | `1000000000` |
| `ts_init` | Initialization timestamp (nanoseconds) | `2000000000` |

**Requirements:**
- Bid and ask prices must have the same precision
- Bid and ask sizes must have the same precision

## Where QuoteTick is Used

### 1. Order Book Management

QuoteTick updates Level 1 (L1) order books with top-of-book prices.

**Data Flow:** `QuoteTick` → `MatchingEngine.process_quote_tick()` → `OrderBook.update_quote_tick()` → `OrderBook (L1_MBP)`

**Example:**

| State | bid_price | bid_size | ask_price | ask_size |
|-------|-----------|----------|-----------|----------|
| **Before** | 99.00 | 100.0 | 100.00 | 100.0 |
| **QuoteTick** | 99.50 | 200.0 | 100.50 | 150.0 |
| **After** | 99.50 | 200.0 | 100.50 | 150.0 |



### 2. Data Aggregation (QuoteTick → Bar)

Multiple QuoteTicks aggregate into OHLCV bars using bid, ask, or mid prices.

**Data Flow:** `QuoteTick[]` → `BarAggregator.handle_quote_tick()` → `Bar`

**Example: Tick-based aggregation (100 ticks per bar)**

| Input (Sample QuoteTicks) | Output (Bar) |
|---------------------------|--------------|
| Tick 1: bid=0.670340, ask=0.670350, mid=0.670345<br>Tick 2: bid=0.670345, ask=0.670355, mid=0.670350<br>Tick 3: bid=0.670225, ask=0.670235, mid=0.670230<br>...<br>Tick 100: bid=0.670230, ask=0.670240, mid=0.670235 | open: 0.670340<br>high: 0.670345<br>low: 0.670225<br>close: 0.670230<br>volume: 100000000 |

### 3. Order Book Generates QuoteTick

OrderBook (L2/L3) extracts top-of-book to generate QuoteTick.

**Data Flow:** `OrderBook (L2/L3)` → `OrderBook.to_quote_tick()` → `QuoteTick`

**Example:**

| OrderBook Levels | Generated QuoteTick |
|------------------|---------------------|
| **Bids:**<br>Level 1: price=99.50, size=200.0<br>Level 2: price=99.00, size=100.0<br><br>**Asks:**<br>Level 1: price=100.50, size=150.0<br>Level 2: price=101.00, size=200.0 | instrument_id: ETHUSDT-PERP.BINANCE<br>bid_price: 99.50 (from top bid)<br>ask_price: 100.50 (from top ask)<br>bid_size: 200.0<br>ask_size: 150.0<br>ts_event: 3000000000<br>ts_init: 4000000000 |

### 4. Bar Converts to QuoteTick (Backtesting)

Bars synthesize into QuoteTicks for backtesting when only bar data is available.

**Data Flow:** `Bar` → `BacktestEngine._process_quote_ticks_from_bar()` → `QuoteTick[]` (4 ticks: OHLC)

**Example:**

| Input Bar | Generated QuoteTicks |
|-----------|----------------------|
| open: 1.12120<br>high: 1.12130<br>low: 1.12110<br>close: 1.12125<br>volume: 100000 | **Tick 1 (Open):**<br>bid=1.12120, ask=1.12120, size=25000<br><br>**Tick 2 (High):**<br>bid=1.12130, ask=1.12130, size=25000<br><br>**Tick 3 (Low):**<br>bid=1.12110, ask=1.12110, size=25000<br><br>**Tick 4 (Close):**<br>bid=1.12125, ask=1.12125, size=25000 |

### 5. CSV Data Processing

CSV files are parsed into QuoteTicks and flow through the system.

**Data Flow:** `CSV` → `QuoteTickDataWrangler.process()` → `QuoteTick[]` → `DataEngine._handle_quote_tick()` → `OrderBook.update_quote_tick()` / `BarAggregator.handle_quote_tick()`

**Example from `quote_tick_data.csv`:**

| CSV Row | Parsed QuoteTick | Impact |
|---------|------------------|--------|
| `20200101 170000065,1.121200,1.121720,0` | instrument_id: EURUSD.SIM<br>bid_price: 1.121200<br>ask_price: 1.121720<br>bid_size: 100000<br>ask_size: 100000<br>ts_event: 20200101 170000065 | Spread: 0.000520<br>Order book updated<br>Published to subscribers |
| `20200101 170010447,1.121200,1.121920,0` | instrument_id: EURUSD.SIM<br>bid_price: 1.121200<br>ask_price: 1.121920<br>bid_size: 100000<br>ask_size: 100000<br>ts_event: 20200101 170010447 | Spread: 0.000720 (widened)<br>Order book ask updated<br>Bar aggregator receives tick |

### 6. Market Data Processing

QuoteTicks flow through the data engine to subscribers.

**Data Flow:** `Exchange` → `Adapter._handle_data()` → `QuoteTick` → `DataEngine._handle_quote_tick()` → `Cache.add_quote_tick()` / `MessageBus.publish()` → `Strategies/Indicators`

**Processing steps:**
1. Exchange sends market data
2. Adapter converts to QuoteTick via `parse_to_quote_tick()`
3. DataEngine calls `_handle_quote_tick()` which caches and publishes
4. Subscribers (strategies, indicators) receive QuoteTick via message bus

### 7. Data Persistence

QuoteTicks are stored in databases for historical analysis.

**Data Flow:** `QuoteTick` → `Persistence Layer` → `PostgreSQL/Parquet`

**Storage format:**
- PostgreSQL: Table `quote` with columns: `instrument_id`, `bid_price`, `ask_price`, `bid_size`, `ask_size`, `ts_event`, `ts_init`
- Parquet: Columnar format for efficient querying

## Price Extraction

QuoteTick can extract different price types:

| Price Type | Calculation | Example |
|------------|-------------|---------|
| **Bid** | Returns bid_price | `10000.0000` |
| **Ask** | Returns ask_price | `10001.0000` |
| **Mid** | (bid_price + ask_price) / 2 | `10000.5000` |

## Comparison with Other Data Types

| Data Type | Description | Relationship |
|-----------|-------------|--------------|
| **QuoteTick** | Top-of-book bid/ask prices | Source for aggregation |
| **TradeTick** | Executed trade prices | Complementary (willing vs actual) |
| **OrderBook** | Multiple price levels (L2/L3) | Can generate QuoteTick from top |
| **Bar** | Aggregated OHLCV data | QuoteTick → Bar (many-to-one)<br>Bar → QuoteTick (one-to-many, backtesting) |
