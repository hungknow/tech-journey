# IndexedDB Data Structure

## Overview

The application uses IndexedDB (via Dexie.js) to cache blockchain event logs and block timestamps in the browser. This enables efficient incremental updates and faster subsequent loads by avoiding redundant blockchain queries.

## Database Structure

The application uses two separate IndexedDB databases:

1. **Events Database** - Stores blockchain event logs
2. **Blocks Database** - Stores block number to timestamp mappings

---

## Events Database

### Database Name
`Events`

### Table: `events`

The events table stores blockchain event logs grouped by chain, event type, and wallet address.

#### Primary Key
- **Composite Key**: `[chainId + topicsKey]`
  - `chainId`: The blockchain network ID (e.g., 1 for Ethereum, 137 for Polygon)
  - `topicsKey`: A string combining event topics and optional address filter

#### Indexes
- `chainId` - Indexed for filtering by chain
- `topics` - Indexed for filtering by event topics
- `toBlock` - Indexed for querying by block range

### Data Structure: `Events` Interface

```typescript
interface Events {
  chainId: number;              // Blockchain network ID
  address?: Address;            // Optional wallet address filter
  topicsKey: string;            // Composite key: topics + address
  topics: Array<string | null>; // Event topic selectors (filters)
  toBlock: number;              // Highest block number queried
  logs: Log[];                  // Array of event logs
}
```

#### Field Descriptions

**`chainId`** (number)
- The blockchain network identifier
- Examples: `1` (Ethereum), `137` (Polygon), `56` (BSC)
- Used to separate events from different chains

**`address`** (Address, optional)
- The wallet address that events are filtered for
- Only present when events are filtered by a specific address
- Format: Ethereum address string (e.g., `"0x1234..."`)

**`topicsKey`** (string)
- Composite key combining event topics and address
- Format: `"topic0,topic1,topic2/address"` or `"topic0,topic1,topic2"` (if no address)
- Examples:
  - `"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef,null,0x0000000000000000000000001234567890123456789012345678901234567890"` (Transfer events to address)
  - `"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925,0x0000000000000000000000001234567890123456789012345678901234567890"` (Approval events from address)

**`topics`** (Array<string | null>)
- Event topic selectors used to filter events
- First topic is the event signature hash
- Subsequent topics are indexed parameters (can be null for wildcard)
- Examples:
  - `["0xddf252ad...", null, "0x1234..."]` - Transfer events where `to` address matches
  - `["0x8c5be1e5...", "0x1234..."]` - Approval events where `owner` matches

**`toBlock`** (number)
- The highest block number that was queried and cached
- Used to determine the starting point for incremental updates
- Example: `18500000` means events up to block 18,500,000 are cached

**`logs`** (Log[])
- Array of raw blockchain event logs
- Contains all events matching the filter criteria
- Can contain thousands of events for active wallets

### Data Structure: `Log` Interface

Each log entry in the `logs` array represents a single blockchain event:

```typescript
interface Log {
  address: Address;        // Contract address that emitted the event
  topics: [topic0: Hex, ...rest: Hex[]]; // Event topics (indexed parameters)
  data: Hex;               // Event data (non-indexed parameters)
  transactionHash: Hash;   // Transaction hash that included this event
  blockNumber: number;     // Block number where event occurred
  transactionIndex: number; // Index within the block
  logIndex: number;         // Index within the transaction
  timestamp?: number;       // Optional block timestamp (added later)
}
```

#### Log Field Descriptions

**`address`** (Address)
- The smart contract address that emitted the event
- Example: `"0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"` (USDC contract)

**`topics`** (Array<Hex>)
- Event topics (indexed parameters)
- `topics[0]`: Event signature hash (e.g., Transfer, Approval)
- `topics[1+]`: Indexed event parameters
- Example for Transfer event:
  - `topics[0]`: `"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"` (Transfer signature)
  - `topics[1]`: `"0x0000000000000000000000001234..."` (from address)
  - `topics[2]`: `"0x0000000000000000000000005678..."` (to address)
  - `topics[3]`: `"0x0000000000000000000000000000000000000000000000000000000000000123"` (tokenId for ERC721)

**`data`** (Hex)
- Encoded non-indexed event parameters
- Example: For ERC20 Transfer, contains the amount as a 32-byte hex string

**`transactionHash`** (Hash)
- Hash of the transaction that included this event
- Format: `"0xabc123..."`

**`blockNumber`** (number)
- Block number where the event was included
- Example: `18500000`

