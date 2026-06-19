# Stop Market Order

Stop market orders provide automated risk management by triggering market orders when price reaches predetermined stop levels.

## When to Use

Stop market orders are ideal for:


- **Stop-loss**: Limit potential losses by automatically exiting positions
- **Breakout entry**: Enter positions when price breaks through key levels
- **Trailing stops**: Dynamically adjust stop levels as price moves favorably
- **Risk automation**: Eliminate emotional decision-making in exiting positions
- **Gap protection**: Exit positions quickly during rapid market moves

## Example

A trader wants to sell 10 BTC if the price drops below $45,000:

```rust
let stop_market_order = StopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Sell,
    Quantity::from(10.0),
    Price::from("45000.00"),  // Trigger price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    Some(expire_time),
    reduce_only,
    quote_quantity,
    Some(display_qty),
    emulation_trigger,
    trigger_instrument_id,
    contingency_type,
    order_list_id,
    linked_order_ids,
    parent_order_id,
    exec_algorithm_id,
    exec_algorithm_params,
    exec_spawn_id,
    tags,
    init_id,
    ts_init,
);
```

## Differences from Other Order Types

Unlike regular market orders, stop market orders:


- **Conditional execution**: Only trigger when price reaches stop level
- **Price protection**: Stop level defines maximum loss for long positions
- **Two-phase lifecycle**: Inactive until triggered, then becomes market order
- **Risk management focus**: Primarily used for loss limiting and breakout entries
- **Direction-dependent**: Buy stops trigger on price rise, sell stops on price drop

Unlike stop limit orders, stop market orders:


- **Immediate execution**: Market order execution immediately after trigger
- **No price guarantee**: May experience slippage after trigger
- **Speed prioritized**: Faster execution over price precision
- **Gap vulnerability**: Can execute at significantly worse prices during gaps

## Data Structure

```rust
pub struct StopMarketOrder {
    pub trigger_price: Price,            // Price that triggers execution
    pub trigger_type: TriggerType,       // Last, bid, ask, etc.
    pub expire_time: Option<UnixNanos>,
    pub display_qty: Option<Quantity>,
    pub trigger_instrument_id: Option<InstrumentId>,
    pub is_triggered: bool,              // Whether order has been triggered
    pub ts_triggered: Option<UnixNanos>, // When order was triggered
    pub protection_price: Option<Price>, // Optional price protection
    core: OrderCore,
}
```

The StopMarketOrder structure includes:

- **trigger_price**: The price level that activates the order
- **trigger_type**: Which price to use for triggering (Last, Bid, Ask, Mid)
- **is_triggered**: Boolean tracking if stop has been activated
- **ts_triggered**: Timestamp when stop was triggered
- **protection_price**: Optional limit on acceptable execution price

## Event Triggers

Stop market orders follow this lifecycle:

- **OrderInitialized**: Stop level and parameters set
- **OrderAccepted**: Stop order placed on venue
- **OrderTriggered**: Price reached stop level, order becomes market order
- **OrderFilled**: Market order execution after trigger
- **OrderUpdated**: Stop level or quantity adjustments

### Key Update Scenarios


- Stop price modifications via `OrderUpdated`
- Quantity changes before triggering
- Protection price setting for slippage control
- Trigger timestamp recording when stop is hit
- Slippage calculation relative to trigger price

### Trigger Logic

```rust
fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    let is_order_triggered = matches!(event, OrderEventAny::Triggered(_));
    
    // Track trigger timestamp
    let ts_event = if is_order_triggered {
        Some(event.ts_event())
    } else {
        None
    };
    
    self.core.apply(event.clone())?;
    
    // Update trigger state
    if is_order_triggered {
        self.is_triggered = true;
        self.ts_triggered = ts_event;
    }
    
    // Calculate slippage based on trigger price
    if is_order_filled {
        self.core.set_slippage(self.trigger_price);
    }
    
    Ok(())
}
```

## Trigger Types

Stop market orders support different price types for triggering:

