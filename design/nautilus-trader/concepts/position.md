# Position

## Purpose

A Position represents an open or closed position at a market, tracking quantity, side, average prices, realized P&L, and the fill events that created and changed the position. It is the core domain model for managing trading positions throughout their lifecycle from opening through closing.

## Use Cases

1. Opening new positions via order fills
2. Accumulating positions via multiple same-side fills
3. Closing positions via opposite-side fills
4. Partially closing positions
5. Reversing positions (flipping from long to short or vice versa)
6. Tracking position state across lifecycle (open, closed, flat)
7. Calculating P&L (realized, unrealized, total)
8. Handling position adjustments (commissions in base currency, funding payments)
9. Rebuilding positions after purging events
10. Reopening positions after closing
11. Handling different instrument types (spot, perpetual futures, futures, options)


## Examples

### Example 1: Simple Long Position with Full Close

**Scenario:** Buy 100 BTC at $50,000, then sell all 100 BTC at $51,000

```rust
// Initial buy order fill
let fill1 = OrderFilled {
    order_side: OrderSide::Buy,
    last_qty: 100.0,
    last_px: 50000.0,
    commission: Some(Money::new(50.0, Currency::USD())),
    // ... other fields
};

// Create position
let mut position = Position::new(&instrument, fill1);

// Position state after opening:
// side: Long
// quantity: 100.0
// signed_qty: 100.0
// avg_px_open: 50000.0
// avg_px_close: None
// realized_pnl: Some(-50.0 USD)  // commission only
// events: [fill1]
// ts_opened: fill1.ts_event

// Sell to close position
let fill2 = OrderFilled {
    order_side: OrderSide::Sell,
    last_qty: 100.0,
    last_px: 51000.0,
    commission: Some(Money::new(51.0, Currency::USD())),
    // ... other fields
};

position.apply(&fill2);

// Position state after closing:
// side: Flat
// quantity: 0.0
// signed_qty: 0.0
// avg_px_open: 50000.0
// avg_px_close: Some(51000.0)
// realized_pnl: Some(99999.0 USD)  // (51000-50000)*100 - 50 - 51
// events: [fill1, fill2]
// ts_closed: Some(fill2.ts_event)
// duration_ns: fill2.ts_event - fill1.ts_event
```


### Example 2: Accumulating Position with Multiple Same-Side Fills

**Scenario:** Buy 50 BTC at $50,000, then buy 30 more at $51,000

```rust
let mut position = Position::new(&instrument, fill_buy_50);

// State after first fill:
// quantity: 50.0
// avg_px_open: 50000.0

position.apply(&fill_buy_30);

// State after second fill (weighted average):
// quantity: 80.0
// signed_qty: 80.0
// avg_px_open: 50375.0  // (50*50000 + 30*51000) / 80
// peak_qty: 80.0
```


### Example 3: Partial Close

**Scenario:** Buy 100 BTC at $50,000, then sell 30 BTC at $51,000

```rust
let mut position = Position::new(&instrument, fill_buy_100);

position.apply(&fill_sell_30);

// State after partial close:
// side: Long (still long)
// quantity: 70.0
// signed_qty: 70.0
// avg_px_open: 50000.0  // unchanged
// avg_px_close: Some(51000.0)
// realized_pnl: Some(29940.0 USD)  // (51000-50000)*30 - commissions
// buy_qty: 100.0
// sell_qty: 30.0
```


### Example 4: Position Reversal (Flip)

**Scenario:** Buy 50 BTC at $50,000, then sell 100 BTC at $51,000 (flips to short)

```rust
let mut position = Position::new(&instrument, fill_buy_50);

position.apply(&fill_sell_100);

// State after flip:
// side: Short
// quantity: 50.0
// signed_qty: -50.0  // 50 (buy) - 100 (sell) = -50
// avg_px_open: 51000.0  // flips to sell price since position reversed
// entry: Sell
// realized_pnl: Includes profit from closing 50 and opening 50 short
// peak_qty: 100.0  // was 100 during transition
```


