# Threading and Task Management Model

## Overview

Nautilus Trader implements a **single-threaded cooperative multitasking** architecture using Tokio's `current_thread` runtime. This design prioritizes determinism, low latency, and simplicity over CPU parallelism. All components run on a single thread using cooperative scheduling through async/await and message passing. The system also provides Python bindings via PyO3 with sophisticated threading management for cross-language interoperability.

## Filetree: Skeleton Files for Threading Management

```
crates/
├── common/
│   └── src/
│       ├── actor/
│       │   ├── data_actor.rs         # Data actor trait definition
│       │   └── registry.rs            # Global actor registry
│       ├── msgbus/
│       │   ├── mod.rs                 # Message bus core
│       │   ├── switchboard.rs         # Topic routing
│       │   └── typed_handler.rs       # Typed message handlers
│       └── python/
│           └── msgbus.rs              # Python message bus bindings
├── live/
│   └── src/
│       ├── config.rs                  # Runtime configuration and validation
│       ├── node.rs                    # Main event loop orchestration
│       └── runner.rs                  # AsyncRunner event loop implementation
├── system/
│   └── src/
│       ├── kernel.rs                  # System kernel and engine management
│       └── trader.rs                  # Actor and strategy lifecycle management
├── data/
│   └── src/
│       └── engine/
│           └── mod.rs                 # Data engine implementation
├── execution/
│   └── src/
│       └── engine/
│           └── mod.rs                 # Execution engine implementation
├── risk/
│   └── src/
│       └── engine/
│           └── mod.rs                 # Risk engine implementation
├── network/
│   ├── src/
│   │   ├── transport/
│   │   │   └── stream.rs              # WebSocket stream transport trait
│   │   ├── websocket/
│   │   │   ├── types.rs               # WebSocket stream types
│   │   │   └── client.rs              # WebSocket client with reader/writer tasks
│   │   └── python/
│   │       ├── websocket.rs           # Python WebSocket bindings
│   │       └── http.rs                # Python HTTP bindings (with GIL release)
├── core/
│   └── src/
│       └── python/
│           └── mod.rs                 # Core Python interop utilities
└── pyo3/
    └── src/
        └── lib.rs                     # PyO3 module aggregator
```

## Core Threading Model

### Single-Threaded Async Runtime

The system uses `tokio::runtime::Builder::new_current_thread()` to create a single-threaded runtime. All components use `Rc<RefCell<..>>` instead of thread-safe `Arc<Mutex<..>>` and are explicitly marked as `!Send` (cannot be moved between threads).

**Key characteristics:**
- All access happens on the same thread
- No synchronization primitives needed (zero lock contention)
- Deterministic performance with predictable latency patterns
- Cache locality benefits from single-threaded execution

### Event Loop Architecture

The `AsyncRunner` in `runner.rs` manages the core event loop using a `tokio::select!` macro with biased selection. This loop multiplexes five key channel pairs:

```rust
pub struct AsyncRunnerChannels {
    pub time_evt_rx: tokio::sync::mpsc::UnboundedReceiver<TimeEventHandler>,
    pub exec_evt_rx: tokio::sync::mpsc::UnboundedReceiver<ExecutionEvent>,
    pub exec_cmd_rx: tokio::sync::mpsc::UnboundedReceiver<TradingCommand>,
    pub data_evt_rx: tokio::sync::mpsc::UnboundedReceiver<DataEvent>,
    pub data_cmd_rx: tokio::sync::mpsc::UnboundedReceiver<DataCommand>,
}
```

**Event processing priority (biased select):**

1. **Signal branches first** - SIGINT and stop signals always checked
2. **Maintenance dispatcher** - Reconciliation, purging, pruning, auditing
3. **Execution commands** - Prioritized over data events
4. **Data events and commands** - Market data and subscriptions

The `select!` macro runs one branch to completion (including inner awaits) before polling the next, ensuring `RefCell` borrows held across `.await` points within a single branch cannot conflict with borrows in other branches.

## Task Distribution Model

### Sequential (Cooperative) Operations

The following tasks are processed **sequentially in order**:

1. **Message bus operations**

    - All message dispatch is immediate and sequential
    - Messages are processed in the order they are received
    - No concurrent message processing

