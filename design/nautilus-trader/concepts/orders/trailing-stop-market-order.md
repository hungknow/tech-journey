# Trailing Stop Market Order

Trailing stop market orders provide dynamic risk management by automatically adjusting stop levels as price moves favorably, combining the protection of stop orders with the flexibility of trailing behavior.

## When to Use

Trailing stop market orders are ideal for:


- **Profit protection**: Lock in gains while allowing positions to run
- **Trend following**: Automatically adjust stops as price moves favorably
- **Volatility adaptation**: Maintain appropriate distance from current price
- **Hands-off management**: Automated risk management without manual adjustment
- **Momentum riding**: Allow positions to capture extended trends

## Example

A trader wants to sell 10 BTC with a trailing stop of 5% below the highest price:

```rust
let trailing_stop_market_order = TrailingStopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Sell,
    Quantity::from(10.0),
    Price::from("50000.00"),  // Initial trigger price
    TriggerType::LastPrice,
    Decimal::from_str("0.05").unwrap(),  // 5% trailing offset
    TrailingOffsetType::Percentage,
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

Unlike regular stop orders, trailing stop market orders:


- **Dynamic adjustment**: Stop price automatically adjusts as price moves favorably
- **Profit maximization**: Allows positions to run while protecting gains
- **Activation tracking**: Records when trailing behavior begins
- **Flexible offsets**: Can use percentage or absolute price offsets

Unlike fixed stop orders, trailing stop market orders:


- **Automatic adjustment**: No manual stop price updates needed
- **Better trend capture**: Allows larger price movements
- **Reduced maintenance**: Less hands-on management required
- **Dynamic risk management**: Adapts to market conditions

## Data Structure

```rust
pub struct TrailingStopMarketOrder {
    core: OrderCore,
    pub activation_price: Option<Price>,  // Price when trailing starts
    pub trigger_price: Price,             // Current trailing stop level
    pub trigger_type: TriggerType,
    pub trailing_offset: Decimal,         // Distance from price
    pub trailing_offset_type: TrailingOffsetType,  // Percentage or Price
    pub expire_time: Option<UnixNanos>,
    pub display_qty: Option<Quantity>,
    pub trigger_instrument_id: Option<InstrumentId>,
    pub is_activated: bool,               // Whether trailing has started
    pub is_triggered: bool,
    pub ts_triggered: Option<UnixNanos>,
}
```

The TrailingStopMarketOrder structure includes:

- **activation_price**: The price level when trailing behavior began
- **trigger_price**: The current dynamic stop level
- **trailing_offset**: Distance from price to stop (percentage or absolute)
- **trailing_offset_type**: Whether offset is percentage or price-based
- **is_activated**: Whether trailing behavior has started
- **is_triggered**: Whether stop has been hit

## Trailing Offset Types

### Percentage Offset

```rust
// 5% trailing offset
TrailingOffsetType::Percentage,
Decimal::from_str("0.05").unwrap(),  // 5%
```

Behavior:


- Stop distance = price × offset percentage
- Automatically adjusts as price moves
- Easier for relative risk management

### Price Offset

```rust
// $500 trailing offset
TrailingOffsetType::Price,
Decimal::from_str("500.00").unwrap(),  // $500
```

Behavior:


- Stop distance = fixed dollar amount
- Easier for absolute risk management
- More predictable stop levels

## Event Triggers

Trailing stop market orders follow this lifecycle:

- **OrderInitialized**: Initial trigger price and trailing parameters set
- **OrderUpdated**: Trigger price adjustments as trailing activates
- **OrderTriggered**: Trailing stop hit, becomes market order
- **OrderFilled**: Market execution after trigger
- **SetActivated**: Called when trailing behavior begins

### Key Update Scenarios


- Dynamic trigger price adjustments via `OrderUpdated`
- Activation price recording when trailing starts
- Trailing offset modifications (percentage/price)
- Transition tracking from activation to trigger

### Update Logic

```rust
fn update(&mut self, event: &OrderUpdated) {
    // Cannot update limit price (market order)
    assert!(event.price.is_none(), "{}", OrderError::InvalidOrderEvent);
    
    // Update trailing stop level
    if let Some(trigger_price) = event.trigger_price {
        self.trigger_price = trigger_price;
    }
    
    self.quantity = event.quantity;
    self.leaves_qty = self.quantity.saturating_sub(self.filled_qty);
}
```

## Trailing Behavior

### Long Position (Sell Stop)

```rust
// Protect long BTC position with 5% trailing stop
let long_trailing = TrailingStopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("LONG-TRAILING-001"),
    OrderSide::Sell,  // Exit long position
    Quantity::from("1.0"),
    Price::from("50000.00"),  // Initial stop level
    TriggerType::LastPrice,
    Decimal::from_str("0.05").unwrap(),  // 5% below
    TrailingOffsetType::Percentage,
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Behavior:


