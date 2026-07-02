# TestClock Usage Documentation

## Overview

TestClock provides a monotonic clock for backtesting and unit testing in the Nautilus Trader system. Unlike LiveClock which advances with real time, TestClock allows manual control over time progression, enabling deterministic testing and historical data processing.

## Core Functionality

TestClock extends the base Clock interface and provides the following key methods:

- `set_time(to_time_ns)` - Set the clock to a specific timestamp
- `advance_time(to_time_ns, set_time=True)` - Advance clock to a timestamp, optionally setting time
- `timestamp_ns()`, `timestamp_ms()`, `timestamp_us()`, `timestamp()` - Get current time in various formats
- `utc_now()`, `local_now(tz)` - Get current time as datetime objects
- `set_time_alert(name, alert_time, callback)` - Set an alert to fire at a specific time
- `set_timer(name, interval, start_time, stop_time, callback)` - Set a recurring timer
- `cancel_timer(name)` - Cancel a specific timer
- `cancel_timers()` - Cancel all timers

## Use Cases

### Backtesting

In backtesting, TestClock is used by the BacktestEngine to control time progression through historical data. The clock is advanced as data events are processed, simulating the passage of time in the backtest.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock

# Create a test clock for backtesting
clock = TestClock()

# Set initial time to backtest start
clock.set_time(start_time_ns)

# Process data events and advance clock
for data_event in historical_data:
    # Process the event at current clock time
    process_event(data_event)

    # Advance clock to next event's timestamp
    event_handlers = clock.advance_time(data_event.ts_init)

    # Handle any timer events that fired during time advance
    for handler in event_handlers:
        handler.handle()
```

**In BacktestEngine:**

The BacktestEngine uses TestClock through its kernel and components:

```python
# In BacktestEngine.__init__ (nautilus_trader/backtest/engine.pyx)
self._kernel = NautilusKernel(name=type(self).__name__, config=config)
# The kernel initializes with a TestClock internally

# SimulatedExchange receives the TestClock
matching_engine = OrderMatchingEngine(
    instrument=instrument,
    clock=self._clock,  # This is a TestClock
    ...
)

# BacktestExecClient receives the TestClock
exec_client = BacktestExecClient(
    exchange=exchange,
    msgbus=msgbus,
    cache=cache,
    clock=clock,  # This is a TestClock
    ...
)
```

### Historical Data Processing with Bar Aggregation

When processing historical data to create bars, each bar aggregator gets its own TestClock to independently manage time for bar creation. This allows the aggregator to correctly align bar boundaries regardless of the system clock or other aggregators.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock

# In historical mode, each aggregator gets its own TestClock
test_clock = TestClock()
aggregator.set_clock(test_clock)

# Process historical ticks
for tick in historical_ticks:
    aggregator.handle_quote_tick(tick, historical=True)

# The aggregator internally manages time via TestClock:
# - Sets clock to tick timestamp
# - Advances clock and checks for bar boundaries
# - Builds bars at appropriate times
```

**In DataEngine (nautilus_trader/data/engine.pyx:3743-3747):**

```python
if historical:
    # In historical mode we use a TestClock so we can advance time
    # independently from the system clock (which may be ahead)
    if isinstance(aggregator, TimeBarAggregator):
        test_clock = TestClock()
        aggregator.set_clock(test_clock)

    aggregator.set_historical_mode(historical, self.process_historical)
```

**In TimeBarAggregator (nautilus_trader/data/aggregation.pyx:1707-1721):**

```python
cdef void _pre_process_historical_events(self, uint64_t ts_init):
    if self._clock.timestamp_ns() == 0:
        self._clock.set_time(ts_init)
        self.start_timer()

    # Advance this aggregator's independent clock and collect timer events
    event_handlers = self._clock.advance_time(ts_init, set_time=True)

    # Process timer events
    for event_handler in event_handlers:
        if event_handler.event.ts_event == ts_init:
            self._historical_event_at_ts_init = event_handler
            continue

        self._build_bar(event_handler.event)
```

### Historical to Live Data Transition

When transitioning from historical data processing to live data (e.g., warming up with historical data before live trading), aggregators switch from TestClock to LiveClock. This allows the system to process historical data quickly, then transition to real-time processing.

