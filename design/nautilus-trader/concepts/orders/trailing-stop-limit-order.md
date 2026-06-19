# Trailing Stop Limit Order

Trailing stop limit orders combine dynamic risk management with precise price control, providing both automatic stop adjustment and guaranteed execution prices.

## When to Use

Trailing stop limit orders are ideal for:


- **Profit protection with limits**: Lock gains while ensuring minimum exit price
- **Gap protection**: Prevent unfavorable fills during rapid reversals
- **Trend following with control**: Allow positions to run with guaranteed exit price
- **Volatility management**: Control execution in volatile markets
- **Precise risk management**: Combine dynamic adjustment with price guarantees

## Example

A trader wants to sell 10 BTC with a trailing stop and minimum exit price:

```rust
let trailing_stop_limit_order = TrailingStopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Sell,
    Quantity::from(10.0),
    Price::from("50000.00"),  // Limit price
    Price::from("52000.00"),  // Initial trigger price
    TriggerType::LastPrice,
    Decimal::from_str("0.05").unwrap(),  // Limit offset
    Decimal::from_str("0.03").unwrap(),  // Trailing offset
    TrailingOffsetType::Percentage,
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

Unlike trailing stop market orders, trailing stop limit orders:


- **Price guarantee**: Limit price ensures minimum execution price
- **Gap protection**: Prevents unfavorable fills during rapid reversals
- **Complex parameters**: Both trailing and limit offsets
- **Three-phase lifecycle**: Activation → Trigger → Limit order
- **No execution guarantee**: May not fill if limit not reached

Unlike stop limit orders, trailing stop limit orders:


- **Dynamic adjustment**: Trigger price adjusts as price moves favorably
- **Better trend capture**: Allows larger price movements before protection
- **Automated management**: Less manual adjustment needed
- **Profit maximization**: Can lock in more gains during trends

## Data Structure

```rust
pub struct TrailingStopLimitOrder {
    core: OrderCore,
    pub activation_price: Option<Price>,  // Price when trailing starts
    pub price: Price,                     // Limit price
    pub trigger_price: Price,             // Current trailing trigger
    pub trigger_type: TriggerType,
    pub limit_offset: Decimal,            // Distance from trigger to limit
    pub trailing_offset: Decimal,         // Distance from price to trigger
    pub trailing_offset_type: TrailingOffsetType,
    pub expire_time: Option<UnixNanos>,
    pub is_post_only: bool,
    pub display_qty: Option<Quantity>,
    pub trigger_instrument_id: Option<InstrumentId>,
    pub is_activated: bool,
    pub is_triggered: bool,
    pub ts_triggered: Option<UnixNanos>,
}
```

The TrailingStopLimitOrder structure includes:

- **activation_price**: The price level when trailing behavior began
- **price**: The limit price after trigger
- **trigger_price**: The current dynamic trigger level
- **limit_offset**: Distance from trigger to limit price
- **trailing_offset**: Distance from price to trigger
- **is_activated**: Whether trailing behavior has started
- **is_triggered**: Whether stop has been hit

## Offset Relationships

### For Long Positions (Sell Orders)

```rust
// Example: Long BTC position with trailing stop limit
OrderSide::Sell,
price: $49,000,  // Limit price (minimum sell)
trigger_price: $50,000,  // Initial trigger (below price)
limit_offset: $1,000,  // $1,000 below trigger
trailing_offset: $1,000,  // $1,000 below price
```

**Calculation**: limit_price = trigger_price - limit_offset

As price moves:


- Price rises to $51,000 → trigger rises to $50,000 → limit = $49,000
- Price rises to $52,000 → trigger rises to $51,000 → limit = $50,000
- Price drops to $51,000 → order triggers at trigger, becomes limit order at $50,000

### For Short Positions (Buy Orders)

```rust
// Example: Short ETH position with trailing stop limit
OrderSide::Buy,
price: $3,000,  // Limit price (maximum buy)
trigger_price: $2,800,  // Initial trigger (below price)
limit_offset: $100,  // $100 above trigger
trailing_offset: $100,  // $100 below price
```

**Calculation**: limit_price = trigger_price + limit_offset

As price moves:


- Price drops to $2,700 → trigger drops to $2,600 → limit = $2,700
- Price drops to $2,600 → trigger drops to $2,500 → limit = $2,600
- Price rises to $2,600 → order triggers at trigger, becomes limit order at $2,600

## Event Triggers

Trailing stop limit orders follow this lifecycle:

- **OrderInitialized**: Limit price, trigger price, and offsets set
- **OrderUpdated**: Dynamic trigger price adjustments as trailing activates
- **OrderTriggered**: Trailing stop hit, becomes limit order
- **OrderFilled**: Limit order execution at or better than limit price
- **SetActivated**: Called when trailing behavior begins

### Key Update Scenarios


- Dynamic trigger price trailing
- Independent limit and trailing offset adjustments
- Activation price recording when trailing starts
- Transition from trailing to limit order behavior
- Slippage calculated relative to limit price

### Update Logic

```rust
fn update(&mut self, event: &OrderUpdated) {
    // Update limit price if provided
    if let Some(price) = event.price {
        self.price = price;
    }
    
    // Update trigger price
    if let Some(trigger_price) = event.trigger_price {
        self.trigger_price = trigger_price;
    }
    
    self.quantity = event.quantity;
    self.leaves_qty = self.quantity.saturating_sub(self.filled_qty);
}
```

## Activation Examples

### Long Position Activation

```rust
// Order initially set
trigger_price: $50,000  // Initial trigger
limit_price: $49,000    // Limit price

