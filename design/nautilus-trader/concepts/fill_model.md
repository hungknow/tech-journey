# FillModel

The `FillModel` is a probabilistic simulation component that models order execution dynamics during backtesting. It addresses a fundamental challenge in backtesting: *even with perfect historical market data, we can't fully simulate how orders may have interacted with other market participants in real-time*.

## Overview

The `FillModel` simulates two key aspects of trading that exist in real markets regardless of data quality:

1. **Queue position for limit orders**: When multiple traders place orders at the same price level, the order's position in the queue affects if and when it gets filled.
2. **Market impact and competition**: When taking liquidity with market orders, you compete with other traders for available liquidity, which can affect your fill price.

## Implementation

The `FillModel` is implemented in both Rust (core) and Python (interface):

- **Rust implementation**: `crates/execution/src/models/fill.rs`
- **Python/Cython interface**: `nautilus_trader/backtest/models/fill.pyx`

### Core Structure

```rust
pub struct FillModel {
    /// The probability of limit order filling if the market rests on its price.
    prob_fill_on_limit: f64,
    /// The probability of stop orders filling if the market rests on its price.
    prob_fill_on_stop: f64,
    /// The probability of order fill prices slipping by one tick.
    prob_slippage: f64,
    /// Random number generator
    rng: StdRng,
}
```

## Configuration Parameters

### `prob_fill_on_limit` (default: `1.0`)

**Purpose**: Simulates the probability of a limit order getting filled when its price level is reached in the market.

**How it works**:

- Simulates your position in the order queue at a given price level
- Applies to all data types (L1/L2/L3 order book, quotes, trades, bars)
- New random probability check occurs each time market price touches your order price (but does not move through it)
- On successful probability check, fills entire remaining order quantity

**Real implementation** (from `crates/execution/src/matching_engine/engine.rs`):

```rust
if order.order_side() == OrderSide::Buy
    && self.core.bid.is_some_and(|bid| bid == order_price)
    && !self.fill_model.is_limit_filled()
{
    // no filled
    return;
}
```

**Examples**:
- `prob_fill_on_limit=0.0`: Limit orders never fill when price matches (simulates being at the very back of the queue)
- `prob_fill_on_limit=0.5`: 50% chance of filling (simulates being in the middle of the queue)
- `prob_fill_on_limit=1.0`: Always fills when price matches (simulates being at the front of the queue)

### `prob_slippage` (default: `0.0`)

**Purpose**: Simulates the probability of experiencing price slippage when executing market orders.

**How it works**:

- Only applies to L1 data types (quotes, trades, bars)
- When triggered, moves fill price one tick against your order direction
- Affects all market-type orders (`MARKET`, `MARKET_TO_LIMIT`, `MARKET_IF_TOUCHED`, `STOP_MARKET`)
- Not utilized with L2/L3 data where order book depth can determine slippage naturally

**Real implementation** (from `crates/execution/src/matching_engine/engine.rs`):

```rust
if self.book_type == BookType::L1_MBP && self.fill_model.is_slipped() {
    fill_px = match order.order_side().as_specified() {
        OrderSideSpecified::Buy => fill_px.add(self.instrument.price_increment()),
        OrderSideSpecified::Sell => fill_px.sub(self.instrument.price_increment()),
    }
}
```

**Examples**:
- `prob_slippage=0.0`: No artificial slippage (idealized scenario)
- `prob_slippage=0.5`: 50% chance of filling one tick worse
- `prob_slippage=1.0`: Always fills one tick worse (consistent adverse price movement)

### `prob_fill_on_stop` (default: `1.0`)

**Status**: ⚠️ **DEPRECATED** - Will be removed in a future version. Use `prob_slippage` instead.

Stop orders convert to market orders when the stop price is touched, so their fill mechanics are controlled by the `prob_slippage` parameter.

## Usage Examples

### Basic Configuration

From `examples/backtest/fx_ema_cross_audusd_ticks.py`:

```python
from nautilus_trader.backtest.models import FillModel

fill_model = FillModel(
    prob_fill_on_limit=0.2,    # 20% chance of limit orders filling
    prob_fill_on_stop=0.95,     # 95% chance of stop orders filling (deprecated)
    prob_slippage=0.5,          # 50% chance of slippage
    random_seed=42,             # For reproducibility
)

engine.add_venue(
    venue=SIM,
    oms_type=OmsType.HEDGING,
    account_type=AccountType.MARGIN,
    base_currency=USD,
    starting_balances=[Money(1_000_000, USD)],
    fill_model=fill_model,
)
```

### Configuration via Importable Config

From `examples/backtest/model_configs_example.py`:

