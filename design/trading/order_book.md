# OrderBook

## Overview

An `OrderBook` is a high-performance data structure that maintains the current state of buy (bid) and sell (ask) orders for a financial instrument. It tracks orders in price-time priority and supports multiple market data granularities:

- **L3_MBO** (Market By Order): Tracks individual orders with unique order IDs at every price level
- **L2_MBP** (Market By Price): Aggregates orders by price level, showing total size at each price
- **L1_MBP** (Market By Price): Maintains only the best bid and ask prices (top-of-book)

The OrderBook is implemented in Rust for maximum performance and is maintained per instrument in both backtesting and live trading environments.

## Data Structure

| Field | Description | Example |
|-------|-------------|---------|
| `instrument_id` | Instrument identifier | `BTCUSDT.BINANCE`, `EURUSD.SIM` |
| `book_type` | Book granularity type | `L1_MBP`, `L2_MBP`, `L3_MBO` |
| `sequence` | Last event sequence number | `12345` |
| `ts_last` | Timestamp of last event (nanoseconds) | `1704067200000000000` |
| `update_count` | Total number of updates applied | `1000000` |
| `bids` | Bid side ladder (price levels) | `BookLadder` |
| `asks` | Ask side ladder (price levels) | `BookLadder` |

## Real Data Examples

### Example 1: L2 OrderBook Snapshot (dYdX)

**Input Data (OrderBookDepth10):**
```json
{
  "asks": [
    {"price": "3393.5", "size": "4.946"},
    {"price": "3393.6", "size": "7.856"},
    {"price": "3393.7", "size": "30.983"},
    {"price": "3393.8", "size": "3.006"}
  ],
  "bids": [
    {"price": "3393.4", "size": "5.123"},
    {"price": "3393.3", "size": "8.456"},
    {"price": "3393.2", "size": "12.789"}
  ]
}
```

**OrderBook State After Applying:**
```
OrderBook L2_MBP
instrument: ETH-USD.DYDX
sequence: 1000
ts_last: 1704067200000000000
update_count: 1

Bids (Buy Side):
  Level 1: price=3393.4, size=5.123
  Level 2: price=3393.3, size=8.456
  Level 3: price=3393.2, size=12.789

Asks (Sell Side):
  Level 1: price=3393.5, size=4.946
  Level 2: price=3393.6, size=7.856
  Level 3: price=3393.7, size=30.983
  Level 4: price=3393.8, size=3.006

Best Bid: 3393.4 @ 5.123
Best Ask: 3393.5 @ 4.946
Spread: 0.1
Midpoint: 3393.45
```

### Example 2: OrderBookDelta Updates

**Delta 1: Add Bid Order**
```python
OrderBookDelta(
    instrument_id=BTCUSDT.BINANCE,
    action=BookAction.ADD,
    order=BookOrder(
        side=OrderSide.BUY,
        price=50000.00,
        size=1.5,
        order_id=12345
    ),
    sequence=1001,
    ts_event=1704067201000000000
)
```

**OrderBook State Before:**
- Best Bid: 49999.00 @ 2.0
- Best Ask: 50001.00 @ 1.5

**OrderBook State After:**
- Best Bid: 50000.00 @ 1.5 (new best bid)
- Best Ask: 50001.00 @ 1.5

**Delta 2: Update Ask Order**
```python
OrderBookDelta(
    instrument_id=BTCUSDT.BINANCE,
    action=BookAction.UPDATE,
    order=BookOrder(
        side=OrderSide.SELL,
        price=50001.00,
        size=0.8,  # Reduced from 1.5
        order_id=67890
    ),
    sequence=1002,
    ts_event=1704067202000000000
)
```

**OrderBook State After:**
- Best Bid: 50000.00 @ 1.5
- Best Ask: 50001.00 @ 0.8 (size updated)