**Sample Code:**

```python
# Phase 1: Process historical data with TestClock
test_clock = TestClock()
aggregator.set_clock(test_clock)
aggregator.set_historical_mode(historical=True, handler=process_historical)

# Feed historical data
for tick in historical_data:
    aggregator.handle_quote_tick(tick)

# Phase 2: Transition to live data
aggregator.stop_timer()
aggregator.set_clock(live_clock)  # Switch to LiveClock
aggregator.set_historical_mode(historical=False, handler=process_live)
aggregator.start_timer()  # Start real-time timer

# Phase 3: Feed live data in real-time
# Live ticks will now be processed with real-time clock
```

**In DataEngine (nautilus_trader/data/engine.pyx:3750-3759):**

```python
else:
    if aggregator.historical_mode:
        # When switching from historical to live mode we unsubscribe from a historical topic
        self._dispose_bar_aggregator(bar_type, historical=True, request_id=request_id)

    if isinstance(aggregator, TimeBarAggregator):
        aggregator.stop_timer()
        aggregator.set_clock(self._clock)  # Switch to LiveClock

    aggregator.set_historical_mode(historical, self.process)
```

### Spread Quote Aggregation in Historical Mode

Similar to bar aggregation, spread quote aggregators use TestClock in historical mode to calculate option Greeks and generate synthetic spreads from historical leg data.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock
from nautilus_trader.risk.greeks import GreeksCalculator

# Create independent TestClock for spread aggregator
test_clock = TestClock()
aggregator.set_clock(test_clock)

# Create GreeksCalculator with TestClock for historical mode
greeks_calculator = GreeksCalculator(cache, test_clock)
aggregator.set_historical_mode(
    historical=True,
    handler=process_historical,
    greeks_calculator=greeks_calculator
)

# Process historical leg quotes
for leg_quote in historical_leg_quotes:
    aggregator.handle_quote_tick(leg_quote)
    # Greeks are calculated using TestClock time
```

**In DataEngine (nautilus_trader/data/engine.pyx:4130-4135):**

```python
if historical:
    # In historical mode we use a TestClock so we can advance time
    # independently from the system clock (which may be ahead)
    test_clock = TestClock()
    aggregator.set_clock(test_clock)
    greeks_calculator = GreeksCalculator(self._cache, test_clock)
    aggregator.set_historical_mode(historical, self.process_historical, greeks_calculator)
```

### Unit Testing

TestClock is extensively used in unit tests to provide deterministic time control and test time-based functionality without waiting for real time to pass.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock
import pytest

class TestMyComponent:
    def setup(self):
        self.clock = TestClock()
        self.handler = []
        self.clock.register_default_handler(self.handler.append)

    def test_time_alert(self):
        # Arrange
        alert_time = self.clock.utc_now() + timedelta(milliseconds=100)
        self.clock.set_time_alert("TEST_ALERT", alert_time)

        # Act
        events = self.clock.advance_time(to_time_ns=millis_to_nanos(150))

        # Assert
        assert len(events) == 1
        assert isinstance(events[0], TimeEventHandler)

    def test_recurring_timer(self):
        # Arrange
        interval = timedelta(milliseconds=100)
        self.clock.set_timer(
            name="TEST_TIMER",
            interval=interval,
            start_time=None,
            stop_time=None,
        )

        # Act
        events = self.clock.advance_time(to_time_ns=millis_to_nanos(400))

        # Assert - should fire 4 times at 100ms, 200ms, 300ms, 400ms
        assert len(events) == 4
```

**In Unit Tests (tests/unit_tests/data/test_engine.py:150):**

```python
class TestDataEngine:
    @pytest.fixture(autouse=True)
    def setup_method(self, tmp_path):
        self.tmp_path = tmp_path
        self.clock = TestClock()
        self.trader_id = TestIdStubs.trader_id()

        self.msgbus = MessageBus(
            trader_id=self.trader_id,
            clock=self.clock,
        )

        self.cache = TestComponentStubs.cache()

        self.portfolio = Portfolio(
            msgbus=self.msgbus,
            cache=self.cache,
            clock=self.clock,
        )

        self.data_engine = DataEngine(
            msgbus=self.msgbus,
            cache=self.cache,
            clock=self.clock,
            config=config,
        )
```