2. **Engine operations**

    - Data engine: Sequential event processing
    - Execution engine: Sequential command handling
    - Risk engine: Sequential risk checks
    - All engines share the same event loop

3. **Actor message handling**

    - Each actor processes messages sequentially
    - Actors are type-erased and registered globally
    - No parallel actor execution

4. **Timer callbacks**

    - Prioritized in the select loop
    - Single maintenance timer for all periodic tasks
    - Tasks fire when their deadline has passed

### No True Parallelism

The system does **not** support parallel execution for:

- CPU-bound tasks (no thread pool)
- Message processing (sequential only)
- Actor execution (one at a time)
- Engine operations (shared event loop)

### Concurrent I/O Operations

The system supports **concurrent I/O** through async operations:

- Network operations (WebSocket connections, HTTP requests)
- Database operations (persistence, event storage)
- File I/O (configuration, logs)

All I/O callbacks run on the same thread when they complete, maintaining the single-threaded invariant.

## Actor Model Implementation

### Global Actor Registry

The system uses a global actor registry with type-erased actors managed through `Trader`:

```rust
pub struct Trader {
    actor_ids: Vec<ActorId>,
    strategy_ids: Vec<StrategyId>,
    exec_algorithm_ids: Vec<ExecAlgorithmId>,
}
```

Actors are registered using `add_actor<T>()` where `T: DataActor + Component`. Registration consumes the actor and stores it in the global registry.

### Thread-Local Storage Pattern

The system uses thread-local storage for channel senders to avoid passing references through the call stack:

**Invariants:**

- `bind_senders` must be called before any code that reads from TLS
- The event loop and all TLS consumers must execute on the same thread
- Senders are cloneable and `Send`, but TLS slots are not accessible from other threads

## Engine Architecture

### Three Main Engines

The kernel orchestrates three main engines:

```rust
pub struct NautilusKernel {
    pub data_engine: Rc<RefCell<DataEngine>>,
    pub risk_engine: Rc<RefCell<RiskEngine>>,
    pub exec_engine: Rc<RefCell<ExecutionEngine>>,
    pub order_emulator: OrderEmulatorAdapter,
    pub trader: Rc<RefCell<Trader>>,
}
```

**Engine lifecycle:**

- All engines are started sequentially: `data_engine`, `exec_engine`, `risk_engine`
- Engines use `Rc<RefCell<..>>` for mutable access on the same thread
- No inter-engine synchronization needed (single-threaded)

### Maintenance Scheduling

Six periodic tasks share a single coarse `maintenance_timer` (100ms interval):

1. Reconciliation (inflight, open, position sub-checks)
2. Purge closed orders
3. Purge closed positions
4. Purge account events
5. Own-books audit
6. Recent-fills cache prune

Each task tracks its own `next_fire: Instant` and the dispatcher fires tasks whose deadline has passed.

## Task Distribution Mechanisms

### Message Bus Routing

The system uses a centralized message bus with:

- **Pub/Sub pattern**: Components subscribe to specific message types
- **Typed endpoints**: Strongly typed message handlers
- **Switchboard routing**: Centralized topic management

### Channel Communication

- **Unbounded channels**: High-throughput event processing
- **Biased select**: Critical messages prioritized (exec commands over data)
- **No backpressure**: By design (unbounded channels)

### Actor Messaging

Actors communicate through:

- **Type-erased handlers**: `TypedHandler<T>` for specific message types
- **Global registry**: Thread-local storage for actor lookup
- **Direct dispatch**: Message bus routes to registered handlers

## Performance Characteristics

### Advantages

1. **Zero lock contention**: No synchronization primitives needed
2. **Deterministic performance**: Predictable latency patterns
3. **Cache locality**: All data structures in CPU cache
4. **Simpler debugging**: No race conditions or deadlocks
5. **Lower overhead**: No context switching or thread management

### Trade-offs

1. **Limited CPU utilization**: Single core only
2. **Blocking operations**: Must be async to avoid blocking the thread
3. **No CPU parallelism**: Cannot parallelize CPU-intensive tasks

## Summary Table

