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
- **OrderPendingUpdate** - Order modification request in progress
- **OrderPendingCancel** - Order cancellation request in progress
- **OrderModifyRejected** - Order modification rejected by venue
- **OrderCancelRejected** - Order cancellation rejected by venue
- **OrderEmulated** - Order is being emulated locally (trigger conditions not yet met)
- **OrderReleased** - Emulated order released for submission to venue

## State-Event Matrix

The following table shows which events can transition from which states, what data is affected, and why:

| Current State | Event | Next State | Data Affected | Why |
|---------------|-------|------------|---------------|-----|
| **INITIALIZED** | Denied | DENIED | `ts_closed` | Local validation or risk check failed before submission |
| **INITIALIZED** | Emulated | EMULATED | `emulation_trigger` | Order is held locally until trigger conditions are met |
| **INITIALIZED** | Released | RELEASED | `emulation_trigger` | Emulated order conditions satisfied, ready for venue submission |
| **INITIALIZED** | Submitted | SUBMITTED | `account_id`, `ts_submitted` | Order transmitted to venue for execution |
| **INITIALIZED** | Rejected | REJECTED | `ts_closed` | External order rejected immediately (e.g., API error) |
| **INITIALIZED** | Accepted | ACCEPTED | `venue_order_id`, `account_id`, `ts_accepted` | External order accepted immediately (rare) |
| **INITIALIZED** | Canceled | CANCELED | `ts_closed` | External order canceled before acknowledgment (rare) |
| **INITIALIZED** | Expired | EXPIRED | `ts_closed` | External order expired before acknowledgment (rare) |
| **INITIALIZED** | Triggered | TRIGGERED | None | External stop order triggered immediately (rare) |
| **INITIALIZED** | Updated | INITIALIZED | Various order fields | In-place modification of order parameters before submission |
| **EMULATED** | Canceled | CANCELED | `ts_closed` | User canceled emulated order before trigger |
| **EMULATED** | Expired | EXPIRED | `ts_closed` | Emulated order reached expiration time |
| **EMULATED** | Released | RELEASED | `emulation_trigger` | Trigger conditions satisfied, order released |
| **RELEASED** | Submitted | SUBMITTED | `account_id`, `ts_submitted` | Released order submitted to venue |
| **RELEASED** | Denied | DENIED | `ts_closed` | Validation failed after release |
| **RELEASED** | Canceled | CANCELED | `ts_closed` | Execution algorithm canceled released order |
| **RELEASED** | Updated | RELEASED | Various order fields | In-place modification of released order parameters |
| **SUBMITTED** | PendingUpdate | PENDING_UPDATE | `previous_status` | Modification request sent to venue, awaiting acknowledgment |
| **SUBMITTED** | PendingCancel | PENDING_CANCEL | `previous_status` | Cancellation request sent to venue, awaiting acknowledgment |
| **SUBMITTED** | Rejected | REJECTED | `ts_closed` | Venue rejected the order (invalid params, insufficient funds) |
| **SUBMITTED** | Canceled | CANCELED | `ts_closed` | FOK/IOC order canceled by venue if not filled (AutoCancel) |
| **SUBMITTED** | Accepted | ACCEPTED | `venue_order_id`, `account_id`, `ts_accepted` | Venue acknowledged the order |
| **SUBMITTED** | Updated | SUBMITTED | Various order fields | Modification confirmed (instant update) |
| **SUBMITTED** | Filled | FILLED | All fill data | Order filled immediately (common for market orders) |
| **ACCEPTED** | Rejected | REJECTED | `ts_closed` | StopLimit order rejected after acceptance (e.g., trigger invalid) |
| **ACCEPTED** | PendingUpdate | PENDING_UPDATE | `previous_status` | Modification request sent to venue |
| **ACCEPTED** | PendingCancel | PENDING_CANCEL | `previous_status` | Cancellation request sent to venue |
| **ACCEPTED** | Canceled | CANCELED | `ts_closed` | Order canceled by user or system |
| **ACCEPTED** | Triggered | TRIGGERED | None | Stop/trigger order activated |
| **ACCEPTED** | Updated | ACCEPTED | Various order fields | Order parameters modified successfully |
| **ACCEPTED** | Expired | EXPIRED | `ts_closed` | Order reached expiration time |
| **ACCEPTED** | Filled | FILLED | All fill data | Order fully or partially executed |
| **CANCELED** | Filled | FILLED | All fill data | Fill occurred after cancellation (race condition) |
| **PENDING_UPDATE** | Rejected | REJECTED | `ts_closed` | Modification rejected by venue |
| **PENDING_UPDATE** | Accepted | ACCEPTED | `venue_order_id`, `account_id`, `ts_accepted` | Order accepted while pending update (rare) |
| **PENDING_UPDATE** | Canceled | CANCELED | `ts_closed` | Order canceled while pending update |
| **PENDING_UPDATE** | Expired | EXPIRED | `ts_closed` | Order expired while pending update |
| **PENDING_UPDATE** | Triggered | TRIGGERED | None | Stop order triggered while pending update |
| **PENDING_UPDATE** | PendingUpdate | PENDING_UPDATE | None | Multiple modification requests queued |
| **PENDING_UPDATE** | PendingCancel | PENDING_CANCEL | `previous_status` | Cancellation request sent while update pending |
| **PENDING_UPDATE** | ModifyRejected | PENDING_UPDATE | `status` (restored to previous) | Venue rejected modification, order returned to previous state |
| **PENDING_UPDATE** | Updated | PENDING_UPDATE | Various order fields | Modification confirmed, state remains pending |
| **PENDING_UPDATE** | Filled | FILLED | All fill data | Order filled while pending update |
| **PENDING_CANCEL** | Rejected | REJECTED | `ts_closed` | Cancellation rejected by venue, order still active |
| **PENDING_CANCEL** | PendingCancel | PENDING_CANCEL | None | Multiple cancellation requests queued |
| **PENDING_CANCEL** | CancelRejected | PENDING_CANCEL | `status` (restored to previous) | Venue rejected cancellation, order returned to previous state |
| **PENDING_CANCEL** | Canceled | CANCELED | `ts_closed` | Cancellation confirmed by venue |
| **PENDING_CANCEL** | Expired | EXPIRED | `ts_closed` | Order expired while pending cancel |
| **PENDING_CANCEL** | Accepted | ACCEPTED | None | Order accepted while pending cancel (failed cancel) |
| **PENDING_CANCEL** | Filled | FILLED | All fill data | Order filled while pending cancel (failed cancel) |
| **TRIGGERED** | Rejected | REJECTED | `ts_closed` | Triggered order rejected by venue |
| **TRIGGERED** | PendingUpdate | PENDING_UPDATE | `previous_status` | Modification request sent after trigger |
| **TRIGGERED** | PendingCancel | PENDING_CANCEL | `previous_status` | Cancellation request sent after trigger |
| **TRIGGERED** | Canceled | CANCELED | `ts_closed` | Triggered order canceled |
| **TRIGGERED** | Expired | EXPIRED | `ts_closed` | Triggered order expired |
| **TRIGGERED** | Filled | FILLED | All fill data | Triggered order executed |
| **TRIGGERED** | Updated | TRIGGERED | Various order fields | Triggered order parameters modified |
| **PARTIALLY_FILLED** | PendingUpdate | PENDING_UPDATE | `previous_status` | Modification request sent |
| **PARTIALLY_FILLED** | PendingCancel | PENDING_CANCEL | `previous_status` | Cancellation request sent |
| **PARTIALLY_FILLED** | Canceled | CANCELED | `ts_closed` | Remaining quantity canceled |
| **PARTIALLY_FILLED** | Expired | EXPIRED | `ts_closed` | Order expired with partial fills |
| **PARTIALLY_FILLED** | Filled | FILLED | All fill data | Final fill completed the order |
| **PARTIALLY_FILLED** | Accepted | ACCEPTED | None | Venue re-acknowledged order (rare) |
| **PARTIALLY_FILLED** | Updated | PARTIALLY_FILLED | Various order fields | Order parameters modified |

