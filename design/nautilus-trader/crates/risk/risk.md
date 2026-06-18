# Risk Module Documentation

## Purpose

The `nautilus-risk` crate provides the core risk management machinery for the NautilusTrader trading engine. It serves as a pre-trade validation gateway that ensures all trading operations remain within defined risk parameters and regulatory constraints before orders are submitted to exchanges.

## Problem Statement

The risk module resolves several critical trading risk problems:

1. **Account Protection**: Preventing orders that would exceed account balances or margin requirements across cash, margin, and betting account types
2. **Order Validation**: Ensuring order parameters (price, quantity, notional values) comply with venue and instrument specifications
3. **Rate Limiting**: Controlling the frequency of order submissions and modifications to comply with exchange rate limits
4. **State Management**: Managing trading states (Active, Reducing, Halted) to dynamically control trading behavior based on market conditions
5. **Position Sizing**: Calculating appropriate position sizes based on fixed-risk parameters with commission and exchange rate support
6. **Exposure Control**: Tracking cumulative notional exposure and position-reducing orders to prevent over-leverage

## Technical Solutions

### 1. Pre-Trade Validation Pipeline

A multi-layered validation approach that checks orders before submission:

- Instrument existence and validity
- Price and quantity precision checks
- Notional value validation (min/max limits)
- Account balance/margin sufficiency
- Position-reducing order validation
- Reduce-only order verification

### 2. Rate Limiting Architecture

Uses throttler components with configurable rate limits:

- `Throttler<TradingCommand>` for order submissions
- `Throttler<ModifyOrder>` for order modifications
- Success/failure handlers for compliant and non-compliant commands
- Configurable intervals and limits per operation type

### 3. Trading State Machine

Three-state trading control system:

- **Active**: Normal trading operations allowed
- **Reducing**: Only position-reducing orders permitted
- **Halted**: All trading operations blocked

### 4. Message Bus Integration

Event-driven architecture using the message bus:

- Multiple endpoint registration for trading commands
- Order event subscription and processing
- Position event monitoring
- Re-entrancy-safe queued execution for event handlers

### 5. Fixed-Risk Position Sizing

Algorithm for calculating position sizes based on:

- Account equity and risk percentage
- Entry/stop-loss price difference
- Commission rates and exchange rates
- Unit batching and hard limits
- Instrument max quantity constraints

### 6. Multi-Account Risk Aggregation

Account-type-specific risk checks:

- **Cash accounts**: Balance sufficiency with optional borrowing
- **Margin accounts**: Initial margin requirement validation
- **Betting accounts**: Liability calculation and balance locking

### 7. Position Tracking

Real-time position monitoring for risk assessment:

- Net long/short quantity tracking
- Pending order quantity accounting
- Position-reducing order identification
- Base currency handling for sell orders

## File Tree

```
crates/risk/
├── Cargo.toml              # Package configuration and dependencies
├── README.md               # Package documentation
├── LICENSE                 # License file
├── src/
│   ├── lib.rs             # Module declarations and exports
│   ├── engine/
│   │   ├── mod.rs         # Core RiskEngine implementation (1978 lines)
│   │   └── config.rs      # RiskEngineConfig configuration
│   ├── sizing.rs          # Position sizing calculations (364 lines)
│   └── python/
│       ├── mod.rs         # Python module registration
│       └── config.rs      # Python bindings for RiskEngineConfig
└── tests/
    └── risk_engine.rs     # Risk engine tests
```

## Data Flow

### Order Submission Flow

```
Strategy/Command Source
        ↓
TradingCommand (SubmitOrder/SubmitOrderList/ModifyOrder)
        ↓
RiskEngine.execute()
        ↓
Message Bus → risk_engine_execute endpoint
        ↓
handle_command()
        ↓
┌─────────────────────────────────────┐
│ Order-specific handlers:            │
│ - handle_submit_order()             │
│ - handle_submit_order_list()        │
│ - handle_modify_order()             │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ Pre-trade validation pipeline:      │
│ 1. Instrument existence check       │
│ 2. Order validation (check_order)   │
│ 3. Risk validation (check_orders_risk) │
└─────────────────────────────────────┘
        ↓
execution_gateway()
        ↓
Trading State check (Active/Reducing/Halted)
        ↓
Throttler.send() → Rate limiting
        ↓
Success: Forward to Execution Engine
Failure: Create OrderDenied/ModifyRejected event
        ↓
Message Bus → exec_engine_process endpoint
        ↓
Strategy receives denial event
```