### Example 5: Position Reopening After Close

**Scenario:** Buy 100 BTC at $50,000, sell all at $51,000, then buy again at $49,000

```rust
let mut position = Position::new(&instrument, fill_buy_100);

position.apply(&fill_sell_100);

// Position is now Flat with:
// side: Flat
// ts_closed: Some(fill_sell_100.ts_event)
// avg_px_close: Some(51000.0)

position.apply(&fill_buy_80);

// Position reopens - resets position lifecycle:
// side: Long
// quantity: 80.0
// ts_opened: fill_buy_80.ts_event  // reset to new fill time
// ts_closed: None
// avg_px_open: 49000.0  // new average price
// events: [fill_buy_80]  // cleared, now only new fill
// opening_order_id: fill_buy_80.client_order_id
```


### Example 6: Spot Position with Base Currency Commission

**Scenario:** Buy 1.0 ETH on spot market with 0.001 ETH commission

```rust
let fill = OrderFilled {
    order_side: OrderSide::Buy,
    last_qty: 1.0,
    last_px: 2000.0,
    commission: Some(Money::new(0.001, Currency::ETH())),  // base currency commission
    // ... other fields
};

let mut position = Position::new(&instrument, fill);

// Position state:
// quantity: 0.999  // 1.0 - 0.001 commission
// signed_qty: 0.999
// buy_qty: 1.0  // tracks actual order fill amount
// adjustments: [PositionAdjusted {
//     adjustment_type: Commission,
//     quantity_change: Some(-0.001),  // reduces position quantity
//     pnl_change: None,
// }]
// events: [fill]

// For spot instruments, base currency commissions create adjustment events
// that affect position quantity, not just P&L
```


### Example 7: Perpetual Futures with Funding Payment

**Scenario:** Long ETH-PERP position receives funding payment

```rust
let mut position = Position::new(&instrument, fill_buy_10);

// Later, funding payment adjustment received
let funding_adjustment = PositionAdjusted {
    adjustment_type: Funding,
    quantity_change: None,
    pnl_change: Some(Money::new(25.0, Currency::USDT)),  // positive funding
    // ... other fields
};

position.apply_adjustment(funding_adjustment);

// Position state:
// quantity: 10.0  // unchanged (funding doesn't affect quantity)
// realized_pnl: Some(25.0 USDT)  // funding added to realized P&L
// adjustments: [funding_adjustment]
```


### Example 8: Purging Events for Order Cancellation

**Scenario:** Position has 3 fills, but 1 order gets cancelled and purged

```rust
let mut position = Position::new(&instrument, fill1);
position.apply(&fill2);
position.apply(&fill3);

// State before purge:
// events: [fill1, fill2, fill3]
// trade_ids: {trade1, trade2, trade3}
// quantity: 250.0

// Purge fills from order1 (contains fill1 and fill2)
position.purge_events_for_order(order1.client_order_id());

// State after purge:
// events: [fill3]  // only remaining fill
// trade_ids: {trade3}
// quantity: 50.0  // recalculated from fill3 only
// adjustments: Preserved non-commission adjustments
// avg_px_open: fill3.last_px  // recalculated
```


### Example 9: Inverse Instrument (Perpetual Futures)

**Scenario:** Short BTC-PERP inverse position

```rust
// BTC-PERP is inverse instrument (contracts priced in USD, collateral in BTC)
let fill = OrderFilled {
    order_side: OrderSide::Sell,
    last_qty: 100000,  // contracts
    last_px: 50000.0,  // USD price
    commission: Some(Money::new(0.0075, Currency::BTC())),
    // ... other fields
};

let position = Position::new(&instrument, fill);

// Position state:
// side: Short
// quantity: 100000
// signed_qty: -100000
// is_inverse: true
// settlement_currency: BTC
// realized_pnl: Some(-0.0075 BTC)  // commission in BTC

// P&L calculation uses inverse formula:
// Unrealized PnL = quantity * (1/open_price - 1/last_price)
// At last_price=45000: 100000 * (1/50000 - 1/45000) ≈ 2.22 BTC profit
```