### Backtest Execution with Time-Based Orders

In backtesting, TestClock ensures that time-based orders (GTD, stop orders, trailing stops) are triggered at the correct times as the clock advances through the historical data.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock

# Create TestClock for matching engine
clock = TestClock()
matching_engine = OrderMatchingEngine(
    instrument=instrument,
    clock=clock,
    ...
)

# Submit a GTD (Good-Till-Date) order
order = market_order_with_gtd(
    expiry_time=expiry_datetime,
)
matching_engine.process_order(order)

# Process data and advance clock
for data_event in historical_data:
    matching_engine.process(data_event)
    clock.advance_time(data_event.ts_init)

    # Order will be cancelled when clock passes expiry_time
```

**In OrderMatchingEngine (nautilus_trader/backtest/engine.pyx):**

The matching engine receives the TestClock and uses it for all time-based operations:

```python
cdef class OrderMatchingEngine:
    def __init__(
        self,
        ...
        TestClock clock,
        ...
    ):
        self._clock = clock
        ...

    cpdef void iterate(self, uint64_t ts_init):
        # Check for GTD order expirations
        self._check_gtd_order_expirations()

        # Check trailing stop updates
        self._check_trailing_stops()

        # Check instrument expiration
        self._check_instrument_expiration()

        # All time-based checks use self._clock which is a TestClock
```

## Live Trading with Historical Warmup

In live trading scenarios where historical data is loaded first to warm up indicators before live trading begins, TestClock is used during the historical warmup phase, then replaced with LiveClock for the live phase.

**Sample Code:**

```python
from nautilus_trader.common.component import TestClock, LiveClock

# Phase 1: Historical warmup
test_clock = TestClock()
data_engine = DataEngine(
    msgbus=msgbus,
    cache=cache,
    clock=test_clock,  # Use TestClock for warmup
)

# Subscribe with historical=True
command = SubscribeBars(
    bar_type=bar_type,
    client_id=client_id,
    venue=venue,
    historical=True,  # Process as historical data
)
data_engine.execute(command)

# Load historical data - processed quickly with TestClock
historical_client = BacktestMarketDataClient(...)
historical_client.request_bistorical_bars(...)

# Phase 2: Switch to live
data_engine._clock = live_clock  # Replace with LiveClock
for aggregator in data_engine._bar_aggregators.values():
    aggregator.stop_timer()
    aggregator.set_clock(live_clock)
    aggregator.set_historical_mode(False, data_engine.process)

# Phase 3: Subscribe live data
live_command = SubscribeBars(
    bar_type=bar_type,
    client_id=client_id,
    venue=venue,
    historical=False,  # Now process as live data
)
data_engine.execute(live_command)

# Live ticks are now processed in real-time with LiveClock
```

**Key Points:**

- Historical warmup uses TestClock to process data deterministically and quickly
- Aggregators get their own TestClock instances for independent time management
- The transition to live mode swaps TestClock for LiveClock
- Live ticks are processed with real-time constraints using LiveClock
- This pattern allows strategies to have complete historical context when live trading begins

## Key Differences: TestClock vs LiveClock

- **Time Control:** TestClock allows manual time control (set_time, advance_time), LiveClock advances with real time
- **Determinism:** TestClock provides deterministic execution for testing, LiveClock is non-deterministic
- **Speed:** TestClock can process historical data as fast as possible, LiveClock is bound to real-time
- **Use Cases:** TestClock for backtesting and unit tests, LiveClock for live trading
- **Timers:** TestClock timers fire when clock is advanced, LiveClock timers fire in real time

## Summary

TestClock is a fundamental component in Nautilus Trader that enables:

- Backtesting with deterministic time progression
- Historical data processing and bar aggregation
- Unit testing of time-based functionality
- Historical warmup before live trading
- Independent time management for aggregators and components

The key pattern is: use TestClock when you need control over time progression (backtesting, historical processing, testing), and use LiveClock when you need real-time progression (live trading). The system seamlessly transitions between them when moving from historical to live modes.