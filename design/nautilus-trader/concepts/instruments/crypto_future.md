# CryptoFuture

A CryptoFuture represents a deliverable futures contract instrument with crypto assets as underlying and for settlement.

## When to Use

Use CryptoFuture when trading:

- **Crypto futures with delivery**: BTC/USDT futures that settle to actual BTC
- **Quarterly futures**: BTCUSD quarterly contracts on exchanges like CME
- **Deliverable crypto derivatives**: Contracts that result in physical delivery of the underlying asset

## Example

```rust
use nautilus_model::instruments::CryptoFuture;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};

// ETH/USDT quarterly futures on Binance
let eth_future = CryptoFuture::new(
    InstrumentId::from("ETHUSDT-240628.BINANCE"),
    Symbol::from("ETHUSDT-240628"),
    Currency::ETH(),                      // underlying
    Currency::USDT(),                     // quote_currency
    Currency::USDT(),                     // settlement_currency
    false,                                // is_inverse
    1719552000000000000.into(),           // activation_ns
    1719600000000000000.into(),           // expiration_ns
    2,                                    // price_precision
    6,                                    // size_precision
    Price::from("0.01"),
    Quantity::from("0.001"),
    None,                                 // multiplier
    Some(Quantity::from("1")),            // lot_size
    None,                                 // max_quantity
    None,                                 // min_quantity
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

**Vs CryptoPerpetual**:

- CryptoFuture has expiration date vs CryptoPerpetual does not
- CryptoFuture settles to physical delivery vs CryptoPerpetual uses funding rates
- CryptoFuture has activation date vs CryptoPerpetual does not
- CryptoFuture is for quarterly/dated contracts vs CryptoPerpetual is for perpetual swaps

**Vs CurrencyPair**:

- CryptoFuture has expiration date vs CurrencyPair does not
- CryptoFuture is derivative trading vs CurrencyPair is spot trading
- CryptoFuture can be inverse vs CurrencyPair is never inverse
- CryptoFuture has underlying asset field vs CurrencyPair does not

**Vs FuturesContract**:

- CryptoFuture specifically for crypto assets vs FuturesContract is generic
- CryptoFuture can be inverse vs FuturesContract is never inverse
- CryptoFuture supports quanto instruments vs FuturesContract does not

## Example Data

```json
{
  "id": "ETHUSDT-240628.BINANCE",
  "raw_symbol": "ETHUSDT-240628",
  "underlying": "ETH",
  "quote_currency": "USDT",
  "settlement_currency": "USDT",
  "is_inverse": false,
  "activation_ns": 1719552000000000000,
  "expiration_ns": 1719600000000000000,
  "price_precision": 2,
  "size_precision": 6,
  "price_increment": "0.01",
  "size_increment": "0.001",
  "multiplier": "1",
  "lot_size": "1",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0.0002",
  "taker_fee": "0.0005",
  "max_quantity": null,
  "min_quantity": null,
  "max_notional": null,
  "min_notional": null,
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
- **Exchange updates**: Changes to margin requirements, fee structures
- **Market conditions**: Adjustments to max/min price or quantity limits
- **Settlement procedures**: Updates to settlement currency or procedures
- **Corporate actions**: Changes to underlying asset (rare for crypto)

## Key Properties

- **Asset Class**: Always `AssetClass::Cryptocurrency`
- **Instrument Class**: Always `InstrumentClass::Future`
- **Expiration**: Has both `activation_ns` and `expiration_ns`
- **Settlement**: Can be linear, inverse, or quanto pricing
- **Multi-currency**: Supports different quote and settlement currencies (quanto)