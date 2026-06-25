# AccountsManager - Business Domain and Technical Documentation

## Business Domain

The `AccountsManager` serves as the central financial accounting engine for the NautilusTrader algorithmic trading system. It resolves the fundamental business requirement of **real-time portfolio and account state management** across multiple trading operations and account types.

### Core Business Problems Addressed

1. **Account Balance Synchronization**: Maintains accurate account balances in response to trading activity (order fills, commissions, PnL) across different account models.

2. **Risk Management**: Calculates and tracks margin requirements (initial and maintenance) for leveraged trading to ensure adequate capital coverage and prevent liquidation risk.

3. **Multi-Currency Support**: Handles trading across different currencies with automatic conversion and balance tracking in multiple currencies.

4. **Position Management**: Maintains accurate position states and calculates net exposure for margin calculation purposes.

5. **Capital Allocation**: Tracks locked balances for open orders, ensuring available capital is properly allocated and preventing oversubscription.

### Supported Account Types

- **Cash Accounts**: Standard cash-based trading where full payment is required upfront
- **Margin Accounts**: Leveraged trading with initial and maintenance margin requirements
- **Betting Accounts**: Specialized accounts for betting exchanges with liability calculations

## Technical Architecture

### Problem-Driven Technical Design

#### Problem 1: Real-time State Consistency Across Concurrent Operations

**Challenge**: Account balances can be updated from multiple sources (fills, order changes, position updates) simultaneously, risking inconsistent financial state.

**Solution: Immutable State Events with Explicit Transitions**

```rust
pub fn update_balances(...) -> (AccountAny, AccountState)
pub fn update_orders(...) -> Option<(AccountAny, AccountState)>
pub fn update_positions(...) -> Option<(MarginAccount, AccountState)>
```

- Each operation returns an immutable `AccountState` event containing complete account snapshot
- States include timestamps and UUIDs for chronological ordering
- Provides audit trail and enables event-sourcing reconstruction
- Prevents race conditions by making state transitions explicit and atomic

#### Problem 2: Multi-Currency Trading with Real-Time Conversion

**Challenge**: Trading instruments denominated in different currencies while maintaining account balances in base currency requires accurate, real-time exchange rate conversion.

**Solution: Cached Exchange Rate Lookup with Venue Context**

```rust
fn calculate_xrate_to_base(
    &self,
    base_currency: Option<Currency>,
    instrument: &InstrumentAny,
    side: OrderSide,
) -> Option<Decimal>
```

- Retrieves exchange rates from centralized cache with venue-specific pricing
- Uses Bid rates for buy orders (converting base to settlement currency)
- Uses Ask rates for sell orders (converting settlement to base currency)
- Returns `Option<Decimal>` to handle missing data gracefully
- Converts PnL, commissions, and margin calculations to base currency

#### Problem 3: Accurate Margin Calculation with Complex Position Hedging

**Challenge**: Multiple positions on same instrument can hedge each other; margin should be calculated on net exposure, not sum of individual positions. Also need to handle partial closes and position reversals correctly.

**Solution: Net Position Folding Algorithm with Chronological Ordering**

```rust
let legs: Vec<(Decimal, Decimal, u64)> = ordered
    .iter()
    .map(|p| (
        p.signed_decimal_qty(),
        Decimal::try_from(p.avg_px_open).unwrap_or(Decimal::ZERO),
        p.ts_opened.as_u64(),
    ))
    .collect();

let (net_signed_qty, net_avg_px) = fold_net_position(&legs);
```

- **Deterministic ordering**: Positions sorted by `(ts_opened, position_id)` ensures consistent results
- **Net exposure calculation**: All position legs folded into single net position
- **Reversal handling**: Maintains correct entry price when position flips (e.g., long → short)
- **Dust clearing**: Zero or sub-precision net quantities clear margin requirements
- **Floating edge cases**: Handles same-timestamp reversals with position ID tie-breaker

#### Problem 4: Diverse Account Type Requirements

**Challenge**: Cash accounts require full balance locking, margin accounts need initial/maintenance tracking, and betting accounts use liability calculations. Each requires different balance update logic.