```rust
pub enum TriggerType {
    Default,
    LastPrice,      // Trade price
    BidPrice,       // Best bid
    AskPrice,       // Best ask
    MidPrice,       // Midpoint of bid/ask
    // ... other trigger types
}
```

### Trigger Type Selection

- **LastPrice**: Most common, uses actual trade prices
- **BidPrice**: Good for sell stops (more conservative)
- **AskPrice**: Good for buy stops (more conservative)
- **MidPrice**: More conservative, uses average

## Stop Loss Examples

### Long Position Protection

```rust
// Protect long BTC position with stop loss
let stop_loss = StopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("STOP-LOSS-001"),
    OrderSide::Sell,  // Exit long position
    Quantity::from("1.0"),
    Price::from("45000.00"),  // Stop below current price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,  // No expiration
    true,  // reduce_only
    false, // quote_quantity
    None,  // display_qty
    None,  // emulation_trigger
    None,  // trigger_instrument_id
    None,  // contingency_type
    None,  // order_list_id
    None,  // linked_order_ids
    None,  // parent_order_id
    None,  // exec_algorithm_id
    None,  // exec_algorithm_params
    None,  // exec_spawn_id
    None,  // tags
    UUID4::new(),
    UnixNanos::now(),
);
```

### Short Position Protection

```rust
// Protect short ETH position with stop loss
let short_stop = StopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("SHORT-STOP-001"),
    OrderSide::Buy,  // Exit short position
    Quantity::from("10.0"),
    Price::from("3500.00"),  // Stop above current price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    true,  // reduce_only
    false,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

## Breakout Entry Examples

### Bullish Breakout

```rust
// Buy if BTC breaks above $50,000
let breakout_buy = StopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("BREAKOUT-001"),
    OrderSide::Buy,  // Enter long position
    Quantity::from("1.0"),
    Price::from("50000.00"),  // Breakout level above current
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false, // Not reduce_only
    false,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

### Bearish Breakout

```rust
// Sell if ETH breaks below $3,000
let breakout_sell = StopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("BREAKDOWN-001"),
    OrderSide::Sell,  // Enter short position
    Quantity::from("10.0"),
    Price::from("3000.00"),  // Breakdown level below current
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false, // Not reduce_only
    false,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

## Advantages and Disadvantages

### Advantages


- **Automation**: Eliminates emotional decision-making
- **Speed**: Fast execution after trigger
- **Simplicity**: Easy to understand and implement
- **Risk control**: Provides maximum loss protection
- **Flexibility**: Works with various trigger types

### Disadvantages


- **Slippage risk**: Market execution can occur at unfavorable prices
- **Gap risk**: Price can gap past stop level
- **Whipsaw risk**: Can be triggered by temporary price spikes
- **No price guarantee**: Execution price unknown until fill
- **Premature triggering**: May trigger on false breakouts

## Best Practices


- Set appropriate stop levels based on volatility
- Consider ATR or percentage-based stops
- Use protective stops to limit slippage
- Monitor stop levels as price moves
- Combine with take-profit orders for complete strategy
- Consider stop limit orders for price-sensitive exits
- Test trigger logic in paper trading first

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// Display quantity cannot exceed total quantity
check_display_qty(display_qty, quantity)?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;

// Trigger price and type are required
let trigger_price = event.trigger_price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_price` is required for `StopMarketOrder` initialization".to_string(),
    })?;

let trigger_type = event.trigger_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_type` is required for `StopMarketOrder` initialization".to_string(),
    })?;
```

## Slippage Calculation

Stop market orders calculate slippage based on the trigger price:

```rust
// Buy stop: slippage = execution_price - trigger_price
// Sell stop: slippage = trigger_price - execution_price
fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    
    self.core.apply(event.clone())?;
    
    if is_order_filled {
        self.core.set_slippage(self.trigger_price);  // Compare to trigger
    }
    
    Ok(())
}
```

## Source Code Reference

Implementation details can be found in:

- [stop_market.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/stop_market.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create stop market order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create stop market order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```