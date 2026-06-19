# Cfd (Contract for Difference)

A Cfd represents a Contract for Difference instrument. CFDs are derivative products that allow traders to speculate on price movements without owning the underlying asset.

## When to Use

Use Cfd when trading:

- **Stock CFDs**: Apple, Microsoft CFDs on forex brokers
- **Index CFDs**: S&P 500, FTSE 100 CFDs
- **Commodity CFDs**: Gold, Oil CFDs
- **Cryptocurrency CFDs**: BTC, ETH CFDs (not spot trading)
- **Forex CFDs**: EUR/USD, GBP/JPY CFDs

## Example

```rust
use nautilus_model::instruments::Cfd;
use nautilus_model::enums::AssetClass;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity, Money};

// Gold CFD on a forex broker
let gold_cfd = Cfd::new(
    InstrumentId::from("GOLD-CFD.SIM"),
    Symbol::from("GOLD-CFD"),
    AssetClass::Commodity,
    None,                                 // base_currency (optional)
    Currency::USD(),
    2,                                    // price_precision
    0,                                    // size_precision
    Price::from("0.01"),
    Quantity::from("1"),                  // size_increment (1 oz)
    Some(Quantity::from("100")),          // lot_size (100 oz lots)
    None,                                 // max_quantity
    Some(Quantity::from("1")),            // min_quantity
    None,                                 // max_notional
    Some(Money::new(100.00, Currency::USD())), // min_notional
    None,                                 // max_price
    None,                                 // min_price
    Some(0.05.into()),                    // margin_init (5%)
    Some(0.02.into()),                    // margin_maint (2%)
    None,                                 // maker_fee
    None,                                 // taker_fee
    None,                                 // tick_scheme
    None,                                 // info
    0.into(),                             // ts_event
    0.into(),                             // ts_init
);

// EUR/USD CFD on a forex broker
let eurusd_cfd = Cfd::new(
    InstrumentId::from("EURUSD-CFD.BROKER"),
    Symbol::from("EURUSD-CFD"),
    AssetClass::Fx,
    Some(Currency::EUR()),                // base_currency
    Currency::USD(),
    5,                                    // price_precision
    2,                                    // size_precision
    Price::from("0.00001"),
    Quantity::from("0.01"),
    Some(Quantity::from("1.0")),          // lot_size (1 standard lot)
    None,                                 // max_quantity
    Some(Quantity::from("0.01")),         // min_quantity
    None,                                 // max_notional
    None,                                 // min_notional
    None,                                 // max_price
    None,                                 // min_price
    Some(0.02.into()),                    // margin_init (2%)
    Some(0.01.into()),                    // margin_maint (1%)
    None,                                 // maker_fee
    None,                                 // taker_fee
    None,                                 // tick_scheme
    None,                                 // info
    0.into(),                             // ts_event
    0.into(),                             // ts_init
);
```

## Differences from Other Types

**Vs CurrencyPair**:

- Cfd is leveraged derivative vs CurrencyPair is spot trading
- Cfd supports margin requirements vs CurrencyPair typically does not
- Cfd can have optional base_currency vs CurrencyPair always has base and quote
- Cfd is cash settlement vs CurrencyPair can be physical settlement

**Vs Equity**:

- Cfd is derivative vs Equity represents ownership
- Cfd is leveraged trading vs Equity is unleveraged (typically)
- Cfd has no ISIN vs Equity may have ISIN
- Cfd is cash settlement vs Equity settles in shares

**Vs FuturesContract**:

- Cfd has no expiration date vs FuturesContract does
- Cfd is typically over-the-counter vs FuturesContract is exchange-traded
- Cfd has simpler structure vs FuturesContract has contract specifications
- Cfd may have different margin requirements vs FuturesContract

## Example Data

```json
{
  "id": "GOLD-CFD.SIM",
  "raw_symbol": "GOLD-CFD",
  "asset_class": "Commodity",
  "base_currency": null,
  "quote_currency": "USD",
  "price_precision": 2,
  "size_precision": 0,
  "price_increment": "0.01",
  "size_increment": "1",
  "margin_init": "0.05",
  "margin_maint": "0.02",
  "maker_fee": "0",
  "taker_fee": "0",
  "lot_size": "100",
  "max_quantity": null,
  "min_quantity": "1",
  "max_notional": null,
  "min_notional": "100.00",
  "max_price": null,
  "min_price": null,
  "tick_scheme": null,
  "info": null,
  "ts_event": 0,
  "ts_init": 0
}
```

## Events/Actions That Trigger Updates

- **Market open/close**: Trading hours and session information
- **Margin requirement changes**: Broker changes initial or maintenance margin
- **Fee schedule updates**: Changes to spread, commissions, or overnight fees
- **Leverage adjustments**: Broker changes maximum leverage limits
- **Market condition changes**: Adjustments to max/min price or quantity limits
- **Corporate actions**: Changes to underlying asset
- **Regulatory changes**: New margin requirements or trading restrictions
- **Delisting**: CFD is removed from broker's offering

## Key Properties

- **Asset Class**: Can be any asset class (Fx, Equity, Index, Commodity, Bond)
- **Instrument Class**: Always `InstrumentClass::Cfd`
- **Settlement**: Always cash settlement in quote currency
- **No Expiration**: CFDs typically have no expiration (unlike futures)
- **Leverage**: Supports margin requirements for leveraged trading
- **Multi-currency**: Can represent various asset classes in quote currency