**Solution: Enum-Based Polymorphism with Type-Specific Branches**

```rust
match account {
    AccountAny::Margin(margin_account) => { /* margin-specific logic */ }
    AccountAny::Cash(cash_account) => { /* cash-specific logic */ }
    AccountAny::Betting(betting_account) => { /* betting-specific logic */ }
}
```

- **Dispatch pattern**: Enum enables type-safe branching without runtime casting
- **Account-specific behavior**: Each branch implements appropriate margin/balance logic
- **Shared interface**: All account types implement `Account` trait for common operations
- **Extensibility**: New account types can be added without changing existing logic

#### Problem 5: Financial Precision for Large Value Calculations

**Challenge**: Floating-point arithmetic causes rounding errors that compound over many transactions, especially with large values (e.g., 100M USDT).

**Solution: Decimal-Based Arithmetic Throughout**

```rust
use rust_decimal::Decimal;

let new_total = balance.total.as_decimal() + pnl.as_decimal();
let margin_maint = Money::from_decimal(total_margin_maint, currency)?;
```

- **Exact arithmetic**: Decimal type provides fixed-point precision for financial calculations
- **Large value handling**: Supports values beyond f64 exact integer range (2^53)
- **Invariant preservation**: Ensures `total == locked + free` always holds
- **Instrument precision**: Respects price and size precision from instrument definitions

#### Problem 6: Balance Allocation and Capital Prevention

**Challenge**: Multiple open orders could potentially oversubscribe available capital if not properly tracked and locked.

**Solution: Per-Instrument Balance Locking with Aggregation**

```rust
for order in orders_open {
    let locked = account.calculate_balance_locked(
        instrument,
        order.order_side(),
        order.quantity(),
        price?,
        None,
    ).unwrap();

    total_locked
        .entry(locked.currency)
        .and_modify(|total| *total = *total + locked)
        .or_insert(locked);
}
```

- **Per-order calculation**: Each open order contributes its locked amount
- **Currency aggregation**: Groups locks by currency for efficient tracking
- **Reduce-only exclusion**: Orders that only close positions don't lock capital
- **Dynamic updates**: Locks recalculated when order state changes
- **Stale entry clearing**: Old currency entries removed before applying new locks

#### Problem 7: Position Identification for PnL Calculation

**Challenge**: Order fills may or may not include position ID; when missing, need to determine which position the fill belongs to.

**Solution: Fallback Position Lookup from Cache**

```rust
let position_id = if let Some(position_id) = fill.position_id {
    position_id
} else {
    let cache = self.cache.borrow();
    let positions_open = cache.positions_open(
        None,
        Some(&fill.instrument_id),
        None,
        Some(&fill.account_id),
        None,
    );
    positions_open
        .first()
        .unwrap_or_else(|| panic!("List of Positions is empty"))
        .id
};
```

- **Explicit ID priority**: Uses position ID from fill if provided
- **Fallback lookup**: Queries open positions by instrument and account
- **Validation**: Panics if no position found (indicates data inconsistency)
- **Position retrieval**: Fetches complete position data for PnL calculation

#### Problem 8: Shared State Access Across Components

**Challenge**: Multiple trading components need access to clock and cache data while maintaining thread safety and preventing data races.

**Solution: Rc<RefCell<>> Pattern for Shared Mutable State**

```rust
pub struct AccountsManager {
    clock: Rc<RefCell<dyn Clock>>,
    cache: Rc<RefCell<Cache>>,
}
```

- **Shared ownership**: `Rc` allows multiple references to same clock/cache
- **Interior mutability**: `RefCell` enables borrowing rules at runtime
- **Single-threaded safety**: Ensures no concurrent access violations
- **Centralized data**: Single source of truth for positions, instruments, rates

#### Problem 9: Instrument-Specific Margin Requirements

**Challenge**: Different instrument types (equities, futures, options, crypto) have vastly different margin calculation formulas and risk parameters.

**Solution: Pattern Matching on Instrument Type**

