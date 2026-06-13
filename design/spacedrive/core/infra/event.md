# Event System

The event system provides decoupled communication throughout Spacedrive. It enables different components to react to system changes without tight coupling, supporting real-time updates, cache invalidation, and cross-component coordination.

## Features

- [Event Bus](#event-bus) - Central broadcast mechanism for all system events
- [Subscription Filtering](#subscription-filtering) - Targeted event delivery based on resource type and path scope
- [Path-Scoped Event Matching](#path-scoped-event-matching) - Hierarchical event filtering for physical and virtual paths
- [Resource Events](#resource-events) - Normalized cache update events for all resource types
- [Event Types](#event-types) - Comprehensive event coverage across all system components
- [Log Streaming Bus](#log-streaming-bus) - Separate high-volume log message streaming for CLI clients

## Event Bus

The event bus provides a publish-subscribe pattern for broadcasting events throughout the daemon. Multiple subscribers can receive events concurrently without publishers knowing about consumers.

**Purpose:** Enables decoupled communication between system components. Libraries, jobs, sync, indexing, and the UI can all react to changes without direct dependencies on each other.

**What it solves:**
- Avoids tight coupling between components
- Supports multiple concurrent consumers
- Enables real-time UI updates without polling
- Allows job progress and state changes to reach all interested parties
- Provides a single source of truth for system-wide state changes

The bus uses `tokio::sync::broadcast` channels with configurable capacity. Subscribers can be unfiltered (receive all events) or filtered (receive only matching events).

## Subscription Filtering

Subscription filtering enables targeted event delivery based on resource type and optional path scopes. Filters reduce noise and improve performance by only delivering relevant events to each subscriber.

**Purpose:** Prevents subscribers from receiving irrelevant events, reducing processing overhead and improving application responsiveness.

**What it solves:**
- UI components only receive events for resources they display
- Path-scoped views (like a specific directory) don't receive updates from unrelated locations
- Reduces unnecessary re-renders and cache invalidations
- Improves daemon performance by avoiding unnecessary event serialization and transmission

Two filter types are supported:
- `Global`: Receives all events of a specific resource type
- `PathScoped`: Receives events affecting a specific path hierarchy (recursive or direct children only)

## Path-Scoped Event Matching

Path-scoped matching allows subscribers to receive events only for paths they're interested in. The system supports both physical filesystem paths and virtual paths (Content ID, Cloud, Sidecar).

**Purpose:** Enables hierarchical event filtering so users viewing a specific directory only see events affecting that directory's contents.

**What it solves:**
- Directory views don't update when unrelated files change
- Large library updates don't overwhelm focused views
- Supports both recursive (all descendants) and exact (direct children) matching modes
- Handles non-hierarchical paths (Content ID, Cloud) appropriately

The matching logic handles:
- Physical path hierarchical matching (recursive vs exact)
- Content ID exact matching
- Sidecar content ID association
- Cloud path hierarchical matching
- Alternate path resolution (content may exist in multiple locations)

## Resource Events

Resource events (`ResourceChanged`, `ResourceChangedBatch`, `ResourceDeleted`) provide a normalized format for cache updates across all resource types (files, tags, albums, locations, etc.).

**Purpose:** Simplify frontend cache management with a single, consistent event format regardless of resource type.

**What it solves:**
- Eliminates the need for different event handling logic per resource type
- Supports batch updates during indexing to reduce event overhead
- Provides metadata for proper merge vs replace behavior
- Includes affected paths for path-scoped filtering
- Marks fields that should replace rather than merge with existing data

The batch variant (`ResourceChangedBatch`) is used during high-volume operations like file indexing to emit multiple resource updates in a single event.

## Event Types

The system defines comprehensive event types covering all major system operations:

- **Core lifecycle**: `CoreStarted`, `CoreShutdown`
- **Library management**: Creation, opening, closing, deletion, load failures, statistics updates
- **Entry operations**: Creation, modification, deletion, moves (deprecated, use ResourceChanged)
- **Volume events**: Added, removed, updated, speed tested, mount changes, errors
- **Job lifecycle**: Queued, started, progress, completed, failed, cancelled, paused, resumed
- **Indexing**: Started, progress, completed, failed
- **Device connectivity**: Connected, disconnected
- **Sync**: State changes, activity, connection changes, errors
- **Cache invalidation**: `Refresh` for full cache invalidation
- **Filesystem raw events**: Unresolved filesystem changes for the responder system
- **Config changes**: Field-level configuration updates
- **Custom events**: Extensible events for third-party integrations

**Purpose:** Provide comprehensive visibility into all system state changes for monitoring, UI updates, and cross-component coordination.

**What it solves:**
- UI can update in real-time as files are indexed, jobs complete, or sync progresses
- Monitoring and logging systems can track all system activity
- Components can react to relevant changes without polling
- Debugging and auditing through event logs
- Network sync can propagate state changes to peers

Legacy event types (`EntryCreated`, `EntryModified`, etc.) are deprecated but maintained for compatibility. New code should use `ResourceChanged` events.

## Log Streaming Bus

The log streaming bus (`LogBus`) is a separate broadcast channel dedicated to log messages from the tracing system. It's isolated from the main event bus to avoid high-volume log events overwhelming other subscribers.

**Purpose:** Stream structured log messages to CLI clients and other monitoring tools without polluting the main event bus.

**What it solves:**
- CLI clients can display real-time logs from daemon operations
- Prevents log volume from affecting performance-critical event delivery
- Integrates with the existing tracing infrastructure via `LogEventLayer`
- Captures job and library context from tracing spans
- Only emits INFO and above to avoid noise

The `LogEventLayer` implements a tracing subscriber that automatically extracts log messages, timestamps, levels, and context (job_id, library_id) from tracing spans and emits them to the log bus.

## Implementation

All implementation is in `core/src/infra/event/`:

- `mod.rs`: Main event bus, `Event` enum, subscription filtering, path matching
- `log_emitter.rs`: Log streaming bus and tracing layer integration