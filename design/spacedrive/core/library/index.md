# Library Module Features

The library module (`core/src/library/`) provides the core functionality for managing Spacedrive libraries. A library is a self-contained unit that stores metadata, thumbnails, and configuration for indexed file locations.

## Features Overview

- [Library Lifecycle Management](#library-lifecycle-management)
- [Library Configuration](#library-configuration)
- [Database Management](#database-management)
- [Lock Management](#lock-management)
- [Device Management](#device-management)
- [Sync Integration](#sync-integration)
- [Statistics Tracking](#statistics-tracking)
- [Thumbnail Management](#thumbnail-management)
- [Event System](#event-system)
- [Job System Integration](#job-system-integration)
- [File System Watching](#file-system-watching)
- [Error Handling](#error-handling)

---

## Library Lifecycle Management

### Purpose
Provides complete lifecycle management for Spacedrive libraries from creation to deletion, ensuring data integrity and proper resource cleanup throughout the library's existence.

### What It Solves
- Prevents data corruption by managing library initialization and shutdown sequences
- Handles concurrent access scenarios through proper locking mechanisms
- Enables automatic library discovery and loading on daemon startup
- Supports both manual and automated library creation workflows
- Provides clean deletion with optional data removal

### Key Components
- **Library Creation**: `LibraryManager::create_library()` - Creates new libraries with proper initialization
- **Library Opening**: `LibraryManager::open_library()` - Opens existing libraries with validation
- **Library Closing**: `LibraryManager::close_library()` - Gracefully shuts down libraries
- **Library Deletion**: `LibraryManager::delete_library()` - Removes libraries with optional data cleanup
- **Auto-discovery**: `LibraryManager::load_all()` - Automatically discovers and loads libraries
- **Manual Loading**: Individual library path loading for on-demand access

---

## Library Configuration

### Purpose
Manages persistent library configuration including settings, statistics, and metadata that control library behavior and provide runtime information.

### What It Solves
- Centralizes library settings in a single, versioned configuration file
- Enables library-wide preferences (thumbnails, sync, encryption)
- Tracks library statistics for UI display and monitoring
- Supports configuration updates without requiring library restart
- Provides version compatibility handling through schema versioning

### Key Components
- **Configuration Structure**: `LibraryConfig` - Main configuration container with versioning
- **Settings Management**: `LibrarySettings` - User-configurable preferences
- **Statistics Tracking**: `LibraryStatistics` - Runtime metrics and counters
- **Indexer Settings**: `IndexerSettings` - Indexing behavior and rule configuration
- **Configuration Persistence**: Automatic save/load from `library.json`
- **Configuration Updates**: Real-time configuration changes with persistence

---

## Database Management

### Purpose
Handles database connection management, migrations, and access for all library data storage needs.

### What It Solves
- Ensures database schema is always up-to-date through automatic migrations
- Manages database connections efficiently with proper connection pooling
- Provides transaction support for atomic operations
- Handles legacy database migration (database.db → library.db)
- Supports WAL (Write-Ahead Logging) for performance and crash recovery

### Key Components
- **Database Initialization**: `Database::create()` - Creates new database with schema
- **Database Opening**: `Database::open()` - Opens existing database with validation
- **Migration System**: Automatic schema migrations on library open
- **Connection Management**: Centralized connection handling
- **Legacy Migration**: Handles old database format upgrades
- **WAL Checkpoint**: Proper cleanup during shutdown

---

## Lock Management

### Purpose
Prevents concurrent access to libraries by multiple processes or instances, ensuring data integrity and preventing corruption.

### What It Solves
- Prevents data corruption from concurrent modifications
- Handles stale lock detection and cleanup
- Provides process tracking for debugging
- Supports graceful lock acquisition and release
- Enables lock file inspection for troubleshooting

### Key Components
- **Lock Acquisition**: `LibraryLock::acquire()` - Attempts to acquire library lock
- **Lock Validation**: Checks for existing locks and process status
- **Stale Detection**: Identifies and cleans up abandoned locks
- **Lock Information**: Stores device ID, process ID, and timestamp
- **Lock Release**: Manual and automatic cleanup mechanisms
- **Cross-platform**: Supports Unix and Windows process checking

---

## Device Management

### Purpose
Manages device registration and tracking within libraries, enabling multi-device synchronization and collaboration.

### What It Solves
- Enables multi-device library access and synchronization
- Handles device slug conflicts with automatic resolution
- Tracks device metadata for identity and capabilities
- Supports device-specific settings and preferences
- Provides device cache for efficient slug-to-UUID resolution

### Key Components
- **Device Registration**: `ensure_device_registered()` - Automatic device registration on library open
- **Slug Collision Handling**: Automatic slug modification for uniqueness
- **Device Cache**: In-memory cache for device resolution
- **Device Metadata**: Tracks hardware specs, OS, and capabilities
- **Library-specific Slugs**: Per-library device identification
- **Device Updates**: Automatic device information updates on open

---

## Sync Integration

### Purpose
Provides integration with Spacedrive's synchronization system for cross-device data replication and collaboration.

### What It Solves
- Enables real-time synchronization across multiple devices
- Supports both device-owned and shared resource types
- Provides efficient batch synchronization for large operations
- Handles foreign key mapping for complex relationships
- Integrates with transaction manager for atomic sync operations

### Key Components
- **Sync Service Initialization**: `init_sync_service()` - Sets up sync infrastructure
- **Model Synchronization**: `sync_model()` - Single record sync
- **Batch Synchronization**: `sync_models_batch()` - Efficient bulk sync
- **Foreign Key Mapping**: Automatic FK conversion for relationships
- **Device-owned Resources**: State-based synchronization
- **Shared Resources**: Log-based synchronization with HLC

---

## Statistics Tracking

### Purpose
Maintains accurate library statistics for monitoring, capacity planning, and user-facing metrics.

### What It Solves
- Provides real-time library metrics for UI display
- Supports capacity planning and storage management
- Enables performance monitoring and optimization
- Tracks indexing progress and completeness
- Supports both immediate and background calculation

### Key Components
- **Statistics Calculation**: `calculate_statistics()` - Computes all library metrics
- **File Statistics**: File count and total size tracking
- **Location Statistics**: Location count and capacity tracking
- **Device Statistics**: Device count and metadata tracking
- **Content Statistics**: Unique content counting
- **Background Updates**: Async statistics recalculation
- **Event Emission**: Statistics change notifications

---

## Thumbnail Management

### Purpose
Manages thumbnail generation, storage, and retrieval for media files in the library.

### What It Solves
- Provides efficient image preview for UI
- Supports multiple thumbnail sizes for different use cases
- Implements two-level directory sharding for performance
- Enables thumbnail generation job scheduling
- Provides thumbnail existence checking and retrieval

### Key Components
- **Thumbnail Storage**: Two-level sharded directory structure
- **Path Resolution**: Size-specific thumbnail paths
- **Thumbnail Saving**: `save_thumbnail()` - Writes thumbnail data
- **Thumbnail Retrieval**: `get_thumbnail()` - Reads thumbnail data
- **Existence Checking**: `has_thumbnail()` - Checks for existing thumbnails
- **Job Integration**: `generate_thumbnails()` - Schedules thumbnail generation
- **Legacy Support**: Backward compatibility for old thumbnail paths

---

## Event System

### Purpose
Emits events for library state changes and operations, enabling reactive UI updates and system coordination.

### What It Solves
- Provides real-time updates to UI components
- Enables coordination between different system components
- Supports event-driven architecture
- Facilitates monitoring and logging
- Enables external integrations through event hooks

### Key Components
- **Event Bus Integration**: General event bus for library events
- **Sync Event Bus**: Dedicated bus for sync operations
- **Library Events**: Created, opened, closed, deleted events
- **Statistics Events**: Statistics update notifications
- **Resource Events**: Model change notifications
- **Error Events**: Failure notifications with categorization

---

## Job System Integration

### Purpose
Integrates with Spacedrive's job system for long-running operations like indexing, thumbnail generation, and synchronization.

### What It Solves
- Enables asynchronous long-running operations
- Provides job scheduling and management
- Supports job resumption after interruption
- Tracks job progress and status
- Enables concurrent job execution

### Key Components
- **Job Manager**: Per-library job scheduling and tracking
- **Job Dispatch**: `jobs.dispatch()` - Schedules new jobs
- **Job Resumption**: Automatic job recovery on library open
- **Job Shutdown**: Graceful job termination
- **Job Logging**: Per-library job log storage
- **Job Context**: Library-specific job configuration

---

## File System Watching

### Purpose
Monitors the libraries directory for changes, enabling automatic library detection and loading.

### What It Solves
- Enables automatic library detection when libraries are added/removed
- Supports hot-reloading of libraries without restart
- Provides filesystem change notifications
- Handles library creation/deletion detection
- Supports manual and automatic watch mode

### Key Components
- **Watcher Initialization**: `start_watching()` - Starts filesystem monitoring
- **Event Processing**: Handles filesystem change events
- **Library Detection**: Automatic library directory identification
- **Path Validation**: Ensures valid library structure
- **Lock Detection**: Checks for library locks before loading
- **Error Handling**: Graceful failure with monitoring

---

## Error Handling

### Purpose
Provides comprehensive error handling for all library operations with clear error types and recovery guidance.

### What It Solves
- Enables proper error classification and handling
- Provides clear error messages for users and developers
- Supports error recovery strategies
- Enables proper error propagation
- Facilitates debugging and troubleshooting

### Key Components
- **Error Types**: Comprehensive error enumeration
- **Error Classification**: Database, IO, JSON, job, and watcher errors
- **Lock Errors**: AlreadyInUse, StaleLock handling
- **Configuration Errors**: Invalid name, missing configuration
- **Result Types**: Type-safe error handling
- **Error Context**: Detailed error information and causes

---

## Implementation Notes

All implementations are located in `core/src/library/` with the following structure:

- `mod.rs` - Main library structure and implementation
- `manager.rs` - Library lifecycle and management
- `config.rs` - Configuration types and persistence
- `lock.rs` - Lock file management
- `error.rs` - Error types and handling
- `sync_helpers.rs` - Synchronization helper methods