```rust
let margin_maint = match instrument {
    InstrumentAny::Betting(i) => account.calculate_maintenance_margin(i, quantity, price, None)?,
    InstrumentAny::BinaryOption(i) => account.calculate_maintenance_margin(i, quantity, price, None)?,
    InstrumentAny::CryptoFuture(i) => account.calculate_maintenance_margin(i, quantity, price, None)?,
    // ... (14 more instrument types)
};
```

- **Type-specific models**: Each instrument type implements appropriate margin formula
- **Flexible parameters**: Supports different leverage, notional values, volatility
- **Extensible design**: New instrument types added by adding new match arm
- **Error propagation**: Returns `Option<Money>` for failed calculations

#### Problem 10: Commission Handling with Currency Conversion

**Challenge**: Commissions may be denominated in different currencies from PnL, requiring conversion before balance deduction. Also handles negative commissions (rebates).

**Solution: Conditional Currency Conversion for Commissions**

```rust
if let Some(ref mut comm) = commission && comm.currency != base_currency {
    let xrate = self.cache.borrow().get_xrate(
        fill.instrument_id.venue,
        comm.currency,
        base_currency,
        if fill.order_side == OrderSide::Sell {
            PriceType::Bid
        } else {
            PriceType::Ask
        },
    );

    if let Some(xrate) = xrate {
        *comm = Money::from_decimal(comm.as_decimal() * xrate, base_currency)?;
    }
}

pnl = pnl - comm;
```

- **Currency check**: Only converts if commission currency differs from base
- **Side-appropriate rate**: Uses Bid for sells, Ask for buys
- **Graceful failure**: Returns unchanged if conversion unavailable
- **Negative handling**: Supports commission rebates (negative values)
- **Deduction from PnL**: Applied after PnL calculation

### Key Data Structures Supporting Technical Solutions

#### AccountsManager

```rust
pub struct AccountsManager {
    clock: Rc<RefCell<dyn Clock>>,
    cache: Rc<RefCell<Cache>>,
}
```

**Problem solved**: Provides shared access to timekeeping and data storage across account operations.

**Design rationale**:
- `Rc<RefCell<dyn Clock>>`: Shared, mutable access to timestamp generation for state events
- `Rc<RefCell<Cache>>`: Centralized lookup for positions, instruments, and exchange rates
- Enables real-time data retrieval without duplicating state

#### AccountAny Enum

```rust
pub enum AccountAny {
    Margin(MarginAccount),
    Cash(CashAccount),
    Betting(BettingAccount),
}
```

**Problem solved**: Handles diverse account type requirements with type-safe dispatch.

**Design rationale**:
- Enum pattern ensures exhaustive handling of all account types
- Each variant holds specific account state and margin/balance logic
- Enables compile-time safety when accessing account-specific operations

#### MarginBalance Structure

```rust
pub struct MarginBalance {
    pub initial: Money,
    pub maintenance: Money,
    pub instrument_id: Option<InstrumentId>,
}
```

**Problem solved**: Tracks margin requirements at both instrument and account levels.

**Design rationale**:
- `instrument_id: None` represents account-wide margin requirements
- `instrument_id: Some(...)` represents per-instrument margin requirements
- Maintains both initial (order-based) and maintenance (position-based) margins

#### AccountState Event

```rust
pub struct AccountState {
    pub account_id: AccountId,
    pub account_type: AccountType,
    pub balances: Vec<AccountBalance>,
    pub margins: Vec<MarginBalance>,
    pub balances_free: bool,
    pub uuid: UUID4,
    pub ts_event: UnixNanos,
    pub ts_init: UnixNanos,
    pub base_currency: Option<Currency>,
}
```

**Problem solved**: Provides immutable snapshots of account state for audit trail and event sourcing.

**Design rationale**:
- `balances`: Complete balance state across all currencies
- `margins`: Combined per-instrument and account-wide margin requirements
- `ts_event`: Actual event time for chronological ordering
- `ts_init`: Event generation time for latency measurement
- `uuid`: Unique identifier for event deduplication