**Delta 3: Delete Bid Order**
```python
OrderBookDelta(
    instrument_id=BTCUSDT.BINANCE,
    action=BookAction.DELETE,
    order=BookOrder(
        side=OrderSide.BUY,
        price=50000.00,
        size=0,  # Size ignored for delete
        order_id=12345
    ),
    sequence=1003,
    ts_event=1704067203000000000
)
```

**OrderBook State After:**
- Best Bid: 49999.00 @ 2.0 (previous level becomes best)
- Best Ask: 50001.00 @ 0.8

### Example 3: L1 OrderBook from QuoteTick

**Input QuoteTick:**
```python
QuoteTick(
    instrument_id=EURUSD.SIM,
    bid_price=1.12120,
    ask_price=1.12125,
    bid_size=100000,
    ask_size=75000,
    ts_event=1704067200000000000
)
```

**OrderBook State (L1_MBP):**
```
OrderBook L1_MBP
instrument: EURUSD.SIM
sequence: 1
ts_last: 1704067200000000000
update_count: 1

Bids:
  Level 1: price=1.12120, size=100000

Asks:
  Level 1: price=1.12125, size=75000

Best Bid: 1.12120 @ 100000
Best Ask: 1.12125 @ 75000
Spread: 0.00005 (5 pips)
Midpoint: 1.121225
```

## Data Flow

### 1. OrderBook Creation and Initialization

**Data Flow:** `Instrument` → `OrderBook.new()` → `OrderBook (empty state)`

**Example:**
```python
# Create new order book
book = OrderBook(
    instrument_id=BTCUSDT.BINANCE,
    book_type=BookType.L2_MBP
)

# Initial state
# sequence: 0
# ts_last: 0
# update_count: 0
# bids: empty
# asks: empty
```

### 2. OrderBookDelta → OrderBook

**Data Flow:** `Exchange` → `Adapter.parse_order_book_delta()` → `OrderBookDelta` → `DataEngine._handle_order_book_delta()` → `Cache.order_book().apply_delta()` → `OrderBook.apply_delta()` → `OrderBook (updated)`

**Processing Steps:**
1. Exchange sends order book update message
2. Adapter parses message into `OrderBookDelta`
3. `DataEngine` receives delta and publishes to message bus
4. `BookUpdater` handler applies delta to cached `OrderBook`
5. `OrderBook.apply_delta()` processes the action (Add/Update/Delete/Clear)
6. OrderBook state is updated

**Example:**
```python
# Delta arrives
delta = OrderBookDelta(
    instrument_id=BTCUSDT.BINANCE,
    action=BookAction.ADD,
    order=BookOrder(side=OrderSide.BUY, price=50000.0, size=1.0, order_id=123),
    sequence=1001,
    ts_event=1704067201000000000
)

# Apply to book
book.apply_delta(delta)

# Book now contains the new bid order
# sequence: 1001
# update_count: 1
# bids: [50000.0 @ 1.0]
```

### 3. OrderBookDeltas → OrderBook

**Data Flow:** `Exchange` → `Adapter.parse_order_book_deltas()` → `OrderBookDeltas` → `DataEngine._handle_order_book_deltas()` → `Cache.order_book().apply_deltas()` → `OrderBook.apply_deltas()` → `OrderBook (updated)`

**Processing Steps:**
1. Exchange sends batched order book updates
2. Adapter parses into `OrderBookDeltas` (multiple deltas)
3. `DataEngine` may buffer deltas if `buffer_deltas=True`
4. When last delta arrives (flag `F_LAST`), deltas are published
5. `BookUpdater` applies all deltas sequentially
6. OrderBook state reflects all changes

**Example:**
```python
# Batched deltas arrive
deltas = OrderBookDeltas(
    instrument_id=BTCUSDT.BINANCE,
    deltas=[
        OrderBookDelta(action=BookAction.ADD, order=BookOrder(...), sequence=1001),
        OrderBookDelta(action=BookAction.UPDATE, order=BookOrder(...), sequence=1002),
        OrderBookDelta(action=BookAction.DELETE, order=BookOrder(...), sequence=1003),
    ],
    sequence=1003,
    ts_event=1704067203000000000
)

# Apply all deltas
book.apply_deltas(deltas)

# Book state reflects all three operations
# sequence: 1003
# update_count: 3
```

