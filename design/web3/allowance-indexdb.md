# Event Fetching and IndexedDB Caching Flow

## Overview

This document describes how the application fetches blockchain events for token allowances, caches them in IndexedDB, and calculates current allowance amounts. The system is designed to efficiently handle large block ranges by using incremental updates and intelligent caching.

## Event Fetching Flow

### Initial Setup

When fetching events for a wallet address, the system follows these steps:

1. **Check Address Activity**: First, it checks if the address has any transactions by querying the transaction nonce. If the nonce is zero (meaning no transactions), the system skips event fetching entirely for efficiency.

2. **Determine Block Range**: 
   - **Starting Block**: Always begins from block 0 (genesis block)
   - **Ending Block**: Always queries up to the latest block on the chain
   - The latest block number is fetched dynamically from the blockchain

3. **Event Types Queried**: The system fetches multiple event types in parallel:
   - ERC721 Transfer events (both to and from the address)
   - ERC721 Approval events (single token approvals)
   - ERC721 ApprovalForAll events (all token approvals)
   - Permit2 Approval events
   - Permit2 Permit events
   - Permit2 Lockdown events

### First-Time Fetch

On the first request for a wallet address:

1. The system queries all events from block 0 to the latest block
2. Events are filtered by the wallet address using topic filters
3. All fetched events are stored in IndexedDB with a cache key based on:
   - Chain ID
   - Event topics (event type selectors)
   - Wallet address (if applicable)
4. The cache stores:
   - All event logs
   - The highest block number that was queried (`toBlock`)
   - Chain ID and filter parameters

**Example**: For a wallet on Ethereum mainnet, the first fetch might query from block 0 to block 18,500,000 (current latest block), fetching all Approval and Transfer events for that address.

## Incremental Updates (Subsequent Fetches)

After the initial fetch, the system uses intelligent incremental updates:

### How It Works

1. **Check Cache**: The system first checks IndexedDB for previously cached events using the same cache key (chain ID + topics + address)

2. **Determine Query Range**:
   - If cached events exist, it retrieves the `toBlock` value from the cache
   - The new query starts from `cachedToBlock + 1` (the next block after the last cached block)
   - The query ends at the current latest block

3. **Fetch Only New Events**: Only events from the new block range are fetched from the blockchain

4. **Merge and Update**: 
   - New events are merged with cached events
   - The cache is updated with the combined event list
   - The `toBlock` is updated to the new latest block

### Example: Incremental Update

**Scenario**: 
- First fetch: Block 0 to 18,500,000 (cached)
- Second fetch (next day): Latest block is now 18,510,000

**Process**:
1. System checks cache and finds events up to block 18,500,000
2. Calculates: `fromBlock = 18,500,000 + 1 = 18,500,001`
3. Queries only blocks 18,500,001 to 18,510,000 (10,000 new blocks)
4. Merges new events with cached events
5. Updates cache with combined events and new `toBlock = 18,510,000`

This approach dramatically reduces query size and improves performance on subsequent loads.

## Maximum Block Range Handling

### No Hard Limit

The system does not enforce a hard maximum block range. It can theoretically query from block 0 to any latest block number.

### Automatic Range Splitting

However, when queries become too large, the system automatically splits them using a "divide and conquer" strategy:

1. **Pre-emptive Splitting**: For certain blockchain APIs (like Covalent), if the block range exceeds 5,000,000 blocks, the query is automatically split in half before attempting to fetch.

2. **Error-Based Splitting**: If a query fails due to response size limits or timeouts:
   - The system catches the error
   - Automatically splits the block range in half
   - Recursively queries both halves
   - Combines the results

3. **Recursive Division**: The splitting continues recursively until:
   - The query succeeds, or
   - The range is reduced to a single block (at which point it throws an error if it still fails)

### Example: Divide and Conquer

**Scenario**: Querying blocks 0 to 20,000,000 fails due to size limit

**Process**:
1. Split into: 0-10,000,000 and 10,000,001-20,000,000
2. Query both ranges in parallel
3. If either fails, split that range in half again
4. Continue until all ranges succeed
5. Combine all results

This ensures the system can handle chains of any size, even if individual queries have limitations.

## Querying to the Next Block

When the system needs to fetch new events, it calculates the next block to query from:

### Formula

```
nextFromBlock = cachedToBlock + 1
nextToBlock = currentLatestBlock
```

### Process

1. **Retrieve Cache**: Get the cached events entry for the specific filter (chain + topics + address)