### Risk Check Flow

```
check_orders_risk_for_account()
        ↓
┌─────────────────────────────────────┐
│ Account retrieval & analysis:       │
│ - Account type determination        │
│ - Free balance calculation          │
│ - Borrowing permission check        │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ Position tracking:                  │
│ - Net long/short positions          │
│ - Pending order quantities          │
│ - Available position quantities     │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ Per-order risk checks:              │
│ 1. Price determination (market data)│
│ 2. Effective quantity calculation   │
│ 3. Notional value computation       │
│ 4. Min/max quantity validation      │
│ 5. Notional limit checks            │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ Account-type-specific checks:       │
│ Margin: Initial margin requirements │
│ Cash: Balance sufficiency           │
│ Betting: Liability calculation      │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ Cumulative exposure tracking:       │
│ - Cumulative notional by side       │
│ - Cumulative margin requirements    │
│ - Position-reducing order tracking  │
└─────────────────────────────────────┘
        ↓
Pass/Fail determination
```

## Logic Flow

### 1. RiskEngine Initialization

```rust
RiskEngine::new()
    ├── Create submit throttler (Throttler<TradingCommand>)
    │   ├── Success handler: Forward to exec_engine_queue_execute
    │   └── Failure handler: Create OrderDenied events
    ├── Create modify throttler (Throttler<ModifyOrder>)
    │   ├── Success handler: Forward ModifyOrder to execution
    │   └── Failure handler: Create OrderModifyRejected events
    ├── Initialize trading state to Active
    ├── Load max_notional_per_order settings
    └── Register message bus handlers
        ├── risk_engine_execute endpoint
        ├── risk_engine_queue_execute endpoint (re-entrancy safe)
        ├── Order event subscriptions
        └── Position event subscriptions
```

### 2. Order Validation Logic

#### Single Order Submission
```rust
handle_submit_order()
    ├── Check bypass flag
    ├── Retrieve order from cache
    ├── Verify instrument exists
    ├── Validate order parameters:
    │   ├── check_order() 
    │   │   ├── check_order_price() - price and trigger_price precision
    │   │   ├── check_order_quantity() - quantity precision
    │   │   └── GTD order expiration validation
    │   └── check_orders_risk() - comprehensive risk checks
    └── Route to execution_gateway()
```

#### Order List Submission
```rust
handle_submit_order_list()
    ├── Check bypass flag
    ├── Retrieve all orders from cache
    ├── Validate list completeness
    ├── Collect instruments for all orders
    ├── Validate each order individually (check_order)
    ├── Validate cumulative risk (check_orders_risk)
    └── Route to execution_gateway()
```

#### Order Modification
```rust
handle_modify_order()
    ├── Check bypass flag
    ├── Retrieve existing order from cache
    ├── Validate order state (not closed, not pending_cancel)
    ├── Verify instrument exists
    ├── Validate new price (check_price)
    ├── Validate new trigger price (check_price)
    ├── Validate new quantity (check_quantity)
    ├── Check trading state compatibility
    └── Route to throttled_modify_order
```

### 3. Risk Check Logic

#### Price Validation
```rust
check_price(instrument, price)
    ├── Check if price exists
    ├── Validate precision ≤ instrument.price_precision()
    ├── Validate price > 0 (unless negative prices allowed)
    └── Return None if valid, error message if invalid
```

#### Quantity Validation
```rust
check_quantity(instrument, quantity, is_quote_quantity)
    ├── Check if quantity exists
    ├── Validate precision ≤ instrument.size_precision()
    ├── Skip min/max for quote quantities
    ├── Validate quantity ≤ max_quantity
    ├── Validate quantity ≥ min_quantity
    └── Return None if valid, error message if invalid
```

#### Comprehensive Risk Validation
```rust
check_orders_risk_for_account(instrument, orders, account_id)
    ├── Initialize tracking variables
    ├── Resolve account (explicit or venue-based)
    ├── Determine account type (Margin/Cash/Betting)
    ├── Calculate free balance
    ├── Track positions and pending orders
    │   ├── Net long quantity
    │   ├── Net short quantity
    │   ├── Pending sell quantity
    │   └── Pending buy quantity
    ├── Process each order:
    │   ├── Determine execution price (market data or order price)
    │   ├── Calculate effective quantity
    │   ├── Validate min/max quantity
    │   ├── Calculate notional value
    │   ├── Check max_notional_per_order
    │   ├── Check instrument min/max notional
    │   ├── Account-type-specific checks:
    │   │   ├── Margin: Initial margin requirements
    │   │   ├── Cash: Balance sufficiency
    │   │   └── Betting: Liability calculation
    │   ├── Track cumulative exposure
    │   └── Identify position-reducing orders
    └── Return true if all checks pass
```