### 4. OrderBookDepth10 → OrderBook

**Data Flow:** `Exchange` → `Adapter.parse_order_book_depth()` → `OrderBookDepth10` → `DataEngine._handle_depth10()` → `Cache.order_book().apply_depth()` → `OrderBook.apply_depth()` → `OrderBook (replaced)`

**Processing Steps:**
1. Exchange sends full depth snapshot (up to 10 levels)
2. Adapter parses into `OrderBookDepth10`
3. `DataEngine` publishes depth snapshot
4. `BookUpdater` applies depth, which **replaces** current book state
5. OrderBook is cleared and rebuilt from snapshot

**Example:**
```python
# Depth snapshot arrives
depth = OrderBookDepth10(
    instrument_id=BTCUSDT.BINANCE,
    bids=[BookOrder(price=50000.0, size=1.0), ...],
    asks=[BookOrder(price=50001.0, size=0.5), ...],
    sequence=5000,
    ts_event=1704067200000000000
)

# Apply depth (replaces entire book)
book.apply_depth(depth)

# Book now contains only the snapshot data
# Previous state is cleared
# sequence: 5000
# update_count: 1
```

### 5. QuoteTick → OrderBook (L1 only)

**Data Flow:** `Exchange` → `Adapter.parse_quote_tick()` → `QuoteTick` → `DataEngine._handle_quote_tick()` → `Cache.order_book().update_quote_tick()` → `OrderBook.update_quote_tick()` → `OrderBook (L1 updated)`

**Processing Steps:**
1. Exchange sends top-of-book quote
2. Adapter parses into `QuoteTick`
3. `DataEngine` caches quote and publishes
4. For L1_MBP books, `OrderBook.update_quote_tick()` updates top level
5. Previous top bid/ask is replaced with new values

**Example:**
```python
# Quote tick arrives
quote = QuoteTick(
    instrument_id=EURUSD.SIM,
    bid_price=1.12120,
    ask_price=1.12125,
    bid_size=100000,
    ask_size=75000,
    ts_event=1704067200000000000
)

# Update L1 book
book.update_quote_tick(quote)

# Book top level updated
# Best Bid: 1.12120 @ 100000
# Best Ask: 1.12125 @ 75000
# sequence: 1
```

### 6. TradeTick → OrderBook (L1 only)

**Data Flow:** `Exchange` → `Adapter.parse_trade_tick()` → `TradeTick` → `DataEngine._handle_trade_tick()` → `Cache.order_book().update_trade_tick()` → `OrderBook.update_trade_tick()` → `OrderBook (L1 updated)`

**Processing Steps:**
1. Exchange sends trade execution
2. Adapter parses into `TradeTick`
3. `DataEngine` processes trade
4. For L1_MBP books, `OrderBook.update_trade_tick()` updates top level with trade price
5. Both bid and ask are set to trade price (market consensus)

**Example:**
```python
# Trade tick arrives
trade = TradeTick(
    instrument_id=BTCUSDT.BINANCE,
    price=50000.50,
    size=0.5,
    ts_event=1704067200000000000
)

# Update L1 book
book.update_trade_tick(trade)

# Book top level updated with trade price
# Best Bid: 50000.50 @ 0.5
# Best Ask: 50000.50 @ 0.5
# sequence: 1
```

### 7. OrderBook → Strategy

**Data Flow:** `OrderBook (updated)` → `Cache.order_book()` → `Strategy.on_order_book_deltas()` / `Strategy.on_quote_tick()` → `Strategy.check_trigger()` → `Strategy uses book data`

**Processing Steps:**
1. OrderBook is updated in cache
2. Strategy receives `OrderBookDeltas` or `QuoteTick` callback
3. Strategy fetches current `OrderBook` from cache
4. Strategy analyzes book state (spread, imbalance, depth, etc.)
5. Strategy makes trading decisions based on book data

