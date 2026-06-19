# Limit If Touched Order

Limit if touched orders are designed for entering positions on pullbacks to support levels or selling into resistance levels, combining trigger conditions with limit order price precision.

## When to Use

Limit if touched orders are ideal for:


- **Support/resistance trading**: Enter positions at key levels with limit protection
- **Pullback entries**: Buy at retracement levels with limit orders
- **Profit taking**: Sell into rallies at resistance levels
- **Trend following**: Enter trends on pullbacks rather than breakouts
- **Mean reversion**: Enter positions at extreme levels with limit protection

## Example

A trader wants to buy 10 BTC if price rises to touch $50,000, then buy at $50,000 or better:

```rust
let limit_if_touched_order = LimitIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Buy,
    Quantity::from(10.0),
    Price::from("50000.00"),  // Limit price
    Price::from("50000.00"),  // Trigger price
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

Unlike stop orders, limit if touched orders:


- **Directional sensitivity**: Buy orders trigger when price rises to level
- **Price advantage**: Execute at limit price which is at or better than trigger
- **Breakout avoidance**: Enter on pullbacks rather than breakouts
- **Favorable positioning**: Limit price equals or exceeds trigger for buy orders

Unlike limit orders, limit if touched orders:


- **Conditional activation**: Only become active limit orders when trigger touched
- **Two-phase lifecycle**: Inactive until triggered, then becomes limit order
- **Entry timing**: Control when order becomes active, not just price level
- **Strategic timing**: Combine price level with market conditions

## Data Structure

```rust
pub struct LimitIfTouchedOrder {
    pub price: Price,                    // Limit price
    pub trigger_price: Price,            // Price that triggers activation
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

The LimitIfTouchedOrder structure includes:

- **price**: The limit price after trigger
- **trigger_price**: The price that activates the limit order
- **trigger_type**: Which price to use for triggering
- **is_triggered**: Boolean tracking if order has been activated
- **ts_triggered**: Timestamp when order was triggered
- **is_post_only**: Flag for post-only limit order behavior

## Event Triggers

Limit if touched orders follow this lifecycle:

- **OrderInitialized**: Trigger and limit prices with validation
- **OrderAccepted**: Order placed in waiting state
- **OrderTriggered**: Price touched trigger level, order becomes active limit
- **OrderFilled**: Limit order execution at or better than limit price
- **OrderUpdated**: Trigger or limit price modifications with validation

### Key Update Scenarios


- Independent trigger and limit price updates
- Validation ensures proper price relationships
- Timestamp tracking of trigger activation
- Slippage calculated relative to limit price
- Partial fills possible after activation

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
    
    // Calculate slippage based on limit price
    if is_order_filled {
        self.core.set_slippage(self.price);
    }
    
    Ok(())
}
```

## Validation Rules

### Buy Order Validation

For BUY limit if touched orders, the trigger price must be less than or equal to the limit price:

```rust
// Validation in new_checked
match order_side {
    OrderSide::Buy if trigger_price > price => {
        return Err(CorrectnessError::PredicateViolation {
            message: "BUY Limit-If-Touched must have `trigger_price` <= `price`".to_string(),
        }.into());
    }
    _ => {}
}
```

Example:


```rust
// Valid: trigger at $49,500, limit at $50,000
Price::from("49500.00"),  // Trigger price
Price::from("50000.00"),  // Limit price

// Invalid: trigger at $50,100, limit at $50,000
Price::from("50100.00"),  // Trigger price - ERROR!
Price::from("50000.00"),  // Limit price
```

### Sell Order Validation

For SELL limit if touched orders, the trigger price must be greater than or equal to the limit price:

```rust
// Validation in new_checked
match order_side {
    OrderSide::Sell if trigger_price < price => {
        return Err(CorrectnessError::PredicateViolation {
            message: "SELL Limit-If-Touched must have `trigger_price` >= `price`".to_string(),
        }.into());
    }
    _ => {}
}
```

Example:


```rust
// Valid: trigger at $50,500, limit at $50,000
Price::from("50500.00"),  // Trigger price
Price::from("50000.00"),  // Limit price

