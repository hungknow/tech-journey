# call_python Implementation and Usage

## Overview

`call_python` and `call_python_threadsafe` are utility functions in the Nautilus Trader system that enable Rust code to invoke Python callbacks. These functions are critical for the Rust-Python interop layer, allowing Rust components to communicate back to Python user code in a thread-safe manner.

## Implementation

### call_python

Location: `crates/core/src/python/mod.rs:88-92`

```rust
pub fn call_python(py: Python, callback: &Py<PyAny>, py_obj: Py<PyAny>) {
    if let Err(e) = callback.call1(py, (py_obj,)) {
        log::error!("Error calling Python: {e}");
    }
}
```

**Parameters:**

- `py: Python` - PyO3 Python token representing the GIL
- `callback: &Py<PyAny>` - Reference to the Python callback function to invoke
- `py_obj: Py<PyAny>` - Python object to pass as argument to the callback


**Behavior:**

- Invokes Python callback synchronously with one argument
- Logs errors if callback invocation fails
- Runs on the current thread (must hold GIL)


### call_python_threadsafe

Location: `crates/core/src/python/mod.rs:99-108`

```rust
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

**Parameters:**

- `py: Python` - PyO3 Python token representing the GIL
- `call_soon: &Py<PyAny>` - Python's `asyncio.loop.call_soon_threadsafe` function
- `callback: &Py<PyAny>` - Reference to the Python callback function to invoke
- `py_obj: Py<PyAny>` - Python object to pass as argument to the callback


**Behavior:**

- Schedules Python callback to run on asyncio event loop thread
- Uses `call_soon_threadsafe` for cross-thread callback scheduling
- Required when invoking Python callbacks that may enter the kernel (e.g., via `MessageBus.send`)
- Logs errors if scheduling fails


## Purpose

The primary purpose of these functions is to bridge Rust components with Python user code in Nautilus Trader's hybrid architecture:


1. **Rust-to-Python Communication:** Enable Rust components (adapters, message bus, infrastructure) to call Python callbacks with data

2. **Thread Safety:** Ensure Python callbacks execute on appropriate threads
   - `call_python`: Same-thread execution when already on Python thread
   - `call_python_threadsafe`: Cross-thread scheduling when calling from Tokio worker threads

3. **Error Handling:** Centralized error logging for callback failures

4. **GIL Management:** Properly manage Python's Global Interpreter Lock during interop

5. **Data Flow:** Push data from Rust workers to Python application logic


## Usage Context and Reasons

### 1. Message Bus Streaming


**Location:** `crates/infrastructure/src/python/redis/msgbus.rs:59`

```rust
Python::attach(|py| call_python(py, &callback, msg.into_py_any_unwrap(py)));
```

**Context:** Redis message bus database adapter streams messages from Redis to Python

**Reason:** Each message received from Redis needs to be delivered to a Python callback for application processing. Used in async context with `Python::attach` to safely acquire GIL.


### 2. Message Bus Listener


**Location:** `crates/common/src/python/listener.rs:70`

```rust
Python::attach(|py| call_python(py, &callback, msg.into_py_any_unwrap(py)));
```

**Context:** Message bus listener streams incoming messages to Python

**Reason:** Forward messages from the message bus receiver channel to Python callbacks for event handling. Runs in async context and needs GIL access.


### 3. WebSocket Data Streams (Thread-safe)


**Location:** `crates/adapters/hyperliquid/src/python/websocket.rs:406`

```rust
Python::attach(|py| {
    for tick in trade_ticks {
        let py_obj = data_to_pycapsule(py, Data::Trade(tick));
        call_python_threadsafe(py, &call_soon, &callback, py_obj);
    }
});
```

**Context:** Hyperliquid adapter WebSocket receiving market data from exchange

**Reason:** Market data (trades, quotes, order book deltas) must be delivered to Python application, but WebSocket runs on Tokio thread. Uses `call_python_threadsafe` to schedule callbacks on Python's asyncio event loop to avoid thread safety issues when callbacks may send messages via `MessageBus.send`.


### 4. Tardis Market Data Processing


**Location:** `crates/adapters/tardis/src/python/machine.rs:338`

```rust
Python::attach(|py| {
    for data in data {
        let py_obj = data_to_pycapsule(py, data);
        call_python(py, &callback, py_obj);
    }
});
```

**Context:** Tardis adapter processes raw market data from exchange

**Reason:** After parsing and transforming Tardis WebSocket messages into Nautilus data structures, results are passed to Python callbacks. Uses `call_python` because this runs on a dedicated thread managed by the adapter.


### 5. OKX WebSocket Event Dispatching


**Location:** `crates/adapters/okx/src/python/websocket.rs:2368`

```rust
fn call_python_with_data<F>(call_soon: &Py<PyAny>, callback: &Py<PyAny>, data_converter: F)
where
    F: FnOnce(Python) -> PyResult<Py<PyAny>>,
{
    Python::attach(|py| match data_converter(py) {
        Ok(py_obj) => call_python_threadsafe(py, call_soon, callback, py_obj),
        Err(e) => log::error!("Failed to convert data to Python object: {e}"),
    });
}
```

**Context:** OKX adapter WebSocket dispatching various market data and account events

**Reason:** Provides a helper pattern to convert Rust data to Python objects and schedule callbacks on event loop. Used extensively for trade ticks, order book updates, order status changes, account state updates, etc.


## When to Use Each Function


### call_python

Use when:

- Already running on a Python thread (holding GIL)
- Callback is simple and won't make calls that enter the kernel
- Processing synchronous operations
- Working with message bus handlers that are already on Python thread
- Data originates from same-thread context (e.g., Tardis dedicated thread)


### call_python_threadsafe

Use when:

- Calling from Tokio worker threads
- Callback may invoke operations that enter the kernel (e.g., `MessageBus.send`)
- Running on WebSocket listener threads
- Need to schedule work on Python's asyncio event loop
- Data arrives from exchange WebSocket connections
- Cross-thread communication from async Rust to Python


## Pattern Summary


**Same-thread pattern:**
```rust
Python::attach(|py| call_python(py, &callback, py_obj));
```

**Cross-thread pattern:**
```rust
Python::attach(|py| {
    let py_obj = convert_to_python(py, data);
    call_python_threadsafe(py, &call_soon, &callback, py_obj);
});
```

Both patterns use `Python::attach` to safely acquire the GIL when needed, then invoke the appropriate function based on threading context.