#### Position Leg Representation

```rust
let legs: Vec<(Decimal, Decimal, u64)> = positions
    .iter()
    .map(|p| (
        p.signed_decimal_qty(),      // Signed quantity (positive for long, negative for short)
        Decimal::try_from(p.avg_px_open).unwrap_or(Decimal::ZERO),  // Entry price
        p.ts_opened.as_u64(),        // Open timestamp
    ))
    .collect();
```

**Problem solved**: Enables accurate net position calculation with reversal handling.

**Design rationale**:
- Signed quantities allow direct addition/subtraction for netting
- Timestamp ensures chronological processing for deterministic reversal pricing
- Decimal precision prevents floating-point errors in large quantity calculations
- Tuple structure provides efficient iteration for folding algorithm

#### Balance Locked Aggregation

```rust
let mut total_locked: AHashMap<Currency, Money> = AHashMap::new();
```

**Problem solved**: Efficiently aggregates locked balances across multiple orders and currencies.

**Design rationale**:
- `AHashMap` from `ahash` crate provides high-performance hash-based lookup
- Currency as key enables per-currency balance tracking
- Aggregation prevents double-counting of locked amounts
- Supports multi-currency balance locking in single pass

#### Money Type

```rust
pub struct Money {
    pub raw: i64,
    pub currency: Currency,
}
```

**Problem solved**: Provides precise financial calculations with currency tracking.

**Design rationale**:
- Fixed-point representation via raw integer prevents floating-point errors
- Currency field ensures monetary operations preserve currency identity
- Handles large values beyond f64 precision (e.g., 100M USDT)
- Enables invariant preservation: `total == locked + free`

#### OrderFilled Event

```rust
pub struct OrderFilled {
    pub instrument_id: InstrumentId,
    pub account_id: AccountId,
    pub order_side: OrderSide,
    pub last_qty: Quantity,
    pub last_px: Price,
    pub commission: Option<Money>,
    pub position_id: Option<PositionId>,
    pub ts_event: UnixNanos,
    // ... other fields
}
```

**Problem solved**: Captures all information needed for balance updates and PnL calculation.

**Design rationale**:
- `commission: Option<Money>` handles cases with no commission
- `position_id: Option<PositionId>` allows fallback position lookup
- `order_side` determines appropriate exchange rate (Bid vs Ask)
- Complete fill data enables accurate PnL and balance updates

## Data Flow

### 1. Order Fill Processing Flow

```
OrderFilled Event
    ↓
Determine Position ID
    ↓
Retrieve Position from Cache
    ↓
Calculate PnL (via Account::calculate_pnls)
    ↓
Currency Conversion (if needed)
    ↓
Apply Commission
    ↓
Update Account Balance
    ↓
Generate AccountState Event
```

**Key Points**:
- Position ID may be provided in fill or derived from open positions
- PnL calculation depends on account type (single vs multi-currency)
- Currency conversion uses exchange rates from cache
- Commissions are deducted from PnL before balance update

### 2. Open Order Balance Locking Flow

```
Open Orders List
    ↓
Filter by Instrument ID & Open Status
    ↓
Skip Reduce-Only Orders
    ↓
Calculate Locked Balance per Order
    ↓
Currency Conversion (if base currency differs)
    ↓
Aggregate Locked Balances
    ↓
Update Account Balance Locked
    ↓
Generate AccountState Event
```

**Special Handling**:
- Cash accounts lock balance, Margin accounts calculate initial margin
- Reduce-only orders don't contribute to locked balance
- Orders without price are skipped (market orders without trigger price)
- Currency conversion uses appropriate Bid/Ask rates based on order side

### 3. Position-Based Margin Calculation Flow

```
Positions List
    ↓
Sort by Timestamp & Position ID
    ↓
Extract Position Legs (quantity, price, timestamp)
    ↓
Net Position Calculation (fold_net_position)
    ↓
Determine Net Side & Average Entry Price
    ↓
Calculate Maintenance Margin per Instrument Type
    ↓
Currency Conversion (if base currency differs)
    ↓
Update Account Maintenance Margin
    ↓
Generate AccountState Event
```