**`transactionIndex`** (number)
- Position of the transaction within the block
- Starts from 0
- Example: `5` (6th transaction in the block)

**`logIndex`** (number)
- Position of this event log within the transaction
- Starts from 0
- Example: `0` (first event in the transaction)

**`timestamp`** (number, optional)
- Unix timestamp of the block (in seconds)
- Added later via block timestamp lookup
- Example: `1699123456`

### Example: Events Entry

```json
{
  "chainId": 1,
  "address": "0x1234567890123456789012345678901234567890",
  "topicsKey": "0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925,0x0000000000000000000000001234567890123456789012345678901234567890/0x1234567890123456789012345678901234567890",
  "topics": [
    "0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925",
    "0x0000000000000000000000001234567890123456789012345678901234567890"
  ],
  "toBlock": 18500000,
  "logs": [
    {
      "address": "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
      "topics": [
        "0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925",
        "0x0000000000000000000000001234567890123456789012345678901234567890",
        "0x0000000000000000000000005678901234567890123456789012345678905678"
      ],
      "data": "0x0000000000000000000000000000000000000000000000000de0b6b3a7640000",
      "transactionHash": "0xabc123def456...",
      "blockNumber": 15000000,
      "transactionIndex": 5,
      "logIndex": 0,
      "timestamp": 1699123456
    }
  ]
}
```

### Cache Key Generation

The cache key is generated as follows:

1. **Extract topics and address** from the filter
2. **Join topics** with commas: `topics.join(',')`
3. **Append address** if present: `topics.join(',') + '/' + address`
4. **Use composite key**: `[chainId, topicsKey]`

**Example Cache Keys:**
- `[1, "0x8c5be1e5...,0x1234.../0x1234..."]` - Approval events for address on Ethereum
- `[137, "0xddf252ad...,null,0x5678..."]` - Transfer events to address on Polygon
- `[1, "0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31"]` - ApprovalForAll events (no address filter)

---

## Blocks Database

### Database Name
`Blocks`

### Table: `blocks`

The blocks table stores block number to timestamp mappings for efficient timestamp lookups.

#### Primary Key
- **Composite Key**: `[chainId + blockNumber]`
  - `chainId`: The blockchain network ID
  - `blockNumber`: The block number

#### Indexes
- `timestamp` - Indexed for querying by time range

### Data Structure: `Block` Interface

```typescript
interface Block {
  chainId: number;    // Blockchain network ID
  blockNumber: number; // Block number
  timestamp: number;   // Unix timestamp (seconds)
}
```

#### Field Descriptions

**`chainId`** (number)
- The blockchain network identifier
- Same values as in Events database

**`blockNumber`** (number)
- The block number
- Example: `18500000`

**`timestamp`** (number)
- Unix timestamp when the block was mined (in seconds)
- Example: `1699123456` (represents October 4, 2023)

### Example: Block Entry

```json
{
  "chainId": 1,
  "blockNumber": 18500000,
  "timestamp": 1699123456
}
```

---

## Data Organization

### Events Table Organization

Events are organized by:
1. **Chain ID** - Separates different blockchain networks
2. **Event Type** - Different event types (Transfer, Approval, etc.) are stored in separate entries
3. **Address Filter** - Events filtered by specific addresses are stored separately

### Multiple Entries Per Chain

For a single wallet address on one chain, multiple entries may exist:

- One entry for Transfer events (to address)
- One entry for Transfer events (from address)
- One entry for Approval events (from address)
- One entry for ApprovalForAll events (from address)
- One entry for Permit2 Approval events
- One entry for Permit2 Permit events
- One entry for Permit2 Lockdown events

Each entry has its own `topicsKey` and stores only events matching that specific filter.

### Incremental Updates

When new events are fetched:
1. System retrieves existing entry using `[chainId, topicsKey]`
2. Checks `toBlock` to determine starting point
3. Fetches new events from `toBlock + 1` to current latest block
4. Merges new events with existing `logs` array
5. Updates `toBlock` to new latest block
6. Saves updated entry back to IndexedDB

---

## Storage Considerations

### Size Estimates

**Per Event Log**: Approximately 500-1000 bytes
- Address: 42 bytes
- Topics: ~130 bytes per topic (4 topics max)
- Data: ~130 bytes
- Transaction hash: 66 bytes
- Block number, indices: ~20 bytes
- Timestamp: 8 bytes

