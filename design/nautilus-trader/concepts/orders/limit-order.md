# Limit Order

Limit orders provide precise price control by ensuring execution at specified prices or better, making them ideal for price-sensitive trading strategies.

## When to Use

Limit orders are ideal for:


- Ensuring maximum/minimum execution prices
- Providing liquidity to the market
- Implementing specific entry/exit price levels
- Trading with reduced fees (maker rebates on many venues)
- Large orders that need to avoid market impact
- Algorithmic trading strategies requiring exact price execution

## Example

A trader wants to buy 10 BTC at a maximum price of $50,000:

```rust
let limit_order = LimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id,
    client_order_id,
    OrderSide::Buy,
    Quantity::from(10.0),
    Price::from("50000.00"),  // Maximum purchase price
    TimeInForce::Gtc,  // Good until canceled
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

Unlike market orders, limit orders:


- **Price guarantee**: Never execute worse than the specified price
- **No execution guarantee**: May never fill if price doesn't reach limit
- **Time persistence**: Can remain in the order book for extended periods
- **Passive execution**: Provide liquidity to other traders
- **Post-only support**: Can be set to only provide liquidity (never take)
- **Display quantity**: Can show only portion of order (iceberg orders)

## Data Structure

```rust
pub struct LimitOrder {
    core: OrderCore,
    pub price: Price,                    // Limit price
    pub expire_time: Option<UnixNanos>,  // Expiration timestamp
    pub is_post_only: bool,              // Only provide liquidity
    pub display_qty: Option<Quantity>,   // Visible quantity in book
    pub trigger_instrument_id: Option<InstrumentId>,
}
```

The LimitOrder structure includes:

- **price**: The limit price - maximum for buys, minimum for sells
- **expire_time**: Optional expiration timestamp for GTD orders
- **is_post_only**: Flag to ensure order only provides liquidity
- **display_qty**: Visible portion for iceberg/hidden orders
- **trigger_instrument_id**: Optional instrument for conditional triggers

## Event Triggers

Limit orders are updated by these events:


- **OrderInitialized**: Order creation with price and quantity
- **OrderUpdated**: Price, quantity, or display quantity modifications
- **OrderFilled**: Partial or complete execution at limit price or better
- **OrderExpired**: Order canceled due to time expiration
- **OrderAccepted**: Venue acknowledgment and placement in order book

### Key Update Scenarios


- Price adjustments via `OrderUpdated` with new price
- Display quantity changes for iceberg orders
- Slippage calculation: always 0 or negative (favorable) for limit orders
- Multiple partial fills at the same or better prices
- Time-based expiration for GTD orders

### Slippage Calculation

For limit orders, slippage is calculated as:

```rust
// Always 0 or negative (favorable) for limit orders
fn apply(&mut self, event: OrderEventAny) -> Result<(), OrderError> {
    let is_order_filled = matches!(event, OrderEventAny::Filled(_));
    
    self.core.apply(event.clone())?;
    
    if is_order_filled {
        self.core.set_slippage(self.price);  // Favorable or no slippage
    }
    
    Ok(())
}
```

## Time-in-Force Options

Limit orders support all time-in-force types:


- **GTC (Good-Til-Cancel)**: Active until manually canceled
- **IOC (Immediate or Cancel)**: Fill immediately or cancel remainder
- **FOK (Fill or Kill)**: Must fill entire quantity or cancel completely
- **GTD (Good-Til-Date)**: Active until specified expiration time (requires expire_time)

### GTD Validation

```rust
// GTD requires expire_time to be set
check_time_in_force(time_in_force, expire_time)?;
```

## Advanced Features

### Post-Only Orders

Post-only limit orders never take liquidity and are rejected if they would:

```rust
// Post-only ensures order only provides liquidity
pub struct LimitOrder {
    pub is_post_only: bool,  // Only provide liquidity
}
```

Benefits:


- Maker rebates on many exchanges
- No taker fees
- Better execution price guarantees

### Display Quantity (Iceberg Orders)

Display only portion of order in the book:

```rust
// Show only 5 BTC of a 10 BTC order
let iceberg_order = LimitOrder::new(
    // ... other parameters
    display_qty: Some(Quantity::from("5.0")),  // Visible portion
);
```

Benefits:


- Hides true order size
- Reduces market impact
- Prevents other traders from seeing large order intent

### Hidden Orders

Set display_qty to 0 or None to hide order completely (if venue supports):

```rust
let hidden_order = LimitOrder::new(
    // ... other parameters
    display_qty: None,  // Hidden from order book
);
```

## Common Use Cases with Examples

### Price-Sensitive Entry

```rust
// Buy at specific support level
let support_buy = LimitOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("SUPPORT-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    Price::from("45000.00"),  // Support level
    TimeInForce::Gtc,
    None,  // No expiration
    false,  // Not post-only
    false,  // Not reduce-only
    false,  // Not quote quantity
    None,   // No display qty
    None,   // No emulation trigger
    None,   // No trigger instrument
    None,   // No contingency
    None,   // No order list
    None,   // No linked orders
    None,   // No parent order
    None,   // No exec algorithm
    None,   // No exec params
    None,   // No exec spawn
    None,   // No tags
    UUID4::new(),
    UnixNanos::now(),
);
```

### Post-Only Limit Order

```rust
// Post-only order to ensure maker rebate
let post_only_order = LimitOrder::new(
    // ... other parameters
    post_only: true,  // Only provide liquidity
);
```

### Time-Limited Order

```rust
// GTD order expiring at specific time
let gtd_order = LimitOrder::new(
    // ... other parameters
    TimeInForce::Gtd,
    Some(expiration_time),  // Must provide expire_time for GTD
);
```

## Advantages and Disadvantages

### Advantages


- **Price guarantee**: Never execute worse than specified price
- **Maker rebates**: Potential fee rebates on many exchanges
- **Market impact**: Can reduce impact by providing liquidity
- **Precision**: Exact entry/exit price control
- **Flexibility**: Multiple time-in-force options

### Disadvantages


- **No execution guarantee**: May never fill
- **Time consumption**: Can wait indefinitely for price
- **Priority**: Lower priority than market orders
- **Missed opportunities**: May miss favorable price movements while waiting

## Best Practices


- Use for price-sensitive trading strategies
- Consider post-only for fee optimization
- Use appropriate time-in-force for strategy needs
- Monitor order age and opportunity cost
- Combine with stop orders for complete strategies
- Use display quantity for large orders to reduce market impact

## Validation Rules

```rust
// Quantity must be positive
check_positive_quantity(quantity, stringify!(quantity))?;

// Display quantity cannot exceed total quantity
check_display_qty(display_qty, quantity)?;

// GTD requires expire_time
check_time_in_force(time_in_force, expire_time)?;
```

## Source Code Reference

Implementation details can be found in:

- [limit.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/limit.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create limit order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create limit order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if order has a price
fn has_price(&self) -> bool  // Always returns true for limit orders
```