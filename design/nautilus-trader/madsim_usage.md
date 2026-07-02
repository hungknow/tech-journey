# Madsim Usage

## Purpose of Madsim

Madsim is a deterministic simulation testing (DST) runtime that replaces the Tokio async runtime with a seed-controlled deterministic scheduler. It intercepts `tokio` primitives to provide reproducible async behavior where task scheduling, timer firings, and random values are fully determined by a single integer seed. Two runs with the same seed, binary, and configuration produce identical observable behavior, making race conditions and timing-sensitive bugs reproducible.

## What Madsim Is NOT Used For

**Backtesting** does NOT use madsim. The backtest engine (`nautilus-backtest`) uses a completely different time control mechanism called `TestClock` with manual static time control. When backtesting with bars that have `ts_event` timestamps, the engine manually sets the clock to match each data point's timestamp:

```rust
// crates/backtest/src/engine.rs:1232
let ts_event = handler.event.ts_event;  // Timestamp from historical bar data
Self::set_all_clocks_time(clocks, ts_event);  // Manual clock control

fn set_all_clocks_time(clocks: &[Rc<RefCell<dyn Clock>>], ts: UnixNanos) {
    for clock in clocks {
        let test_clock = clock.borrow_mut().as_any_mut()
            .downcast_mut::<TestClock>()
            .expect("BacktestEngine requires TestClock");
        test_clock.set_time(ts);  // Manually set time to match historical data
    }
}
```

**Key Differences:**

- Backtesting follows exact historical timestamps from data (`ts_event`)
- Madsim DST simulates realistic async behavior with virtual time advancement
- Backtesting uses `TestClock` with manual `set_time()` calls
- Madsim uses `madsim::runtime::Runtime` with virtual time controlled by async operations
- The two approaches are mutually exclusive and serve different purposes

## Use Cases

### Deterministic Async Task Scheduling

Madsim provides deterministic task scheduling by swapping the runtime for tokio primitives (`time`, `task`, `runtime`, `signal`) through feature-gated re-exports in the `nautilus_common::live::dst` module. When both the `simulation` feature and `cfg(madsim)` are active, async tasks execute in a fixed order determined by the seed rather than the OS scheduler, eliminating flaky race conditions in tests.

**Code Example:**
```rust
// crates/common/src/live/dst.rs
pub mod task {
    #[cfg(all(feature = "simulation", madsim))]
    pub use madsim::task::{JoinHandle, spawn, spawn_local, yield_now};
    #[cfg(not(all(feature = "simulation", madsim)))]
    pub use tokio::task::{JoinHandle, spawn, spawn_local, yield_now};
}
```

**Why This Helps:**

- Eliminates non-deterministic task interleaving that causes flaky tests
- Makes race conditions reproducible with a single seed value
- Allows systematic exploration of different interleavings by varying the seed
- Catches ordering bugs that only appear under specific OS scheduling patterns

### Virtual Time Control

Monotonic time reads and time-based operations route through `nautilus_common::live::dst::time` (or `nautilus_network::dst::time` for network code). Under simulation, time advances instantly based on virtual sleep calls rather than real wall-clock time, enabling fast execution of time-dependent code and deterministic timer behavior without waiting for real clock progression.

**Code Example:**
```rust
// crates/network/src/dst.rs
pub mod time {
    #[cfg(all(feature = "simulation", madsim))]
    pub use madsim::time::{Instant, sleep, timeout};
    #[cfg(not(all(feature = "simulation", madsim)))]
    pub use tokio::time::{Instant, sleep, timeout};
}

// Virtual time test with sub-millisecond precision
#[cfg(all(feature = "simulation", madsim))]
#[madsim::test]
async fn test_dst_sleep_uses_virtual_time() {
    let start = time::Instant::now();
    time::sleep(time::Duration::from_millis(100)).await;
    let elapsed = start.elapsed();
    assert!(elapsed >= time::Duration::from_millis(100));
    assert!(elapsed < time::Duration::from_millis(101), // No OS jitter
        "virtual sleep showed real-tokio jitter: {elapsed:?}");
}
```

**Why This Helps:**

