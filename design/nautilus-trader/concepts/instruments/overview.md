# Instruments

Instruments are tradable financial assets that can be bought and sold on various venues. NautilusTrader provides a comprehensive set of instrument types to represent different asset classes and financial products.

## Purpose

Instruments serve as the fundamental data structures that describe the properties and characteristics of tradable assets. They provide the metadata needed for:

- Order creation and validation
- Price and quantity calculations
- Fee computations
- Margin requirements
- Position sizing
- Risk management

## List of Types

- [CurrencyPair](currency_pair.md) - Generic currency pair for spot/cash markets (Fiat FX and Crypto)
- [Equity](equity.md) - Generic equity instrument (stocks)
- [CryptoFuture](crypto_future.md) - Deliverable futures contract with crypto assets as underlying
- [CryptoPerpetual](crypto_perpetual.md) - Crypto perpetual futures contract (perpetual swap)
- [FuturesContract](futures_contract.md) - Generic deliverable futures contract
- [OptionContract](option_contract.md) - Generic option contract instrument
- [Cfd](cfd.md) - Contract for Difference instrument
- [Commodity](commodity.md) - Generic commodity instrument
- [BettingInstrument](betting_instrument.md) - Sports betting instrument
- [BinaryOption](binary_option.md) - Binary option instrument
- [SyntheticInstrument](synthetic_instrument.md) - Synthetic instrument with formula-based pricing

**Note**: Additional instrument types (CryptoFuturesSpread, CryptoOption, CryptoOptionSpread, FuturesSpread, IndexInstrument, OptionSpread, PerpetualContract, TickScheme, TokenizedAsset) are available but may have specialized use cases.

## Use Cases

Instruments are used throughout the trading lifecycle:

- **Market Data Processing**: Instruments provide the structure for processing and normalizing market data from different venues
- **Order Management**: Instruments validate order parameters (price, quantity, size) against instrument constraints
- **Risk Management**: Instruments provide margin requirements and position sizing limits
- **Backtesting**: Instruments enable historical testing with accurate price increments and size constraints
- **Portfolio Management**: Instruments help track positions and calculate portfolio value across different asset classes
- **Fee Calculation**: Instruments provide fee rates for makers and takers
- **Price Calculation**: Instruments enable conversion between different price and quantity representations
- **Cross-Venue Trading**: Instruments normalize different venue specifications into a common format

## Common Properties

All instruments share common properties defined in the `Instrument` trait:

- **Identification**: `id`, `raw_symbol`, `venue`
- **Pricing**: `price_precision`, `price_increment`, `max_price`, `min_price`
- **Sizing**: `size_precision`, `size_increment`, `multiplier`, `lot_size`, `max_quantity`, `min_quantity`
- **Notional**: `max_notional`, `min_notional`
- **Fees**: `maker_fee`, `taker_fee`
- **Margin**: `margin_init`, `margin_maint`
- **Currency**: `base_currency`, `quote_currency`, `settlement_currency`
- **Timing**: `activation_ns`, `expiration_ns`, `ts_event`, `ts_init`
- **Metadata**: `info`, `tick_scheme`

## Instrument Creation

Instruments can be created using either:

- **`new()`**: Panics on invalid parameters (for performance-critical code)
- **`new_checked()`**: Returns `Result` with validation errors (for user-facing code)

## Price and Quantity Operations

Instruments provide methods for working with prices and quantities:

- **`make_price()`**: Convert f64 to Price with proper rounding
- **`make_qty()`**: Convert f64 to Quantity with proper rounding
- **`calculate_notional_value()`**: Calculate notional value for a quantity at a given price
- **`calculate_base_quantity()`**: Calculate base quantity from quote quantity
- **`next_bid_price()`**: Get the next valid bid price
- **`next_ask_price()`**: Get the next valid ask price