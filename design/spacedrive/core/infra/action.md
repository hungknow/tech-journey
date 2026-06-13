# Action System Features

## Overview

The Action System provides a centralized, robust, and extensible layer for handling all user-initiated operations. It serves as the primary integration point for CLI, daemon RPC, and future APIs, with built-in audit logging, validation, and confirmation support.

## Core Features

### 1. Action Traits

- **CoreAction**: Trait for core-level actions that operate without library context (managing libraries, volumes, devices, etc.)
- **LibraryAction**: Trait for library-scoped actions that operate within a specific library context (files, locations, indexing, etc.)

Both traits provide:
- Input/Output type associations with wire contracts
- Pre-execution validation step
- User confirmation workflow support
- Async execution with proper error handling
- Action kind identification for logging

**Purpose**: Provides a unified abstraction for all user-initiated operations across the system, enabling type-safe execution, validation, and audit logging.

### 2. Action Manager

- Central dispatcher for all action execution
- Automatic audit log creation and synchronization
- Library existence validation for library actions
- Result tracking and error handling
- Action history querying by library
- Individual action retrieval by UUID

**Purpose**: Eliminates code duplication in action execution logic and ensures consistent audit logging across all operations, with automatic sync for multi-device environments.

### 3. Action Context

- Tracks which action spawned each job
- Captures action type, initiation time, and user/session
- Stores sanitized action input for audit purposes
- Provides action-specific context metadata
- Enables rich contextual metadata throughout job lifecycle

**Purpose**: Enables detailed tracing of operation origins and provides rich context for debugging, monitoring, and user-facing progress displays.

### 4. Validation & Confirmation Workflow

- Pre-execution validation step for all actions
- Returns `ValidationResult::Success` or `ValidationResult::RequiresConfirmation`
- Confirmation requests with user-facing messages and choices
- Optional metadata for rich UI display (strategy info, file counts, etc.)
- Resolution step to handle user choices

**Purpose**: Prevents destructive operations without user consent and enables interactive workflows for complex operations (file conflicts, migration strategies, etc.).

### 5. Comprehensive Error Handling

- `ActionError` enum covering all failure scenarios:
  - Action registration and input validation errors
  - Permission, library, location, and device not found errors
  - File system, network, and database errors
  - Job execution and timeout errors
  - Validation and cancellation errors
- Type aliases for `ActionResult<T>`
- Conversion from related error types (LibraryError, CoreError, IO errors)
- Helpers for specific error types (io_error, device_manager_error)

**Purpose**: Provides actionable error messages to users and enables proper error recovery across all action types.

### 6. Action Receipts

- Unique identifier for each action execution
- Optional job handle for background operations
- Optional result payload for immediate actions
- Immediate vs. job-based execution tracking
- Hybrid support for actions with both immediate results and background work

**Purpose**: Enables clients to track action execution status and follow up on long-running operations via job handles.

### 7. Action Output Trait

- Standardized interface for action outputs
- JSON serialization support
- Human-readable display messages
- Output type identification
- Type-safe output handling

**Purpose**: Ensures consistent output handling across all actions and enables both programmatic and human-readable output formats.

### 8. Action Builder Pattern

- `ActionBuilder` trait for constructing actions
- `CliActionBuilder` for CLI-specific construction
- Comprehensive `ActionBuildError` types:
  - Validation errors (single or multiple messages)
  - IO and parse errors
  - Permission and argument errors
  - Required field errors
- Helper methods for common error scenarios

**Purpose**: Provides a flexible, testable way to construct actions from various sources (CLI arguments, API requests, UI forms) with proper validation.

### 9. Audit Logging

- Automatic creation of audit log entries for library actions
- Tracking of action type, device, targets, status, and job IDs
- Timestamp-based audit trails (created_at, completed_at)
- Error message logging for failed actions
- Result payload storage for successful actions
- Version tracking for sync conflict resolution
- Automatic synchronization across devices

**Purpose**: Provides complete audit trails for compliance, debugging, and multi-device coordination, with sync support for distributed environments.

## Integration Points

- **Wire Registry**: Actions registered with `register_core_action!` and `register_library_action!` macros
- **RPC Server**: JSON-RPC endpoint executes actions via `execute_json_operation()`
- **Job System**: Actions can spawn background jobs with action context tracking
- **Sync System**: Audit logs automatically synchronized across devices
- **CLI**: Actions invocable from CLI with proper validation and confirmation handling