## Data Affected by Fill Events

The **OrderFilled** event is particularly important as it affects multiple data fields:

| Data Field | Affected | Why |
|------------|----------|-----|
| `filled_qty` | Increased by `last_qty` | Tracks cumulative executed quantity |
| `leaves_qty` | Decreased by `last_qty` | Tracks remaining quantity to be executed |
| `overfill_qty` | Increased if fill exceeds order quantity | Detects and tracks execution errors |
| `venue_order_id` | Set to fill's `venue_order_id` | Associates venue's order identifier |
| `position_id` | Set to fill's `position_id` | Links order to position |
| `trade_ids` | Appended with fill's `trade_id` | Records all trade executions |
| `last_trade_id` | Set to fill's `trade_id` | Tracks most recent trade |
| `liquidity_side` | Set to fill's `liquidity_side` | Records if order took or provided liquidity |
| `avg_px` | Recalculated as weighted average | Tracks average execution price |
| `commissions` | Accumulated by currency | Records trading fees and costs |
| `ts_accepted` | Set on first fill if not previously set | Records venue acknowledgment time |
| `ts_last` | Set to fill's `ts_event` | Records most recent activity |
| `ts_closed` | Set when order fully filled | Records order completion time |
| `status` | Updated to PARTIALLY_FILLED or FILLED | Reflects order state after fill |

## Key Design Principles

### Previous State Preservation

The system carefully preserves `previous_status` to enable proper recovery from failed operations:
- When entering `PENDING_UPDATE` or `PENDING_CANCEL`, the pre-pending status is saved
- This allows restoration to the correct state if the operation is rejected
- The previous status is NOT overwritten when already in a pending state (handles multiple concurrent requests)

### Duplicate Detection

Duplicate fills are detected and rejected to prevent data corruption:
- Checks are performed before state transition to maintain consistency
- Detection uses `trade_id`, `order_side`, `last_qty`, and `last_px` for matching
- This prevents double-counting of executions from venue retransmissions

### State Machine Invariants

The state machine enforces several invariants:
- `filled_qty + leaves_qty >= quantity` (may exceed due to overfill)
- All fills must have valid `venue_order_id`, `last_trade_id`, and `trade_ids`
- Status must be PARTIALLY_FILLED or FILLED after any fill
- Venue order IDs are tracked throughout the order's lifecycle (can change on modification)

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