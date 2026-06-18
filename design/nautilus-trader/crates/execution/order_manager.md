# Order Manager

## Purpose

The Order Manager is responsible for managing the lifecycle and state of orders within the Nautilus Trader execution system. It provides centralized order management with support for complex order relationships and contingent orders.

## Problems Solved

### 1. Complex Order Relationship Management
The Order Manager resolves the complexity of managing contingent order types that depend on each other's state, including:

- **OTO (One-Triggers-Others)**: When a parent order fills, it triggers child orders to be submitted
- **OCO (One-Cancels-Others)**: When one order fills, it automatically cancels all linked orders
- **OUO (One-Updates-Others)**: When one order updates, it propagates changes to linked orders

### 2. Order State Coordination

The manager ensures consistent order state across multiple system components:

- Local order state tracking
- Emulation system integration
- Risk management coordination
- Execution algorithm routing

### 3. Event-Driven Order Lifecycle

Handles order events and triggers appropriate actions based on order state changes:

- Order rejection handling
- Order cancellation logic
- Order expiration management
- Order filled event processing
- Order updated event handling

## Techniques Used

### 1. Action-Based Architecture
The Order Manager uses a command pattern where operations return a list of `OrderManagerAction` enum variants:
```rust
pub enum OrderManagerAction {
    PublishInitialized(OrderEventAny),
    SubmitToEmulator(SubmitOrder),
    SubmitToRisk(SubmitOrder),
    SubmitToAlgorithm { command: SubmitOrder, exec_algorithm_id: ExecAlgorithmId },
    CancelLocal(OrderAny),
    ModifyLocalQuantity { order: OrderAny, quantity: Quantity },
}
```

This allows the owner of the OrderManager to control what actions are actually executed.

### 2. Command Caching
Submit order commands are cached using a HashMap keyed by `ClientOrderId`:
```rust
submit_order_commands: AHashMap<ClientOrderId, SubmitOrder>
```
This enables tracking pending orders and preventing duplicate submissions.

### 3. Cache-Backed State Management
The manager relies on a shared `Cache` for persistent order state, allowing:

- Order existence verification
- Closed state tracking
- Pending cancel local status
- Execution spawn quantity tracking
- Position and client ID association

### 4. Event Routing with Pattern Matching

Order events are dispatched to specific handler methods using pattern matching:
```rust
pub fn handle_event(&mut self, event: &OrderEventAny) -> Vec<OrderManagerAction> {
    match event {
        OrderEventAny::Rejected(event) => self.handle_order_rejected(*event),
        OrderEventAny::Canceled(event) => self.handle_order_canceled(*event),
        OrderEventAny::Expired(event) => self.handle_order_expired(*event),
        OrderEventAny::Updated(event) => self.handle_order_updated(*event),
        OrderEventAny::Filled(event) => self.handle_order_filled(*event),
        _ => Vec::new(),
    }
}
```

### 5. Contingency-Aware Processing
Different contingency types trigger different behaviors:

- **OTO**: Child orders submitted when parent fills, quantities adjusted based on fill amount
- **OCO**: Contingent orders cancelled when one order fills
- **OUO**: Child orders cancelled when parent is fully executed, quantities updated based on parent's leaves

## File Tree

```
crates/execution/src/order_manager/
├── mod.rs          # Module definition and OrderManagerAction enum
└── manager.rs      # OrderManager implementation with ~1200 lines including tests
```

## Data Flow

### 1. Order Submission Flow
```
Strategy/Client
    ↓
create_new_submit_order()
    ↓
Check emulation_trigger
    ├─ Has trigger → SubmitToEmulator + cache command
    └─ No trigger → Check exec_algorithm_id
                   ├─ Has algorithm → SubmitToAlgorithm + cache command
                   └─ No algorithm → SubmitToRisk + cache command
```

### 2. Order Event Handling Flow
```
External Event (Filled/Rejected/Canceled/Expired/Updated)
    ↓
handle_event()
    ↓
Route to specific handler (handle_order_filled, etc.)
    ↓
Check contingency_type
    ├─ NoContingency → No action
    └─ Has contingency → handle_contingencies()
                        ↓
                        Iterate linked_order_ids
                        ↓
                        Generate CancelLocal/ModifyLocalQuantity actions
```