- Tests run instantly instead of waiting for real time (sleep(100ms) completes in microseconds)
- Eliminates OS scheduler jitter that makes timing-based tests flaky
- Enables testing of long-running scenarios (hours/days) in milliseconds
- Provides deterministic timeout behavior for testing retry logic and backoff strategies

### Deterministic Wall-Clock Time

Wall-clock reads route through `nautilus_core::time::duration_since_unix_epoch`, which under simulation returns virtual time from `madsim::time::TimeHandle::try_current()`. This preserves Unix-epoch semantics for order and fill timestamps while making them reproducible, enabling deterministic backtesting and simulation scenarios.

**Code Example:**
```rust
// crates/core/src/time.rs
fn wall_clock_now() -> SystemTime {
    #[cfg(not(all(feature = "simulation", madsim)))]
    {
        SystemTime::now()
    }
    #[cfg(all(feature = "simulation", madsim))]
    {
        match madsim::time::TimeHandle::try_current() {
            Some(handle) => handle.now_time(), // Virtual wall-clock
            None => SystemTime::now(),
        }
    }
}

pub fn nanos_since_unix_epoch() -> u64 {
    u64::try_from(duration_since_unix_epoch().as_nanos())
        .expect("System time overflow: value exceeds u64::MAX nanoseconds")
}
```

**Why This Helps:**

- Preserves real-world timestamp semantics (Unix epoch) for trading operations
- Makes order timestamps, fill times, and event sequencing reproducible in tests
- Enables accurate backtesting with deterministic time progression
- Allows validation of time-based business logic (market hours, settlement, etc.)

### Seeded Random Number Generation

UUID generation and fill model RNG route through `madsim::rand::thread_rng()` when running inside a madsim runtime. This ensures all random values (UUIDs, probabilistic fills, shuffled orders) are reproducible from a seed, which is critical for deterministic simulation testing of trading strategies and execution logic.

**Code Example:**
```rust
// crates/core/src/uuid.rs
pub fn new_bytes() -> [u8; 16] {
    let mut bytes = [0u8; 16];
    #[cfg(all(feature = "simulation", madsim))]
    {
        if madsim::runtime::Handle::try_current().is_ok() {
            MadsimRngCore::fill_bytes(&mut madsim::rand::thread_rng(), &mut bytes);
        } else {
            rand::rng().fill_bytes(&mut bytes); // dst-ok: tests outside runtime
        }
    }
    #[cfg(not(all(feature = "simulation", madsim)))]
    rand::rng().fill_bytes(&mut bytes);

    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Set the version to 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Set the variant to RFC 4122
    bytes
}
```

**Why This Helps:**

- Makes randomized test behavior reproducible with a single seed
- Enables validation of strategies that depend on probabilistic fills
- Allows debugging of rare random behaviors by replaying with the same seed
- Ensures UUID generation doesn't introduce non-determinism in event ordering

### Compile-Time Validation

The `check-dst-conventions` pre-commit hook enforces structural conditions to maintain determinism: banning direct `SystemTime::now` and `Instant::now` reads, requiring `biased;` in `select!` blocks, and ensuring iteration-order-sensitive collections use `IndexMap`/`IndexSet` rather than `AHashMap`/`AHashSet`. This prevents silent fallbacks to non-deterministic sources.

**Code Example:**
```bash
# .pre-commit-hooks/check_dst_conventions.sh
# Rule 3: No unbiased tokio::select! (must have `biased;` as first token in block)
if echo "$next_window" | grep -q 'biased;'; then
    continue # Valid biased select
else
    echo "${RED}ERROR: tokio::select! missing 'biased;' in first 3 lines"
    echo "Add 'biased;' as the first token inside the select! block${NC}"
    ((VIOLATIONS++))
fi
```

**Why This Helps:**

- Prevents accidental introduction of non-deterministic code paths
- Catches violations at commit time before they reach CI
- Maintains determinism contract without relying on code review attention
- Provides clear error messages explaining why violations matter

### Stress Testing Under Deterministic Conditions

The `cargo-test-sim` make target compiles in-scope crates under `cfg(madsim)` with the `simulation` feature and runs all sim-compatible tests across `nautilus-common`, `nautilus-network`, `nautilus-execution`, and `nautilus-core`. This exposes timing-sensitive bugs and validates DST seam correctness before they reach CI.

