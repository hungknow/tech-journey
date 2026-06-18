# call_python_threadsafe Implementation and Usage

## Overview

`call_python_threadsafe` is a critical function in NautilusTrader's Python-Rust interoperability layer. It enables safe cross-thread communication from Tokio worker threads to Python's asyncio event loop, ensuring thread-safety when calling Python callbacks that may interact with the kernel (e.g., `MessageBus.send`).

## Implementation

**Location:** `crates/core/src/python/mod.rs:99-108`

```rust
/// Schedules a Python callback on the event loop thread via `call_soon_threadsafe`.
///
/// This must be used instead of [`call_python`] when invoking Python callbacks
/// from Tokio worker threads, since Python callbacks that enter the kernel
/// (e.g. via `MessageBus.send`) must run on the asyncio event loop thread.
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

## Comparison with call_python

**Location:** `crates/core/src/python/mod.rs:88-92`

```rust
/// Calls a Python callback with a single argument, logging any errors.
pub fn call_python(py: Python, callback: &Py<PyAny>, py_obj: Py<PyAny>) {
    if let Err(e) = callback.call1(py, (py_obj,)) {
        log::error!("Error calling Python: {e}");
    }
}
```

**Key differences:**


| Aspect | `call_python` | `call_python_threadsafe` |
|--------|---------------|--------------------------|
| **Execution thread** | Current thread (Tokio event loop) | Python asyncio event loop thread |
| **Scheduling** | Immediate | Deferred via `call_soon_threadsafe` |
| **Use case** | Simple callbacks, no kernel interaction | Callbacks that may call `MessageBus.send` |
| **Thread safety** | May violate kernel threading requirements | Guarantees event loop execution |
| **Latency** | Lower (direct call) | Slightly higher (scheduled) |

**Why the difference matters:**

Python callbacks in trading strategies often need to interact with the message bus:

```python
# Python strategy callback
def on_trade_tick(self, tick):
    # This calls MessageBus.send internally
    # Must execute on asyncio event loop thread
    self.publish_event(tick)
```

If called from Tokio thread without `call_soon_threadsafe`, this could cause threading violations or race conditions.

## When to Use call_python_threadsafe

Use `call_python_threadsafe` when calling Python callbacks from Tokio worker threads that may interact with the kernel (e.g., `MessageBus.send`).

### Usage in WebSocket Adapters

All cryptocurrency exchange WebSocket adapters use `call_python_threadsafe` to forward market data to Python:

**Adapters:**
- Hyperliquid
- Kraken (spot and futures)
- dYdX
- Deribit
- Bybit
- Bitmex
- OKX
- Binance

**Example pattern:**

```rust
// crates/adapters/hyperliquid/src/python/websocket.rs
match msg {
    NautilusWsMessage::Trades(trade_ticks) => {
        Python::attach(|py| {
            for tick in trade_ticks {
                let py_obj = data_to_pycapsule(py, Data::Trade(tick));
                call_python_threadsafe(py, &call_soon, &callback, py_obj);
            }
        });
    }
    NautilusWsMessage::Quote(quote_tick) => {
        Python::attach(|py| {
            let py_obj = data_to_pycapsule(py, Data::Quote(quote_tick));
            call_python_threadsafe(py, &call_soon, &callback, py_obj);
        });
    }
    NautilusWsMessage::Deltas(deltas) => {
        Python::attach(|py| {
            let py_obj = data_to_pycapsule(
                py,
                Data::Deltas(OrderBookDeltas_API::new(deltas)),
            );
            call_python_threadsafe(py, &call_soon, &callback, py_obj);
        });
    }
}
```

**Message types forwarded:**

- Trade ticks
- Quote ticks
- Order book deltas
- Order book snapshots
- Bar/candle data
- Mark price updates
- Index price updates
- Funding rates
- Execution reports (orders and fills)
- Custom data types

### When NOT to Use It

Use direct `call_python` when:
- The callback runs in a `pyo3_async_runtimes::tokio::future_into_py` context
- The callback doesn't need to interact with the kernel
- The adapter has its own isolated message processing

**Example:** Databento live adapter uses `call_python` because it processes messages through its own async future:

```rust
// crates/adapters/databento/src/python/live.rs
pyo3_async_runtimes::tokio::future_into_py(py, async move {
    while let Some(msg) = msg_rx.recv().await {
        match msg {
            DatabentoMessage::Data(data) => Python::attach(|py| {
                let py_obj = data_to_pycapsule(py, data);
                call_python(py, &callback, py_obj);  // Direct call
            }),
            // ... other message types
        }
    }
})
```

## Threading Context

NautilusTrader uses a single-threaded Tokio runtime for all Rust async operations, but Python callbacks may need to run on Python's asyncio event loop thread. `call_python_threadsafe` bridges this gap.

### Runtime Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Python asyncio event loop                 │
│                    (Main Python thread)                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Python callbacks (kernel, msgbus, strategies)         │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↕ call_soon_threadsafe
┌─────────────────────────────────────────────────────────────┐
│                    Tokio single-threaded runtime             │
│                    (Same thread as Python)                   │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  WebSocket reader task  →  Message processing           │ │
│  │  WebSocket writer task  →  Order submission             │ │
│  │  Controller task       →  Heartbeat & reconnection      │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Example: WebSocket Message Processing

Here's how a typical exchange adapter processes incoming messages:

```rust
// crates/adapters/hyperliquid/src/python/websocket.rs
tokio::task::spawn(async move {
    while let Some(msg) = reader.next().await {
        match msg {
            NautilusWsMessage::Trades(trade_ticks) => {
                Python::attach(|py| {
                    for tick in trade_ticks {
                        // Convert to Python object
                        let py_obj = data_to_pycapsule(py, Data::Trade(tick));
                        // Schedule on Python event loop (not current thread)
                        call_python_threadsafe(py, &call_soon, &callback, py_obj);
                    }
                });
            }
            // ... other message types
        }
    }
});
```

**What happens:**

1. Tokio task receives WebSocket message on event loop thread
2. Data is converted to Python object (capsule or Py object)
3. `call_python_threadsafe` schedules callback via `call_soon_threadsafe`
4. Python callback executes on asyncio event loop thread

### Why call_soon_threadsafe is Required

The `call_soon` parameter comes from Python's asyncio event loop:

```rust
// crates/network/src/python/websocket.rs
#[staticmethod]
fn py_connect(
    loop_: Py<PyAny>,  // Python asyncio event loop
    config: WebSocketConfig,
    handler: Py<PyAny>,
    py: Python<'_>,
) -> PyResult<Bound<'_, PyAny>> {
    // Get call_soon_threadsafe from the event loop
    let call_soon_threadsafe: Py<PyAny> = loop_.getattr(py, "call_soon_threadsafe")?;
    // ... pass to message handler
}
```

Python usage:

```python
import asyncio