| Aspect | Implementation |
|--------|----------------|
| **Threading Model** | Single-threaded cooperative multitasking |
| **Runtime** | Tokio `current_thread` flavor |
| **Scheduler** | Cooperative async/await |
| **Synchronization** | None (by design) |
| **Message Passing** | Channel-based (unbounded mpsc) |
| **Component Access** | `Rc<RefCell<..>>` (not thread-safe) |
| **Task Distribution** | Event-driven, message-based |
| **Parallel Execution** | None (sequential processing) |
| **Concurrent I/O** | Yes (async I/O, single-threaded) |
| **Tasks Processed In Order** | Message bus, engines, actors, timers |
| **Tasks Processed In Parallel** | None (no CPU parallelism) |
| **Concurrent I/O Operations** | Network, database, file I/O |

This architecture is well-suited for high-frequency trading systems where low latency and deterministic behavior are more important than CPU parallelism.

## Python-Rust Interoperability

### PyO3 Bindings Architecture

Nautilus Trader provides Python bindings through PyO3, enabling Python code to call Rust logic efficiently. The main entry point is `/Users/hung/work/nautilus_trader/crates/pyo3/src/lib.rs` which aggregates all Python submodules:

```rust
#[pymodule]
fn _libnautilus(py: Python<'_>, m: &Bound<'_, PyModule>) -> PyResult<()> {
    // Registers multiple submodules from different crates
    let submodule = pyo3::wrap_pymodule!(nautilus_core::python::core);
    m.add_wrapped(submodule)?;
    // ... similar for all other crates
}
```

### Threading Model for Python Calls

#### Same-Thread Processing

For operations that can run on the current thread, the system uses `Python::attach`:

```rust
// crates/core/src/python/mod.rs
pub fn call_python(py: Python, callback: &Py<PyAny>, py_obj: Py<PyAny>) {
    if let Err(e) = callback.call1(py, (py_obj,)) {
        log::error!("Error calling Python: {e}");
    }
}
```

**Use cases:**

- Message bus handlers processing events
- Callback invocations from Rust to Python
- Direct synchronous operations

#### Cross-Thread Processing

For operations that need to run on Python's event loop, the system uses `call_soon_threadsafe`:

```rust
// crates/core/src/python/mod.rs
pub fn call_python_threadsafe(
    py: Python,
    call_soon: &Py<PyAny>,
    callback: &Py<PyAny>,
    py_obj: Py<PyAny>,
) {
    if let Err(e) = call_soon.call1(py, (callback, py_obj)) {
        log::error!("Error scheduling Python callback on event loop: {e}");
    }
}
```

**Use cases:**

- Scheduling callbacks on Python's asyncio event loop
- Cross-thread communication from Tokio tasks to Python
- Deferring work to Python's thread

### GIL (Global Interpreter Lock) Management

The system implements strategic GIL handling to maximize concurrency:

#### GIL Release for Blocking Operations

For blocking I/O operations, the GIL is released to allow other Python threads to run:

```rust
// crates/network/src/python/http.rs
pub fn http_get(py: Python<'_>, url: String, ...) -> PyResult<HttpResponse> {
    // Release the GIL while blocking on the request
    py.detach(|| {
        join_blocking_http_thread(std::thread::spawn(move || {
            let runtime = blocking_http_runtime()?;
            runtime.block_on(async {
                // HTTP request processing
            })
        }))
    })
}
```

**Thread used:** Dedicated blocking thread spawned for the HTTP request

#### GIL Acquisition for Callbacks

When Rust calls back into Python, the GIL is acquired:

```rust
// crates/common/src/python/msgbus.rs
impl Handler<dyn Any> for PyCallableHandler {
    fn handle(&self, message: &dyn Any) {
        if let Some(py_msg) = message.downcast_ref::<PyMessage>() {
            Python::attach(|py| {
                if let Err(e) = self.callable.call1(py, (&py_msg.0,)) {
                    log::error!("Python handler {id} failed: {e}", id = self.id);
                }
            });
        }
    }
}
```

**Thread used:** Current Tokio event loop thread (single-threaded runtime)

### Async Integration with Python

The system uses `pyo3_async_runtimes` for seamless async/await integration:

```rust
// crates/network/src/python/websocket.rs
#[staticmethod]
fn py_connect(
    loop_: Py<PyAny>,
    config: WebSocketConfig,
    handler: Py<PyAny>,
    py: Python<'_>,
) -> PyResult<Bound<'_, PyAny>> {
    let call_soon_threadsafe: Py<PyAny> = loop_.getattr(py, "call_soon_threadsafe")?;

    pyo3_async_runtimes::tokio::future_into_py(py, async move {
        Box::pin(Self::connect(
            config,
            Some(message_handler),
            ping_handler_fn,
            post_reconnection_fn,
        ))
        .await
        .map_err(to_websocket_pyerr)
    })
}
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

### Python → Rust Data Flow

1. Python calls PyO3-exposed methods
2. PyO3 converts Python types to Rust types
3. Rust processes the request (often async on Tokio runtime)
4. Results converted back to Python via `pyo3_async_runtimes`

**Thread:** Tokio event loop thread (single-threaded runtime)

### Rust → Python Data Flow

1. Rust code generates events/data
2. Data wrapped in `PyMessage` for Python consumption
3. `Python::attach` acquires GIL and calls Python callbacks
4. Python handlers receive processed data via `call_soon_threadsafe`

**Thread:** Tokio event loop thread (single-threaded runtime)

## Streaming Infrastructure

### WebSocket Stream Architecture

The system provides WebSocket streaming with a split architecture:

```rust
// crates/network/src/websocket/types.rs
use futures_util::stream::{SplitSink, SplitStream};

/// Stream half of the active WebSocket transport.
pub type MessageReader = SplitStream<BoxedWsTransport>;
```

### Stream Backend Abstraction

```rust
// crates/network/src/transport/stream.rs
pub trait WsTransport:
    Stream<Item = Result<Message, TransportError>>
    + Sink<Message, Error = TransportError>
    + Send
    + Unpin
{
}
```

**Thread safety:** Stream trait requires `Send`, but actual execution happens on Tokio runtime thread

### WebSocket Client Threading Model

The WebSocket client uses a multi-task architecture:

#### Reader Task
```rust
tokio::task::spawn(async move {
    // Processes incoming WebSocket messages
    while let Some(Ok(msg)) = reader.next().await {
        // Process message and call Python handler
    }
});
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

#### Writer Task
```rust
tokio::task::spawn(async move {
    // Handles outgoing messages
    while let Some(cmd) = receiver.recv().await {
        // Send message through WebSocket
    }
});
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

#### Controller Task
```rust
tokio::task::spawn(async move {
    // Manages connection state and reconnection
    // Heartbeat handling
    // Rate limiting
});
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

### Stream Processing Priority

All WebSocket stream tasks run cooperatively on the single Tokio event loop thread:

- **Reader task**: Processes incoming WebSocket messages as they arrive
- **Writer task**: Sends messages from the command channel
- **Controller task**: Periodic maintenance (heartbeat, reconnection)

Tasks are scheduled cooperatively through `tokio::select!` and await points, with no true parallelism.

### Message Bus Streaming

The Python message bus supports streaming patterns:

```rust
// crates/common/src/python/msgbus.rs
pub struct PyMessageBus {
    listeners: Vec<Py<PyAny>>,
    streaming_types: Vec<Py<PyAny>>,
    correlation_index: AHashMap<UUID4, Py<PyAny>>,
}

impl PyMessageBus {
    pub fn py_publish(&mut self, py: Python<'_>, topic: &str, msg: Py<PyAny>, external_pub: bool) -> PyResult<()> {
        let py_msg = PyMessage(msg.clone_ref(py));
        msgbus_api::publish_any(topic_mstr, &py_msg);

        if external_pub {
            self.publish_external(py, topic, &msg)?;
        }

        self.pub_count += 1;
        Ok(())
    }
}
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

### HTTP Streaming

For HTTP requests, the system uses dedicated blocking threads:

```rust
// crates/network/src/python/http.rs
pub fn http_get(py: Python<'_>, url: String, ...) -> PyResult<HttpResponse> {
    py.detach(|| {
        join_blocking_http_thread(std::thread::spawn(move || {
            let runtime = blocking_http_runtime()?;
            runtime.block_on(async {
                // HTTP request processing
            })
        }))
    })
}
```

**Thread used:** Dedicated blocking thread (spawned per request)

### Adapter-Specific Streaming Patterns

Exchange adapters follow consistent patterns for shared state across async operations:

```rust
// crates/adapters/okx/src/python/websocket.rs
//! Design Pattern: Clone and Share State
//! The WebSocket client must be cloned for async operations because PyO3's `future_into_py`
//! requires `'static` futures (cannot borrow from `self`). To ensure clones share the same
//! connection state, key fields use `Arc<RwLock<T>>`:
//!
//! - `inner: Arc<RwLock<Option<WebSocketClient>>>` - The WebSocket connection.
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