- **Start**: If price rises to $51,000, activation price = $51,000
- **Trail**: Stop moves to $51,000 × (1 - 0.05) = $48,450
- **Trigger**: Order triggers when price drops to $48,450
- **Execution**: Immediate market sell execution

### Short Position (Buy Stop)

```rust
// Protect short ETH position with 3% trailing stop
let short_trailing = TrailingStopMarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("SHORT-TRAILING-001"),
    OrderSide::Buy,  // Exit short position
    Quantity::from("10.0"),
    Price::from("3000.00"),  // Initial stop level
    TriggerType::LastPrice,
    Decimal::from_str("0.03").unwrap(),  // 3% above
    TrailingOffsetType::Percentage,
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
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

Behavior:


- **Start**: If price drops to $2,900, activation price = $2,900
- **Trail**: Stop moves to $2,900 × (1 + 0.03) = $2,987
- **Trigger**: Order triggers when price rises to $2,987
- **Execution**: Immediate market buy execution

## Activation Examples

### Activation on Price Rise

```rust
// Order initially set
trigger_price: $50,000  // Initial stop

// Price rises to $52,000
activation_price: Some($52,000)  // Set when trailing activates
trigger_price: $49,400  // $52,000 × (1 - 0.05)

// Price rises to $54,000
trigger_price: $51,300  // $54,000 × (1 - 0.05)
```

### Activation on Price Drop

```rust
// Order initially set
trigger_price: $3,000  // Initial stop

// Price drops to $2,800
activation_price: Some($2,800)  // Set when trailing activates
trigger_price: $2,884  // $2,800 × (1 + 0.03)

