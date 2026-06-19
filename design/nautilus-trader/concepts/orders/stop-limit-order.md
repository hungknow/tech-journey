# Stop Limit Order

Stop limit orders provide precise control over both trigger and execution prices, combining the risk management of stop orders with the price protection of limit orders.

## When to Use

Stop limit orders are ideal for:


- **Stop-loss with price protection**: Limit losses while ensuring minimum fill price
- **Breakout entries**: Enter positions at breakout levels with limit protection
- **Gap protection**: Avoid unfavorable fills during price gaps
- **Price-sensitive exits**: Need guaranteed maximum/minimum execution price
- **Volatility management**: Control execution in volatile markets

## Example

A trader wants to sell 10 BTC if price drops below $45,000, but not below $44,500:

```rust
let stop_limit_order = StopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Sell,
    Quantity::from(10.0),
    Price::from("44500.00"),  // Limit price (minimum execution)
    Price::from("45000.00"),  // Trigger price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    Some(expire_time),
    post_only,
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

Unlike stop market orders, stop limit orders:


- **Price precision**: Guarantee both trigger and execution prices
- **No execution guarantee**: May not fill if limit price not reached
- **Three-phase lifecycle**: Inactive → Triggered → Limit order
- **Gap protection**: Limit price prevents unfavorable gap fills
- **Slower execution**: Limit order takes time to fill after trigger

Unlike limit if touched orders, stop limit orders:


- **Opposite direction**: Sell stops trigger on price drop, buy stops on rise
- **Breakout focus**: Designed for breakouts rather than pullbacks
- **More conservative**: Trigger price is at less favorable level

## Data Structure

```rust
pub struct StopLimitOrder {
    pub price: Price,                    // Limit price
    pub trigger_price: Price,            // Price that triggers execution
    pub trigger_type: TriggerType,
    pub expire_time: Option<UnixNanos>,
    pub is_post_only: bool,
    pub display_qty: Option<Quantity>,
    pub trigger_instrument_id: Option<InstrumentId>,
    pub is_triggered: bool,
    pub ts_triggered: Option<UnixNanos>,
    core: OrderCore,
}
```

The StopLimitOrder structure includes:

- **price**: The limit price after trigger
- **trigger_price**: The price that activates the order
- **trigger_type**: Which price to use for triggering
- **is_triggered**: Boolean tracking if stop has been activated
- **ts_triggered**: Timestamp when stop was triggered
- **is_post_only**: Flag for post-only limit order behavior

## Event Triggers

Stop limit orders follow this lifecycle:

- **OrderInitialized**: Both stop and limit prices set
- **OrderAccepted**: Stop limit order placed on venue
- **OrderTriggered**: Stop price reached, order becomes limit order
- **OrderFilled**: Limit order execution at or better than limit price
- **OrderUpdated**: Stop or limit price modifications

### Key Update Scenarios


- Independent updates to stop and limit prices
- Quantity adjustments before or after triggering
- Post-only flag modifications
- Slippage calculation relative to limit price
- Partial fills possible during limit phase

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
    
    // Calculate slippage based on limit price (not trigger)
    if is_order_filled {
        self.core.set_slippage(self.price);
    }
    
    Ok(())
}
```

## Price Relationship Rules

### Buy Stop Limit Orders

For buy stop limit orders, the trigger price must be ABOVE the current price, and the limit price determines the maximum execution price:

```rust
// Trigger price > current price (breakout)
// Limit price >= trigger price (or could be different based on strategy)

// Example: Buy if BTC breaks above $50,000, but not above $50,100
Price::from("50000.00"),  // Trigger price
Price::from("50100.00"),  // Limit price (max execution)
```

### Sell Stop Limit Orders

For sell stop limit orders, the trigger price must be BELOW the current price, and the limit price determines the minimum execution price:

```rust
// Trigger price < current price (breakdown)
// Limit price <= trigger price (or could be different based on strategy)

// Example: Sell if BTC drops below $45,000, but not below $44,900
Price::from("45000.00"),  // Trigger price
Price::from("44900.00"),  // Limit price (min execution)
```

## Stop Loss with Price Protection

### Long Position Protection