### Example 10: Multiple Currency Commissions

**Scenario:** Position accumulates commissions in different currencies

```rust
let mut position = Position::new(&instrument, fill_usd_commission);

position.apply(&fill_usdt_commission);
position.apply(&fill_btc_commission);
position.apply(&fill_usd_commission_again);

// commissions IndexMap:
// {
//     USD: Money(1.5 USD),     // accumulated in place
//     USDT: Money(2.0 USDT),   // added in insertion order
//     BTC: Money(0.0001 BTC)   // added in insertion order
// }

// Only USD commissions affect realized_pnl if USD is settlement currency
```


## Data Grouped by Use Case

### Position Identification and Tracking

**Fields:**

- `id: PositionId` - Unique position identifier (assigned by venue or system-generated)
- `trader_id: TraderId` - Trader identifier
- `strategy_id: StrategyId` - Strategy identifier
- `account_id: AccountId` - Trading account identifier
- `instrument_id: InstrumentId` - Instrument being traded

**When affected:**


- Set once during position initialization in `Position::new()` from the initial fill

**Context:**

- Immutable after creation for core identification fields
- Used for position lookup, routing, and association with trading entities


### Position State (Side and Quantity)

**Fields:**

- `side: PositionSide` - Current position side (Long, Short, Flat)
- `quantity: Quantity` - Absolute quantity of the position
- `signed_qty: f64` - Signed quantity (positive for long, negative for short)
- `peak_qty: Quantity` - Maximum quantity ever held

**When affected:**

- `signed_qty`: Modified on every fill in `apply()`, `handle_buy_order_fill()`, `handle_sell_order_fill()`, and in `apply_adjustment()` for quantity changes
- `quantity`: Derived from `signed_qty.abs()` after each operation
- `side`: Updated based on `signed_qty` sign after each operation, set to Flat when quantity is zero
- `peak_qty`: Updated in `apply()` when current quantity exceeds previous peak

**Context:**

- Core position tracking that drives all P&L calculations and position status
- Handles position reversal (flipping) when fills cross from positive to negative or vice versa
- `quantity` rounded to instrument's size precision for display/storage
- `signed_qty` preserved as f64 for calculations


### Order and Event Tracking

**Fields:**

- `events: Vec<OrderFilled>` - All order fill events applied to position
- `adjustments: Vec<PositionAdjusted>` - All position adjustment events
- `trade_ids: AHashSet<TradeId>` - Set of all trade IDs from fills
- `buy_qty: Quantity` - Total buy quantity from order fills
- `sell_qty: Quantity` - Total sell quantity from order fills
- `opening_order_id: ClientOrderId` - ID of order that opened position
- `closing_order_id: Option<ClientOrderId>` - ID of order that closed position (if closed)

**When affected:**

- `events`: Appended to on every `apply()` call, cleared in `purge_events_for_order()` and on position reset
- `adjustments`: Appended to in `apply_adjustment()`, cleared on position reset, preserved during `purge_events_for_order()` for non-commission adjustments
- `trade_ids`: Inserted in `apply()` when fill is applied, cleared on purge/reset
- `buy_qty`: Incremented in `handle_buy_order_fill()` for order fills (does not include adjustments)
- `sell_qty`: Incremented in `handle_sell_order_fill()` for order fills (does not include adjustments)
- `opening_order_id`: Set in `Position::new()` and reset when position reopens
- `closing_order_id`: Set in `apply()` when position becomes flat

**Context:**

- Provides complete audit trail of all position changes
- `buy_qty`/`sell_qty` track actual order fills separately from commission adjustments (which affect position quantity differently)
- Critical for position reconstruction, debugging, and regulatory compliance