## Runtime Management

### Tokio Runtime Configuration

The system provides both production and simulation runtime support:

```rust
// crates/common/src/live/dst.rs
pub mod runtime {
    #[cfg(not(all(feature = "simulation", madsim)))]
    pub use tokio::runtime::{Builder, Handle, Runtime};

    #[cfg(all(feature = "simulation", madsim))]
    mod sim {
        // Simulated runtime for deterministic testing
    }
}
```

### Async Task Spawning

Extensive use of `tokio::task::spawn` for concurrent operations:

```rust
// crates/network/src/websocket/client.rs
tokio::task::spawn(async move {
    // Background tasks for connection management
    // Message processing
    // Heartbeat handling
    // Rate limiting
});
```

**Thread used:** Tokio event loop thread (single-threaded runtime)

## Complete Threading Summary

### Thread Allocation

| Component | Thread | Model |
|-----------|--------|-------|
| **Core event loop** | Single Tokio thread | Cooperative multitasking |
| **Message bus processing** | Single Tokio thread | Sequential |
| **Engine operations** | Single Tokio thread | Sequential |
| **WebSocket reader** | Single Tokio thread | Cooperative async |
| **WebSocket writer** | Single Tokio thread | Cooperative async |
| **WebSocket controller** | Single Tokio thread | Cooperative async |
| **Python callbacks (same-thread)** | Single Tokio thread | GIL acquired |
| **Python callbacks (cross-thread)** | Python event loop thread | `call_soon_threadsafe` |
| **HTTP requests** | Dedicated blocking thread | Per-request spawn |
| **Async I/O** | Single Tokio thread | Non-blocking |
| **Adapter WebSocket** | Single Tokio thread | Cooperative async |

### Python-Rust Interop Summary

| Aspect | Implementation |
|--------|----------------|
| **Same-thread calls** | `Python::attach` on Tokio thread |
| **Cross-thread calls** | `call_soon_threadsafe` on Python event loop |
| **GIL handling** | Released for blocking I/O, acquired for callbacks |
| **Async integration** | `pyo3_async_runtimes::tokio` |
| **State sharing** | `Arc<RwLock<T>>` pattern |
| **Callback thread** | Tokio event loop thread (single-threaded) |

### Stream Processing Summary

| Stream Type | Reader Thread | Writer Thread | Controller Thread |
|-------------|---------------|---------------|-------------------|
| **WebSocket** | Tokio thread | Tokio thread | Tokio thread |
| **HTTP** | Blocking thread | Blocking thread | N/A |
| **Message bus** | Tokio thread | Tokio thread | N/A |
| **Async I/O** | Tokio thread | Tokio thread | N/A |

### Key Architecture Points

1. **Single-threaded Tokio runtime** for core trading logic (deterministic, low-latency)
2. **Dedicated blocking threads** for HTTP requests (non-blocking for Tokio runtime)
3. **GIL-aware design** for Python interop (strategic release/acquisition)
4. **Cooperative multitasking** for all async operations (no true parallelism)
5. **Split stream architecture** for WebSocket (separate reader/writer tasks on same thread)
6. **Cross-thread scheduling** for Python event loop integration (`call_soon_threadsafe`)
7. **Shared state via `Arc<RwLock<T>>`** for async operations across clones

The architecture enables high-performance Rust processing with full Python interoperability, maintaining deterministic behavior for trading logic while providing flexible streaming capabilities for data ingestion and order execution.