**Netting Algorithm**:
- All positions for the same instrument are netted together
- Maintains chronological ordering for deterministic results
- Closed positions are filtered out
- Floating dust below instrument precision clears margin

## Logic Flow

### Primary Business Operations

#### 1. Balance Updates (`update_balances`)

**Purpose**: Update account balances based on order fills with PnL and commission calculations.

**Logic**:
```rust
pub fn update_balances(
    &self,
    mut account: AccountAny,
    instrument: &InstrumentAny,
    fill: OrderFilled,
) -> (AccountAny, AccountState)
```

**Processing Steps**:
1. Determine position ID from fill or open positions
2. Retrieve position for PnL calculation
3. Calculate PnL based on account type:
   - **Single Currency**: Direct PnL calculation
   - **Multi Currency**: Per-currency PnL list
4. Apply currency conversion if base currency differs
5. Deduct commission from PnL
6. Update account balance
7. Generate account state event

**Error Handling**:
- Returns unchanged account if conversion data unavailable
- Logs errors for missing currency balances
- Handles negative balance based on account borrowing policy

#### 2. Order-Based Balance Updates (`update_orders`)

**Purpose**: Update locked balances based on open orders.

**Logic**:
```rust
pub fn update_orders(
    &self,
    account: &AccountAny,
    instrument: &InstrumentAny,
    orders_open: &[&OrderAny],
    ts_event: UnixNanos,
) -> Option<(AccountAny, AccountState)>
```

**Processing by Account Type**:

**Cash Accounts**:
- Calculate locked balance: `quantity × price`
- Sum across all open orders
- Convert to base currency if needed
- Update `balance_locked` field

**Margin Accounts**:
- Calculate initial margin per instrument type
- Sum across all open orders
- Convert to base currency if needed
- Update `initial_margin` field

**Betting Accounts**:
- Calculate liability using `calculate_balance_locked`
- Sum across all open orders
- Convert to base currency if needed
- Update `balance_locked` field

#### 3. Position-Based Margin Updates (`update_positions`)

**Purpose**: Calculate maintenance margin based on net position exposure.

**Logic**:
```rust
pub fn update_positions(
    &self,
    account: &MarginAccount,
    instrument: &InstrumentAny,
    positions: Vec<&Position>,
    ts_event: UnixNanos,
) -> Option<(MarginAccount, AccountState)>
```

**Net Position Algorithm**:
```rust
let legs: Vec<(Decimal, Decimal, u64)> = ordered
    .iter()
    .map(|p| (
        p.signed_decimal_qty(),
        Decimal::try_from(p.avg_px_open).unwrap_or(Decimal::ZERO),
        p.ts_opened.as_u64(),
    ))
    .collect();

let (net_signed_qty, net_avg_px) = fold_net_position(&legs);
```

**Margin Calculation**:
- Uses instrument-specific margin models
- Applies leverage settings
- Handles currency conversion
- Clears margin for zero or dust net positions

## Key Technical Techniques

### 1. Multi-Currency Support

**Exchange Rate Conversion**:
```rust
fn calculate_xrate_to_base(
    &self,
    base_currency: Option<Currency>,
    instrument: &InstrumentAny,
    side: OrderSide,
) -> Option<Decimal>
```

- Uses Bid rate for buy orders (converting base to settlement)
- Uses Ask rate for sell orders (converting settlement to base)
- Retrieves rates from cache with venue context

### 2. Position Netting

**Deterministic Ordering**:
```rust
ordered.sort_by_key(|p| (p.ts_opened, p.id));
```

- Ensures consistent margin calculation across runs
- Maintains chronological processing for accurate reversal pricing

**Net Position Calculation**:
- Folds all position legs into net exposure
- Preserves net-side entry price for accurate margin
- Handles floating edge cases and dust

### 3. Account Type Polymorphism

**Enum-Based Dispatch**:
```rust
match account {
    AccountAny::Margin(margin_account) => { /* margin-specific logic */ }
    AccountAny::Cash(cash_account) => { /* cash-specific logic */ }
    AccountAny::Betting(betting_account) => { /* betting-specific logic */ }
}
```