// Price rises to $51,000
activation_price: Some($51,000)  // Set when trailing activates
trigger_price: $50,000  // Trailing stops ($51,000 - $1,000)
limit_price: $49,000  // Limit = $50,000 - $1,000

// Price rises to $52,000
trigger_price: $51,000  // Trailing stops ($52,000 - $1,000)
limit_price: $50,000  // Limit = $51,000 - $1,000

// Price drops to $51,000
is_triggered: true  // Trigger hit
ts_triggered: Some(timestamp)  // Trigger time
// Order becomes limit order at $50,000
```

### Short Position Activation

```rust
// Order initially set
trigger_price: $3,000  // Initial trigger
limit_price: $3,100    // Limit price

// Price drops to $2,800
activation_price: Some($2,800)  // Set when trailing activates
trigger_price: $2,700  // Trailing stops ($2,800 + $100)
limit_price: $2,800  // Limit = $2,700 + $100

// Price drops to $2,600
trigger_price: $2,500  // Trailing stops ($2,600 + $100)
limit_price: $2,600  // Limit = $2,500 + $100

// Price rises to $2,600
is_triggered: true  // Trigger hit
ts_triggered: Some(timestamp)  // Trigger time
// Order becomes limit order at $2,600
```

## Common Use Cases

### Profit Protection with Price Guarantee

```rust
// Protect long BTC gains with trailing stop limit
let profit_protection = TrailingStopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("PROFIT-PROTECT-001"),
    OrderSide::Sell,  // Exit long position
    Quantity::from("1.0"),
    Price::from("49000.00"),  // Limit price (minimum exit)
    Price::from("50000.00"),  // Trigger price
    TriggerType::LastPrice,
    Decimal::from_str("1000.00").unwrap(),  // $1,000 limit offset
    Decimal::from_str("1000.00").unwrap(),  // $1,000 trailing offset
    TrailingOffsetType::Price,
    TimeInForce::Gtc,
    None,
    false, // Not post-only
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

Strategy:


- **Protection**: Stops trail price movements downward
- **Price guarantee**: Won't sell below limit price
- **Gap protection**: Won't execute if price gaps to lower level

### Volatility-Based Protection

```rust
// Set offsets based on volatility
let atr_value = calculate_atr(instrument, 14);
let limit_offset = atr_value * 1.5;  // Conservative limit
let trail_offset = atr_value * 1.0;  // Normal trail

let volatility_trail = TrailingStopLimitOrder::new(
    // ... other parameters
    TrailingOffsetType::Price,
    limit_offset,  // ATR-based limit offset
    trail_offset,  // ATR-based trail offset
);
```

### Percentage-Based Protection

