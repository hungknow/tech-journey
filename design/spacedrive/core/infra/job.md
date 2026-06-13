# Job System

The job system provides a robust framework for executing, managing, and monitoring long-running operations in Spacedrive. It supports resumable jobs, checkpointing, progress tracking, and integration with the task system for efficient execution.

## Features

- [Job Registration](#job-registration) - Compile-time job discovery and type-safe dynamic dispatch
- [Job Execution](#job-execution) - Task system integration with lifecycle management
- [Job Context](#job-context) - Execution environment with services and capabilities
- [Progress Reporting](#progress-reporting) - Real-time progress updates with multiple formats
- [Checkpointing](#checkpointing) - State persistence for resumable jobs
- [Job Handles](#job-handles) - Control and monitoring interface for running jobs
- [Job Manager](#job-manager) - Central orchestration for job lifecycle
- [Job Persistence](#job-persistence) - Database-backed state storage and resumption
- [Event Integration](#event-integration) - Real-time job events for UI updates
- [File Logging](#file-logging) - Per-job log files for debugging and auditing

## Job Registration

The job registry uses compile-time registration to automatically discover job types across the codebase, enabling type-safe dynamic dispatch without manual boilerplate.

**Purpose:** Provides zero-boilerplate job registration so new job types become available throughout the system without modifying registration logic.

**What it solves:**
- Eliminates manual job registration code
- Enables job discovery by name for API dispatch
- Supports schema introspection for job parameters
- Handles serialization/deserialization for resumption
- Works with the inventory crate for compile-time collection
- Provides type safety through `DynJob` trait

Jobs register using the `inventory` crate at compile time. The global `REGISTRY` collects all registered jobs and provides methods to:
- List available job names
- Get job schema for introspection
- Create job instances from JSON (for API dispatch)
- Deserialize jobs from binary (for resumption)
- Check if a job type exists

## Job Execution

The job executor wraps jobs for execution in the task system, handling lifecycle events, status updates, and error recovery.

**Purpose:** Provides a consistent execution environment for all jobs with automatic status management and integration with the task system.

**What it solves:**
- Task system integration without job implementations needing task-specific knowledge
- Automatic status transitions (Queued → Running → Completed/Failed/Cancelled)
- Error handling and propagation to the job manager
- Progress forwarding and event emission
- Job state persistence at appropriate points
- Lifecycle hooks (pause, resume, cancel)

The executor implements the `Task` trait and:
- Creates a job context with all required services
- Runs the job's `run()` method
- Handles interruptions gracefully
- Updates status in both memory and database
- Emits appropriate events
- Manages file logger lifecycle
- Cleans up checkpoints on completion

## Job Context

The job context provides execution-time services and capabilities to jobs, including library access, networking, volume management, and progress reporting.

**Purpose:** Supplies jobs with everything they need to execute without tight coupling to system internals.

**What it solves:**
- Jobs access library database and services through a clean interface
- Progress reporting is abstracted behind a simple API
- Checkpointing is provided without jobs managing persistence directly
- Jobs can check for interrupts without knowing the interrupter implementation
- Child job spawning capability (planned)
- Access to networking and volume services for distributed operations

The context provides:
- Job ID and library reference
- Progress channel for reporting updates
- Metrics tracking (bytes processed, items processed, error counts)
- Checkpoint handler for state persistence
- Access to networking service
- Access to volume manager
- File logger for job-specific logs
- Interrupter for cooperative cancellation

## Progress Reporting

Jobs can report progress in multiple formats, with automatic forwarding to subscribers and database persistence.

**Purpose:** Provide flexible progress reporting that works for different job types (file operations, indexing, generic tasks) while maintaining consistent delivery to consumers.

**What it solves:**
- Jobs report progress without knowing about subscribers
- Multiple progress formats support different use cases:
  - `percentage()` - Simple 0-1 float progress
  - `message()` - Text status updates
  - `indeterminate()` - Indeterminate progress bars
  - `Generic` - Structured progress with phases and completion tracking
  - `Structured` - Type-specific progress (e.g., CopyProgress)
- Automatic throttling prevents event bus flooding
- Database persistence for historical progress tracking
- Real-time UI updates through event emission
- Backward compatibility with legacy progress formats

Progress updates flow through multiple channels:
- `mpsc` channel from job to manager
- `broadcast` channel for multiple subscribers
- Event bus emission (throttled to 100ms)
- Database updates (throttled to 2 seconds)

## Checkpointing

Jobs can create checkpoints to save their state at arbitrary points, enabling resumption from interruptions.

**Purpose:** Provide fine-grained state control for long-running jobs so they can resume from exactly where they left off after crashes or shutdowns.

**What it solves:**
- Jobs avoid redoing completed work after interruption
- Checkpoints can include custom state specific to the job
- Automatic checkpoint cleanup on completion
- Integration with job persistence for full state recovery
- No need for jobs to manage persistence directly

Checkpointing features:
- `ctx.checkpoint()` - Simple checkpoint with job state
- `ctx.checkpoint_with_state()` - Checkpoint with custom state
- `ctx.save_state()` - Save state without marking checkpoint
- `ctx.load_state()` - Load previous state
- Database-backed checkpoint storage
- Automatic cleanup when jobs complete successfully

Jobs implementing `JobHandler` can also override `on_pause()` and `on_resume()` for custom pause/resume logic.

## Job Handles

Job handles provide a control interface for running jobs, allowing consumers to monitor status, receive progress updates, and wait for completion.

**Purpose:** Give callers a way to interact with running jobs without coupling to the job manager implementation.

**What it solves:**
- Callers can check job status without accessing internal state
- Progress subscriptions work with multiple concurrent consumers
- Jobs can be waited on synchronously or asynchronously
- Serializable `JobReceipt` for passing handles across process boundaries
- Job output is available after completion

Handle capabilities:
- `status()` - Get current job status
- `subscribe_status()` - Watch for status changes
- `subscribe_progress()` - Receive progress updates
- `wait()` - Block until job completes
- `to_receipt()` - Convert to serializable form

Note: Pause/resume/cancel operations require access to the job manager and are not yet implemented on handles.

## Job Manager

The job manager orchestrates job execution, persistence, and lifecycle management for a single library.

**Purpose:** Provide a centralized job execution system that handles all job lifecycle management, persistence, and event emission.

**What it solves:**
- Single point of control for job dispatch and monitoring
- Automatic job resumption after daemon restart
- Progress forwarding with throttling
- Event emission for real-time UI updates
- Database persistence for job history
- Integration with task system for execution
- Library statistics recalculation on completion
- Background vs foreground job distinction

Manager responsibilities:
- Job dispatch with priority support
- Job resumption from interrupted state
- Progress forwarding and throttling
- Event emission with throttling
- Database persistence (for persistent jobs)
- Running job tracking in memory
- Job completion monitoring and cleanup
- Library statistics updates after jobs complete

The manager maintains its own database (`jobs.db`) separate from the library database for job state.

## Job Persistence

Jobs can be persisted to a database for historical tracking and resumption after interruptions. Persistence is optional and controlled by the `DynJob::should_persist()` method.

**Purpose:** Enable job state to survive daemon restarts and provide a history of job executions.

**What it solves:**
- Jobs resume after crashes or shutdowns
- Job history persists for auditing
- Progress is tracked across sessions
- Ephemeral jobs (like volume indexing) don't clutter the database
- Background jobs can run without persistence overhead

Persistence features:
- Separate `jobs.db` database per library
- Automatic state serialization on pause
- Progress updates persisted periodically
- Job state loaded for resumption
- Ephemeral jobs skip persistence (configurable)
- Action context preserved for audit trail
- Error messages and warnings stored
- Completion metrics tracked

The job database schema includes:
- Job ID, name, and status
- Serialized job state
- Progress data (type and serialized progress)
- Timestamps (created, started, completed, paused)
- Priority and error information
- Parent job ID for job hierarchies
- Action context for origin tracking

## Event Integration

Jobs emit events through the event bus for real-time UI updates and cross-component coordination.

**Purpose:** Enable all connected clients to see job state changes and progress without polling.

**What it solves:**
- UI updates instantly as jobs progress
- Multiple clients see consistent job state
- No polling overhead
- Throttled emission prevents event flooding
- Generic progress support for UI components

Emitted events:
- `JobStarted` - When job transitions to Running
- `JobProgress` - Throttled progress updates (100ms)
- `JobCompleted` - When job finishes successfully
- `JobFailed` - When job encounters an error
- `JobCancelled` - When job is cancelled

Events include:
- Job ID and type
- Device ID running the job
- Progress percentage
- Progress message
- Generic progress data for structured UI updates
- Job output (on completion)

Background jobs (ephemeral jobs with `should_emit_events() = false`) skip event emission to reduce noise.

## File Logging

Each job can write to its own log file for debugging and auditing purposes. Logging is configurable and supports both persistent and ephemeral jobs.

**Purpose:** Provide per-job debugging logs that survive job completion and daemon restarts.

**What it solves:**
- Debugging specific job executions without noisy global logs
- Auditing job-specific operations and errors
- Troubleshooting failed jobs after they complete
- Historical logs for compliance or review
- Configurable logging level and retention

Logging features:
- Per-job log files in `library/job_logs/` directory
- Structured log levels (INFO, WARN, ERROR, DEBUG)
- Progress messages logged automatically
- Job context included in log messages
- Configurable via `JobLoggingConfig`:
  - Enable/disable for ephemeral jobs
  - Log level filtering
  - File retention policy
- Integration with job context for easy logging from job implementations

Log format:
- Timestamp
- Log level
- Job ID
- Message

Job logging is separate from the global tracing infrastructure, providing job-specific logs without polluting the daemon's main log file.