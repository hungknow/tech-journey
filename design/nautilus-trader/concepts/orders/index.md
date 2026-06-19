# Orders

Orders are fundamental trading instructions that represent an investor's intent to buy or sell financial instruments. In Nautilus Trader, orders are modeled as comprehensive domain objects that track their entire lifecycle from initialization through execution or cancellation.

## Purpose

The order system in Nautilus Trader provides:

- Type-safe order representations for various trading strategies
- Complete order lifecycle tracking with event sourcing
- Support for complex order types including stop orders and conditional triggers
- Flexible execution parameters like time-in-force, display quantity, and post-only options
- Integration with venue-specific order management

## Order Types

Nautilus Trader supports the following order types:

- [Market Order](./market-order.md) - Immediate execution at current market prices
- [Limit Order](./limit-order.md) - Price-constrained orders with guaranteed maximum/minimum execution price
- [Stop Market Order](./stop-market-order.md) - Market orders that trigger when price reaches a stop level
- [Stop Limit Order](./stop-limit-order.md) - Limit orders that trigger when price reaches a stop level
- [Limit If Touched Order](./limit-if-touched-order.md) - Limit orders activated when price touches a trigger level
- [Market If Touched Order](./market-if-touched-order.md) - Market orders activated when price touches a trigger level
- [Market To Limit Order](./market-to-limit-order.md) - Market orders that become limit orders if unfilled
- [Trailing Stop Market Order](./trailing-stop-market-order.md) - Dynamic stop orders that trail favorable price movements
- [Trailing Stop Limit Order](./trailing-stop-limit-order.md) - Dynamic stop limit orders that trail favorable price movements

## Common Use Cases

Orders enable various trading strategies and risk management approaches:

- **Immediate Execution**: Market orders for quick entry/exit when price precision is less critical than execution speed
- **Price Control**: Limit orders to ensure execution at favorable prices or better
- **Risk Management**: Stop orders to limit potential losses by exiting positions at predetermined levels
- **Breakout Trading**: Stop orders to enter positions when prices break through key levels
- **Profit Protection**: Trailing stop orders to lock in gains while allowing positions to run
- **Conditional Entry**: If-touched orders to enter positions only when specific price conditions are met
- **Liquidity Management**: Display quantity orders to show only a portion of large orders
- **Time Management**: Time-in-force orders to control order duration and expiration

## Order Events and State Transitions

Orders progress through various states based on events received from the trading venue:

- **OrderInitialized** - Initial order creation and validation
- **OrderSubmitted** - Order sent to the venue for execution
- **OrderAccepted** - Venue acknowledges the order
- **OrderRejected** - Venue rejects the order (invalid parameters, insufficient funds, etc.)
- **OrderFilled** - Order fully or partially executed
- **OrderCanceled** - Order canceled by user or system
- **OrderExpired** - Order reached expiration time
- **OrderTriggered** - Stop/trigger orders activated
- **OrderUpdated** - Order parameters modified
- **OrderDenied** - Order denied by risk engine or validation logic

## Order Lifecycle Management

Nautilus Trader orders follow a deterministic state machine with event sourcing. Each order maintains:

1. **Event History**: Complete record of all events applied to the order
2. **State Tracking**: Current status and previous status for state recovery
3. **Validation**: In-order checks to ensure valid state transitions
4. **Slippage Calculation**: Automatic slippage tracking for execution analysis
5. **Commission Tracking**: Per-currency commission accumulation

### Common Order States

- **INITIALIZED**: Order created but not yet submitted
- **SUBMITTED**: Order sent to venue, awaiting acknowledgment
- **ACCEPTED**: Order acknowledged and active on venue
- **TRIGGERED**: Stop/trigger orders activated
- **PARTIALLY_FILLED**: Order partially executed
- **FILLED**: Order completely executed
- **CANCELED**: Order canceled by user or system
- **EXPIRED**: Order reached expiration time
- **REJECTED**: Order rejected by venue or risk engine
- **DENIED**: Order denied by validation logic

### State Validation

The order system ensures valid state transitions through the `OrderStatus::transition()` method, preventing invalid state changes and maintaining order lifecycle integrity.