```rust
// Protect long BTC position with stop limit
let stop_loss_limit = StopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("STOP-LIMIT-001"),
    OrderSide::Sell,  // Exit long position
    Quantity::from("1.0"),
    Price::from("44900.00"),  // Limit price (minimum fill)
    Price::from("45000.00"),  // Stop price (trigger)
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,  // No expiration
    false, // Not post-only
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

This provides:


- **Protection**: Exits if price drops to $45,000
- **Price guarantee**: Won't sell below $44,900
- **Gap protection**: Won't execute if price gaps to $44,000

### Short Position Protection

```rust
// Protect short ETH position with stop limit
let short_stop_limit = StopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("SHORT-STOP-LIMIT-001"),
    OrderSide::Buy,  // Exit short position
    Quantity::from("10.0"),
    Price::from("3510.00"),  // Limit price (max fill)
    Price::from("3500.00"),  // Stop price (trigger)
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false,
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

## Breakout Entry with Limit Protection

### Bullish Breakout

```rust
// Buy if BTC breaks above $50,000, with limit at $50,100
let breakout_limit = StopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("BREAKOUT-LIMIT-001"),
    OrderSide::Buy,  // Enter long position
    Quantity::from("1.0"),
    Price::from("50100.00"),  // Limit price (max execution)
    Price::from("50000.00"),  // Stop price (trigger)
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false, // Not post-only
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

This provides:


- **Entry**: Enters if price breaks $50,000
- **Price control**: Won't pay more than $50,100
- **Breakout protection**: Won't overpay on false breakouts

### Bearish Breakdown

```rust
// Sell if ETH breaks below $3,000, with limit at $2,990
let breakdown_limit = StopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("BREAKDOWN-LIMIT-001"),
    OrderSide::Sell,  // Enter short position
    Quantity::from("10.0"),
    Price::from("2990.00"),  // Limit price (min execution)
    Price::from("3000.00"),  // Stop price (trigger)
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false,
    false,
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

## Advanced Features

### Post-Only Stop Limit

```rust
// Post-only stop limit for maximum price control
let post_only_stop = StopLimitOrder::new(
    // ... other parameters
    post_only: true,  // Only provide liquidity after trigger
);
```

Benefits:


- Maker rebates on limit portion
- Never takes liquidity after trigger
- Better price guarantees

### Display Quantity for Large Orders

```rust
// Show only portion after trigger
let large_stop = StopLimitOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("5.0")),  // Visible portion
);
```

## Advantages and Disadvantages

### Advantages


- **Price precision**: Guaranteed maximum/minimum execution price
- **Risk control**: Stop level provides protection
- **Gap protection**: Limit price prevents unfavorable fills
- **Cost control**: Won't overpay for entries
- **Flexibility**: Independent stop and limit control

### Disadvantages


- **No execution guarantee**: May not fill if limit not reached
- **Complexity**: More parameters to manage
- **Slower execution**: Limit phase takes time
- **Missed opportunities**: May miss valid exits due to limit
- **Tracking needed**: Must monitor both trigger and limit phases

## Best Practices


- Set appropriate spread between stop and limit prices
- Consider volatility when setting limit levels
- Monitor triggered orders for execution
- Use post-only for fee optimization
- Combine with trailing stops for dynamic protection
- Test limit levels in different market conditions
- Consider order time-in-force for limit phase

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// Display quantity cannot exceed total quantity
check_display_qty(display_qty, quantity)?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;

// Price, trigger price, and trigger type are required
let price = event.price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`price` is required for `StopLimitOrder` initialization".to_string(),
    })?;

let trigger_price = event.trigger_price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_price` is required for `StopLimitOrder` initialization".to_string(),
    })?;

let trigger_type = event.trigger_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_type` is required for `StopLimitOrder` initialization".to_string(),
    })?;
```

## Slippage Calculation

Stop limit orders calculate slippage based on the limit price (not trigger price):

```rust
// For fills: slippage relative to limit price
// Buy orders: may have negative slippage (favorable) if fill < limit
// Sell orders: may have negative slippage (favorable) if fill > limit

fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    
    self.core.apply(event.clone())?;
    
    if is_order_filled {
        self.core.set_slippage(self.price);  // Compare to limit price
    }
    
    Ok(())
}
```

## Source Code Reference

Implementation details can be found in:

- [stop_limit.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/stop_limit.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create stop limit order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create stop limit order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```