```rust
// Use percentage offsets for relative risk
let percent_trail = TrailingStopLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("PERCENT-TRAIL-001"),
    OrderSide::Buy,  // Exit short position
    Quantity::from("10.0"),
    Price::from("3500.00"),  // Limit price (max buy)
    Price::from("3600.00"),  // Trigger price
    TriggerType::LastPrice,
    Decimal::from_str("100.00").unwrap(),  // Fixed limit offset
    Decimal::from_str("0.05").unwrap(),  // 5% trailing offset
    TrailingOffsetType::Percentage,
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

## Advanced Features

### Post-Only Limit Portion

```rust
// Post-only for maximum price control
let post_only_trail = TrailingStopLimitOrder::new(
    // ... other parameters
    post_only: true,  // Only provide liquidity after trigger
);
```

Benefits:


- Maker rebates on limit portion
- Never takes liquidity after trigger
- Better price guarantees

### Display Quantity

```rust
// Show only portion of trailing stop limit
let display_trail = TrailingStopLimitOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("5.0")),  // Visible portion
);
```

### Cross-Instrument Trailing

```rust
// Trail based on ETH price for BTC order
let cross_trail = TrailingStopLimitOrder::new(
    // ... other parameters
    trigger_instrument_id: Some(instrument_id!("ETH-USDT.BINANCE")),
);
```

## Advantages and Disadvantages

### Advantages


- **Dynamic adjustment**: Automatically adapts to price movements
- **Price precision**: Guaranteed maximum/minimum execution price
- **Gap protection**: Prevents unfavorable fills during reversals
- **Risk control**: Maintains appropriate distance from price
- **Flexibility**: Works with both percentage and fixed offsets

### Disadvantages


- **No execution guarantee**: May not fill if limit not reached
- **Complexity**: More parameters to manage than simple trailing stops
- **Slower execution**: Limit phase takes time after trigger
- **Missed opportunities**: May miss valid exits due to limit
- **Tracking needed**: Monitor both trigger and limit phases

## Best Practices


- Set appropriate spread between trigger and limit prices
- Consider volatility when setting offset distances
- Monitor activated orders for execution
- Use post-only for fee optimization
- Combine with take-profit orders for complete strategies
- Test parameters in paper trading first
- Consider minimum spread requirements

## Offset Selection Guidelines

### Limit Offset

**Purpose**: Distance from trigger to limit price

**Use when:**


- Want price protection after trigger
- Trading volatile markets with potential gaps
- Want to prevent unfavorable fills

**Typical values:**


- Conservative: 1-2× ATR or 1-2% price
- Moderate: 0.5-1× ATR or 0.5-1% price
- Aggressive: 0.2-0.5× ATR or 0.2-0.5% price

### Trailing Offset

**Purpose**: Distance from current price to trigger

**Use when:**


- Want appropriate risk adjustment speed
- Trading markets with different volatility profiles
- Want control over trailing sensitivity

**Typical values:**


- Conservative: 1-3× ATR or 1-3% price
- Moderate: 0.5-1× ATR or 0.5-1% price
- Aggressive: 0.2-0.5× ATR or 0.2-0.5% price

## Common Trading Strategies

### Trend Following with Protection

```rust
// Enter trend with protection
let trend_entry = MarketOrder::new(
    OrderSide::Buy,
    Quantity::from("1.0"),
    TimeInForce::Ioc,
    // ... other parameters
);

// Protect with trailing stop limit
let trend_trail = TrailingStopLimitOrder::new(
    OrderSide::Sell,
    Quantity::from("1.0"),
    Price::from("49000.00"),  // Limit price
    Price::from("50000.00"),  // Trigger price
    TriggerType::LastPrice,
    Decimal::from_str("500.00").unwrap(),  // $500 limit offset
    Decimal::from_str("1000.00").unwrap(),  // $1,000 trail offset
    TrailingOffsetType::Price,
    TimeInForce::Gtc,
    // ... other parameters
);
```

### Volatility-Adjusted Protection

```rust
// Adjust offsets based on current volatility
let atr = calculate_atr(instrument, 14);
let volatility_factor = atr / average_atr(instrument, 100);

let limit_offset = base_limit_offset * volatility_factor;
let trail_offset = base_trail_offset * volatility_factor;

let adjusted_trail = TrailingStopLimitOrder::new(
    // ... other parameters
    TrailingOffsetType::Price,
    limit_offset,  // Adjusted based on volatility
    trail_offset,  // Adjusted based on volatility
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

// Required fields
let price = event.price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`price` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;

let trigger_price = event.trigger_price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_price` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;

let trigger_type = event.trigger_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_type` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;

let limit_offset = event.limit_offset.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`limit_offset` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;

let trailing_offset = event.trailing_offset.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trailing_offset` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;

let trailing_offset_type = event.trailing_offset_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trailing_offset_type` is required for `TrailingStopLimitOrder` initialization".to_string(),
    })?;
```

## Slippage Calculation

Trailing stop limit orders calculate slippage based on the limit price (not trigger price):

```rust
// For fills: slippage relative to limit price
// Buy orders: may have negative slippage (favorable) if fill < limit
// Sell orders: may have negative slippage (favorable) if fill > limit

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
        self.core.set_slippage(self.price);  // Compare to limit price
    }
    
    Ok(())
}
```

## Activation Management

```rust
impl TrailingStopLimitOrder {
    #[must_use]
    pub fn has_activation_price(&self) -> bool {
        self.activation_price.is_some()
    }
    
    pub fn set_activated(&mut self) {
        debug_assert!(!self.is_activated, "double activation");
        self.is_activated = true;
    }
}
```

## Source Code Reference

Implementation details can be found in:

- [trailing_stop_limit.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/trailing_stop_limit.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create trailing stop limit order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create trailing stop limit order (panics on validation failure)
pub fn new(...) -> Self

// Check if has activation price
pub fn has_activation_price(&self) -> bool

// Set activation state
pub fn set_activated(&mut self)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```