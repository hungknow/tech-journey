# SyntheticInstrument

A SyntheticInstrument represents a synthetic instrument with prices derived from component instruments using a formula. It allows creation of custom instruments that combine or transform existing market data.

## When to Use

Use SyntheticInstrument when creating:

- **Basket indices**: Weighted averages of multiple instruments
- **Spread instruments**: Price differences between related instruments
- **Arbitrage combinations**: Multi-leg strategies as single instruments
- **Custom indicators**: Technical indicators calculated from multiple inputs
- **Correlation instruments**: Products or ratios of related assets
- **Volatility instruments**: Standard deviation or variance calculations
- **Benchmark instruments**: Custom benchmarks tracking specific portfolios

## Example

```rust
use nautilus_model::instruments::SyntheticInstrument;
use nautilus_model::identifiers::{InstrumentId, Symbol};

// BTC-LTC average price synthetic instrument
let btc_ltc_avg = SyntheticInstrument::new(
    Symbol::from("BTC-LTC-AVG"),
    2,                                    // price_precision
    vec![
        InstrumentId::from("BTC.BINANCE"),
        InstrumentId::from("LTC.BINANCE"),
    ],
    "(BTC.BINANCE + LTC.BINANCE) / 2.0",   // formula
    0.into(),                             // ts_event
    0.into(),                             // ts_init
);

// Calculate price from component prices
let price = btc_ltc_avg.calculate(&[100.0, 200.0]).unwrap();
// Result: Price::from("150.0")

// Gold-silver ratio synthetic instrument
let gold_silver_ratio = SyntheticInstrument::new(
    Symbol::from("AU-AG-RATIO"),
    4,                                    // price_precision
    vec![
        InstrumentId::from("GOLD.COMEX"),
        InstrumentId::from("SILVER.COMEX"),
    ],
    "GOLD.COMEX / SILVER.COMEX",           // formula
    0.into(),
    0.into(),
);
```

## Differences from Other Types

**Vs FuturesSpread**:

- SyntheticInstrument supports arbitrary formulas vs FuturesSpread has fixed structure
- SyntheticInstrument can combine any instruments vs FuturesSpread is for futures only
- SyntheticInstrument is more flexible vs FuturesSpread is specialized for calendar spreads
- SyntheticInstrument requires manual formula vs FuturesSpread has built-in logic

**Vs OptionSpread**:

- SyntheticInstrument can create custom spreads vs OptionSpread is predefined strategies
- SyntheticInstrument supports mathematical operations vs OptionSpread has specific Greeks
- SyntheticInstrument is more general purpose vs OptionSpread is options-specific
- SyntheticInstrument can handle any instruments vs OptionSpread is for options only

**Vs InstrumentAny**:

- SyntheticInstrument creates derived instruments vs InstrumentAny is a union type
- SyntheticInstrument calculates prices dynamically vs InstrumentAny stores data
- SyntheticInstrument is compositional vs InstrumentAny is categorical
- SyntheticInstrument enables custom strategies vs InstrumentAny enables polymorphism

## Example Data

```json
{
  "id": "BTC-LTC-AVG.SYNTH",
  "price_precision": 2,
  "price_increment": "0.01",
  "components": ["BTC.BINANCE", "LTC.BINANCE"],
  "formula": "(BTC.BINANCE + LTC.BINANCE) / 2.0",
  "ts_event": 0,
  "ts_init": 0
}
```

## Events/Actions That Trigger Updates

- **Component price updates**: New prices from any component instrument trigger recalculation
- **Formula changes**: Updates to derivation formula (via `change_formula()`)
- **Component changes**: Adding/removing component instruments
- **Precision adjustments**: Changes to price precision or increments
- **Validation failures**: Formula compilation errors or missing inputs
- **Market data gaps**: Missing prices from components causing calculation failures

## Key Properties

- **Venue**: Always `SYNTH` (synthetic venue)
- **Formula-based**: Uses mathematical expressions to derive prices
- **Dynamic calculation**: Prices calculated in real-time from component inputs
- **Error handling**: Comprehensive error types for validation and calculation issues
- **Flexibility**: Supports arbitrary mathematical operations and functions
- **Component binding**: Maps formula variables to component instrument IDs
- **Performance optimized**: Uses inline buffers for small component sets

## Formula Syntax

Supports standard mathematical expressions:

- **Basic operations**: `+`, `-`, `*`, `/`
- **Functions**: `sin`, `cos`, `exp`, `log`, `sqrt`, `abs`, `min`, `max`
- **Constants**: `PI`, `E`
- **Parentheses**: `(expression)`
- **Variables**: Component instrument IDs (e.g., `BTC.BINANCE`)

Example formulas:

```rust
// Weighted average
"(BTC.BINANCE * 0.7 + ETH.BINANCE * 0.3)"

// Spread
"ESZ24.GLBX - ESH25.GLBX"

// Ratio
"GOLD.COMEX / SILVER.COMEX"

// Volatility approximation
"sqrt(pow((BTC.BINANCE - BTC.BINANCE_LAG1), 2))"
```

## Error Handling

Comprehensive error types for various failure modes:

- **SyntheticInstrumentError::Validation**: Input validation failures
- **SyntheticInstrumentError::Expression**: Formula parsing/evaluation errors
- **SyntheticInstrumentError::MissingInput**: Required component price not provided
- **SyntheticInstrumentError::InputCountMismatch**: Wrong number of input values
- **SyntheticInstrumentError::NonFiniteInput**: NaN or infinity in input values
- **SyntheticInstrumentError::InvalidPriceResult**: Formula produced invalid price

## Validation

- **Formula compilation**: Validates formula syntax and variable references
- **Input validation**: Checks for finite values and correct input count
- **Price validation**: Ensures calculated prices are valid (finite, within precision)
- **Component verification**: Confirms all referenced components exist in the component list