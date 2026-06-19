# Market If Touched Order

Market if touched orders combine trigger conditions with immediate market execution, ideal for breakout trading and rapid market response strategies.

## When to Use

Market if touched orders are ideal for:


- **Breakout trading**: Enter positions immediately when key levels break
- **News trading**: React quickly to price movements after news events
- **Technical trading**: Execute immediately when technical levels are breached
- **Momentum trading**: Enter positions quickly on momentum shifts
- **Event-driven**: Execute rapid responses to market events

## Example

A trader wants to buy 10 BTC immediately if price rises to $50,000:

```rust
let market_if_touched_order = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Buy,
    Quantity::from(10.0),
    Price::from("50000.00"),  // Trigger price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    Some(expire_time),
    reduce_only,
    quote_quantity,
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

Unlike limit if touched orders, market if touched orders:


- **Immediate execution**: Market order execution immediately after trigger
- **No price guarantee**: May experience slippage after trigger
- **Speed prioritized**: Faster execution over price precision
- **Breakout focused**: Designed for momentum trading strategies

Unlike stop market orders, market if touched orders:


- **Opposite direction**: Buy orders trigger on price rise (like buy stops)
- **Different psychological focus**: Entering on strength vs exiting on weakness
- **Similar execution**: Both become market orders after trigger
- **Breakout oriented**: Designed for entering breakouts, not protecting positions

## Data Structure

```rust
pub struct MarketIfTouchedOrder {
    pub trigger_price: Price,            // Price that triggers market order
    pub trigger_type: TriggerType,
    pub expire_time: Option<UnixNanos>,
    pub trigger_instrument_id: Option<InstrumentId>,
    pub is_triggered: bool,
    pub ts_triggered: Option<UnixNanos>,
    core: OrderCore,
}
```

The MarketIfTouchedOrder structure includes:

- **trigger_price**: The price that activates the market order
- **trigger_type**: Which price to use for triggering
- **is_triggered**: Boolean tracking if order has been activated
- **ts_triggered**: Timestamp when order was triggered
- **No execution price**: Market orders don't have a fixed price

## Event Triggers

Market if touched orders follow this lifecycle:

- **OrderInitialized**: Trigger price set
- **OrderAccepted**: Order placed in waiting state
- **OrderTriggered**: Price touched trigger level, becomes market order
- **OrderFilled**: Immediate market execution (may be partial/complete)
- **OrderUpdated**: Trigger price or quantity adjustments

### Key Update Scenarios


- Trigger price modifications
- Quantity changes before triggering
- Protection price setting for slippage control
- Slippage calculation: execution price - trigger price
- Immediate market execution after trigger

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

## Breakout Entry Examples

### Bullish Breakout

```rust
// Buy immediately if BTC breaks above $50,000
let breakout_buy = MarketIfTouchedOrder::new(
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
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $50,000
- **Execution**: Immediate market execution (no price guarantee)
- **Rationale**: Enter bullish breakout quickly to capture momentum

### Bearish Breakdown

```rust
// Sell immediately if ETH breaks below $3,000
let breakdown_sell = MarketIfTouchedOrder::new(
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
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Trigger**: Order becomes active when price touches $3,000
- **Execution**: Immediate market execution (no price guarantee)
- **Rationale**: Enter bearish breakdown quickly to capture momentum

## News Trading Examples

### Positive News Reaction

```rust
// Buy immediately on positive news breakout
let news_buy = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("NEWS-POSITIVE-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("51000.00"),  // News-driven breakout level
    TriggerType::LastPrice,
    TimeInForce::Ioc,  // Immediate or cancel
    None,
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

### Negative News Reaction

```rust
// Sell immediately on negative news breakdown
let news_sell = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("NEWS-NEGATIVE-001"),
    OrderSide::Sell,
    Quantity::from("10.0"),
    Price::from("2900.00"),  // News-driven breakdown level
    TriggerType::LastPrice,
    TimeInForce::Ioc,
    None,
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

## Technical Trading Examples

### Moving Average Breakout

```rust
// Buy immediately when price breaks above MA
let ma_breakout = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("MA-BREAKOUT-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("49500.00"),  // 200-day MA level
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
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

### Resistance Breakout

```rust
// Buy immediately when resistance breaks
let resistance_breakout = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("RESISTANCE-BREAK-001"),
    OrderSide::Buy,
    Quantity::from("10.0"),
    Price::from("3550.00"),  // Resistance level
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
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

### Cross-Instrument Triggers

```rust
// Trigger BTC order based on ETH price movement
let cross_trigger = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("CROSS-TRIGGER-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("3000.00"),  // ETH trigger price
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    None,
    false,
    false,
    None,
    Some(instrument_id!("ETH-USDT.BINANCE")),  // Trigger instrument
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

### Reduce-Only Entry

```rust
// Only enter if it reduces position (close short)
let reduce_entry = MarketIfTouchedOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("REDUCE-ENTRY-001"),
    OrderSide::Buy,  // Close short position
    Quantity::from("1.0"),
    Price::from("50000.00"),
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
    None,
    None,
    UUID4::new(),
    UnixNanos::now(),
);
```

## Advantages and Disadvantages

### Advantages


- **Speed**: Immediate execution after trigger
- **Simplicity**: No need to specify execution price
- **Breakout capture**: Enter quickly on momentum shifts
- **Automation**: Eliminates manual execution delays
- **Versatility**: Works for various trigger conditions

### Disadvantages


- **Slippage risk**: Market execution can occur at unfavorable prices
- **Gap risk**: Price can gap significantly after trigger
- **No price control**: Cannot guarantee execution price
- **False breakouts**: Can trigger on temporary spikes
- **Overpaying**: May pay significantly more than trigger price

## Best Practices


- Use in liquid markets to minimize slippage
- Set appropriate trigger levels based on analysis
- Consider position sizing to manage slippage impact
- Monitor fill prices for execution quality
- Combine with stop losses for risk management
- Test trigger logic in paper trading first
- Use appropriate time-in-force for strategy

## Risk Management

### Slippage Protection

Monitor and limit slippage:

```rust
// Track slippage after execution
if let Some(slippage) = order.slippage() {
    if slippage > MAX_ACCEPTABLE_SLIPPAGE {
        // Take action: adjust strategy, reduce position size, etc.
    }
}
```

### Position Sizing

Adjust position size based on expected slippage:

```rust
// Smaller positions for larger expected slippage
let expected_volatility = calculate_volatility(instrument);
let position_size = calculate_safe_position(
    capital,
    expected_volatility,
    max_slippage,
);
```

## Common Trading Strategies

### Breakout Strategy

```rust
// Classic breakout strategy
let breakout_entry = MarketIfTouchedOrder::new(
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("50000.00"),  // Resistance level
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    // ... other parameters
);

let stop_loss = StopMarketOrder::new(
    OrderSide::Sell,
    Quantity::from("1.0"),
    Price::from("47500.00"),  // Below entry
    TriggerType::LastPrice,
    TimeInForce::Gtc,
    // ... other parameters
);
```

### Momentum Strategy

```rust
// Enter on momentum shift
let momentum_entry = MarketIfTouchedOrder::new(
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("52000.00"),  // Momentum breakout
    TriggerType::LastPrice,
    TimeInForce::Ioc,
    // ... other parameters
);
```

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;

// Trigger price and type are required
let trigger_price = event.trigger_price.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_price` is required for `MarketIfTouchedOrder` initialization".to_string(),
    })?;

let trigger_type = event.trigger_type.ok_or_else(|| 
    CorrectnessError::PredicateViolation {
        message: "`trigger_type` is required for `MarketIfTouchedOrder` initialization".to_string(),
    })?;
```

## Slippage Calculation

Market if touched orders calculate slippage based on the trigger price:

```rust
// Buy orders: slippage = execution_price - trigger_price
// Sell orders: slippage = trigger_price - execution_price
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

- [market_if_touched.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/market_if_touched.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create market if touched order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create market if touched order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if triggered
fn is_triggered(&self) -> Option<bool>  // Returns Some(true/false)
```