### Timestamps and Lifecycle

**Fields:**

- `ts_init: UnixNanos` - Position initialization timestamp
- `ts_opened: UnixNanos` - Position opening timestamp
- `ts_last: UnixNanos` - Last update timestamp
- `ts_closed: Option<UnixNanos>` - Position closing timestamp (if closed)
- `duration_ns: u64` - Duration position was open (ts_closed - ts_opened)

**When affected:**

- `ts_init`: Set from initial fill's `ts_init` in `Position::new()` and on position reset
- `ts_opened`: Set from initial fill's `ts_event` in `Position::new()` and on position reset
- `ts_last`: Updated to fill's `ts_event` in `apply()` and adjustment's `ts_event` in `apply_adjustment()`
- `ts_closed`: Set to `Some(fill.ts_event)` when position becomes flat in `apply()`, cleared on position reset
- `duration_ns`: Calculated as `ts_closed - ts_opened` when position closes, reset to 0 on position reset

**Context:**

- Tracks complete position lifecycle for performance analysis
- `ts_opened` and `duration_ns` reset on position reopen (treated as new position)


### Pricing and P&L Calculation

**Fields:**

- `avg_px_open: f64` - Average entry price
- `avg_px_close: Option<f64>` - Average exit price (if closed)
- `realized_return: f64` - Realized return percentage
- `realized_pnl: Option<Money>` - Realized profit/loss including commissions
- `commissions: IndexMap<Currency, Money>` - Cumulative commissions by currency

**When affected:**

- `avg_px_open`: Updated on same-side fills in `handle_buy_order_fill()`/`handle_sell_order_fill()` using weighted average, reset on position flip (when position reverses)
- `avg_px_close`: Updated on opposite-side fills when closing position in `handle_buy_order_fill()`/`handle_sell_order_fill()`, cleared on position reset
- `realized_return`: Calculated on closing fills based on price change
- `realized_pnl`: Updated on each fill with commission (negative) and closing P&L (positive/negative), also updated in `apply_adjustment()` for PnL changes
- `commissions`: Accumulated in `apply()` when fill has commission, aggregated by currency in IndexMap

**Context:**

- Uses f64 arithmetic for average price calculations with documented precision tolerances
- Handles both regular and inverse instruments (perpetual futures)
- Commission handling differs by instrument type:
  - Spot with base currency commission: Creates PositionAdjusted event that affects quantity
  - All other cases: Commission only affects realized_pnl
- `realized_pnl` only accumulates commissions in settlement currency


### Instrument Characteristics

**Fields:**

- `price_precision: u8` - Price precision for instrument
- `size_precision: u8` - Size precision for instrument
- `multiplier: Quantity` - Contract multiplier
- `is_inverse: bool` - Whether instrument is inverse (perpetual futures)
- `is_currency_pair: bool` - Whether instrument is currency pair
- `instrument_class: InstrumentClass` - Instrument class type
- `base_currency: Option<Currency>` - Base currency (if applicable)
- `quote_currency: Currency` - Quote currency
- `settlement_currency: Currency` - Settlement currency for P&L

**When affected:**

- Set once during position initialization in `Position::new()` from instrument parameters
- Never modified after creation

**Context:**

- Immutable instrument properties that affect P&L calculations and position behavior
- `is_inverse` determines whether P&L uses inverse price calculations (1/price)
- `settlement_currency` is the currency for realized_pnl calculations
- `is_currency_pair` and `base_currency` determine if base currency commissions affect position quantity

### Entry Direction

**Fields:**

- `entry: OrderSide` - Order side of entry (Buy or Sell)

**When affected:**

- Set from initial fill in `Position::new()`
- Updated on position flip when position reverses direction
- Set to Buy/Long when reopening from Flat state

**Context:**

- Tracks whether position was originally entered as long (Buy) or short (Sell)
- Used for determining opposite side and position direction changes