**Example Storage:**
- 1,000 events: ~500 KB - 1 MB
- 10,000 events: ~5 MB - 10 MB
- 100,000 events: ~50 MB - 100 MB

### Browser Limits

- **IndexedDB Storage Limit**: Typically 50-100 MB per origin (browser-dependent)
- **Practical Limit**: For most users, 10,000-50,000 events per filter is manageable
- **Optimization**: Events are filtered by address and event type, reducing storage per entry

### Cache Invalidation

The cache is automatically updated when:
- New blocks are queried (incremental updates)
- Database schema changes (version upgrades clear the cache)

Manual cache clearing can be done by:
- Clearing browser data
- Database version upgrade (automatically clears on schema change)

---

## Database Versions

### Events Database

**Version 2025_03_23** (Current)
- Primary key: `[chainId + topicsKey]`
- Indexes: `chainId`, `topics`, `toBlock`
- On upgrade: Clears all existing events (full re-index)

### Blocks Database

**Version 2023_03_14** (Current)
- Primary key: `[chainId + blockNumber]`
- Index: `timestamp`

---

## Usage Examples

### Querying Events

To retrieve cached events:
1. Generate `topicsKey` from filter
2. Query with composite key: `[chainId, topicsKey]`
3. Check `toBlock` to see how up-to-date the cache is
4. Use `logs` array for event processing

### Adding New Events

When new events are fetched:
1. Retrieve existing entry
2. Append new logs to existing `logs` array
3. Update `toBlock` to new latest block
4. Save updated entry

### Block Timestamp Lookup

To get block timestamp:
1. Query blocks table with `[chainId, blockNumber]`
2. Retrieve `timestamp` field
3. If not found, fetch from blockchain and cache it

---

## Benefits of This Structure

1. **Efficient Queries**: Composite keys enable fast lookups by chain and event type
2. **Incremental Updates**: `toBlock` tracking allows fetching only new events
3. **Separation of Concerns**: Events and blocks stored separately for optimal indexing
4. **Scalability**: Multiple entries per chain prevent single large arrays
5. **Flexibility**: Address filtering allows wallet-specific caching

---

## Storage Optimization: Block Bucket Processing

### Current Storage Issue

IndexedDB has storage limits (typically 50-100 MB per origin). When storage quota is exceeded, the system falls back to querying events directly from the blockchain, disabling caching benefits.

### Solution: Block Bucket Processing

Instead of storing all raw events, process events in block ranges (buckets) and store only the final processed allowance state. This reduces storage by 90-98%.

### How It Works

1. **Process Events in Buckets**: Divide blockchain into block ranges (e.g., every 10,000 blocks)
2. **Calculate Final State**: Process all events in bucket and calculate final allowance state at end of bucket
3. **Store Processed Results**: Save only final allowance state, delete raw events
4. **Incremental Updates**: Only process new buckets as they're discovered

**Data Structure:**
```typescript
interface ProcessedBlockBucket {
  chainId: number;
  address: Address;
  fromBlock: number;
  toBlock: number;
  processedAt: number;
  allowances: TokenAllowanceData[]; // Final state at toBlock
}
```

**Processing Flow:**
1. Fetch events for bucket [fromBlock, toBlock]
2. Process events chronologically
3. Calculate allowances at end of bucket
4. Query on-chain state for ERC20 (if needed)
5. Store ProcessedBlockBucket, delete raw events
6. Merge with previous bucket's final state for next bucket

**Storage Comparison:**
- **Current**: 100,000 events × 1 KB = ~100 MB
- **Block Buckets**: 100,000 events → ~1,000 allowances × 2 KB = ~2 MB (98% reduction)

**Hybrid Approach (Recommended):**
- **Old blocks** (0-18M): Processed into buckets (final state only)
- **Recent blocks** (last 100k): Raw events stored (for fast access)
- **New blocks**: Processed incrementally

**Benefits:**
- 90-98% storage reduction
- Faster queries (load processed results vs processing all events)
- Scalable to unlimited history
- Avoids storage quota issues

---

## Current Limitations

1. **Storage Size**: Large event histories consume significant browser storage (50-100 MB limit)
2. **No Cache Eviction**: When storage limit is reached, cache fails silently and falls back to direct queries
3. **Chain-Specific**: Some chains (PulseChain, BitTorrent) don't use caching
4. **Cache Staleness**: Cache may be outdated if user hasn't visited in a while

**Solution**: Implement block bucket processing (see above) to reduce storage by 90-98%
