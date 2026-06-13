# API Infrastructure Module

The API infrastructure module (`core/src/infra/api/`) provides a unified, type-safe API layer for all Spacedrive operations. It replaces scattered handler functions with a clean, unified entry point that handles cross-cutting concerns like authentication, authorization, session management, and error handling.

## Features

- **Unified API Dispatcher**: Single entry point for all operations (actions and queries) with automatic session context propagation
- **Session Management**: Rich session context that tracks authentication, library selection, device capabilities, and request metadata
- **Permission System**: Fine-grained permission checking for library, core, network, and job operations
- **Error Handling**: Comprehensive error types with automatic conversion from underlying system errors
- **Middleware Pipeline**: Extensible middleware system for logging, metrics, rate limiting, and other cross-cutting concerns
- **Request Metadata**: Audit trails with request IDs, timestamps, source tracking, and client information

## Unified API Dispatcher

### Purpose

The `ApiDispatcher` provides a single, clean entry point for all operations that replaces scattered handler functions throughout the codebase. It automatically handles session context propagation, permission checking, and error conversion before delegating to the appropriate action/query manager.

### What It Solves

Previously, each operation type (library action, core action, library query, core query) had its own handler with duplicated logic for permission checks, session validation, and error handling. The dispatcher centralizes this logic and provides a consistent interface for all applications (CLI, Swift, web) to interact with the core daemon.

### Key Functions

- `execute_library_action<A>`: Execute library-scoped state-changing operations
- `execute_core_action<A>`: Execute daemon-level operations
- `execute_library_query<Q>`: Execute library-scoped read operations
- `execute_core_query<Q>`: Execute daemon-level read operations
- `create_base_session`: Create a session context for the current device

## Session Management

### Purpose

The session system replaces simple `library_id` parameters with rich `SessionContext` objects that carry comprehensive information about who is making the request, what device they're using, what permissions they have, and what library context they're operating within.

### What It Solves

Many operations need to know more than just which library they're operating on. They need to know which user/device is making the request, what permissions that session has, what device capabilities are available, and request metadata for audit trails. The session system provides all of this information in a single, type-safe object that gets passed to every operation.

### Session Context Components

- `AuthenticationInfo`: User ID, device ID, authentication level, session timing
- `PermissionSet`: Core, library, network, and job permissions for this session
- `RequestMetadata`: Request ID, timestamp, source (CLI/Swift), client info
- `DeviceContext`: Device ID, name, OS, hardware model, capabilities
- `current_library_id`: Currently selected library for this session

### Authentication Levels

- `None`: No authentication - limited access
- `Device`: Device-level authentication - normal operations
- `User`: User-level authentication - personal operations (future)
- `Admin`: Admin-level authentication - system operations (future)

## Permission System

### Purpose

The permission layer provides fine-grained authorization for all API operations. It ensures that each session can only execute operations that it has permissions for, preventing unauthorized access to libraries, settings, devices, and other resources.

### What It Solves

Without a permission system, any authenticated client could execute any operation. The permission layer enables:
- Device-level vs user-level access control
- Read-only access restrictions
- Fine-grained library permissions (read, write, delete, manage locations/tags, search, index)
- Core system permissions (read status, manage libraries, modify settings, manage devices)
- Network operation permissions (start/stop, pair devices, spacedrop)
- Job management permissions (list, pause/resume, cancel, view details)

### Permission Checking

The `PermissionLayer` provides check methods for each operation type:
- `check_library_action<A>`: Verify session can execute library-scoped actions
- `check_core_action<A>`: Verify session can execute daemon-level actions
- `check_library_query<Q>`: Verify session can execute library-scoped queries
- `check_core_query<Q>`: Verify session can execute daemon-level queries

### Permission Sets

- `admin_all()`: Full admin permissions
- `device_default()`: Default device permissions (currently permissive)
- `read_only()`: Read-only access for query-only sessions

## Error Handling

### Purpose

The `ApiError` type provides a comprehensive, unified error type for all API operations. It wraps errors from the underlying action, query, and job systems and converts them into a consistent format with context about what went wrong.

### What It Solves

Different subsystems (actions, queries, jobs) have different error types. The API layer needs a unified error type that can represent all possible failures while providing meaningful context to clients. The error system automatically converts from underlying errors and provides HTTP status code equivalents for REST API scenarios.