2. **Check Cache Status**:
   - If no cache exists: `fromBlock = 0` (initial fetch)
   - If cache exists: `fromBlock = cachedToBlock + 1`

3. **Validate Range**:
   - If `fromBlock > toBlock`: All events are already cached, return cached events filtered by the requested range
   - Otherwise: Query from `fromBlock` to `toBlock`

4. **Update Cache**: After successful query, update the cache with:
   - Combined old and new events
   - New `toBlock` value

### Example: Next Block Query

**Current State**:
- Cached events: Blocks 0 to 15,000,000
- Current latest block: 15,000,500

**Calculation**:
- `fromBlock = 15,000,000 + 1 = 15,000,001`
- `toBlock = 15,000,500`
- Query range: 15,000,001 to 15,000,500 (500 blocks)

**Result**: Only 500 blocks are queried instead of 15+ million blocks.

## Allowance Amount Calculation

The system calculates current allowance amounts differently for ERC20 and ERC721 tokens:

### ERC20 Token Allowances

**Why Events Aren't Enough**: 
- Approval events only show the amount that was approved at the time
- The actual allowance decreases when tokens are transferred using `transferFrom`
- Events cannot tell us the current remaining allowance

**Calculation Process**:

1. **Find Approval Events**: Identify all Approval events for the token and spender from the event logs

2. **Deduplicate**: Remove duplicate events, keeping only the most recent approval for each token-spender pair

3. **Filter Zero Approvals**: If the most recent approval event shows amount 0, the allowance is definitely zero (no need to query)

4. **Query Current State**: For non-zero approvals, query the token contract directly:
   - Call: `allowance(owner, spender)` 
   - This returns the current remaining allowance on-chain
   - This is the actual amount that can still be spent

5. **Store Result**: Store the current allowance amount along with the last updated timestamp from the approval event

**Example**:
- Event shows: Approval of 1000 tokens at block 10,000
- User transfers 300 tokens using transferFrom at block 12,000
- Current allowance query returns: 700 tokens (1000 - 300)
- System displays: 700 tokens as the current allowance

### ERC721 Token Allowances

ERC721 tokens have two types of allowances:

#### Single Token Approvals

**Process**:
1. Find Approval events for specific token IDs
2. Check if the token was transferred after approval (transfers reset approvals)
3. If the most recent event is a Transfer, the approval is revoked
4. If the most recent event is an Approval to address(0), the approval is revoked
5. Otherwise, the approval is still active

**No Contract Query Needed**: Single token approvals can be determined entirely from events because transfers automatically revoke them.

#### Approval For All

**Process**:
1. Find ApprovalForAll events
2. Check the `approved` boolean in the most recent event
3. If `approved = false`, the allowance is revoked
4. If `approved = true`, the allowance is still active

**No Contract Query Needed**: The most recent ApprovalForAll event directly indicates the current state.

### Permit2 Allowances

**Process**:
1. Find Permit2 Approval/Permit/Lockdown events
2. Query the Permit2 contract: `allowance(owner, token, spender)`
3. Returns: amount, expiration, and nonce
4. Filter out expired allowances (expiration < current time)
5. Filter out zero-amount allowances

**Why Query**: Permit2 allowances have expiration times and can be partially used, so the current state must be queried from the contract.

## Complete Example Flow

### Scenario: User checks allowances for wallet `0x1234...` on Ethereum

**Step 1: Initial Fetch (First Time)**
- Check nonce: 5 transactions found (non-zero, proceed)
- Latest block: 18,500,000
- Query events: Block 0 to 18,500,000
- Events found:
  - 3 Approval events for USDC token (ERC20)
  - 1 Approval event for Bored Ape NFT #1234 (ERC721 single token)
  - 1 ApprovalForAll event for Bored Ape NFT collection
  - 4 Transfer events (2 ERC20 transfers, 2 ERC721 transfers)
- Cache stored: All events + `toBlock = 18,500,000`

**Step 2: Process Events and Calculate Allowances**

**For USDC (ERC20 Token):**
- Found 3 approval events:
  - Block 10,000: Approved 1000 tokens to `spender1`
  - Block 12,000: Approved 500 tokens to `spender2`
  - Block 15,000: Approved 2000 tokens to `spender3`
- Found 2 transfer events:
  - Block 13,000: `spender1` transferred 300 tokens using `transferFrom`
  - Block 16,000: `spender3` transferred 500 tokens using `transferFrom`
