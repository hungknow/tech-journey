# BinaryOption

A BinaryOption represents a generic binary option instrument. Binary options have a fixed payout if the condition is met at expiration, otherwise they expire worthless.

## When to Use

Use BinaryOption when trading:

- **Binary options**: Yes/No financial instruments with fixed payouts
- **Prediction markets**: Polymarket, Augur outcome tokens
- **Event contracts**: Economic indicator predictions, election outcomes
- **Binary credit events**: Credit default swaps triggered by binary conditions
- **Regulated binary options**: Nadex, Cantor Exchange binary options

## Example

```rust
use nautilus_model::instruments::BinaryOption;
use nautilus_model::enums::AssetClass;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};
use ustr::Ustr;

// Will Biden win 2024 presidential election? (Polymarket)
let biden_binary = BinaryOption::new(
    InstrumentId::from("BIDEN-2024.POLYMARKET"),
    Symbol::from("BIDEN-2024"),
    AssetClass::Alternative,
    Currency::USDC(),
    0.into(),                             // activation_ns
    1725552000000000000.into(),           // expiration_ns (Nov 5, 2024)
    3,                                    // price_precision
    2,                                    // size_precision
    Price::from("0.001"),
    Quantity::from("0.01"),
    Some(Ustr::from("YES")),              // outcome
    Some(Ustr::from("Biden wins presidency")), // description
    None,                                 // max_quantity
    Some(Quantity::from("0.01")),         // min_quantity
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

**Vs OptionContract**:

- BinaryOption has fixed binary payout vs OptionContract has non-linear payoff
- BinaryOption has no strike price vs OptionContract does
- BinaryOption has outcome field vs OptionContract has option kind
- BinaryOption expires at specific outcome vs OptionContract can be exercised anytime (for American)

**Vs BettingInstrument**:

- BinaryOption is financial binary outcome vs BettingInstrument is sports/event outcome
- BinaryOption has financial structure vs BettingInstrument has event structure
- BinaryOption has outcome/description vs BettingInstrument has full event hierarchy
- BinaryOption can have different margins vs BettingInstrument defaults to 100%

**Vs CryptoPerpetual**:

- BinaryOption has fixed expiration vs CryptoPerpetual is perpetual
- BinaryOption has binary outcome vs CryptoPerpetual is continuous
- BinaryOption has no leverage built-in vs CryptoPerpetual supports high leverage
- BinaryOption has simple payoff vs CryptoPerpetual has complex payoff

## Example Data

```json
{
  "id": "BIDEN-2024.POLYMARKET",
  "raw_symbol": "BIDEN-2024",
  "asset_class": "Alternative",
  "currency": "USDC",
  "activation_ns": 0,
  "expiration_ns": 1725552000000000000,
  "price_precision": 3,
  "size_precision": 2,
  "price_increment": "0.001",
  "size_increment": "0.01",
  "margin_init": "0",
  "margin_maint": "0",
  "maker_fee": "0",
  "taker_fee": "0",
  "outcome": "YES",
  "description": "Biden wins presidency",
  "max_quantity": null,
  "min_quantity": "0.01",
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

- **Market opening**: Binary options become available for trading
- **Market closing**: Markets close when the underlying event occurs
- **Probability updates**: Prices change based on market perception of outcome probability
- **New information**: News, data releases affecting outcome probability
- **Liquidity changes**: Updates to max/min quantity or notional limits
- **Event resolution**: Final determination of outcome at expiration
- **Fee schedule changes**: Updates to maker/taker fees
- **Market condition changes**: Adjustments to max/min price limits

## Key Properties

- **Asset Class**: Typically `AssetClass::Alternative` for prediction markets, can vary
- **Instrument Class**: Always `InstrumentClass::BinaryOption`
- **Expiration**: Has both `activation_ns` and `expiration_ns`
- **Outcome**: Optional field describing the binary outcome (e.g., "YES"/"NO")
- **Description**: Optional field providing additional context about the binary condition
- **Simple Structure**: No strike price, option kind, or underlying asset fields
- **Fixed Payout**: Typically pays 1 unit of currency if condition met, 0 otherwise
- **Probability Trading**: Price represents market-implied probability of outcome