**Code Example:**
```makefile
# Makefile:738
.PHONY: cargo-test-sim
cargo-test-sim: export RUSTFLAGS=--cfg madsim
cargo-test-sim:
    cargo build -p nautilus-common -p nautilus-core -p nautilus-network \
                -p nautilus-execution --tests --lib --features simulation
    cargo nextest run -p nautilus-common --features simulation
    cargo nextest run -p nautilus-network --features simulation
    cargo nextest run -p nautilus-execution --features simulation
```

**Why This Helps:**

- Validates that all DST seams compile correctly under madsim
- Catches regressions in determinism before code is merged
- Tests both standard and high-precision configurations
- Provides fast feedback loop for developers working on DST paths

### Network Simulation Compatibility

Test modules that drive real localhost sockets are cfg-gated out under `all(feature = "simulation", madsim)` because their production paths reach madsim time primitives which panic outside a madsim runtime. Retry test modules use `cfg_attr` to swap between `#[tokio::test(start_paused = true)]` and `#[madsim::test]`, allowing both real and virtual time testing from the same test body.

**Code Example:**
```rust
// crates/network/src/websocket/client.rs:2205
#[cfg(test)]
#[cfg(not(feature = "turmoil"))]
#[cfg(not(all(feature = "simulation", madsim)))] // transport-layer I/O not simulated
#[cfg(target_os = "linux")] // Only run network tests on Linux (CI stability)
mod tests {
    // Real socket tests only run outside madsim simulation
}
```

**Why This Helps:**

- Prevents tests from mixing real and virtual time sources (which causes panics)
- Allows reuse of test logic across real tokio and madsim environments
- Ensures network tests only run on appropriate platforms/configurations
- Maintains clean separation between integration and simulation test suites

### Signal Injection in Tests

The `signal::ctrl_c` re-export in `nautilus_common::live::dst::signal` routes to `madsim::signal::ctrl_c` under simulation, allowing test code to inject ctrl_c signals via `madsim::runtime::Handle::send_ctrl_c()` for deterministic shutdown testing of live trading nodes.

**Code Example:**
```rust
// crates/common/src/live/dst.rs
pub mod signal {
    #[cfg(all(feature = "simulation", madsim))]
    pub use madsim::signal::ctrl_c;
    #[cfg(not(all(feature = "simulation", madsim)))]
    pub use tokio::signal::ctrl_c;
}
```

**Why This Helps:**

- Enables testing of shutdown behavior without requiring manual signal handling
- Makes signal-driven code paths deterministic and testable
- Allows validation of graceful shutdown sequences under stress
- Eliminates timing uncertainty in signal handling tests

### Enforcement Through Pre-Commit Hooks

The DST contract is enforced at commit time by the `check-dst-conventions` hook in `.pre-commit-hooks/check_dst_conventions.sh`, which fails commits that add banned patterns like raw clock reads, unseeded RNG, or thread spawning to the DST path, ensuring determinism is maintained without relying on reviewer attention.

**Code Example:**
```bash
# .pre-commit-hooks/check_dst_conventions.sh:1
#!/usr/bin/env bash
# Enforces deterministic simulation testing (DST) path bans in the in-scope crates.
#
# Rules (all applied to production code in the 16 in-scope crates):
#   1. No direct std::time::Instant::now(), std::time::SystemTime::now(), or
#      chrono::Utc::now() reads
#   2. No raw RNG entries (rand::thread_rng, rand::rng(), fastrand::,
#      getrandom::, OsRng, uuid::Uuid::new_v4) without cfg gating
#   3. No unbiased tokio::select! (must have `biased;` as first token in block)
#   4. No raw thread spawning without cfg gating
#   5. No AHashMap / AHashSet in iteration-order-sensitive files
#   6. No direct tokio::net::TcpStream::connect / tokio::net::TcpListener::bind
```

**Why This Helps:**

- Provides automated enforcement of determinism rules at the commit boundary
- Catches violations before they enter the codebase review process
- Reduces reviewer burden by catching deterministic violations automatically
- Maintains the DST contract through CI gate validation