- Query current on-chain state for each:
  - `allowance(0x1234..., spender1)` → 700 tokens (1000 - 300 = 700 remaining)
  - `allowance(0x1234..., spender2)` → 500 tokens (no transfers, full amount available)
  - `allowance(0x1234..., spender3)` → 1500 tokens (2000 - 500 = 1500 remaining)
- **Result**: 3 active allowances (700, 500, and 1500 tokens)

**For Bored Ape NFT #1234 (ERC721 Single Token):**
- Found events in chronological order:
  - Block 8,000: Approval event - Token #1234 approved to `spenderA`
  - Block 9,000: **Transfer event** - Token #1234 transferred to another address
  - Block 11,000: Approval event - Token #1234 approved to `spenderB` (after transfer back)
- Processing logic:
  - Most recent event for token #1234 is an Approval (block 11,000)
  - Transfer at block 9,000 would have revoked the approval, but token was transferred back
  - Current approval to `spenderB` is still active
- **Result**: 1 active allowance (Token #1234 to `spenderB`)

**For Bored Ape Collection (ERC721 ApprovalForAll):**
- Found 1 ApprovalForAll event:
  - Block 7,000: `approved = true` to `spenderC`
- Note: Transfers do NOT affect ApprovalForAll (only explicit ApprovalForAll events with `approved = false` can revoke it)
- **Result**: 1 active allowance (all tokens in collection to `spenderC`)

**Step 3: Display Results**
- USDC: 3 active allowances (700, 500, and 1500 tokens)
- Bored Ape #1234: 1 active allowance (to spenderB)
- Bored Ape Collection: 1 active allowance (all tokens to spenderC)

**Step 4: Next Day - Transfer Happens (Incremental Update)**

**New Events Detected:**
- Latest block: 18,510,000
- Check cache: Events up to 18,500,000
- Calculate: Query blocks 18,500,001 to 18,510,000
- New events found:
  - Block 18,505,000: Transfer event - `spender2` transferred 200 USDC tokens using `transferFrom`
  - Block 18,507,000: Transfer event - Bored Ape NFT #1234 transferred to another address
  - Block 18,509,000: ApprovalForAll event - `approved = false` to `spenderC` (explicit revocation)

**Recalculate Allowances:**

**USDC Allowances:**
- Re-query contract for `spender2`: `allowance(0x1234..., spender2)` → 300 tokens (500 - 200 = 300 remaining)
- Other allowances unchanged (spender1: 700, spender3: 1500)
- **Updated Result**: 3 active allowances (700, 300, and 1500 tokens)

**Bored Ape NFT #1234:**
- Most recent event for token #1234 is now a Transfer (block 18,507,000)
- Transfer automatically revokes single token approvals
- **Updated Result**: 0 active allowances (approval revoked by transfer)

**Bored Ape Collection:**
- Most recent ApprovalForAll event shows `approved = false` (block 18,509,000)
- **Updated Result**: 0 active allowances (explicitly revoked)

**Step 5: Final Display Results After Transfers**
- USDC: 3 active allowances (700, 300, and 1500 tokens) - one reduced by transfer
- Bored Ape #1234: 0 active allowances - revoked by transfer
- Bored Ape Collection: 0 active allowances - explicitly revoked

### Key Takeaways from Transfer Impact

1. **ERC20 Transfers**: Reduce the allowance amount but don't revoke it completely. The system detects this by querying the current on-chain state, which reflects all transfers.

2. **ERC721 Single Token Transfers**: Automatically revoke approvals for that specific token. The system detects this by checking if the most recent event for a token ID is a Transfer event.

3. **ERC721 ApprovalForAll**: Transfers do NOT affect ApprovalForAll. Only explicit ApprovalForAll events with `approved = false` can revoke it.

4. **Event Order Matters**: The system processes events chronologically to determine which is the most recent action, which determines the current allowance state.

## Key Benefits

1. **Efficiency**: Only queries new blocks after initial fetch
2. **Performance**: Cached events load instantly from IndexedDB
3. **Accuracy**: Always queries current on-chain state for ERC20 allowances
4. **Scalability**: Handles chains of any size through automatic range splitting
5. **Reliability**: Falls back to full query if cache fails

## Limitations

1. **Browser Storage**: IndexedDB has storage limits (typically 50-100MB per origin)
2. **Cache Invalidation**: Cache is only updated when new blocks are queried
3. **Chain-Specific**: Some chains (PulseChain, BitTorrent) don't use caching due to infrastructure limitations
4. **Event-Based Discovery**: Can only find allowances for tokens that have had approval events (won't find tokens with no approval history)