// Invalid: trigger at $49,900, limit at $50,000
Price::from("49900.00"),  // Trigger price - ERROR!
Price::from("50000.00"),  // Limit price
```

## Support Level Entry Examples

### Buying at Support with Limit

```rust
// Buy BTC if it touches $45,000 support
let support_entry = LimitIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("SUPPORT-ENTRY-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("45000.00"),  // Limit price (support level)
    Price::from("45000.00"),  // Trigger price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false, // Not post-only
    false, // Not reduce-only
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $45,000
- **Execution**: Will execute at $45,000 or better
- **Rationale**: Buying at support level with price protection

### Pullback Entry with Better Price

```rust
// Buy ETH on pullback to support, but aim for better price
let pullback_entry = LimitIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("PULLBACK-001"),
    OrderSide::Buy,
    Quantity::from("10.0"),
    Price::from("3490.00"),  // Limit price (better than trigger)
    Price::from("3500.00"),  // Trigger price
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $3,500
- **Execution**: Will execute at $3,490 or better (more favorable)
- **Rationale**: Enter pullback but aim for better execution

## Resistance Level Exit Examples

### Selling at Resistance with Limit

```rust
// Sell BTC if it touches $50,000 resistance
let resistance_exit = LimitIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("RESISTANCE-EXIT-001"),
    OrderSide::Sell,
    Quantity::from("1.0"),
    Price::from("50000.00"),  // Limit price (resistance level)
    Price::from("50000.00"),  // Trigger price
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $50,000
- **Execution**: Will execute at $50,000 or better (higher price)
- **Rationale**: Selling at resistance with price protection

### Rally Exit with Better Price

```rust
// Sell ETH on rally to resistance, but aim for higher price
let rally_exit = LimitIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("RALLY-EXIT-001"),
    OrderSide::Sell,
    Quantity::from("10.0"),
    Price::from("3510.00"),  // Limit price (better than trigger)
    Price::from("3500.00"),  // Trigger price
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $3,500
- **Execution**: Will execute at $3,510 or better (higher price)
- **Rationale**: Sell rally but aim for better execution

## Advanced Features

### Post-Only Limit If Touched

```rust
// Post-only for maximum price control and fee optimization
let post_only_lit = LimitIfTouchedOrder::new(
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
let large_lit = LimitIfTouchedOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("5.0")),  // Visible portion
);
```

### Time-Based Activation

```rust
// GTD order with specific expiration
let time_limited_lit = LimitIfTouchedOrder::new(
    // ... other parameters
    TimeInForce::Gtd,
    Some(expiration_time),  // Must provide for GTD
);
```

## Advantages and Disadvantages

### Advantages


- **Pullback timing**: Enter on market pullbacks rather than breakouts
- **Price advantage**: Get better execution than trigger price
- **Support/resistance**: Trade at key technical levels
- **Risk management**: Limit price provides execution control
- **Flexibility**: Independent trigger and limit control

### Disadvantages


- **No execution guarantee**: May never trigger if price doesn't reach level
- **Time consumption**: Can wait indefinitely for price touch
- **Missed opportunities**: Price may move past level without touching
- **Complex validation**: Must maintain proper price relationships
- **Monitoring needed**: Track both trigger and limit phases

## Best Practices


- Set appropriate spread between trigger and limit prices
- Use technical analysis to identify good trigger levels
- Consider volatility when setting price relationships
- Monitor activated orders for execution
- Use post-only for fee optimization
- Test trigger levels in paper trading first
- Consider time limits for activation

## Common Trading Strategies

### Support/Resistance Trading


```rust
// Enter at support, exit at resistance
let support_buy = LimitIfTouchedOrder::new(
    // Buy at $45,000 support
    OrderSide::Buy,
    Price::from("45000.00"),
    Price::from("45000.00"),
    // ... other parameters
);

let resistance_sell = LimitIfTouchedOrder::new(
    // Sell at $50,000 resistance
    OrderSide::Sell,
    Price::from("50000.00"),
    Price::from("50000.00"),
    // ... other parameters
);
```

### Mean Reversion

```rust
// Buy at oversold levels
let oversold_entry = LimitIfTouchedOrder::new(
    OrderSide::Buy,
    Price::from("42000.00"),  // Limit (support)
    Price::from("42000.00"),  // Trigger
    TriggerType::LastPrice,
    // ... other parameters
);
```

### Trend Following

```rust
// Buy pullback in uptrend
let trend_pullback = LimitIfTouchedOrder::new(
    OrderSide::Buy,
    Price::from("48000.00"),  // Limit (better price)
    Price::from("49000.00"),  // Trigger (recent high)
    TriggerType::LastPrice,
    // ... other parameters
);
```

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// Display quantity cannot exceed total quantity
check_display_qty(display_qty, quantity)?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;

// Price and trigger relationship validation
match order_side {
    OrderSide::Buy if trigger_price > price => {
        return Err(CorrectnessError::PredicateViolation {
            message: "BUY Limit-If-Touched must have `trigger_price` <= `price`".to_string(),
        }.into());
    }
    OrderSide::Sell if trigger_price < price => {
        return Err(CorrectnessError::PredicateViolation {
            message: "SELL Limit-If-Touched must have `trigger_price` >= `price`".to_string(),
        }.into());
    }
    _ => {}
}
```

## Slippage Calculation

Limit if touched orders calculate slippage based on the limit price:

```rust
// Favorable slippage possible if limit price better than trigger
// Buy: fill price <= limit price = negative or zero slippage
// Sell: fill price >= limit price = negative or zero slippage

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

- [limit_if_touched.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/limit_if_touched.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create limit if touched order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create limit if touched order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```