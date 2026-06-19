# OptionContract

An OptionContract represents a generic option contract instrument. Options give the holder the right, but not the obligation, to buy or sell an underlying asset at a specified price on or before a specified date.

## When to Use

Use OptionContract when trading:

- **Equity options**: AAPL calls/puts, SPY options
- **Index options**: SPX options, VIX options
- **Futures options**: Options on ES futures, GC futures
- **Currency options**: EUR/USD options on CME
- **Commodity options**: Options on gold, oil futures

## Example

```rust
use nautilus_model::instruments::OptionContract;
use nautilus_model::enums::{AssetClass, OptionKind};
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};
use ustr::Ustr;

// AAPL $150 Call option expiring Dec 17, 2021
let aapl_call = OptionContract::new(
    InstrumentId::from("AAPL211217C00150000.OPRA"),
    Symbol::from("AAPL211217C00150000"),
    AssetClass::Equity,
    Some(Ustr::from("GMNI")),           // exchange MIC
    Ustr::from("AAPL"),                  // underlying
    OptionKind::Call,
    Price::from("150.0"),                // strike price
    Currency::USD(),
    1639713600000000000.into(),          // activation_ns
    1639756800000000000.into(),          // expiration_ns
    2,                                    // price_precision
    Price::from("0.01"),
    Quantity::from("100"),               // multiplier (100 shares per contract)
    Quantity::from("1"),                  // lot_size
    None,                                 // max_quantity
    None,                                 // min_quantity
    None,                                 // max_price
    None,                                 // min_price
    None,                                 // margin_init
    None,                                 // margin_maint
    None,                                 // maker_fee
    None,                                 // taker_fee
    None,                                 // tick_scheme
    None,                                 // info
    0.into(),                             // ts_event
    0.into(),                             // ts_init
);

// AAPL $140 Put option
let aapl_put = OptionContract::new(
    InstrumentId::from("AAPL211217P00140000.OPRA"),
    Symbol::from("AAPL211217P00140000"),
    AssetClass::Equity,
    Some(Ustr::from("GMNI")),
    Ustr::from("AAPL"),
    OptionKind::Put,
    Price::from("140.0"),                // strike price
    Currency::USD(),
    1639713600000000000.into(),
    1639756800000000000.into(),
    2,
    Price::from("0.01"),
    Quantity::from("100"),
    Quantity::from("1"),
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    0.into(),
    0.into(),
);
```

## Differences from Other Types

**Vs FuturesContract**:

- OptionContract gives right (not obligation) vs FuturesContract obligates execution
- OptionContract has non-linear payoff vs FuturesContract has linear payoff
- OptionContract has strike price vs FuturesContract does not
- OptionContract has option kind (CALL/PUT) vs FuturesContract does not
- OptionContract requires complex margin calculations vs FuturesContract simpler

**Vs OptionSpread**:

- OptionContract is single leg vs OptionSpread is multi-leg strategy
- OptionContract has simpler margin vs OptionSpread may have reduced margin due to offset
- OptionContract is basic building block vs OptionSpread is composite strategy

**Vs Equity**:

- OptionContract has expiration date vs Equity does not
- OptionContract has strike price vs Equity does not
- OptionContract has option kind vs Equity does not
- OptionContract is derivative vs Equity is underlying

## Example Data

```json
{
  "id": "AAPL211217C00150000.OPRA",
  "raw_symbol": "AAPL211217C00150000",
  "asset_class": "Equity",
  "exchange": "GMNI",
  "underlying": "AAPL",
  "option_kind": "Call",
  "strike_price": "150.0",
  "activation_ns": 1639713600000000000,
  "expiration_ns": 1639756800000000000,
  "currency": "USD",
  "price_precision": 2,
  "price_increment": "0.01",
  "size_increment": "1",
  "size_precision": 0,
  "multiplier": "100",
  "lot_size": "1",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0",
  "taker_fee": "0",
  "max_quantity": null,
  "min_quantity": "1",
  "max_price": null,
  "min_price": null,
  "tick_scheme": null,
  "info": null,
  "ts_event": 0,
  "ts_init": 0
}
```

## Events/Actions That Trigger Updates

- **Option listing**: New option series becomes available for trading
- **Option expiration**: Option reaches expiration and is delisted/exercised
- **Corporate actions**: Stock splits, mergers, acquisitions affect underlying
- **Dividend declarations**: Early exercise considerations for call options
- **Volatility changes**: Implied volatility affects option pricing
- **Exercise assignments**: Options are exercised or assigned
- **Exchange updates**: Changes to margin requirements, fee structures
- **Market conditions**: Adjustments to max/min price or quantity limits

## Key Properties

- **Asset Class**: Can be any asset class (Equity, Index, Commodity, Currency, Bond)
- **Instrument Class**: Always `InstrumentClass::Option`
- **Expiration**: Has both `activation_ns` and `expiration_ns`
- **Option Kind**: Either `OptionKind::Call` or `OptionKind::Put`
- **Strike Price**: The price at which the option can be exercised
- **Exchange**: Optional MIC (Market Identifier Code) for the exchange
- **Underlying**: String identifier for the underlying asset
- **Size Precision**: Always `0` (options typically trade in whole contracts)
- **Size Increment**: Always `1` (minimum one contract)
- **Multiplier**: Contract multiplier (typically 100 for equity options)