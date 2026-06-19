# Market To Limit Order

Market to limit orders provide flexible execution strategies by attempting immediate market execution and falling back to limit orders for unfilled portions.

## When to Use

Market to limit orders are ideal for:


- **Hybrid approach**: Attempt immediate execution, fall back to limit order
- **Liquidity management**: Get immediate fills while preserving remaining quantity
- **Cost control**: Limit unfilled portions to specified price
- **Balanced execution**: Combine speed of market with price protection of limit
- **Large orders**: Handle big orders with mixed execution strategies

## Example

A trader wants to buy 10 BTC immediately, but any unfilled amount becomes a limit order at $50,000:

```rust
let market_to_limit_order = MarketToLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Buy,
    Quantity::from(10.0),
    TimeInForce::Gtc,
    Some(expire_time),
    post_only,
    reduce_only,
    quote_quantity,
    Some(display_qty),
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

Note: The limit price is typically set after the initial market execution based on the fill price or a specified level.

## Differences from Other Order Types

Unlike pure market orders, market to limit orders:


- **Two-phase execution**: Immediate market fill, then limit for remainder
- **Price control**: Limit portion has guaranteed execution price
- **Flexibility**: Combines speed of market with price protection of limit
- **Partial execution guaranteed**: At least some portion fills immediately
- **Price determination**: Limit price set after initial market execution

Unlike pure limit orders, market to limit orders:


- **Immediate execution**: Market portion fills immediately
- **Price discovery**: Limit price determined by market fill
- **Hybrid behavior**: Mixes aggressive and passive execution
- **Reduced waiting**: Some execution guaranteed, remainder waits

## Data Structure

```rust
pub struct MarketToLimitOrder {
    core: OrderCore,
    pub price: Option<Price>,            // Set after initial market execution
    pub expire_time: Option<UnixNanos>,
    pub is_post_only: bool,
    pub display_qty: Option<Quantity>,
}
```

The MarketToLimitOrder structure includes:

- **price**: Optional limit price (set after market execution)
- **expire_time**: Optional expiration for limit portion
- **is_post_only**: Flag for limit portion behavior
- **display_qty**: Visible portion for limit portion (iceberg)

## Event Triggers

Market to limit orders follow this lifecycle:

- **OrderInitialized**: Order created without price (market portion)
- **OrderSubmitted**: Order sent to venue
- **OrderUpdated**: Price set after market fill, limit portion created
- **OrderFilled**: Both market and limit portions can fill
- **OrderAccepted**: Limit portion acceptance if market fills completely

### Key Update Scenarios


- Price setting after initial market execution via `OrderUpdated`
- Quantity tracking between market and limit portions
- Slippage calculation for market portion
- Transition from market behavior to limit behavior

### Update Logic

```rust
fn update(&mut self, event: &OrderUpdated) {
    assert!(
        event.trigger_price.is_none(),
        "{}",
        OrderError::InvalidOrderEvent
    );
    
    // Set limit price after market execution
    if let Some(price) = event.price {
        self.price = Some(price);
    }
    
    self.quantity = event.quantity;
    self.leaves_qty = self.quantity.saturating_sub(self.filled_qty);
}
```

## Execution Flow

### Phase 1: Market Execution

```rust
// Initial order is submitted without price
let mtl_order = MarketToLimitOrder::new(
    // ... parameters
    TimeInForce::Ioc,  // Immediate or Cancel for market portion
    // ... other parameters
);
```

### Phase 2: Price Determination

After market execution, the venue or system sets the limit price:

```rust
// Price set via OrderUpdated event
let update_event = OrderUpdated {
    client_order_id,
    strategy_id,
    price: Some(Price::from("50000.00")),  // Limit price
    quantity: remaining_quantity,
    ..Default::default()
};
```

### Phase 3: Limit Execution

Remaining quantity executes as limit order at specified price:

```rust
// Limit order behavior for remainder
// - Passive execution at limit price or better
// - Time-in-force applies to limit portion
// - May fill partially or completely over time
```

## Common Use Cases with Examples

### Large Order Execution

```rust
// Execute large BTC order with hybrid strategy
let large_order = MarketToLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("LARGE-ORDER-001"),
    OrderSide::Buy,
    Quantity::from("50.0"),  // Large order
    TimeInForce::Gtc,  // Limit portion time-in-force
    None,  // No expiration
    true,  // Post-only for limit portion
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
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Phase 1**: Market order fills immediate available liquidity (maybe 10 BTC)
- **Phase 2**: Limit order at fill price for remaining 40 BTC
- **Benefit**: Get immediate partial fill while protecting remainder

### Balanced Execution