**Example:**
```python
def on_order_book_deltas(self, deltas: OrderBookDeltas) -> None:
    # Fetch current book state
    book = self.cache.order_book(self.instrument_id)
    
    # Analyze book
    best_bid = book.best_bid_price()  # 50000.00
    best_ask = book.best_ask_price()  # 50001.00
    spread = book.spread()  # 1.00
    
    bid_size = book.best_bid_size()  # 2.5
    ask_size = book.best_ask_size()  # 1.0
    
    # Make trading decision
    if bid_size > ask_size * 2:
        # Imbalance detected, submit order
        self.submit_order(...)
```

### 8. OrderBook → QuoteTick Generation

**Data Flow:** `OrderBook (L2/L3)` → `OrderBook.to_quote_tick()` → `QuoteTick` → `DataEngine._handle_quote_tick()` → `Strategy.on_quote_tick()`

**Processing Steps:**
1. OrderBook (L2 or L3) maintains full depth
2. When book updates, `to_quote_tick()` extracts top-of-book
3. Generated `QuoteTick` is published
4. Strategies can subscribe to quotes instead of full deltas

**Example:**
```python
# OrderBook has multiple levels
# Bids: [50000.0 @ 2.0, 49999.0 @ 1.5, ...]
# Asks: [50001.0 @ 1.0, 50002.0 @ 2.5, ...]

# Extract top-of-book
quote = book.to_quote_tick()
# QuoteTick(bid_price=50000.0, ask_price=50001.0, bid_size=2.0, ask_size=1.0)
```

## What Data Affects the OrderBook

### 1. OrderBookDelta

**Impact:** Individual order-level changes (Add, Update, Delete, Clear)

**Actions:**
- `BookAction.ADD`: Adds a new order to the book
- `BookAction.UPDATE`: Updates quantity/price of existing order
- `BookAction.DELETE`: Removes an order from the book
- `BookAction.CLEAR`: Clears all orders from the book

**Example:**
```python
# Add new bid order
delta = OrderBookDelta(
    action=BookAction.ADD,
    order=BookOrder(side=OrderSide.BUY, price=50000.0, size=1.0, order_id=123)
)
book.apply_delta(delta)
# Book now has bid at 50000.0

# Update order quantity
delta = OrderBookDelta(
    action=BookAction.UPDATE,
    order=BookOrder(side=OrderSide.BUY, price=50000.0, size=0.5, order_id=123)
)
book.apply_delta(delta)
# Bid quantity changed from 1.0 to 0.5

# Delete order
delta = OrderBookDelta(
    action=BookAction.DELETE,
    order=BookOrder(side=OrderSide.BUY, price=50000.0, size=0, order_id=123)
)
book.apply_delta(delta)
# Bid at 50000.0 removed
```

### 2. OrderBookDeltas

**Impact:** Batch of multiple order-level changes

**Use Case:** Efficiently process multiple updates in a single operation

**Example:**
```python
deltas = OrderBookDeltas(
    instrument_id=BTCUSDT.BINANCE,
    deltas=[
        OrderBookDelta(action=BookAction.ADD, order=BookOrder(...)),
        OrderBookDelta(action=BookAction.UPDATE, order=BookOrder(...)),
        OrderBookDelta(action=BookAction.DELETE, order=BookOrder(...)),
    ]
)
book.apply_deltas(deltas)
# All three operations applied sequentially
```

### 3. OrderBookDepth10

**Impact:** Complete replacement of book state (snapshot)

**Use Case:** Initial book state or periodic snapshots to ensure consistency

**Example:**
```python
depth = OrderBookDepth10(
    instrument_id=BTCUSDT.BINANCE,
    bids=[BookOrder(price=50000.0, size=1.0), BookOrder(price=49999.0, size=0.5)],
    asks=[BookOrder(price=50001.0, size=1.5), BookOrder(price=50002.0, size=2.0)]
)
book.apply_depth(depth)
# Entire book replaced with snapshot
# Previous state cleared
```

### 4. QuoteTick (L1_MBP only)

