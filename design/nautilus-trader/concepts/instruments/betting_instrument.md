# BettingInstrument

A BettingInstrument represents a sports betting instrument with complete market and selection details. This type is designed for betting exchanges like Betfair.

## When to Use

Use BettingInstrument when trading:

- **Sports betting**: Football/soccer, tennis, horse racing markets
- **Betting exchange trading**: Backing and laying selections on exchanges like Betfair
- **Prop betting**: Special bets on specific events or outcomes
- **Political betting**: Election outcomes, referendum results
- **Entertainment betting**: Awards shows, reality TV outcomes

## Example

```rust
use nautilus_model::instruments::BettingInstrument;
use nautilus_model::identifiers::{InstrumentId, Symbol};
use nautilus_model::types::{Currency, Price, Quantity};
use ustr::Ustr;

// Arsenal vs Chelsea match odds on Betfair
let arsenal_bet = BettingInstrument::new(
    InstrumentId::from("1-123.BETFAIR"),
    Symbol::from("1-123"),
    6423,                                 // event_type_id (Soccer)
    Ustr::from("Soccer"),
    1,                                    // competition_id
    Ustr::from("English Premier League"),
    1,                                    // event_id
    Ustr::from("Arsenal vs Chelsea"),
    Ustr::from("GB"),                      // event_country_code
    0.into(),                             // event_open_date
    Ustr::from("ODDS"),                    // betting_type
    Ustr::from("1-123"),                   // market_id
    Ustr::from("Match Odds"),              // market_name
    Ustr::from("WIN"),                     // market_type
    0.into(),                             // market_start_time
    50214,                                // selection_id
    Ustr::from("Arsenal"),                 // selection_name
    0.0,                                  // selection_handicap
    Currency::GBP(),
    2,                                    // price_precision
    2,                                    // size_precision
    Price::from("0.01"),
    Quantity::from("0.01"),
    None,                                 // max_quantity
    None,                                 // min_quantity
    None,                                 // max_notional
    None,                                 // min_notional
    None,                                 // max_price
    None,                                 // min_price
    None,                                 // margin_init (defaults to 100%)
    None,                                 // margin_maint (defaults to 100%)
    None,                                 // maker_fee
    None,                                 // taker_fee
    None,                                 // tick_scheme (Betfair auto-applied)
    None,                                 // info
    0.into(),                             // ts_event
    0.into(),                             // ts_init
);
```

## Differences from Other Types

**Vs BinaryOption**:

- BettingInstrument is for sports/event outcomes vs BinaryOption is financial binary options
- BettingInstrument has event/competition structure vs BinaryOption does not
- BettingInstrument has betting-specific fields vs BinaryOption has financial contract fields
- BettingInstrument supports handicaps vs BinaryOption does not

**Vs CurrencyPair**:

- BettingInstrument is for binary outcomes vs CurrencyPair is continuous pricing
- BettingInstrument represents win/loss scenarios vs CurrencyPair represents exchange rates
- BettingInstrument has event timing vs CurrencyPair is always available
- BettingInstrument uses 100% margin vs CurrencyPair typically has lower margins

**Vs OptionContract**:

- BettingInstrument is binary outcome vs OptionContract has non-linear payoff
- BettingInstrument has event structure vs OptionContract has financial structure
- BettingInstrument has no strike price vs OptionContract does
- BettingInstrument uses decimal odds vs OptionContract uses premiums

## Example Data

```json
{
  "id": "1-123.BETFAIR",
  "raw_symbol": "1-123",
  "event_type_id": 6423,
  "event_type_name": "Soccer",
  "competition_id": 1,
  "competition_name": "English Premier League",
  "event_id": 1,
  "event_name": "Arsenal vs Chelsea",
  "event_country_code": "GB",
  "event_open_date": 0,
  "betting_type": "ODDS",
  "market_id": "1-123",
  "market_name": "Match Odds",
  "market_type": "WIN",
  "market_start_time": 0,
  "selection_id": 50214,
  "selection_name": "Arsenal",
  "selection_handicap": 0.0,
  "currency": "GBP",
  "price_precision": 2,
  "size_precision": 2,
  "price_increment": "0.01",
  "size_increment": "0.01",
  "margin_init": "1",
  "margin_maint": "1",
  "maker_fee": "0",
  "taker_fee": "0",
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

- **Event scheduling**: New sporting events become available for betting
- **Market opening**: Betting markets open for specific events
- **Market closing**: Markets close when events start or suspend
- **Odds updates**: Bookmakers update odds based on betting activity
- **Event changes**: Postponements, cancellations, venue changes
- **Player/team news**: Injuries, lineups affecting odds
- **Weather conditions**: Impact on outdoor sports betting
- **Market suspension**: Temporary halts due to unexpected events
- **Settlement**: Final results and payout calculations

## Key Properties

- **Asset Class**: Always `AssetClass::Alternative`
- **Instrument Class**: Always `InstrumentClass::SportsBetting`
- **Event Structure**: Complete hierarchy from sport type to specific selection
- **Timing**: Has activation (`market_start_time`) but no expiration
- **Margins**: Defaults to 100% (full upfront payment required)
- **Tick Scheme**: Automatically applies Betfair tick scheme for Betfair venue
- **Odds Format**: Uses decimal odds format (e.g., 2.50 = 2.5x return)