// Price drops to $2,600
trigger_price: $2,678  // $2,600 × (1 + 0.03)
```

## Advanced Features

### Fixed Price Offset

```rust
// Use $500 fixed offset instead of percentage
let fixed_offset = TrailingStopMarketOrder::new(
    // ... other parameters
    TrailingOffsetType::Price,
    Decimal::from_str("500.00").unwrap(),  // $500 fixed offset
);
```

Behavior:


- Stop always $500 away from current price
- More predictable than percentage offset
- Better for fixed risk management

### Cross-Instrument Trailing

```rust
// Trail based on ETH price for BTC order
let cross_trail = TrailingStopMarketOrder::new(
    // ... other parameters
    trigger_instrument_id: Some(instrument_id!("ETH-USDT.BINANCE")),
);
```

### Display Quantity

```rust
// Show only portion of trailing stop
let display_trail = TrailingStopMarketOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("5.0")),  // Visible portion
);
```

## Advantages and Disadvantages

### Advantages


- **Dynamic adjustment**: Automatically adapts to price movements
- **Profit maximization**: Allows positions to capture extended trends
- **Reduced maintenance**: No manual stop updates needed
- **Risk protection**: Maintains appropriate distance from price
- **Flexibility**: Works with both percentage and fixed offsets

### Disadvantages


- **Complexity**: More complex than fixed stops
- **Market risk**: Can be triggered on temporary pullbacks
- **Gap risk**: Price can gap past trailing stop level
- **Over-tightening**: May stop out too early in volatile markets
- **Tracking needed**: Must monitor activation and trigger levels

## Best Practices


- Choose appropriate trailing offset for strategy
- Consider volatility when setting offset distance
- Monitor activation levels and trail distance
- Use fixed offsets for predictable risk amounts
- Use percentage offsets for relative risk management
- Test trailing parameters in paper trading first
- Consider minimum trail distance requirements

## Offset Selection Guidelines

### Percentage Offset

**Use when:**


- Trading instruments with similar price ranges
- Want risk relative to position value
- Trading trending markets with extended moves
- Want adaptive risk management

**Typical values:**


- Conservative: 1-3% for major trends
- Moderate: 3-5% for normal trading
- Aggressive: 5-10% for high-volatility trading

### Fixed Price Offset

**Use when:**


- Trading instruments with consistent volatility
- Want fixed dollar risk amounts
- Trading range-bound markets
- Want predictable stop levels

**Typical values:**


- Based on ATR (Average True Range)
- Based on recent volatility
- Fixed dollar amount per contract
- Based on support/resistance levels

## Common Trading Strategies

### Trend Following Strategy

```rust
// Enter trend and let trailing stop protect gains
let trend_entry = MarketOrder::new(
    OrderSide::Buy,
    Quantity::from("1.0"),
    TimeInForce::Ioc,
    // ... other parameters
);

// Protect with 5% trailing stop
let trend_trail = TrailingStopMarketOrder::new(
    OrderSide::Sell,
    Quantity::from("1.0"),
    Price::from("50000.00"),  // Initial stop
    TriggerType::LastPrice,
    Decimal::from_str("0.05").unwrap(),  // 5% trail
    TrailingOffsetType::Percentage,
    TimeInForce::Gtc,
    // ... other parameters
);
```

### Volatility-Based Trailing

```rust
// Set trailing offset based on ATR
let atr_value = calculate_atr(instrument, 14);
let trail_offset = atr_value * 2.0;  // 2x ATR

let atr_trail = TrailingStopMarketOrder::new(
    // ... other parameters
    TrailingOffsetType::Price,
    trail_offset,  // ATR-based offset
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
let trigger_price = event.trigger_price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_price` is required for `TrailingStopMarketOrder` initialization".to_string(),
    })?;

let trigger_type = event.trigger_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_type` is required for `TrailingStopMarketOrder` initialization".to_string(),
    })?;

let trailing_offset = event.trailing_offset.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trailing_offset` is required for `TrailingStopMarketOrder` initialization".to_string(),
    })?;

let trailing_offset_type = event.trailing_offset_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trailing_offset_type` is required for `TrailingStopMarketOrder` initialization".to_string(),
    })?;
```

## Slippage Calculation

Trailing stop market orders calculate slippage based on the trigger price:

```rust
// Buy orders: slippage = execution_price - trigger_price
// Sell orders: slippage = trigger_price - execution_price
fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    let is_order_triggered = matches!(event, OrderEventAny::Triggered(_));
    
    self.core.apply(event.clone())?;
    
    if is_order_triggered {
        self.is_triggered = true;
        self.ts_triggered = Some(event.ts_event());
    }
    
    if is_order_filled {
        self.core.set_slippage(self.trigger_price);  // Compare to trigger
    }
    
    Ok(())
}
```

## Activation Management

```rust
impl TrailingStopMarketOrder {
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

- [trailing_stop_market.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/trailing_stop_market.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create trailing stop market order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create trailing stop market order (panics on validation failure)
pub fn new(...) -> Self

// Check if has activation price
pub fn has_activation_price(&self) -> bool

// Set activation state
pub fn set_activated(&mut self)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```