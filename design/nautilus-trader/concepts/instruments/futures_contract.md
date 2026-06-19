# FuturesContract

A FuturesContract represents a generic deliverable futures contract instrument. Futures contracts are standardized agreements to buy or sell an asset at a predetermined price at a specified time in the future.

## When to Use

Use FuturesContract when trading:

- **Commodity futures**: Oil (CL), Gold (GC), Corn (ZC) on CME, CBOT
- **Index futures**: S&P 500 (ES), Nasdaq 100 (NQ), Dow Jones (YM)
- **Interest rate futures**: Treasury bonds (ZB), Eurodollar (GE)
- **Currency futures**: EUR/USD (6E), GBP/USD (6B) on CME
- **Energy futures**: Natural gas (NG), Heating oil (HO)
- **Metals futures**: Silver (SI), Copper (HG)

## Example

```rust
use nautilus_model::instruments::FuturesContract;
use nautilus_model::enums::AssetClass;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};
use ustr::Ustr;

// S&P 500 E-mini futures on CME
let es_future = FuturesContract::new(
    InstrumentId::from("ESZ24.GLBX"),
    Symbol::from("ESZ24"),
    AssetClass::Index,
    Some(Ustr::from("XCME")),           // exchange MIC
    Ustr::from("ES"),                    // underlying
    1732492800000000000.into(),          // activation_ns
    1735603200000000000.into(),          // expiration_ns
    Currency::USD(),
    2,                                    // price_precision
    Price::from("0.25"),
    Quantity::from("50"),                 // multiplier ($50 per point)
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
```

## Differences from Other Types

**Vs CryptoFuture**:

- FuturesContract is generic across asset classes vs CryptoFuture is crypto-specific
- FuturesContract does not support inverse pricing vs CryptoFuture can be inverse
- FuturesContract does not support quanto vs CryptoFuture can be quanto
- FuturesContract is more commonly used for traditional markets vs CryptoFuture for crypto

**Vs OptionContract**:

- FuturesContract obligates execution vs OptionContract gives right but not obligation
- FuturesContract has linear payoff vs OptionContract has non-linear payoff
- FuturesContract has simpler margin requirements vs OptionContract has complex Greeks-based margins
- FuturesContract has no strike price vs OptionContract does

**Vs CurrencyPair**:

- FuturesContract has expiration date vs CurrencyPair does not
- FuturesContract uses contract multipliers vs CurrencyPair typically does not
- FuturesContract is for derivative trading vs CurrencyPair is spot trading
- FuturesContract has underlying asset vs CurrencyPair does not

## Example Data

```json
{
  "id": "ESZ24.GLBX",
  "raw_symbol": "ESZ24",
  "asset_class": "Index",
  "exchange": "XCME",
  "underlying": "ES",
  "activation_ns": 1732492800000000000,
  "expiration_ns": 1735603200000000000,
  "currency": "USD",
  "price_precision": 2,
  "price_increment": "0.25",
  "size_increment": "1",
  "size_precision": 0,
  "multiplier": "50",
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

- **Contract listing**: New futures contract becomes available for trading
- **Contract expiration**: Contract reaches expiration and is delisted
- **Roll over events**: Traders move from expiring to new contracts
- **Exchange updates**: Changes to margin requirements, fee structures, tick sizes
- **Market conditions**: Adjustments to max/min price or quantity limits
- **Corporate actions**: Changes to underlying (e.g., index rebalancing)
- **Regulatory changes**: New position limits or reporting requirements
- **Settlement changes**: Updates to settlement procedures or delivery specifications

## Key Properties

- **Asset Class**: Can be any asset class (Equity, Index, Commodity, Currency, Bond)
- **Instrument Class**: Always `InstrumentClass::Future`
- **Expiration**: Has both `activation_ns` and `expiration_ns`
- **Exchange**: Optional MIC (Market Identifier Code) for the exchange
- **Underlying**: String identifier for the underlying asset/index
- **Size Precision**: Always `0` (futures typically trade in whole contracts)
- **Size Increment**: Always `1` (minimum one contract)
- **Multiplier**: Contract multiplier for notional value calculation