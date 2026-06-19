# Market Order

Market orders provide immediate execution at current market prices when getting filled quickly is more important than price precision.

## When to Use

Market orders are ideal for:


- Entering or exiting positions quickly
- Trading highly liquid instruments where slippage is minimal
- Situations where getting filled takes precedence over execution price
- Emergency position closures
- High-frequency trading where microseconds matter

## Example

A trader wants to buy 10 BTC immediately at the current market price:

```rust
let market_order = MarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id,  // e.g., "BTC-USDT.BINANCE"
    client_order_id,
    OrderSide::Buy,
    Quantity::from(10.0),
    TimeInForce::Ioc,  // Immediate or Cancel
    init_id,
    ts_init,
    reduce_only,
    quote_quantity,
    contingency_type,
    order_list_id,
    linked_order_ids,
    parent_order_id,
    exec_algorithm_id,
    exec_algorithm_params,
    exec_spawn_id,
    tags,
);
```

## Differences from Other Order Types

Unlike limit orders, market orders:


- **No price guarantee**: May execute at worse prices than expected due to slippage
- **Immediate execution**: Fill as soon as possible, often within milliseconds
- **No time in persistence**: Typically IOC (Immediate or Cancel) or FOK (Fill or Kill)
- **Aggressive execution**: Always take liquidity from the order book
- **No post-only**: Cannot be set as post-only since they're always aggressive

## Data Structure

```rust
pub struct MarketOrder {
    core: OrderCore,              // Common order fields and state
    pub protection_price: Option<Price>,  // Optional price protection
}
```

The MarketOrder structure includes:

- **core**: Contains all common order fields like quantity, side, status, event history
- **protection_price**: Optional field for setting maximum acceptable slippage price

## Event Triggers

Market orders are updated by these events:


- **OrderInitialized**: Order creation with parameters
- **OrderUpdated**: Quantity or protection price modifications
- **OrderFilled**: Partial or complete execution
- **OrderRejected**: Venue rejection (insufficient liquidity, etc.)

### Key Update Scenarios


- Quantity changes via `OrderUpdated` event
- Protection price may be set for slippage control
- Slippage calculated when filled: `execution_price - expected_price` for buys
- Multiple fills possible for large orders across different price levels

### Slippage Calculation

For market orders, slippage is calculated as:

```rust
// Buy orders: execution_price - expected_price
// Sell orders: expected_price - execution_price
fn set_slippage(&mut self, price: Price) {
    self.slippage = self.avg_px.and_then(|avg_px| {
        let current_price = price.as_f64();
        match self.side {
            OrderSide::Buy if avg_px > current_price => Some(avg_px - current_price),
            OrderSide::Sell if avg_px < current_price => Some(current_price - avg_px),
            _ => None,
        }
    });
}
```

## Time-in-Force Constraints

Market orders have specific time-in-force restrictions:


- **GTD not supported**: Cannot use Good-Til-Date time-in-force with market orders
- **Typical usage**: IOC (Immediate or Cancel) or FOK (Fill or Kill)
- **Validation**: System will reject market orders with GTD time-in-force

## Common Use Cases with Examples

### Quick Position Entry

```rust
// Buy 1 BTC immediately at current market price
let buy_order = MarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("BTC-USDT.BINANCE"),
    ClientOrderId::from("BUY-001"),
    OrderSide::Buy,
    Quantity::from("1.0"),
    TimeInForce::Ioc,
    UUID4::new(),
    UnixNanos::now(),
    false,  // reduce_only
    false,  // quote_quantity
    None,   // contingency_type
    None,   // order_list_id
    None,   // linked_order_ids
    None,   // parent_order_id
    None,   // exec_algorithm_id
    None,   // exec_algorithm_params
    None,   // exec_spawn_id
    None,   // tags
);
```

### Emergency Position Exit

```rust
// Sell all position immediately due to market conditions
let emergency_sell = MarketOrder::new(
    trader_id,
    strategy_id,
    instrument_id!("ETH-USDT.BINANCE"),
    ClientOrderId::from("EMERGENCY-EXIT-001"),
    OrderSide::Sell,
    position.quantity,  // Exit entire position
    TimeInForce::Ioc,
    UUID4::new(),
    UnixNanos::now(),
    true,   // reduce_only
    false,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
);
```

## Advantages and Disadvantages

### Advantages


- **Speed**: Fastest execution method available
- **Certainty**: High probability of execution in liquid markets
- **Simplicity**: No need to specify price levels
- **Immediate**: No waiting for price to reach specific levels

### Disadvantages


- **Slippage**: May get worse prices than expected
- **No control**: Cannot guarantee maximum or minimum execution price
- **Market impact**: Large orders can move the market significantly
- **Unexpected fills**: May execute at very unfavorable prices in thin markets

## Best Practices


- Use for highly liquid instruments where slippage is minimal
- Avoid for large orders that could move the market
- Consider limit orders for price-sensitive trades
- Use protection price to cap maximum slippage when available
- Monitor fill prices for execution quality analysis

## Source Code Reference

Implementation details can be found in:

- [market.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/market.rs) - Main implementation
- [mod.rs](https://github.com/nautechsystems/nautilus_trader/blob/master/crates/model/src/orders/mod.rs) - Order trait and core functionality

Key methods:

```rust
// Create market order with validation
pub fn new_checked(...) -> Result<Self, OrderError>

// Create market order (panics on validation failure)
pub fn new(...) -> Self

// Update order fields
fn update(&mut self, event: &OrderUpdated)

// Check if order has a price
fn has_price(&self) -> bool  // Returns protection_price.is_some()
```