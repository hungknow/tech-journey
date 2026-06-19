# Instruments Documentation

This folder contains comprehensive documentation for all instrument types in NautilusTrader.

## Quick Start

1. Start with [overview.md](overview.md) to understand the purpose and common use cases of instruments
2. Read specific instrument documentation based on your trading needs
3. Each instrument type includes:
   - When to use the instrument type
   - Code examples
   - Differences from similar instrument types
   - Example data structures
   - Events that trigger updates

## Common Instrument Types

### Spot Trading
- [CurrencyPair](currency_pair.md) - Forex and crypto spot pairs
- [Equity](equity.md) - Stocks and shares
- [Commodity](commodity.md) - Raw materials and agricultural products

### Derivatives
- [CryptoFuture](crypto_future.md) - Crypto futures contracts
- [CryptoPerpetual](crypto_perpetual.md) - Perpetual crypto swaps
- [FuturesContract](futures_contract.md) - Generic futures contracts
- [OptionContract](option_contract.md) - Option contracts
- [Cfd](cfd.md) - Contracts for Difference

### Alternative Instruments
- [BettingInstrument](betting_instrument.md) - Sports betting markets
- [BinaryOption](binary_option.md) - Binary outcome instruments
- [SyntheticInstrument](synthetic_instrument.md) - Custom formula-based instruments

## Instrument Selection Guide

**For crypto trading:**
- Spot: Use `CurrencyPair`
- Futures: Use `CryptoFuture` (dated) or `CryptoPerpetual` (perpetual)

**For traditional markets:**
- Stocks: Use `Equity`
- Forex: Use `CurrencyPair`
- Commodities: Use `Commodity` (spot) or `FuturesContract` (derivatives)
- Options: Use `OptionContract`

**For custom strategies:**
- Basket instruments: Use `SyntheticInstrument`
- Sports betting: Use `BettingInstrument`
- Prediction markets: Use `BinaryOption`

## Key Concepts

All instruments share common properties:
- **Identification**: ID, symbol, venue
- **Pricing**: Precision, increments, limits
- **Sizing**: Precision, increments, multipliers
- **Fees**: Maker/taker rates
- **Margins**: Initial and maintenance requirements
- **Currency**: Base, quote, and settlement currencies

## Additional Information

For implementation details, refer to the source code in `crates/model/src/instruments/`.

Each instrument type implements the `Instrument` trait, providing a consistent interface for:
- Price and quantity operations
- Notional calculations
- Tick navigation
- Currency and asset class information