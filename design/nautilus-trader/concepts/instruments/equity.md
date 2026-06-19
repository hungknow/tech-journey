# Equity

An Equity represents a generic equity instrument (stocks, shares) traded on stock exchanges.

## When to Use

Use Equity when trading:

- **Common stocks**: AAPL, GOOGL, MSFT
- **Preferred stocks**: Various preferred share classes
- **ETFs**: SPY, QQQ, IWM (though some venues may treat these as other instrument types)
- **ADR/GDR**: American/Global Depositary Receipts

## Example

```rust
use nautilus_model::instruments::Equity;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};
use ustr::Ustr;

// Apple Inc. stock on NASDAQ
let apple_stock = Equity::new(
    InstrumentId::from("AAPL.XNAS"),
    Symbol::from("AAPL"),
    Some(Ustr::from("US0378331005")),  // ISIN
    Currency::USD(),
    2,                                  // price_precision
    Price::from("0.01"),
    None,                               // lot_size
    None,                               // max_quantity
    None,                               // min_quantity
    None,                               // max_price
    None,                               // min_price
    None,                               // margin_init
    None,                               // margin_maint
    None,                               // maker_fee
    None,                               // taker_fee
    None,                               // tick_scheme
    None,                               // info
    0.into(),                           // ts_event
    0.into(),                           // ts_init
);
```

## Differences from Other Types

**Vs CurrencyPair**:

- Equity has ISIN (International Securities Identification Number) vs CurrencyPair does not
- Equity has no base currency (single currency) vs CurrencyPair has base and quote currencies
- Equity size_precision is always 0 (whole shares) vs CurrencyPair can have fractional precision

**Vs FuturesContract**:

- Equity has no expiration date (no `activation_ns`, `expiration_ns`) vs FuturesContract does
- Equity is spot trading vs FuturesContract is derivative trading
- Equity has no multiplier (always 1) vs FuturesContract can have contract multipliers

**Vs Cfd**:

- Equity represents ownership in a company vs Cfd is a derivative contract
- Equity is spot trading vs Cfd is leveraged trading
- Equity settles in shares vs Cfd settles in cash

## Example Data

```json
{
  "id": "AAPL.XNAS",
  "raw_symbol": "AAPL",
  "isin": "US0378331005",
  "currency": "USD",
  "price_precision": 2,
  "price_increment": "0.01",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0",
  "taker_fee": "0",
  "lot_size": null,
  "max_quantity": null,
  "min_quantity": null,
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
- **Corporate actions**: Stock splits, dividends, mergers, acquisitions
- **Exchange updates**: Changes to trading rules, fee structures, or tick sizes
- **Corporate events**: Earnings announcements, guidance updates
- **Regulatory changes**: New reporting requirements or trading restrictions
- **Delisting**: Company is removed from exchange
- **Symbol changes**: Company ticker symbol changes (e.g., due to rebranding)

## Key Properties

- **Asset Class**: Always `AssetClass::Equity`
- **Instrument Class**: Always `InstrumentClass::Spot`
- **ISIN**: Optional International Securities Identification Number for regulatory purposes
- **Size Precision**: Always `0` (equities typically trade in whole shares)
- **Size Increment**: Always `1` (minimum one share)
- **Multiplier**: Always `1` (each contract represents one share)