```python
from nautilus_trader.backtest.config import ImportableFillModelConfig

fill_model_config = ImportableFillModelConfig(
    fill_model_path="nautilus_trader.backtest.models:FillModel",
    config_path="nautilus_trader.backtest.config:FillModelConfig",
    config={
        "prob_fill_on_limit": 0.95,  # 95% chance of limit orders filling
        "prob_fill_on_stop": 0.98,   # 98% chance of stop orders filling
        "prob_slippage": 0.05,       # 5% chance of slippage
        "random_seed": 42,           # For reproducibility
    },
)
```

## How FillModel Affects Trading

### Limit Orders

When a limit order's price level is reached:

1. The matching engine checks if the market price matches the limit price
2. If matched, `is_limit_filled()` is called with probability `prob_fill_on_limit`
3. If the check succeeds, the order is filled at the limit price
4. If the check fails, the order remains open (simulating being behind other orders in the queue)

**Impact on trading**:

- Lower `prob_fill_on_limit` values result in fewer filled limit orders
- This can cause strategies to miss entry/exit opportunities
- Higher values (closer to 1.0) simulate better queue position and more fills

### Market Orders

When executing market orders with L1 data:

1. The matching engine determines the fill price from the order book
2. If `prob_slippage` is configured, `is_slipped()` is called
3. If slippage occurs, the fill price is adjusted by one tick against the order direction
4. For L2/L3 data, slippage is determined naturally by order book depth

**Impact on trading**:

- Slippage increases execution costs
- For buy orders: slippage means paying more (one tick above best ask)
- For sell orders: slippage means receiving less (one tick below best bid)
- Higher `prob_slippage` values reduce strategy profitability

### Stop Orders

Stop orders convert to market orders when triggered, so they are affected by:
- `prob_slippage` (for the market order execution)
- `prob_fill_on_stop` (deprecated, legacy behavior)

**Impact on trading**:
- Slippage on stop orders can worsen stop-loss execution
- This is particularly important for risk management strategies

## Advanced Fill Models

The codebase includes several enhanced fill model implementations that provide more sophisticated simulation:

### BestPriceFillModel

Provides unlimited liquidity at best prices. Ideal for testing basic strategy logic without execution friction.

**Location**: `nautilus_trader/backtest/models/fill.pyx:168`

```python
class BestPriceFillModel(FillModel):
    """
    Fill model that executes all orders at the best available price.
    Ideal for testing basic strategy logic.
    """
```

### OneTickSlippageFillModel

Forces exactly one tick of slippage for all orders by placing liquidity one tick away from best prices.

**Location**: `nautilus_trader/backtest/models/fill.pyx:214`

```python
class OneTickSlippageFillModel(FillModel):
    """
    Fill model that forces exactly one tick of slippage for all orders.
    """
```

### TwoTierFillModel

Simulates basic market depth: first 10 contracts at best price, remainder one tick worse.

**Location**: `nautilus_trader/backtest/models/fill.pyx:262`

```python
class TwoTierFillModel(FillModel):
    """
    Fill model with two-tier pricing: first 10 contracts at best price,
    remainder one tick worse.
    """
```

### SizeAwareFillModel

Applies different execution models based on order size. Small orders (≤10) get good liquidity at best prices. Large orders experience price impact.

**Location**: `nautilus_trader/backtest/models/fill.pyx:387`

```python
class SizeAwareFillModel(FillModel):
    """
    Fill model that applies different execution models based on order size.
    Small orders (<=10) get good liquidity at best prices.
    Large orders experience price impact with partial fills at worse prices.
    """
```

### ThreeTierFillModel

Distributes fills across three price levels for realistic market depth simulation.

**Location**: `nautilus_trader/backtest/models/fill.pyx:535`

```python
class ThreeTierFillModel(FillModel):
    """
    Fill model with three-tier pricing for realistic market depth simulation.
    Distributes 100-contract order fills across three price levels:
    - 50 contracts at best price
    - 30 contracts 1 tick worse
    - 20 contracts 2 ticks worse
    """
```

### MarketHoursFillModel

Simulates varying market conditions based on time, implementing wider spreads during low liquidity periods.

**Location**: `nautilus_trader/backtest/models/fill.pyx:615`

### VolumeSensitiveFillModel

Adjusts liquidity based on recent trading volume, creating realistic market depth based on actual market activity.

**Location**: `nautilus_trader/backtest/models/fill.pyx:702`

### CompetitionAwareFillModel

Simulates market competition effects by making only a percentage of visible liquidity actually available.

**Location**: `nautilus_trader/backtest/models/fill.pyx:783`

## Data Type Behavior

The behavior of `FillModel` adapts based on the order book type being used:

### L2/L3 Order Book Data

With full order book depth, the `FillModel` focuses purely on simulating queue position for limit orders through `prob_fill_on_limit`. The order book itself handles slippage naturally based on available liquidity at each price level.