**Impact:** Updates top-of-book bid and ask prices/sizes

**Use Case:** When only top-of-book data is available

**Example:**
```python
quote = QuoteTick(
    bid_price=1.12120,
    ask_price=1.12125,
    bid_size=100000,
    ask_size=75000
)
book.update_quote_tick(quote)
# Top bid: 1.12120 @ 100000
# Top ask: 1.12125 @ 75000
# Previous top levels replaced
```

### 5. TradeTick (L1_MBP only)

**Impact:** Updates top-of-book with trade execution price

**Use Case:** Inferring market price from trades when order book data is limited

**Example:**
```python
trade = TradeTick(price=50000.50, size=0.5)
book.update_trade_tick(trade)
# Both bid and ask set to trade price: 50000.50 @ 0.5
```

## How OrderBook Data is Used in Context

### 1. Strategy Decision Making

**Use Case:** OrderBook imbalance strategy

**Example:**
```python
def check_trigger(self) -> None:
    book = self.cache.order_book(self.instrument_id)
    
    # Get best bid/ask
    best_bid = book.best_bid_price()
    best_ask = book.best_ask_price()
    bid_size = book.best_bid_size()
    ask_size = book.best_ask_size()
    
    # Calculate imbalance
    smaller = min(bid_size, ask_size)
    larger = max(bid_size, ask_size)
    ratio = smaller / larger
    
    # Trading logic
    if larger > self.trigger_min_size and ratio < self.trigger_imbalance_ratio:
        if bid_size > ask_size:
            # More bids than asks - buy at ask
            order = self.order_factory.limit(
                price=best_ask,
                order_side=OrderSide.BUY,
                quantity=ask_size
            )
            self.submit_order(order)
        else:
            # More asks than bids - sell at bid
            order = self.order_factory.limit(
                price=best_bid,
                order_side=OrderSide.SELL,
                quantity=bid_size
            )
            self.submit_order(order)
```

### 2. Price Discovery

**Use Case:** Determine fair market price

**Example:**
```python
book = cache.order_book(instrument_id)

# Get midpoint (fair value estimate)
midpoint = book.midpoint()  # (best_bid + best_ask) / 2

# Get spread (liquidity indicator)
spread = book.spread()  # best_ask - best_bid

# Calculate spread percentage
spread_pct = (spread / midpoint) * 100
```

### 3. Execution Simulation

**Use Case:** Simulate order fills before submission

**Example:**
```python
book = cache.order_book(instrument_id)

# Simulate market order fill
order = BookOrder(side=OrderSide.BUY, price=50001.0, size=2.0)
fills = book.simulate_fills(order)

# Returns: [(50001.0, 1.0), (50002.0, 1.0)]
# Shows how order would be filled across price levels
```

### 4. Average Price Calculation

**Use Case:** Calculate average execution price for target quantity

**Example:**
```python
book = cache.order_book(instrument_id)

# Calculate average price to buy 5.0 units
avg_price = book.get_avg_px_for_quantity(
    qty=Quantity(5.0),
    order_side=OrderSide.BUY
)
# Returns weighted average price across ask levels
```

### 5. Depth Analysis

**Use Case:** Analyze order book depth and liquidity

**Example:**
```python
book = cache.order_book(instrument_id)

# Get multiple price levels
bids = book.bids(depth=5)  # Top 5 bid levels
asks = book.asks(depth=5)  # Top 5 ask levels

# Analyze depth
total_bid_size = sum(level.size_decimal() for level in bids)
total_ask_size = sum(level.size_decimal() for level in asks)

# Calculate depth imbalance
depth_imbalance = (total_bid_size - total_ask_size) / (total_bid_size + total_ask_size)
```

### 6. Market Making

**Use Case:** Place orders around current market price

