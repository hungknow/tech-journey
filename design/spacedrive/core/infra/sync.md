# Sync Infrastructure

The sync infrastructure provides leaderless peer-to-peer synchronization for Spacedrive libraries. It uses a hybrid architecture where device-owned resources (locations, entries) sync via state broadcast, while shared resources (tags, albums, collections) sync via per-peer logs ordered by Hybrid Logical Clocks (HLC).

## Features Overview

- [Hybrid Logical Clocks](#hybrid-logical-clocks) - Distributed ordering for conflict resolution
- [Per-Peer Logs](#per-peer-logs) - Ordered append-only logs for shared resource changes
- [Syncable Registry](#syncable-registry) - Runtime registration of syncable models
- [Transaction Manager](#transaction-manager) - Atomic writes with sync event emission
- [Sync Configuration](#sync-configuration) - Tunable behavior for different network conditions
- [Watermark Tracking](#watermark-tracking) - Per-resource incremental sync tracking
- [Checkpoints](#checkpoints) - Resumable backfill with state persistence
- [Sync Event Bus](#sync-event-bus) - High-capacity event bus for sync coordination
- [Network Transport](#network-transport) - Abstraction layer for sync message delivery
- [Foreign Key Mapping](#foreign-key-mapping) - Batch FK resolution during sync
- [Dependency Graph](#dependency-graph) - Topological sort for constraint-safe ordering
- [Deterministic UUIDs](#deterministic-uuids) - Predictable IDs for system resources
- [Event Logging](#event-logging) - Persistent sync event logging and querying
- [Backfill Context](#backfill-context) - Context tracking during library backfill

## Hybrid Logical Clocks

Hybrid Logical Clocks (HLC) provide a globally consistent ordering mechanism for distributed systems without requiring a centralized time service or clock synchronization.

**Purpose:** Enable conflict-free ordering of shared resource changes across devices with unsynchronized clocks.

**What it solves:**

- **Clock drift:** Devices can have different system clocks, making timestamp comparison unreliable
- **Concurrent edits:** When two devices edit the same tag simultaneously, HLC provides deterministic ordering
- **Causality tracking:** HLC encodes causal relationships between changes (A happened before B)
- **Offline scenarios:** Devices generate valid HLC timestamps while offline, merge correctly when reconnected

HLC combines physical wall clock time with logical counters. When a device receives a message with a higher HLC, it advances its own HLC to be greater than the received value, ensuring monotonic increase across the system.

Each HLC encodes a 64-bit timestamp (milliseconds since epoch) and a 16-bit counter. The counter increments only for rapid successive events within the same millisecond. This allows unlimited events per millisecond while maintaining ordering.

Implementation: `core/src/infra/sync/hlc.rs`

## Per-Peer Logs

Each device maintains a separate append-only log (`sync.db`) containing only its own changes to shared resources. Logs are ordered by HLC and pruned once all peers have acknowledged receiving the changes.

**Purpose:** Track shared resource changes from this device's perspective, enabling incremental sync and conflict resolution.

**What it solves:**

- **Deterministic sync:** Peers only send their own changes, avoiding duplication
- **Incremental transfer:** Peers request "changes since HLC X" to get only new data
- **Conflict resolution:** Per-record HLC comparison determines which change wins
- **Storage efficiency:** Prunes entries once all peers acknowledge, preventing unbounded growth

Each `sync.db` contains:
- `shared_changes`: Log entries with HLC, model_type, record_uuid, change_type, data
- `peer_acks`: Acknowledgments from peers (peer_device_id → last_acked_hlc)
- `device_resource_watermarks`: Watermarks for device-owned resources
- `peer_received_watermarks`: Watermarks for shared resources received from peers
- `backfill_checkpoints`: Resumable backfill state
- `sync_event_log`: Persistent event log for debugging

The log supports range queries with limits for efficient batching during sync. Acknowledgments enable automatic pruning - entries with HLC ≤ min(all peer acks) are deleted.

Implementation: `core/src/infra/sync/peer_log.rs`

## Syncable Registry

The registry provides dynamic dispatch for sync operations, enabling the sync system to apply changes without compile-time knowledge of concrete model types. Models self-register using the `register_syncable!` macro.

**Purpose:** Enable generic sync apply logic that works for any model type without maintaining exhaustive match statements.

**What it solves:**

- **Extensibility:** New models can be added without modifying sync infrastructure
- **Type safety:** Compile-time registration with inventory crate
- **Generic apply:** Single code path handles all model types via registered functions
- **FK resolution:** Batch foreign key mapping queries reduce N*M lookups to M

Registry stores for each model:
- Apply functions (state-based for device-owned, log-based for shared)
- Query functions for backfill
- Deletion handlers for device-owned models
- FK lookup functions (UUID ↔ local ID)
- FK mapping declarations (which FKs need resolution)
- Sync dependencies (topological sort order)
- Post-backfill rebuild hooks (e.g., closure table reconstruction)

Two registration macros:
- `register_syncable_device_owned!` for locations, entries, volumes
- `register_syncable_shared!` for tags, albums, collections

The registry supports runtime queries for model metadata, FK mapping, and dependency ordering computation.

Implementation: `core/src/infra/sync/registry.rs`

## Transaction Manager

The TransactionManager is the sole gatekeeper for all writes to sync-enabled models. It ensures atomicity, logging, and event emission for every state-changing operation.

**Purpose:** Coordinate database writes, sync log creation, and event emission in a single consistent operation.

**What it solves:**

- **Atomicity:** Writes either fully succeed with sync coordination or fully fail
- **Event ordering:** Sync events are emitted immediately after successful commit
- **Separation of concerns:** Models don't need to know about sync or event bus internals
- **Dual sync modes:** Handles both device-owned (state broadcast) and shared (log-based) sync

Two commit methods:
- `commit_device_owned`: Emits `StateChange` event with current state
- `commit_shared`: Generates HLC, appends to peer log, emits `SharedChange` event

The manager holds references to both the sync event bus (for sync coordination) and general event bus (for resource events). It generates HLC timestamps for shared resources via the HLCGenerator.

Implementation: `core/src/infra/sync/transaction.rs`

## Sync Configuration

Unified configuration system controls all sync behavior with presets for different network conditions and device capabilities.

**Purpose:** Provide tunable sync parameters without code changes, with sensible defaults for common scenarios.

**What it solves:**

- **Performance tuning:** Adjust batch sizes and timeouts for LAN vs mobile networks
- **Storage management:** Control retention periods and pruning strategies
- **Resource limits:** Prevent battery drain on mobile with reduced sync frequency
- **Monitoring balance:** Enable/disable metrics for production vs debugging

Configuration sections:
- `BatchingConfig`: Backfill batch size, broadcast batch sizes, snapshot limits, realtime batching
- `RetentionConfig`: Pruning strategy, max retention days, full sync threshold
- `NetworkConfig`: Message timeouts, backfill timeouts, sync loop interval, connection check interval
- `MonitoringConfig`: Pruning interval, metrics enablement, metrics log interval

Three presets:
- `aggressive()`: Fast LAN, minimal storage overhead, 2-second sync loop
- `conservative()`: Unreliable networks, extended retention, 10-second sync loop
- `mobile()`: Battery/bandwidth conservation, 30-second sync loop, metrics disabled

Configuration is serializable for persistence and can be customized per library or device profile.

Implementation: `core/src/infra/sync/config.rs`

## Watermark Tracking

Watermark stores track per-resource incremental sync state to avoid transferring already-synced data.

**Purpose:** Enable incremental sync by tracking which resources each device has already received from each peer.

**What it solves:**

- **Efficiency:** Skip already-synced records during backfill
- **Resumability:** Resume interrupted backfills from last watermark
- **Reduced bandwidth:** Only transfer delta, not full library state
- **Per-resource tracking:** Fine-grained sync state (not just global position)

Two watermark stores:

**ResourceWatermarkStore** tracks device-owned resources per peer:
- Key: (device_id, model_type, resource_uuid)
- Value: HLC or timestamp of last synced version
- Used during shared resource sync to resolve FK references

**PeerWatermarkStore** tracks shared resources received from each peer:
- Key: (peer_device_id, model_type)
- Value: Highest HLC received from that peer
- Used during backfill to request "changes since this HLC"

Watermarks persist in `sync.db` and are updated as changes are applied. They enable incremental sync even after full backfill completes.

Implementation: `core/src/infra/sync/watermarks.rs`, `core/src/infra/sync/peer_watermarks.rs`

## Checkpoints

Checkpoints enable resumable backfill operations by storing the current position and state during full library sync.

**Purpose:** Allow backfill to resume from interruption without restarting from the beginning.

**What it solves:**

- **Network resilience:** Backfill interrupted by network drop or app crash resumes automatically
- **Large library sync:** Millions of entries sync across multiple sessions
- **Battery preservation:** Mobile devices can pause backfill when battery is low
- **Progress tracking:** UI shows accurate progress during long backfills

BackfillCheckpointStore tracks:
- Device ID being backfilled
- Current position (cursor) for each model type
- Total record count and synced count
- Started/completed timestamps
- Status (in_progress, paused, completed, failed)

Checkpoints persist in `sync.db` backfill_checkpoints table. During backfill, the sync system loads the existing checkpoint and resumes from the stored cursor position. On completion, the checkpoint is marked complete and eventually pruned.

Implementation: `core/src/infra/sync/checkpoints.rs`

## Sync Event Bus

A dedicated high-capacity event bus for sync coordination events, separate from the general event bus to prevent sync traffic from overwhelming UI updates.

**Purpose:** Provide a broadcast mechanism for sync events with higher capacity and lower latency than the general event bus.

**What it solves:**

- **High volume:** State changes during indexing generate thousands of events per second
- **Prioritization:** Sync coordination events don't compete with UI events
- **Subscribers:** PeerSync subscribes to sync events, not UI events
- **Isolation:** Sync event delivery failures don't affect UI responsiveness

SyncEvent types:
- `StateChange`: Device-owned resource changed (location, entry)
- `SharedChange`: Shared resource changed (tag, album)
- `BackfillProgress`: Backfill status updates
- `PeerConnected/Disconnected`: Peer connectivity changes

The bus uses `tokio::sync::broadcast` with configurable capacity. It's integrated into the TransactionManager so sync events are emitted atomically with database writes.

Implementation: `core/src/infra/sync/event_bus.rs`

## Network Transport

The NetworkTransport trait abstracts the networking layer from the sync system, breaking circular dependencies and enabling testability.

**Purpose:** Provide a clean interface for sending sync messages without coupling sync logic to networking implementation.

**What it solves:**

- **Circular dependency:** Sync depends on networking, networking depends on library, library depends on sync
- **Testability:** Mock implementations enable unit testing without network
- **Protocol flexibility:** Sync system doesn't care about transport (Iroh, WebRTC, etc.)
- **Error isolation:** Network errors don't corrupt sync state

NetworkTransport methods:
- `send_sync_message`: Fire-and-forget broadcast to specific device
- `send_sync_request`: Request-response pattern with timeout
- `get_connected_sync_partners`: List reachable sync partners for this library
- `is_device_reachable`: Quick check before attempting send

MockNetworkTransport provides a test implementation that records sent messages without network I/O. The real implementation lives in the networking layer and maps device UUIDs to Iroh NodeIds.

Implementation: `core/src/infra/sync/transport.rs`

## Foreign Key Mapping

Foreign key mapping resolves UUID references in synced data to local database IDs, ensuring referential integrity when applying changes.

**Purpose:** Translate foreign keys from UUIDs (sync representation) to local IDs (database representation) during sync apply.

**What it solves:**

- **Referential integrity:** FK constraints reference local IDs, not UUIDs
- **Batch efficiency:** Reduce N*M database queries to M batch queries
- **Mapping discovery:** Automatically resolve FKs without manual model-specific code
- **Insert order:** Insert records with resolved FKs in correct order

FKMapping declares which fields in a model reference other syncable models:

```rust
pub struct FKMapping {
    pub field_name: &'static str,
    pub target_table: &'static str,
    pub is_array: bool,
}
```

Batch FK mapper:
1. Collects all UUIDs referenced in incoming batch
2. Queries target tables in batches (M queries instead of N*M)
3. Builds UUID → local ID mapping
4. Replaces UUID fields in JSON data with local IDs
5. Returns ready-to-insert records

Implementation: `core/src/infra/sync/fk_mapper.rs`

## Dependency Graph

The dependency graph computes topological sort order for syncable models based on declared dependencies, ensuring foreign key constraints are never violated during sync.

**Purpose:** Determine safe ordering for inserting synced records so dependent records always exist before being referenced.

**What it solves:**

- **Constraint safety:** Sync never violates FK constraints
- **Deterministic ordering:** All devices sync in same order for consistency
- **Automatic validation:** Detect circular dependencies at registration time
- **Extensibility:** New models declare dependencies, no manual ordering

Models declare dependencies via `sync_depends_on` method returning array of model names:

```rust
impl Syncable for Entry {
    fn sync_depends_on() -> &'static [&'static str] {
        &["location"]  // entries reference locations
    }
}
```

The sync system runs topological sort at startup. If circular dependencies are detected, sync fails fast with error. The sorted order is used during backfill and conflict resolution.

Implementation: `core/src/infra/sync/dependency_graph.rs`

## Deterministic UUIDs

Deterministic UUID generation creates predictable IDs for system resources based on library UUID and resource type, enabling consistent identification across devices.

**Purpose:** Generate UUIDs that are the same across all devices for system resources without coordination.

**What it solves:**

- **System resources:** Default tags, albums, and spaces have consistent UUIDs
- **No coordination:** Devices generate same UUIDs independently
- **Merge safety:** System resources from different devices match automatically
- **Known IDs:** Code can reference system resources by known UUID

Functions:
- `deterministic_system_tag_uuid(tag_name, library_uuid)`: Tags like "Favorites", "Imported"
- `deterministic_system_album_uuid(album_name, library_uuid)`: Default albums
- `deterministic_library_default_uuid(library_uuid)`: Library-specific default resources
- `system_tags(library_uuid)`: Get list of system tag UUIDs

Uses UUID v5 (SHA-1 namespace) with library UUID as namespace and resource type/name as input. This produces deterministic IDs that differ per library but are consistent across devices.

Implementation: `core/src/infra/sync/deterministic.rs`

## Event Logging

The sync event log provides persistent, queryable logging of sync events for debugging, monitoring, and audit trails.

**Purpose:** Record all sync events to disk for post-mortem analysis and real-time monitoring.

**What it solves:**

- **Debugging:** Reproduce and diagnose sync issues after they occur
- **Monitoring:** Query sync health metrics and error rates
- **Audit trail:** Track which devices synced what and when
- **Performance analysis:** Identify bottlenecks in sync operations

Event log stored in `sync.db` sync_event_log table:
- timestamp, device_id, event_type, category, severity
- summary (short description), details (structured data)
- correlation_id (groups related events), peer_device_id
- model_types (affected models), record_count, duration_ms

Event types:
- `BackfillStarted`, `BackfillProgress`, `BackfillCompleted`, `BackfillFailed`
- `MessageReceived`, `MessageSent`, `MessageError`
- `StateChangeReceived`, `SharedChangeReceived`
- `ConnectionEstablished`, `ConnectionLost`
- `ConflictDetected`, `ConflictResolved`

SyncEventLogger provides structured logging with automatic correlation ID generation. SyncEventQuery enables filtering by time range, severity, category, peer, and event type. BatchAggregator reduces log churn by aggregating high-frequency events.

Implementation: `core/src/infra/sync/event_log/`

## Backfill Context

Backfill context tracks the state and progress of a full library sync operation, coordinating the backfill process across multiple model types and peers.

**Purpose:** Provide a central coordinator for backfill operations that tracks progress and manages state across the entire sync process.

**What it solves:**

- **Orchestration:** Coordinate backfill across all model types and all peers
- **Progress tracking:** Report overall backfill progress to UI
- **State management:** Track which peers are being backfilled, which models are synced
- **Cancellation:** Handle graceful cancellation of in-progress backfill

BackfillContext tracks:
- Library ID and device ID
- List of peers to backfill
- Current peer and model type
- Progress statistics (total records, synced records, errors)
- Status (in_progress, completed, failed, cancelled)

Helper functions:
- `in_backfill()`: Check if backfill is currently active for a library
- `is_in_backfill()`: Check if backfill is active for a specific device

The context is persisted in checkpoints for resumability and updated as each model type completes backfill for each peer.

Implementation: `core/src/infra/sync/backfill_context.rs`