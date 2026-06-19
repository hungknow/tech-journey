# Commodity

A Commodity represents a generic commodity instrument. Commodities are raw materials or primary agricultural products that can be bought and sold, such as gold, oil, or wheat.

## When to Use

Use Commodity when trading:

- **Precious metals**: Gold (XAU), Silver (XAG), Platinum, Palladium
- **Energy**: Crude oil (WTI, Brent), Natural gas, Heating oil
- **Agricultural**: Wheat, Corn, Soybeans, Coffee, Sugar
- **Industrial metals**: Copper, Aluminum, Zinc, Nickel
- **Livestock**: Live cattle, Lean hogs

## Example

```rust
use nautilus_model::instruments::Commodity;
use nautilus_model::enums::AssetClass;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity, Money};

// Gold spot on COMEX
let gold = Commodity::new(
    InstrumentId::from("GOLD.COMEX"),
    Symbol::from("GOLD"),
    AssetClass::Commodity,
    Currency::USD(),
    2,                                    // price_precision
    0,                                    // size_precision
    Price::from("0.01"),
    Quantity::from("1"),                  // size_increment (1 troy oz)
    Some(Quantity::from("100")),          // lot_size (100 oz lots)
    None,                                 // max_quantity
    Some(Quantity::from("1")),            // min_quantity
    None,                                 // max_notional
    Some(Money::new(1000.00, Currency::USD())), // min_notional
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

// Natural gas (allows negative prices)
let nat_gas = Commodity::new(
    InstrumentId::from("NG.NYMEX"),
    Symbol::from("NG"),
    AssetClass::Commodity,
    Currency::USD(),
    3,                                    // price_precision
    0,                                    // size_precision
    Price::from("0.001"),
    Quantity::from("1"),                  // size_increment (1 MMBtu)
    Some(Quantity::from("10000")),        // lot_size
    None,                                 // max_quantity
    Some(Quantity::from("1")),            // min_quantity
    None,                                 // max_notional
    None,                                 // min_notional
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

**Vs CurrencyPair**:

- Commodity represents physical goods vs CurrencyPair represents currencies
- Commodity allows negative prices vs CurrencyPair does not
- Commodity has no base currency vs CurrencyPair has base and quote
- Commodity is typically traded in lots vs CurrencyPair in base units

**Vs FuturesContract**:

- Commodity is spot trading vs FuturesContract is derivative trading
- Commodity has no expiration vs FuturesContract has expiration
- Commodity allows negative prices vs FuturesContract typically does not
- Commodity is for immediate delivery vs FuturesContract is for future delivery

**Vs Equity**:

- Commodity represents physical goods vs Equity represents company ownership
- Commodity allows negative prices vs Equity does not
- Commodity has no ISIN vs Equity may have ISIN
- Commodity is for commodities vs Equity is for stocks

## Example Data

```json
{
  "id": "GOLD.COMEX",
  "raw_symbol": "GOLD",
  "asset_class": "Commodity",
  "quote_currency": "USD",
  "price_precision": 2,
  "size_precision": 0,
  "price_increment": "0.01",
  "size_increment": "1",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0",
  "taker_fee": "0",
  "lot_size": "100",
  "max_quantity": null,
  "min_quantity": "1",
  "max_notional": null,
  "min_notional": "1000.00",
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
- **Supply/demand news**: Production changes, inventory reports, geopolitical events
- **Weather events**: Impact on agricultural commodities or energy demand
- **Economic data**: Inflation, GDP, employment affecting commodity demand
- **Exchange updates**: Changes to fee structures, tick sizes, lot sizes
- **Storage capacity changes**: Affecting energy commodities
- **Transportation issues**: Affecting commodity logistics
- **Seasonal patterns**: Regular supply/demand cycles

## Key Properties

- **Asset Class**: Always `AssetClass::Commodity`
- **Instrument Class**: Always `InstrumentClass::Spot`
- **Negative Prices**: Allows negative prices (e.g., electricity, natural gas during oversupply)
- **Physical Delivery**: Typically represents physical commodity delivery
- **No Base Currency**: Single quote currency for pricing
- **Multi-currency**: Can be priced in various currencies (USD, EUR, etc.)