**Example:**
```python
book = cache.order_book(instrument_id)

# Get current market
best_bid = book.best_bid_price()
best_ask = book.best_ask_price()
midpoint = book.midpoint()

# Place orders around midpoint
buy_price = midpoint - Decimal("0.5")  # Below midpoint
sell_price = midpoint + Decimal("0.5")  # Above midpoint

# Submit market making orders
self.submit_order(limit_order(buy_price, OrderSide.BUY))
self.submit_order(limit_order(sell_price, OrderSide.SELL))
```

### 7. Order Book Filtering (Excluding Own Orders)

**Use Case:** View public order book excluding your own orders

**Example:**
```python
book = cache.order_book(instrument_id)
own_book = cache.own_order_book(instrument_id)

# Get public bids (excluding own orders)
public_bids = book.bids_filtered_as_map(
    depth=10,
    own_book=own_book,
    status=None  # Include all order statuses
)

# Get public asks (excluding own orders)
public_asks = book.asks_filtered_as_map(
    depth=10,
    own_book=own_book,
    status={OrderStatus.ACCEPTED}  # Only accepted orders
)
```

### 8. Price Level Grouping

**Use Case:** Group orders into price buckets for analysis

**Example:**
```python
book = cache.order_book(instrument_id)

# Group bids into $1.00 buckets
grouped_bids = book.group_bids(
    group_size=Decimal("1.00"),
    depth=20
)
# Returns: {50000.0: 5.5, 49999.0: 3.2, 49998.0: 1.8, ...}
# Aggregates all orders within each $1.00 price range
```

### 9. Matching Engine Integration

**Use Case:** Matching engine uses OrderBook to determine execution prices

**Data Flow:** `OrderBook` → `MatchingEngine.process_order_book_delta()` → `OrderBook.apply_delta()` → `MatchingEngine.iterate()` → `Order matching`

**Example:**
```rust
// Matching engine processes order book update
matching_engine.process_order_book_delta(&delta)?;

// OrderBook is updated
// Matching engine checks if any pending orders can be filled
matching_engine.iterate(ts_init);
```

### 10. Data Persistence

**Use Case:** Store OrderBook state for analysis

**Data Flow:** `OrderBook` → `Persistence Layer` → `Database/Parquet`

**Example:**
```python
# OrderBook snapshots can be persisted
book = cache.order_book(instrument_id)

# Store book state
persistence.save_order_book_snapshot(book, timestamp)
```

## Book Types Comparison

| Book Type | Granularity | Data Source | Use Case |
|-----------|-------------|-------------|----------|
| **L3_MBO** | Individual orders with IDs | `OrderBookDelta` (with order_id) | High-frequency trading, order tracking |
| **L2_MBP** | Price levels (aggregated) | `OrderBookDelta`, `OrderBookDepth10` | Standard market making, depth analysis |
| **L1_MBP** | Top-of-book only | `QuoteTick`, `TradeTick`, `OrderBookDelta` | Simple strategies, cost-effective backtesting |

## OrderBook Integrity

The OrderBook maintains several invariants:

1. **Price-Time Priority**: Orders at the same price are ordered by time (FIFO)
2. **No Crossed Book**: Best bid should not exceed best ask (warnings logged if crossed)
3. **Sequence Monotonicity**: Sequence numbers should not decrease
4. **Timestamp Monotonicity**: Timestamps should not decrease

**Example:**
```python
# Check book integrity
book.check_integrity()
# Raises RuntimeError if book is crossed or invalid
```

## Performance Characteristics

- **Implementation**: Rust for maximum performance
- **Update Latency**: Sub-microsecond for single delta application
- **Memory**: Efficient storage using price ladders and order caches
- **Scalability**: Handles millions of updates per second

## Summary

The `OrderBook` is a core component of NautilusTrader that:

1. **Maintains** real-time order book state from multiple data sources
2. **Processes** incremental updates (deltas) and snapshots (depth)
3. **Provides** efficient access to price levels, spreads, and depth
4. **Enables** sophisticated trading strategies through rich market data
5. **Supports** multiple granularities (L1/L2/L3) for different use cases

The OrderBook serves as the foundation for price discovery, execution simulation, and market analysis in both backtesting and live trading environments.

