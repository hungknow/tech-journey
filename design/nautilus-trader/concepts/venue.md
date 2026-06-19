# Venue

## Purpose

The `Venue` struct represents a valid trading venue identifier in the Nautilus Trader system. It serves as a unique identifier for trading venues such as centralized exchanges (CEXs), decentralized exchanges (DEXs), and synthetic venues. The struct wraps a UTF-8 string identifier that represents venue names or codes.


## Use Cases

1. Identifying centralized exchanges (CEXs) like "BINANCE", "COINBASE", etc.
2. Identifying decentralized exchanges (DEXs) in blockchain format like "Ethereum:UniswapV3"
3. Creating synthetic venues for backtesting and simulated trading scenarios
4. Mapping venue codes to full venue identifiers using the `VENUE_MAP`
5. Validating venue formats and checking for proper ASCII strings
6. Parsing DEX venues to extract blockchain and DEX type information


## Data Organization by Use Case

### Core Identifier Data

**Data held:**
- Inner `Ustr` value (UTF-8 string) representing the venue identifier (stored in self.0)

**Examples:**
```rust
let venue = Venue::new("BINANCE");
// venue.0 contains the Ustr "BINANCE"
```

**When and what affects this data:**

- During creation: Set when `Venue::new()` or `Venue::new_checked()` is called with a string value
  - Example: `Venue::new("COINBASE")` sets the inner value to "COINBASE"
- During modification: Can be changed via `set_inner()` method when the venue needs to be updated
  - Example: `venue.set_inner("KRAKEN")` updates the venue to "KRAKEN"
- During parsing: For DEX venues, the format is validated during creation and must follow "Chain:DexId" pattern
  - Example: `Venue::new("Ethereum:UniswapV3")` validates the format and sets the inner value


### CEX Venue Identification

**Data held:**
- Simple ASCII string venue codes (e.g., "BINANCE", "COINBASE")

**Examples:**
```rust
let venue = Venue::new("BINANCE");
// venue.as_str() returns "BINANCE"
```

**When and what affects this data:**

- Creation context: Set when creating venues for centralized exchanges using standard ASCII strings
  - Example: `Venue::new("COINBASE")` creates a venue identifier for Coinbase
  - Example: `Venue::new("KRAKEN")` creates a venue identifier for Kraken
- Validation context: Must pass ASCII string validation during venue creation
  - Example: `Venue::new("ÜNİCOİN")` would fail validation because it contains non-ASCII characters
- Code mapping context: Can be resolved from venue codes using `from_code()` method that looks up in VENUE_MAP
  - Example: `Venue::from_code("BNB")` might resolve to "BINANCE"
  - Example: `Venue::from_code("COIN")` might resolve to "COINBASE"


### DEX Venue Identification

**Data held:**
- Blockchain-specific venue strings in format "Chain:DexId" (e.g., "Ethereum:UniswapV3")

**Examples:**
```rust
let venue = Venue::new("Ethereum:UniswapV3");
// venue.as_str() returns "Ethereum:UniswapV3"
```

**When and what affects this data:**

- Creation context: Set when creating DEX venues with colon-separated blockchain and DEX identifiers
  - Example: `Venue::new("Arbitrum:CamelotV3")` creates a venue for Camelot V3 on Arbitrum
  - Example: `Venue::new("Polygon:SushiSwapV3")` creates a venue for SushiSwap V3 on Polygon
- Validation context: Must pass blockchain venue format validation including chain recognition and DEX type recognition
  - Example: `Venue::new("Ethereum:UniswapV3")` passes validation (valid chain, valid DEX)
  - Example: `Venue::new("InvalidChain:UniswapV3")` fails validation (unknown chain)
  - Example: `Venue::new("Ethereum:InvalidDex")` fails validation (unknown DEX)
  - Example: `Venue::new("Ethereum:")` fails validation (empty DEX ID)
- Parsing context: Can be parsed into `(Blockchain, DexType)` components using `parse_dex()` method
  - Example: `venue.parse_dex()` returns `Ok((Blockchain::Ethereum, DexType::UniswapV3))`
  - Example: `Venue::new("Base:AerodromeV1").parse_dex()` returns `Ok((Blockchain::Base, DexType::AerodromeV1))`
  - Example: `Venue::new("BINANCE").parse_dex()` returns error (not a DEX venue)
- Context requirements: DEX validation only runs when the "defi" feature is enabled


### Synthetic Venue Identification

**Data held:**
- Constant synthetic venue identifier "SYNTH"

**Examples:**
```rust
let venue = Venue::synthetic();
// venue.as_str() returns "SYNTH"
```

**When and what affects this data:**

- Creation context: Set when creating synthetic venues using `synthetic()` method
  - Example: `Venue::synthetic()` always creates a venue with the identifier "SYNTH"
  - Example: Used in backtesting: `let backtest_venue = Venue::synthetic();`
- Identification context: Checked via `is_synthetic()` method to determine if a venue is synthetic
  - Example: `Venue::synthetic().is_synthetic()` returns `true`
  - Example: `Venue::new("BINANCE").is_synthetic()` returns `false`
- Use context: Used for backtesting and simulated trading where real venue connection is not required
  - Example: Creating a backtest strategy: `Venue::synthetic()` is used instead of real exchange names
  - Example: Paper trading systems use synthetic venues to avoid real money transactions


### Venue Type Detection

**Data held:**
- Boolean flag indicating DEX venue status (derived from presence of ':')

**Examples:**
```rust
let dex_venue = Venue::new("Ethereum:UniswapV3");
dex_venue.is_dex(); // returns true

let cex_venue = Venue::new("BINANCE");
cex_venue.is_dex(); // returns false
```

**When and what affects this data:**

- Detection context: Determined dynamically by `is_dex()` method checking for colon in venue string
  - Example: `Venue::new("Ethereum:UniswapV3").is_dex()` returns `true` (contains ':')
  - Example: `Venue::new("Arbitrum:CamelotV3").is_dex()` returns `true`
  - Example: `Venue::new("BINANCE").is_dex()` returns `false` (no colon)
  - Example: `Venue::new("Ethereum").is_dex()` returns `false` (no colon, even though "Ethereum" is a chain name)
- Feature context: Only available when the "defi" feature is enabled
- Validation context: DEX venues must pass format validation during creation
  - Example: Venues with ':' must be valid blockchain:DEX format
  - Example: `Venue::new("Ethereum:UniswapV3")` is a valid DEX venue
  - Example: `Venue::new("Invalid:Format")` fails validation