### Error Categories

- **Authentication errors**: Unauthenticated access
- **Authorization errors**: Insufficient permissions
- **Session/context errors**: No library selected, invalid session, library not found
- **Input validation errors**: Invalid input, missing required fields
- **Operation execution errors**: Action/query/job execution failures
- **Resource errors**: Not found, conflicts
- **System errors**: Database, network, file system errors
- **Rate limiting and quotas**: Rate limit exceeded, quota exceeded
- **Generic errors**: Internal errors, timeouts

### Error Conversions

The error system implements automatic conversions from:
- `ActionError`: Core action execution errors
- `QueryError`: Query execution errors
- `JobError`: Job dispatch errors
- `anyhow::Error`: Generic application errors
- `String`/`&str`: Simple string errors

## Middleware Pipeline

### Purpose

The middleware system provides a composable way to handle cross-cutting concerns that apply to all operations. Instead of adding logging, metrics, or rate limiting code to every operation, middleware layers can be applied to the entire pipeline.

### What It Solves

Many concerns apply to all operations uniformly: logging every request, collecting metrics, enforcing rate limits, caching results, etc. The middleware system provides a clean, composable way to apply these concerns without duplicating code across operations.

### Middleware Layers

- **LoggingMiddleware**: Logs all API operations with request ID, operation name, device ID, library ID, duration, and success/failure
- **MetricsMiddleware**: Tracks operation metrics for monitoring and performance analysis
- **RateLimitMiddleware**: Prevents abuse by limiting request rates per device/user/operation
- **MiddlewarePipeline**: Composes multiple middleware layers into a single pipeline

### Middleware Pipeline

The `MiddlewarePipeline` allows combining multiple middleware layers:
- `with_logging()`: Add logging middleware
- `with_metrics()`: Add metrics middleware
- `with_rate_limiting()`: Add rate limiting middleware
- `default_pipeline()`: Create a pipeline with all default middleware

## Request Metadata

### Purpose

Request metadata provides comprehensive information about each API request for audit trails, debugging, and monitoring. It tracks when requests were made, where they came from, and provides a unique ID for tracing.

### What It Solves

For debugging and audit purposes, you need to track who made which request, when it was made, and from what source. Request metadata provides this information in a structured format that gets logged with each operation and can be used for analytics, troubleshooting, and compliance.

### Metadata Fields

- `request_id`: Unique UUID for this request (useful for tracing)
- `timestamp`: When the request was made
- `source`: Where the request came from (CLI, Swift, Internal, Other)
- `client_ip`: Client IP address for network requests
- `user_agent`: User agent string if applicable
- `metadata`: Additional key-value pairs for custom metadata

### Pre-built Constructors

- `cli_request()`: Request from the CLI application
- `swift_request()`: Request from the Swift/macOS application
- `internal_request()`: Internal system operation
- `with_metadata()`: Add custom metadata key-value pairs

## Architecture

The API module follows a layered architecture:

```
Applications (CLI, Swift, Web)
         ↓
   ApiDispatcher
         ↓
   PermissionLayer
         ↓
   ActionManager / QueryManager
         ↓
   Actions / Queries
```

Each layer has a specific responsibility:
- **Applications**: Make requests with session context
- **ApiDispatcher**: Unified entry point, session validation, permission checking
- **PermissionLayer**: Authorization checks based on session permissions
- **ActionManager/QueryManager**: Dispatch to specific operations
- **Actions/Queries**: Execute business logic

## Integration

The API module integrates with:
- **Action system**: `core/src/infra/action/` for state-changing operations
- **Query system**: `core/src/infra/query/` for read operations
- **Job system**: `core/src/infra/job/` for long-running operations
- **Device manager**: For device ID and session creation
- **Core context**: Shared business logic context

## Future Enhancements

- **User authentication**: Full user session support with JWT tokens
- **Role-based access control**: Role definitions and role assignment
- **Advanced rate limiting**: Per-device, per-operation, and tiered rate limits
- **Metrics collection**: Integration with Prometheus/StatsD
- **Request caching**: Middleware for caching query results
- **API versioning**: Support for multiple API versions
- **CORS support**: Cross-origin resource sharing configuration
- **Webhook support**: Event notifications via webhooks