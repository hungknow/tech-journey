# Database Infrastructure

The database infrastructure provides persistent storage for all Spacedrive data using SQLite with SeaORM. It handles connection pooling, schema migrations, and database performance optimization.

## Features

- **[Connection Management](#connection-management)** - SQLite connection pool with configurable settings
- **[Database Initialization](#database-initialization)** - Create and open database files with proper error handling
- **[SQLite Optimization](#sqlite-optimization)** - PRAGMA configuration for performance and reliability
- **[Migration System](#migration-system)** - Schema versioning and automatic upgrades
- **[Entity Definitions](#entity-definitions)** - SeaORM entities for all database tables

## Connection Management

The database connection pool manages multiple concurrent SQLite connections efficiently.

### Purpose

Provide a performant, reliable connection pool that handles concurrent database access from multiple threads and async tasks.

### What it solves

- **Concurrency**: Multiple queries can run simultaneously without blocking
- **Resource management**: Automatic connection lifecycle prevents resource leaks
- **Performance tuning**: Pool size can be adjusted based on workload
- **Timeout handling**: Configurable timeouts for acquire, idle, and lifetime
- **Environment control**: Pool size configurable via `SPACEDRIVE_DB_POOL_SIZE` env var

### Implementation

Location: `core/src/infra/db/mod.rs`

- Uses `sqlx::pool::PoolOptions` for connection pooling
- Default pool size: 30 connections
- Minimum connections: 5 (or 1 if pool size is smaller)
- Acquire timeout: 30 seconds
- Idle timeout: 30 seconds
- Max lifetime: 30 seconds
- Environment variable override: `SPACEDRIVE_DB_POOL_SIZE`
- Converts sqlx pool to SeaORM `DatabaseConnection`

## Database Initialization

Provides methods to create new databases or open existing ones with proper validation.

### Purpose

Simplify database file creation and opening with appropriate error handling and logging.

### What it solves

- **New database creation**: Automatically creates parent directories
- **Existing database validation**: Fails fast if database doesn't exist
- **Memory database support**: Handles `:memory:` in-memory databases
- **URI mode configuration**: Uses `mode=rwc` for read-write-create with shared cache
- **Error messages**: Clear, descriptive errors for common failure scenarios

### Implementation

Location: `core/src/infra/db/mod.rs`

- `Database::create(path)` - Creates new database at specified path
- `Database::open(path)` - Opens existing database with existence check
- Automatic parent directory creation
- In-memory database support via `:memory:` path
- SQLite URI mode configuration with shared cache
- Logging on successful creation/opening

## SQLite Optimization

Applies performance and reliability PRAGMAs to every database connection in the pool.

### Purpose

Optimize SQLite for Spacedrive's workload while maintaining data integrity.

### What it solves

- **Concurrency**: WAL mode enables simultaneous readers and writers
- **Performance**: Normal synchronous mode balances speed and safety
- **Memory usage**: Memory-based temp store for temporary tables
- **Cache efficiency**: 20MB cache reduces disk I/O
- **Large file support**: 64MB mmap size for efficient file access
- **Busy handling**: 5 second timeout prevents deadlocks

### Implementation

Location: `core/src/infra/db/mod.rs:sqlite_connect_options`

- WAL journal mode: `PRAGMA journal_mode=WAL`
- Normal synchronous: `PRAGMA synchronous=NORMAL`
- Memory temp store: `PRAGMA temp_store=MEMORY`
- 20MB cache: `PRAGMA cache_size=-20000`
- 64MB mmap: `PRAGMA mmap_size=67108864`
- 5 second busy timeout: `PRAGMA busy_timeout=5000`

## Migration System

Automated schema versioning and upgrades using SeaORM migrations.

### Purpose

Enable database schema evolution over time while maintaining backward compatibility and data integrity.

### What it solves

- **Version control**: Each migration has a timestamp and unique ID
- **Automatic application**: Migrations run automatically on database startup
- **Idempotent operations**: Migrations can be re-run safely
- **History tracking**: Migration status tracked in database
- **Rollback capability**: Down migrations available (though not currently used)
- **Feature development**: Schema changes tracked in version control alongside code

### Implementation

Location: `core/src/infra/db/migration/`

- SeaORM migration framework (`sea_orm_migration::MigratorTrait`)
- Timestamp-based naming: `mYYYYMMDD_HHMMSS_description.rs`
- `Migrator::up()` applies all pending migrations
- Migration status tracked in internal migration table
- Migrations ordered by timestamp automatically
- Over 40 migrations covering all schema changes

## Entity Definitions

SeaORM entities provide type-safe database access for all tables.

### Purpose

Enable compile-time type checking and automatic query generation for database operations.

### What it solves

- **Type safety**: Compile-time errors prevent invalid queries
- **Query builder**: Fluent API for building complex queries
- **Relationships**: Define foreign keys and associations at compile time
- **Active record pattern**: Methods like `save()`, `delete()`, `update()` on entities
- **Validation**: Derive macros enforce constraints
- **Code generation**: Auto-generated from schema for consistency

### Implementation

Location: `core/src/infra/db/entities/`

- SeaORM entity derive macros
- Entity definitions for all domain objects:
  - Files and directories: `entry`, `directory_paths`, `entry_closure`
  - Content management: `content_kind`, `content_identity`
  - Locations and volumes: `location`, `volume`, `device`
  - Collections and spaces: `collection`, `collection_entry`, `space`, `space_item`, `space_group`
  - Tagging: `tag`, `tag_relationship`, `tag_closure`, `tag_usage_pattern`, `user_metadata_tag`
  - Metadata: `user_metadata`, `metadata_label`, `label`, `mime_type`
  - Media data: `image_media_data`, `video_media_data`, `audio_media_data`
  - Sidecars: `sidecar`, `sidecar_availability`
  - Cloud: `cloud_credential`
  - Indexing: `indexer_rule`
  - Sync: `sync_conduit`, `sync_generation`, `device_state_tombstone`
  - Audit: `audit_log`