```rust
// Get some immediate execution, wait for better price on remainder
let balanced_order = MarketToLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("BALANCED-001"),
    OrderSide::Buy,
    Quantity::from("20.0"),
    TimeInForce::Gtc,
    None,
    false,  // Not post-only
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
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Phase 1**: Market order for immediate execution
- **Phase 2**: Limit order for remaining quantity at market fill price
- **Benefit**: Immediate execution plus price protection

### Price Discovery

```rust
// Use market fill to discover fair price, then limit remainder
let discovery_order = MarketToLimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("DISCOVERY-001"),
    OrderSide::Buy,
    Quantity::from("5.0"),
    TimeInForce::Gtc,
    None,
    true,  // Post-only for limit portion
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
    UUID4::new(),
    UnixNanos::now(),
);
```

Strategy:


- **Phase 1**: Market execution reveals fair market price
- **Phase 2**: Limit order at discovered price for maker rebates
- **Benefit**: Price discovery plus fee optimization

## Advanced Features

### Post-Only Limit Portion

```rust
// Limit portion only provides liquidity
let post_only_mtl = MarketToLimitOrder::new(
    // ... other parameters
    post_only: true,  // Limit portion is post-only
);
```

Benefits:


- Maker rebates on limit portion
- Better execution for remainder
- Reduced fees overall

### Display Quantity

```rust
// Show only portion of limit order in book
let display_mtl = MarketToLimitOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("2.0")),  // Visible portion
);
```

### Time Limits

```rust
// Limit portion expires at specific time
let time_limited_mtl = MarketToLimitOrder::new(
    // ... other parameters
    TimeInForce::Gtd,
    Some(expiration_time),  // Limit portion expiration
);
```

## Advantages and Disadvantages

### Advantages


- **Immediate partial execution**: Some fills guaranteed
- **Price protection**: Limit portion has execution control
- **Flexibility**: Combines speed and price precision
- **Liquidity management**: Handle large orders effectively
- **Fee optimization**: Potential for maker rebates on limit portion

### Disadvantages


- **Complexity**: More complex execution logic to manage
- **Slippage on market portion**: Market fills can have slippage
- **Tracking needed**: Monitor both phases separately
- **Price uncertainty**: Limit price unknown until market fill
- **Venue dependency**: Some venues may not support this order type

## Best Practices


- Understand venue-specific implementation differences
- Monitor both execution phases separately
- Consider position sizing for each phase
- Track slippage on market portion
- Use appropriate time-in-force for limit portion
- Consider alternative strategies if market portion fills completely

## Execution Scenarios

### Scenario 1: Complete Market Fill

```rust
// Order completely fills as market order
// Price never gets set (limit portion not needed)
OrderFilled {
    last_qty: full_quantity,
    // ... other fields
}

// No OrderUpdated event needed
// No limit phase
```

### Scenario 2: Partial Market Fill

```rust
// 3 BTC filled as market order
OrderFilled {
    last_qty: Quantity::from("3.0"),
    last_px: Price::from("50000.00"),  // Market fill price
    // ... other fields
}

// Price set for remainder
OrderUpdated {
    price: Some(Price::from("50000.00")),  // Limit price
    quantity: Quantity::from("7.0"),  // Remaining quantity
    // ... other fields
}

// Remaining 7 BTC executes as limit order
```

### Scenario 3: No Market Fill

```rust
// Market order doesn't fill immediately
// Venue may convert to limit order at specified price

OrderUpdated {
    price: Some(Price::from("50100.00")),  // Venue-set limit price
    quantity: full_quantity,  // All quantity remains
    // ... other fields
}

// Entire order executes as limit order
```

## Slippage Calculation

Market to limit orders handle slippage differently for each phase:

```rust
fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    
    self.core.apply(event.clone())?;
    
    if is_order_filled && let Some(price) = self.price {
        // Limit portion filled - calculate slippage against limit price
        self.core.set_slippage(price);
    }
    
    Ok(())
}
```

- **Market portion**: Slippage calculated based on execution vs. expected
- **Limit portion**: Slippage based on execution vs. limit price (favorable or zero)

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// Display quantity cannot exceed total quantity
check_display_qty(display_qty, quantity)?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;

// Market orders cannot be GTD (but limit portion can be)
if time_in_force == TimeInForce::Gtd {
    // This validation applies to initial market phase
    // Limit portion may have GTD with expire_time
}
```

## Venue Differences

Different venues may implement market-to-limit orders differently:


- **Price determination**: Some venues allow specifying limit price upfront
- **Phase separation**: Some venues treat as two separate orders
- **Priority**: Different queue priorities for each phase
- **Fees**: Different fee structures for market vs. limit portions

Always check venue documentation for specific implementation details.

## Common Trading Strategies

### VWAP Implementation

```rust
// Simulate VWAP with market-to-limit
let vwap_order = MarketToLimitOrder::new(
    OrderSide::Buy,
    Quantity::from("100.0"),
    TimeInForce::Gtc,
    None,  // No expiration
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
    UUID4::new(),
    UnixNanos::now(),
);

// Market portion gets immediate execution
// Limit portion ensures we don't overpay on remainder
```

### Liquidity Taking Strategy

```rust
// Take liquidity immediately, then provide liquidity
let liquidity_strategy = MarketToLimitOrder::new(
    OrderSide::Buy,
    Quantity::from("50.0"),
    TimeInForce::Gtc,
    None,
    true,  // Post-only for limit portion
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

// Market: Take available liquidity immediately
// Limit: Provide liquidity at market fill price
```

## Source Code Reference

Implementation details can be found in:

- [market_to_limit.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/market_to_limit.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create market to limit order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create market to limit order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if has price
fn has_price(&self) -> bool  // Returns price.is_some()
```