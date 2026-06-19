# CurrencyPair

A CurrencyPair represents a generic currency pair instrument in a spot/cash market. Can represent both Fiat FX and Cryptocurrency pairs.

## When to Use

Use CurrencyPair when trading:

- **Fiat FX pairs**: EUR/USD, GBP/JPY, AUD/CAD
- **Crypto spot pairs**: BTC/USDT, ETH/USDC, SOL/BTC
- **Any spot market where currencies are exchanged**

## Example

```rust
use nautilus_model::instruments::CurrencyPair;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};

// BTC/USDT pair on Binance
let btc_usdt = CurrencyPair::new(
    InstrumentId::from("BTCUSDT.BINANCE"),
    Symbol::from("BTCUSDT"),
    Currency::BTC(),
    Currency::USDT(),
    2,              // price_precision
    6,              // size_precision
    Price::from("0.01"),
    Quantity::from("0.000001"),
    None,           // multiplier
    None,           // lot_size
    None,           // max_quantity
    None,           // min_quantity
    None,           // max_notional
    None,           // min_notional
    None,           // max_price
    None,           // min_price
    None,           // margin_init
    None,           // margin_maint
    None,           // maker_fee
    None,           // taker_fee
    None,           // tick_scheme
    None,           // info
    0.into(),       // ts_event
    0.into(),       // ts_init
);
```

## Differences from Other Types

**Vs CryptoFuture**:

- CurrencyPair has no expiration date (no `activation_ns`, `expiration_ns`)
- CurrencyPair is for spot trading, CryptoFuture is for futures
- CurrencyPair settles immediately vs CryptoFuture settles at expiration

**Vs CryptoPerpetual**:

- CurrencyPair has no expiration date
- CurrencyPair settles immediately vs CryptoPerpetual has funding rate mechanism
- CurrencyPair is for spot vs CryptoPerpetual is for perpetual derivatives

**Vs Cfd**:

- CurrencyPair is physical settlement (actual currency exchange) vs Cfd is cash settlement
- CurrencyPair has no leverage built-in vs Cfd typically includes leverage

## Example Data

```json
{
  "id": "BTCUSDT.BINANCE",
  "raw_symbol": "BTCUSDT",
  "base_currency": "BTC",
  "quote_currency": "USDT",
  "price_precision": 2,
  "size_precision": 6,
  "price_increment": "0.01",
  "size_increment": "0.000001",
  "multiplier": "1",
  "lot_size": null,
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0.001",
  "taker_fee": "0.001",
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

- **Venue connection**: Instrument definition is received from venue on connection
- **Venue configuration updates**: Exchange updates trading rules (fees, limits, tick sizes)
- **Trading pair listing**: New trading pair becomes available
- **Trading pair delisting**: Trading pair is removed from venue
- **Venue maintenance**: Temporary changes to trading parameters
- **Market data updates**: When venue provides updated instrument information through REST API or WebSocket

## Key Properties

- **Asset Class**: Automatically determined as `AssetClass::Cryptocurrency` if either currency is crypto, otherwise `AssetClass::FX`
- **Instrument Class**: Always `InstrumentClass::Spot`
- **Settlement Currency**: Same as quote currency (immediate settlement)
- **Inverse**: Always `false` (never inverse pricing)