### 3. Contingent Order Flow (OTO Example)
```
Parent Order Filled
    ↓
handle_order_filled()
    ↓
For each linked order:
    ├─ Set position_id from parent
    ├─ Adjust quantity to parent's filled_qty
    └─ Submit child order via create_new_submit_order()
```

### 4. OCO Flow
```
One Order Fills
    ↓
handle_order_filled()
    ↓
For each linked order:
    └─ Skip self, cancel all other linked orders
```

## Logic Flow

### Core Operations

#### 1. Order Creation
```rust
create_new_submit_order(order, position_id, client_id, correlation_id)
    ├─ Add order to cache
    ├─ Publish initialized event (if new order)
    ├─ Create SubmitOrder command
    ├─ Route based on trigger/algorithm:
    │   ├─ Has trigger → SubmitToEmulator
    │   ├─ Has algorithm → SubmitToAlgorithm
    │   └─ Otherwise → SubmitToRisk
    └─ Cache the submit command
```

#### 2. Order Cancellation
```rust
cancel_order(order)
    ├─ Check if pending cancel local → return empty
    ├─ Check if closed → warn and return empty
    ├─ Remove from submit_order_commands cache
    └─ Return CancelLocal action
```

#### 3. Order Modification
```rust
modify_order_quantity(order, new_quantity)
    └─ Return ModifyLocalQuantity action
```

#### 4. Event Handling
```rust
handle_event(event)
    ├─ Rejected → handle_order_rejected() → handle_contingencies()
    ├─ Canceled → handle_order_canceled() → handle_contingencies()
    ├─ Expired → handle_order_expired() → handle_contingencies()
    ├─ Updated → handle_order_updated() → handle_contingencies_update()
    ├─ Filled → handle_order_filled() (special handling for OTO/OCO/OUO)
    └─ Other events → No operation
```

#### 5. Contingency Handling
```rust
handle_contingencies(order)
    ├─ Get filled_qty and leaves_qty (considering exec_spawn_id)
    ├─ For each linked order:
    │   ├─ Check should_manage_order() and not self
    │   ├─ Check if closed → skip
    │   └─ Apply contingency logic:
    │       ├─ OTO: Cancel if no fill, adjust quantity if filled
    │       ├─ OCO: Cancel if parent closed
    │       └─ OUO: Cancel if parent fully executed, adjust quantity otherwise
```

#### 6. Contingency Update Handling
```rust
handle_contingencies_update(order)
    ├─ Get total quantity (considering exec_spawn_id)
    ├─ For each linked order:
    │   ├─ Check should_manage_order() and not self and not closed
    │   └─ For OTO/OCO: Adjust quantity if changed
```

### Key Design Decisions

1. **Active Local Flag**: The `active_local` flag determines whether the manager should manage local orders (`should_manage_order()`), allowing the same code to work in different modes.

2. **Double State Check**: Order cancellation checks both local state (`order.is_closed()`) and cache state (`cache.is_order_closed()`) to handle stale references.

3. **Command Caching**: Submit commands are cached to prevent duplicate submissions and track pending orders.

4. **Action Return Pattern**: All methods return actions rather than executing them, allowing the owner to control execution flow.

5. **Event-Driven**: The system is entirely event-driven, with actions generated based on order state changes.

Key Dependencies:

- `nautilus_common::Cache`: Centralized cache for order state
- `nautilus_common::Clock`: Time source for timestamping
- `nautilus_model`: Order types, events, identifiers
- `ahash::AHashMap`: High-performance hash map for command caching

## Integration Points

1. **Execution Engine**: Receives OrderManagerAction events
2. **Emulation System**: Handles orders with triggers
3. **Risk Management**: Validates orders before submission
4. **Execution Algorithms**: Processes algorithmic orders
5. **Message Bus**: Publishes order events to subscribers