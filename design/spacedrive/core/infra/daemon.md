# Daemon Features

This document outlines the features that the Spacedrive daemon needs to implement. The daemon provides a centralized, long-running process that manages core functionality while multiple clients (CLI, GraphQL server, desktop app) connect to it.

## Features Overview

- **RPC Server**: JSON-over-TCP server for client communication
- **Event Streaming**: Real-time event broadcasting with filtering
- **Log Streaming**: Real-time log message streaming with filtering
- **Connection Management**: Multi-client support with connection limits
- **Event Buffering**: Handling subscription race conditions
- **Daemon Bootstrap**: Initialization and startup sequence
- **Operation Registry**: Dynamic handler registration for actions/queries
- **Graceful Shutdown**: Clean termination with resource cleanup

## RPC Server

The RPC server provides the primary communication interface between clients and the daemon. It uses a simple JSON-over-TCP protocol with newline-delimited messages.

### Purpose

Enables type-safe client-daemon communication without complex protocol overhead. JSON is chosen for broad language compatibility and ease of debugging.

### What it solves

- **Protocol simplicity**: No need for complex protocol buffers or gRPC infrastructure
- **Language agnostic**: Any client can communicate via JSON over TCP
- **Connection management**: Handles multiple concurrent connections with proper lifecycle
- **Request-response**: Synchronous operations return results immediately
- **Streaming**: Long-lived connections for real-time events and logs

### Implementation

Location: `core/src/infra/daemon/rpc.rs`

- TCP listener with configurable address
- Concurrent connection handling via `tokio::spawn`
- Connection limits to prevent resource exhaustion (default: 100)
- JSON-RPC 2.0-like protocol with newline-delimited messages
- Support for both request-response and streaming modes
- Integration with operation registry for method dispatch

## Event Streaming

The daemon broadcasts real-time events to subscribed clients, enabling UI updates and progress tracking across all connected clients.

### Purpose

Provides a push-based notification system so clients can react to changes immediately without polling.

### What it solves

- **Real-time UI updates**: File operations, job progress, library state changes appear instantly
- **Multi-client consistency**: All clients see the same state updates simultaneously
- **Efficient resource usage**: No polling required, clients only receive relevant events
- **Filtering support**: Clients subscribe to specific event types and scopes

### Implementation

Location: `core/src/infra/daemon/rpc.rs` (event broadcaster), `event_buffer.rs`

- Subscribes to core event bus on startup
- Broadcasts events to all matching connections
- Event filtering by:
  - Event type (inclusion list)
  - Library ID
  - Job ID
  - Device ID
  - Resource type (file, location, etc.)
  - Path scope with descendant inclusion
- Event buffer for handling race conditions (see below)
- Automatic cleanup of closed connections

## Log Streaming

Separate streaming channel for real-time log messages, enabling clients to view debug output and job-specific logs without server-side log file access.

### Purpose

Provides real-time access to daemon and job logs for debugging and monitoring without requiring file system access to the daemon's data directory.

### What it solves

- **Remote debugging**: Clients can view logs without daemon server access
- **Job-specific logs**: Filter logs by job ID to track specific operations
- **Library-specific logs**: Filter by library ID for per-library diagnostics
- **Level filtering**: Show only INFO, WARN, or ERROR logs as needed
- **Component filtering**: Target specific modules (e.g., `sd_core::ops`)

### Implementation

Location: `core/src/infra/daemon/rpc.rs`

- Subscribes to global `LogBus` via `LogEventLayer`
- Separate from event bus (not broadcast as events)
- Log filtering by:
  - Library ID
  - Job ID
  - Log level (INFO, WARN, ERROR, DEBUG)
  - Target/component name
- Per-connection log streaming via background tasks

## Connection Management

The daemon manages multiple concurrent client connections with proper lifecycle handling and resource limits.

### Purpose

Enables multiple clients to connect to the same daemon instance simultaneously while preventing resource exhaustion.

### What it solves

- **Multi-client support**: CLI, desktop app, and GraphQL server can all connect
- **Resource limits**: Prevents denial of service via connection flooding
- **Graceful degradation**: Rejects new connections when limits reached
- **Automatic cleanup**: Removes dead connections from internal state
- **Connection tracking**: Monitors active connection count for observability

### Implementation

Location: `core/src/infra/daemon/rpc.rs`

- Connection counter with atomic operations
- Configurable max connections (default: 100)
- HashMap tracking active connections by UUID
- Automatic removal of closed connections
- File descriptor limit checks and warnings
- Connection statistics for monitoring

