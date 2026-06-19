# CryptoPerpetual

A CryptoPerpetual represents a crypto perpetual futures contract instrument (also known as a perpetual swap). Unlike traditional futures, perpetual swaps have no expiration date and use a funding rate mechanism to keep the contract price close to the spot price.

## When to Use

Use CryptoPerpetual when trading:

- **Perpetual swaps**: BTC/USDT-PERP, ETH/USDT-PERP on exchanges like Binance, Bybit
- **Inverse perpetuals**: XBTUSD-PERP on BitMEX (priced in USD but settled in BTC)
- **Quanto perpetuals**: Contracts settled in different currency from quote currency
- **Leveraged crypto trading**: Up to 125x leverage on some venues

## Example

```rust
use nautilus_model::instruments::CryptoPerpetual;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity, Money};

// BTC/USDT perpetual on Binance
let btc_perp = CryptoPerpetual::new(
    InstrumentId::from("BTCUSDT-PERP.BINANCE"),
    Symbol::from("BTCUSDT-PERP"),
    Currency::BTC(),                      // base_currency
    Currency::USDT(),                     // quote_currency
    Currency::USDT(),                     // settlement_currency
    false,                                // is_inverse
    2,                                    // price_precision
    3,                                    // size_precision
    Price::from("0.01"),
    Quantity::from("0.001"),
    None,                                 // multiplier
    Some(Quantity::from("1")),            // lot_size
    Some(Quantity::from("10000.0")),      // max_quantity
    Some(Quantity::from("0.001")),        // min_quantity
    None,                                 // max_notional
    Some(Money::new(10.00, Currency::USDT())), // min_notional
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

// Inverse perpetual on BitMEX
let xbt_perp = CryptoPerpetual::new(
    InstrumentId::from("XBTUSD-PERP.BITMEX"),
    Symbol::from("XBTUSD-PERP"),
    Currency::BTC(),                      // base_currency
    Currency::USD(),                      // quote_currency
    Currency::BTC(),                      // settlement_currency (inverse!)
    true,                                 // is_inverse
    1,                                    // price_precision
    0,                                    // size_precision
    Price::from("0.5"),
    Quantity::from("1"),
    None,                                 // multiplier
    Some(Quantity::from("1")),            // lot_size
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

**Vs CryptoFuture**:

- CryptoPerpetual has no expiration date vs CryptoFuture does
- CryptoPerpetual uses funding rates vs CryptoFuture settles physically
- CryptoPerpetual is for perpetual swaps vs CryptoFuture is for quarterly contracts
- CryptoPerpetual never has activation date vs CryptoFuture does

**Vs CurrencyPair**:

- CryptoPerpetual supports leverage vs CurrencyPair is spot trading
- CryptoPerpetual can be inverse vs CurrencyPair is never inverse
- CryptoPerpetual has funding rate mechanism vs CurrencyPair does not
- CryptoPerpetual supports lot sizes vs CurrencyPair typically does not

**Vs PerpetualContract**:

- CryptoPerpetual is specific to crypto assets vs PerpetualContract is generic
- CryptoPerpetual supports inverse and quanto pricing vs PerpetualContract may not
- CryptoPerpetual is optimized for crypto market conventions vs PerpetualContract is general-purpose

## Example Data

```json
{
  "id": "BTCUSDT-PERP.BINANCE",
  "raw_symbol": "BTCUSDT-PERP",
  "base_currency": "BTC",
  "quote_currency": "USDT",
  "settlement_currency": "USDT",
  "is_inverse": false,
  "price_precision": 2,
  "size_precision": 3,
  "price_increment": "0.01",
  "size_increment": "0.001",
  "multiplier": "1",
  "lot_size": "1",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0.0002",
  "taker_fee": "0.0004",
  "max_quantity": "10000.0",
  "min_quantity": "0.001",
  "max_notional": null,
  "min_notional": "10.00",
  "max_price": null,
  "min_price": null,
  "tick_scheme": null,
  "info": null,
  "ts_event": 0,
  "ts_init": 0
}
```

## Events/Actions That Trigger Updates

- **Funding rate changes**: Periodic updates to funding rates (typically every 8 hours)
- **Leverage adjustments**: Exchange changes maximum leverage limits
- **Risk parameter updates**: Changes to margin requirements, liquidation thresholds
- **Fee schedule changes**: Updates to maker/taker fees or fee tiers
- **Market condition changes**: Adjustments to max/min price or quantity limits during volatility
- **Liquidity changes**: Updates to min_notional requirements
- **Exchange maintenance**: Temporary changes to trading parameters

## Key Properties

- **Asset Class**: Always `AssetClass::Cryptocurrency`
- **Instrument Class**: Always `InstrumentClass::Swap`
- **Expiration**: No expiration (perpetual trading)
- **Settlement**: Can be linear, inverse, or quanto pricing
- **Funding Rate**: Not stored in instrument but applied periodically
- **Multi-currency**: Supports different quote and settlement currencies (quanto)