- `prob_fill_on_limit`: ✅ Active - simulates queue position
- `prob_slippage`: ❌ Not used - real order book depth determines price impact

### L1 Order Book Data

With only best bid/ask prices available, the `FillModel` provides additional simulation:

- `prob_fill_on_limit`: ✅ Active - simulates queue position
- `prob_slippage`: ✅ Active - simulates basic price impact since we lack real depth information

### Bar/Quote/Trade Data

When using less granular data, the same behaviors apply as L1:

- `prob_fill_on_limit`: ✅ Active - simulates queue position
- `prob_slippage`: ✅ Active - simulates basic price impact

## Real-World Impact Examples

### Example 1: Conservative Fill Model

```python
fill_model = FillModel(
    prob_fill_on_limit=0.2,  # Only 20% of limit orders fill
    prob_slippage=0.3,        # 30% chance of slippage
    random_seed=42,
)
```

**Impact**:

- Fewer limit order fills → missed trading opportunities
- Some slippage on market orders → higher execution costs
- More conservative backtest results → lower reported returns
- Better represents challenging market conditions

### Example 2: Optimistic Fill Model

```python
fill_model = FillModel(
    prob_fill_on_limit=1.0,  # All limit orders fill
    prob_slippage=0.0,       # No slippage
    random_seed=42,
)
```

**Impact**:

- All limit orders fill when price matches → maximum trading opportunities
- No slippage on market orders → lowest execution costs
- More optimistic backtest results → higher reported returns
- May not represent realistic market conditions

### Example 3: Realistic Fill Model

```python
fill_model = FillModel(
    prob_fill_on_limit=0.8,  # 80% of limit orders fill
    prob_slippage=0.15,      # 15% chance of slippage
    random_seed=42,
)
```

**Impact**:

- Most limit orders fill → good trading opportunity capture
- Occasional slippage → realistic execution costs
- Balanced backtest results → more representative of live trading

## Testing

The `FillModel` is thoroughly tested in:

- **Rust tests**: `crates/execution/src/models/fill.rs` (lines 129-185)
- **Python tests**: `tests/unit_tests/backtest/test_models.py`
- **Enhanced fill models tests**: `tests/unit_tests/backtest/test_enhanced_fill_models.py`

### Test Example

From `tests/unit_tests/backtest/test_models.py`:

```python
def test_is_limit_filled_with_random_seed(self):
    # Arrange
    fill_model = FillModel(
        prob_fill_on_limit=0.5,
        random_seed=42,
    )
    
    # Act, Assert
    assert not fill_model.is_limit_filled()  # Deterministic with seed
```

## Default Behavior

The default `FillModel` configuration is:

```rust
impl Default for FillModel {
    fn default() -> Self {
        Self::new(0.5, 0.5, 0.1, None).unwrap()
    }
}
```

This means:
- `prob_fill_on_limit = 0.5` (50% chance)
- `prob_fill_on_stop = 0.5` (50% chance)
- `prob_slippage = 0.1` (10% chance)
- No random seed (non-deterministic)

However, the Python interface defaults are:
- `prob_fill_on_limit = 1.0` (always fill)
- `prob_fill_on_stop = 1.0` (always fill)
- `prob_slippage = 0.0` (no slippage)

## Important Considerations

1. **Partial Fills**: Supported with L2/L3 order book data. When there is no longer any size available in the order book, no more fills will be generated and the order will remain in a partially filled state.

2. **L1 Data Limitations**: With L1 data, slippage is limited to a fixed 1-tick, at which the system fills the entire order's quantity.

3. **Reproducibility**: Use `random_seed` parameter for deterministic backtest results. Without a seed, results will vary between runs.

4. **Data Quality**: The `FillModel` cannot fully compensate for poor data quality. Higher granularity data (L2/L3) provides more accurate backtesting.

## Future Enhancements

As the `FillModel` continues to evolve, future versions may introduce:

- Partial fill simulation for L1 data
- Variable slippage based on order size
- More complex queue position modeling
- Time-of-day and volatility-based adjustments
- Market microstructure-aware simulation

## Related Documentation

- [Backtesting Concepts](./backtesting.md) - Comprehensive backtesting guide
- [Order Types](../api_reference/model/orders.md) - Understanding different order types
- [Matching Engine](../api_reference/execution/matching_engine.md) - How orders are matched

## Code References

- **Rust Implementation**: `crates/execution/src/models/fill.rs`
- **Python Interface**: `nautilus_trader/backtest/models/fill.pyx`
- **Configuration**: `nautilus_trader/backtest/config.py` (FillModelConfig)
- **Matching Engine Integration**: `crates/execution/src/matching_engine/engine.rs`
- **Examples**: `examples/backtest/fx_ema_cross_audusd_ticks.py`
- **Tests**: `tests/unit_tests/backtest/test_models.py`

