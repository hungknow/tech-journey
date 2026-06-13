# Query Infrastructure Features

This document outlines the features that the query infrastructure needs to implement. The query module provides the read-only side of the CQRS architecture, enabling efficient data retrieval without state mutation.

## Features Overview

- **Query Traits**: Type-safe interfaces for library-scoped and core-scoped queries
- **Query Manager**: Central dispatch with validation, logging, and error handling
- **Query Context**: Tracking query origins, metadata, and caching support
- **Error Handling**: Comprehensive error types for query operations

## Query Traits

The query system defines two trait types that all query operations must implement, providing a consistent interface across the application.

### Purpose

Enforces a standard pattern for all query operations while maintaining type safety and providing optional validation hooks.

### What it solves

- **Type safety**: Compile-time guarantees for input/output types
- **Consistency**: All queries follow the same lifecycle (validation, execution)
- **Scoping**: Clear separation between library-scoped and daemon-scoped operations
- **Validation**: Optional pre-execution validation for input sanitization
- **Testability**: Queries can be unit-tested independently
- **Wire protocol integration**: Queries automatically integrate with the RPC system

### Implementation

Location: `core/src/infra/query/mod.rs`

- **`LibraryQuery`**: For queries operating within a specific library context
  - Requires `library` parameter in validation
  - Used for operations like file listing, location queries
  - Input/Output types must be `Send + Sync + 'static`
  - Default validation always succeeds (opt-in)

- **`CoreQuery`**: For queries operating at daemon level
  - No library context required
  - Used for operations like library listing, device status
  - Same type constraints as `LibraryQuery`
  - Default validation always succeeds (opt-in)

Both traits provide:
- `from_input()`: Create query instance from input data
- `validate()`: Optional pre-execution validation (async)
- `execute()`: Main query logic with session context (async)

## Query Manager

The `QueryManager` provides centralized dispatch for all queries with consistent infrastructure support including validation, logging, and error handling.

### Purpose

Acts as the single point of entry for executing queries, ensuring all queries go through the same validation, logging, and error handling pipeline.

### What it solves

- **Consistency**: All queries follow the same execution path
- **Observability**: Automatic logging of query type, duration, and library/device context
- **Error handling**: Unified error propagation and conversion
- **Library resolution**: Automatic library lookup for library-scoped queries
- **Performance tracking**: Query duration logging for monitoring
- **Validation enforcement**: All queries validated before execution

### Implementation

Location: `core/src/infra/query/manager.rs`

- **`QueryManager`**: Central dispatcher struct
  - Holds reference to `CoreContext` for library/device access
  - Created via `new()` with context

- **`dispatch_core()`**: Execute daemon-scoped queries
  1. Validates the query against core context
  2. Logs query execution with device ID
  3. Executes query with timing measurement
  4. Logs completion with duration
  5. Returns result or error

- **`dispatch_library()`**: Execute library-scoped queries
  1. Looks up library by ID (returns error if not found)
  2. Validates the query against library and core context
  3. Logs query execution with library and device ID
  4. Executes query with timing measurement
  5. Logs completion with duration and library context
  6. Returns result or error

## Query Context

The `QueryContext` provides rich metadata about query execution, enabling tracking of origins, caching hints, and audit information.

### Purpose

Captures contextual information about each query execution for debugging, caching, and audit purposes.

### What it solves

- **Audit trails**: Track which user/session initiated each query
- **Caching support**: Mark queries as cacheable with duration hints
- **Debugging**: Query timing, input, and context for troubleshooting
- **Security**: Sanitized input logging to avoid leaking sensitive data
- **Origin tracking**: Identify the source of each query operation

### Implementation

Location: `core/src/infra/query/context.rs`

- **`QueryContext`**: Metadata struct for query execution
  - `query_type`: Name of the query operation
  - `initiated_at`: Timestamp when query started
  - `initiated_by`: Optional user/session identifier
  - `query_input`: Sanitized input data (JSON)
  - `context`: Additional query-specific metadata
  - `cacheable`: Whether result can be cached
  - `cache_duration`: Optional cache duration hint

- **`QueryContextProvider`**: Trait for queries to provide context
  - `create_query_context()`: Generate context for this instance
  - `query_type_name()`: Static type name for the query
  - `is_cacheable()`: Whether this query type is cacheable (default: false)
  - `cache_duration()`: Cache duration for this query type (default: None)

- **`sanitize_query_input()`**: Safe input serialization
  - Converts input to JSON for logging
  - Currently passes through as-is
  - Future extension: field-level sanitization for passwords/tokens

Builder methods for `QueryContext`:
- `with_initiated_by()`: Set user/session identifier
- `with_initiated_at()`: Custom timestamp
- `with_caching()`: Mark as cacheable with duration

## Error Handling

The query system provides comprehensive error types covering all failure modes in query execution.

### Purpose

Provides clear, actionable error information for query failures across all subsystems.

### What it solves

- **Type safety**: Compile-time error guarantees via `QueryResult<T>`
- **Error conversion**: Automatic conversion from subsystem errors
- **Descriptive messages**: Clear error context for debugging
- **Error categorization**: Separate error types for different failure modes
- **Propagation**: Errors flow cleanly from bottom layers to clients

### Implementation

Location: `core/src/infra/query/error.rs`

Error types:
- **Registry errors**: `QueryNotRegistered`, `InvalidQueryType`
- **Input validation**: `InvalidInput`, `PermissionDenied`, `Validation`
- **Resource errors**: `LibraryNotFound`, `LocationNotFound`, `DeviceNotFound`
- **System errors**: `FileSystem`, `Network`, `Database`, `Io`
- **Execution errors**: `Timeout`, `Cancelled`
- **Infrastructure**: `DeviceManager`, `Cache`
- **Serialization**: `JsonSerialization`, `SeaOrm`

Automatic conversions:
- `LibraryError` → `QueryError::Internal`
- `CoreError` → `QueryError::Internal`
- `std::io::Error` → `QueryError::Io`
- `anyhow::Error` → `QueryError::Internal`

Helper methods:
- `io_error()`: Create IO error with known path
- `device_manager_error()`: Create device manager error from display type