### 4. State Generation

**Account State Events**:
- Include per-instrument margins
- Include account-wide margins
- Capture complete balance state
- Include timestamps for event ordering

### 5. Error Handling and Validation

**Defensive Programming**:
- Returns `Option` for operations that may fail
- Logs errors for missing data
- Validates instrument and order relationships
- Handles edge cases (zero quantities, dust amounts)

## Performance Characteristics

### Time Complexity

- **Balance Updates**: O(1) for single currency, O(n) for multi-currency where n = number of currencies
- **Order Updates**: O(m) where m = number of open orders
- **Position Updates**: O(p log p) where p = number of positions (due to sorting)

### Space Complexity

- O(1) additional space (modifies accounts in place)
- Uses shared cache for position/instrument lookup

## Testing Strategy

The implementation includes comprehensive test coverage:

### Unit Tests

1. **Balance Locking Tests**:
   - Multiple order handling
   - Currency conversion
   - Order cancellation releases locks
   - Stale currency clearing

2. **Margin Calculation Tests**:
   - Net position calculation
   - Hedging subpositions
   - Net-zero hedge handling
   - Floating dust clearing
   - Base currency margin preservation
   - Deterministic ordering

3. **Multi-Currency Tests**:
   - PnL application across currencies
   - Commission handling
   - Exchange rate conversion
   - Large value handling (f64 precision)

4. **Error Handling Tests**:
   - Missing exchange rates
   - Negative balance rejection
   - New currency rejection

### Test Techniques

- **Property-Based Testing**: Verifies invariants (e.g., `total == locked + free`)
- **Regression Testing**: Addresses specific historical issues
- **Edge Case Testing**: Floating point precision, dust amounts
- **Determinism Testing**: Ensures consistent results across permutations

## Integration Points

### External Dependencies

1. **Cache**: Positions, instruments, exchange rates
2. **Clock**: Timestamp generation for state events
3. **Account Models**: Balance calculation, margin models

### Event Generation

Produces `AccountState` events containing:
- Account identifier
- Account type
- Current balances
- Margin requirements
- Event timestamps
- Transaction IDs

## Business Rules

### Margin Requirements

1. **Initial Margin**: Required to open leveraged positions
2. **Maintenance Margin**: Required to keep positions open
3. **Calculation**: Varies by instrument type (equity, futures, options, crypto, etc.)

### Balance Management

1. **Cash Accounts**: Full payment required, borrowing optional
2. **Margin Accounts**: Leverage supported, margin requirements enforced
3. **Betting Accounts**: Liability-based calculation, exchange-specific rules

### Currency Handling

1. **Multi-Currency**: Supports balances in multiple currencies
2. **Base Currency**: Optional base currency for consolidated reporting
3. **Conversion**: Automatic conversion using market rates
4. **Precision**: Maintains accounting precision for large values

## Data Consistency Guarantees

### Invariants

1. **Balance Invariant**: `total == locked + free` must always hold
2. **Margin Invariant**: Maintenance margin ≤ Initial margin
3. **Currency Invariant**: No negative balances unless borrowing allowed

### State Recovery

- Account state events provide complete snapshot
- Can reconstruct account state from event history
- Immutable state with explicit transitions

## Scalability Considerations

### Current Limitations

- Single-threaded operation (no concurrent updates)
- In-memory cache dependency
- No distributed state management

### Optimization Opportunities

- Batch processing for multiple order updates
- Cached exchange rate calculations
- Instrument-specific margin model optimization

## Security Considerations

### Input Validation

- Validates instrument-order relationships
- Checks order open status before processing
- Verifies price availability for calculations

### Error Handling

- Returns `Option` for potentially failed operations
- Logs errors without exposing sensitive data
- Maintains account state consistency on errors

### Financial Safety

- Prevents overdraft on cash accounts (unless borrowing enabled)
- Enforces margin requirements
- Handles precision edge cases to prevent rounding errors