## Event Buffering

The daemon buffers recent events to handle subscription race conditions where events are emitted before clients subscribe.

### Purpose

Ensures clients don't miss events that occur between connection and subscription.

### What it solves

- **Race condition handling**: Events emitted before subscription are replayed
- **No missed updates**: Critical state changes are always delivered
- **Memory safety**: Bounded buffer with time-based eviction
- **Performance**: Uses `Arc<Event>` to avoid expensive clones during replay

### Implementation

Location: `core/src/infra/daemon/event_buffer.rs`

- Fixed-size buffer (default: 100 events)
- Time-based retention (default: 5 seconds)
- Periodic cleanup task prevents unbounded growth
- Events stored with `Arc` for efficient replay
- Subscription flow:
  1. Get matching buffered events
  2. Register connection for live streaming
  3. Send buffered events in chronological order
  4. Continue receiving live events

## Daemon Bootstrap

The bootstrap process initializes all daemon components including core, networking, and logging infrastructure.

### Purpose

Provides a single entry point for starting the daemon with all required subsystems initialized in the correct order.

### What it solves

- **Initialization ordering**: Core, networking, and RPC server start in correct sequence
- **Logging setup**: Configures file-based logging with multiple streams
- **Configuration loading**: Reads app config for logging filters
- **System checks**: Validates file descriptor limits
- **Graceful failures**: Provides clear error messages for common startup issues

### Implementation

Location: `core/src/infra/daemon/bootstrap.rs`

- Initializes `tracing` subscriber with file logging
- Creates and configures `Core` instance
- Optionally initializes networking
- Starts RPC server with event streaming
- Logs system information (data directory, socket address)
- Checks file descriptor limits on Unix systems
- Supports embedded mode (when daemon runs inside other processes)

## Operation Registry

The operation registry provides dynamic handler registration for actions and queries without hard-coding method dispatch logic.

### Purpose

Enables compile-time registration of operations that become available at runtime without manual registration code.

### What it solves

- **No boilerplate**: Operations self-register via macros
- **Type safety**: Compile-time checks for input/output types
- **Extensibility**: New operations don't require changes to dispatch logic
- **Decoupling**: RPC server doesn't know about concrete operation types
- **Testability**: Handlers can be unit-tested independently

### Implementation

Location: `core/src/infra/daemon/dispatch.rs`, `core/src/ops/registry.rs`

- Uses `inventory` crate for compile-time collection
- Generic handlers for actions and queries
- Bincode serialization for payload encoding
- JSON-over-TCP mode for external clients
- Registry lookup by method string
- Separate registries for:
  - Core actions (library-scoped operations)
  - Library actions (library-specific operations)
  - Core queries (global data retrieval)
  - Library queries (library-specific data retrieval)

## Graceful Shutdown

The daemon supports clean termination with proper resource cleanup and state persistence.

### Purpose

Ensures data integrity and proper cleanup when the daemon is shut down, preventing data loss and resource leaks.

### What it solves

- **Data persistence**: Ensures in-memory state is flushed to disk
- **Connection cleanup**: Closes all client connections gracefully
- **Job completion**: Allows in-progress jobs to complete or be cancelled cleanly
- **Resource release**: Frees file descriptors, network sockets, and other resources
- **Signal handling**: Responds to shutdown signals (SIGTERM, SIGINT)

### Implementation

Location: `core/src/infra/daemon/rpc.rs`

- Shutdown channel for signaling termination
- RPC server exits accept loop on shutdown signal
- Core `shutdown()` method called for cleanup
- Connections close naturally (clients detect EOF)
- Log streams and event broadcasters stop
- Background tasks terminated when tokio runtime shuts down

## Client Library

The client library provides a convenient API for connecting to the daemon from Rust applications.

### Purpose

Abstracts TCP communication and protocol details from application code.

### What it solves

- **Protocol hiding**: Applications don't need to implement JSON-over-TCP manually
- **Connection pooling**: Reuses connections when possible
- **Type safety**: Serialization/deserialization handled automatically
- **Streaming support**: Easy setup for event and log subscriptions

### Implementation

Location: `core/src/infra/daemon/client.rs`

- `DaemonClient` struct with socket address
- `send()` method for request-response operations
- `stream()` method for event subscriptions
- `stream_logs()` method for log subscriptions
- Automatic serialization/deserialization
- Error handling with descriptive messages