### 4. Trading State Logic

```rust
execution_gateway(instrument, command)
    ├── Match on trading_state:
    │   ├── Halted:
    │   │   ├── Deny all SubmitOrder commands
    │   │   ├── Deny all SubmitOrderList commands
    │   │   └── Log TradingHalted reason
    │   ├── Reducing:
    │   │   ├── Allow position-reducing orders
    │   │   ├── Deny position-opening orders
    │   │   └── Route to throttler if allowed
    │   └── Active:
    │       ├── Route SubmitOrder to throttler
    │       ├── Route SubmitOrderList to throttler
    │       └── Process other commands
```

### 5. Position Sizing Logic

```rust
calculate_fixed_risk_position_size()
    ├── Validate exchange rate > 0
    ├── Calculate risk_ticks: |entry - stop_loss| / price_increment
    ├── Calculate riskable_money: (equity * risk) - (commission * 2)
    ├── Calculate base position size: riskable_money / (risk_ticks * price_increment)
    ├── Apply hard limit if specified
    ├── Divide by number of units
    ├── Apply unit batching if specified
    ├── Respect instrument max_quantity
    └── Convert to Quantity with proper precision
```

### 6. Message Bus Handler Registration

```rust
register_msgbus_handlers()
    ├── risk_engine_execute endpoint
    │   └── Direct command execution (fast path)
    ├── risk_engine_queue_execute endpoint
    │   ├── Check for TradingCommandSender
    │   ├── Queue for next iteration (live mode)
    │   └── Fall back to direct execution (test mode)
    ├── Order event subscription
    │   └── Process order events for monitoring
    └── Position event subscription
        └── Process position events for monitoring
```

### 7. Denial/Rejection Logic

```rust
deny_order(order, reason)
    ├── Log denial with client_order_id and reason
    ├── Check order status is Initialized
    ├── Add order to cache if not present
    ├── Create OrderDenied event
    │   ├── Include trader_id, strategy_id
    │   ├── Include instrument_id, client_order_id
    │   ├── Include denial reason
    │   └── Timestamp with current time
    └── Send to exec_engine_process endpoint

reject_modify_order(order, reason)
    ├── Create OrderModifyRejected event
    │   ├── Include order identification
    │   ├── Include rejection reason
    │   ├── Include venue_order_id
    │   └── Timestamp with current time
    └── Send to exec_engine_process endpoint
```

## Key Components

### RiskEngine
Central risk management orchestrator with:
- Message bus integration for command/event handling
- Dual throttlers for rate limiting
- Trading state management
- Account and portfolio references
- Configurable risk parameters

### RiskEngineConfig
Configuration structure with:
- `bypass`: Disable all risk checks
- `max_order_submit`: Rate limit for order submissions
- `max_order_modify`: Rate limit for order modifications
- `max_notional_per_order`: Per-instrument notional limits
- `debug`: Enable debug logging

### Position Sizing
Fixed-risk position calculation with:
- Equity-based risk percentage
- Commission and exchange rate adjustment
- Unit batching for position scaling
- Hard limit enforcement

## Integration Points

### Dependencies
- `nautilus-common`: Cache, Clock, Throttler, Message bus
- `nautilus-model`: Data types (Order, Account, Instrument)
- `nautilus-execution`: Trailing stop calculations
- `nautilus-portfolio`: Portfolio state management

### Message Bus Endpoints
- Input: `risk_engine_execute`, `risk_engine_queue_execute`
- Output: `exec_engine_queue_execute`, `exec_engine_process`
- Subscriptions: `events.order.*`, `events.position.*`

## Testing
The module includes comprehensive tests for:
- Position sizing calculations (sizing.rs)
- Risk engine operations (risk_engine.rs)
- Edge cases (zero equity, zero exchange rate, excessive risk)

## Python Bindings
Full PyO3 integration for:
- Configuration object creation
- Property getters/setters
- String representation methods
- Type-safe parameter parsing