async def on_trade(trade_data):
    # This callback runs on asyncio event loop thread
    msgbus.send("trades", trade_data)  # Must be on event loop thread

async def main():
    loop = asyncio.get_running_loop()
    client = await WebSocket.connect(loop, config, on_trade)
```

### Why Not Direct call_python?

If Python callbacks interact with the kernel (e.g., `MessageBus.send`), they **must** run on the asyncio event loop thread:

```python
# Python strategy that receives callbacks
class MyStrategy(Strategy):
    def on_quote_tick(self, tick):
        # This calls msgbus.send() internally
        # Must run on asyncio event loop thread!
        self.publish_quote(tick)
```

Using `call_python` directly from Tokio task would violate this requirement:

```rust
// ❌ WRONG: Callback may need to run on event loop thread
tokio::task::spawn(async move {
    Python::attach(|py| {
        let py_obj = data_to_pycapsule(py, Data::Trade(tick));
        call_python(py, &callback, py_obj);  // Runs on Tokio thread!
    });
});
```

```rust
// ✅ CORRECT: Scheduled on asyncio event loop
tokio::task::spawn(async move {
    Python::attach(|py| {
        let py_obj = data_to_pycapsule(py, Data::Trade(tick));
        call_python_threadsafe(py, &call_soon, &callback, py_obj);
    });
});
```

### When Direct call_python is Safe

Databento adapter uses direct `call_python` because its message processor runs in a `pyo3_async_runtimes::tokio::future_into_py` context where the callback doesn't need kernel interaction:

```rust
// crates/adapters/databento/src/python/live.rs
pyo3_async_runtimes::tokio::future_into_py(py, async move {
    while let Some(msg) = msg_rx.recv().await {
        match msg {
            DatabentoMessage::Data(data) => Python::attach(|py| {
                let py_obj = data_to_pycapsule(py, data);
                call_python(py, &callback, py_obj);  // Safe here
            }),
        }
    }
})
```

### Thread Safety Guarantee

`call_python_threadsafe` ensures:

1. Callbacks execute on asyncio event loop thread
2. GIL is properly acquired/released
3. Kernel operations (msgbus, strategies) work correctly
4. No race conditions with Python state

This is critical for high-frequency trading systems where determinism and correctness outweigh minor latency overhead.

## Safety Mechanisms

The system implements robust thread-safe callback execution, ensuring Python interactions remain stable and predictable across different runtime contexts. By leveraging event loop scheduling and carefully managing callback invocation, the architecture prevents potential concurrency issues that could compromise data integrity or system performance.

Key strategies include precise error logging to quickly identify and address potential failures during callback processing, creating a resilient framework for cross-language interactions.