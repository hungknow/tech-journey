# Extension System Features

The extension system provides a secure WebAssembly-based plugin architecture for Spacedrive. Extensions run in sandboxed WASM modules and interact with Spacedrive core via a minimal host function API that routes to the existing Wire operation registry.

## Features Overview

- [Plugin Lifecycle Management](#plugin-lifecycle-management) - Load, unload, and hot-reload WASM extensions
- [Host Function Bridge](#host-function-bridge) - Bridge between WASM and Wire operation registry
- [Permission System](#permission-system) - Capability-based security with rate limiting
- [Job Registry](#job-registry) - Runtime registration of extension-defined jobs
- [WASM Job Execution](#wasm-job-execution) - Generic job executor for extension jobs
- [Extension Manifest](#extension-manifest) - Metadata and permission declarations

## Plugin Lifecycle Management

The plugin manager handles the complete lifecycle of WASM extensions from loading to unloading.

**Purpose:** Enable dynamic loading of WASM extensions at runtime without restarting the daemon.

**What it solves:**

- **Hot-reloading**: Extensions can be updated without daemon restart during development
- **Resource isolation**: Each extension gets its own WASM instance and memory space
- **Clean initialization**: Proper setup sequence from manifest loading to plugin initialization
- **Safe unloading**: Proper cleanup when extensions are removed
- **Dependency management**: Extensions can only call permitted operations

The manager supports the expected plugin directory structure:

```
plugins/
├── finance/
│   ├── manifest.json
│   └── finance.wasm
└── photos/
    ├── manifest.json
    └── photos.wasm
```

## Host Function Bridge

Host functions provide the bridge between WASM extensions and Spacedrive's Wire operation registry.

**Purpose:** Enable extensions to call Spacedrive operations without needing separate API endpoints or custom protocols.

**What it solves:**

- **Minimal API surface**: Extensions only need one main function (`spacedrive_call`) for all operations
- **Protocol reuse**: Leverages existing Wire operation registry used by daemon RPC
- **Type safety**: JSON serialization/deserialization handled automatically
- **Memory isolation**: Extensions can't access host memory directly
- **Permission enforcement**: Every call is checked against extension's permissions

The main host function routes to the same handlers used by daemon RPC:

- Core queries (library creation, deletion, etc.)
- Library queries (file listings, metadata, etc.)
- Core actions (global operations)
- Library actions (file operations, sync, etc.)

## Permission System

The permission system enforces capability-based security with rate limiting for all extension operations.

**Purpose:** Prevent malicious or buggy extensions from causing harm while allowing legitimate functionality.

**What it solves:**

- **Capability isolation**: Extensions can only call permitted Wire methods (prefix matching)
- **Library access control**: Extensions can be restricted to specific libraries or denied access
- **Resource limits**: Memory and concurrent job limits prevent resource exhaustion
- **Rate limiting**: Prevents denial-of-service via excessive API calls
- **Auditability**: All operations are logged with extension context

Permissions are declared in the extension manifest and enforced at runtime:

```json
{
  "permissions": {
    "methods": ["vdfs.", "ai.ocr"],
    "libraries": ["*"],
    "rate_limits": {
      "requests_per_minute": 1000,
      "concurrent_jobs": 10
    },
    "max_memory_mb": 512
  }
}
```

## Job Registry

The job registry allows extensions to register custom job types at runtime that integrate with Spacedrive's job system.

**Purpose:** Enable extensions to define long-running operations that users can track, pause, and resume.

**What it solves:**

- **Dynamic registration**: Extensions can register jobs without modifying core code
- **Type safety**: Jobs are registered with metadata (name, export function, resumability)
- **Clean isolation**: Jobs are namespaced by extension (e.g., "finance:email_scan")
- **Proper cleanup**: Jobs are automatically unregistered when extensions are unloaded
- **Integration**: Extension jobs appear alongside core jobs in the UI

Extensions register jobs during `plugin_init()`:

```rust
host_register_job(
    "email_scan".as_ptr(),    // Job name
    10,                        // Length
    "execute_email_scan".as_ptr(), // Export function
    19,                        // Length
    1                          // Resumable (1 = yes)
);
```

## WASM Job Execution

The generic `WasmJob` type executes extension-defined jobs within Spacedrive's job system.

**Purpose:** Provide a unified execution model for both core and extension jobs.

**What it solves:**

- **Unified tracking**: Extension jobs appear in job listings and progress feeds
- **Resumability**: Jobs can be paused and resumed via checkpointing
- **Context injection**: Extension jobs receive job ID and library ID for logging
- **Progress reporting**: Extensions can report progress and warnings via host functions
- **Error handling**: Failed jobs are tracked and reported like core jobs

The executor verifies the extension is loaded before execution and prepares a job context for the WASM function:

```json
{
  "job_id": "550e8400-e29b-41d4-a716-446655440000",
  "library_id": "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
}
```

## Extension Manifest

The manifest file (`manifest.json`) declares extension metadata, permissions, and resource requirements.

**Purpose:** Provide a self-documenting extension specification for users and the plugin manager.

**What it solves:**

- **Self-documentation**: Users can read manifest to understand extension capabilities
- **Permission declaration**: Explicit declaration of required permissions
- **Resource requirements**: Memory and job limits prevent resource exhaustion
- **Version tracking**: Semver versioning for compatibility checking
- **WASM linkage**: Links manifest to compiled WASM file

Manifest structure:

```json
{
  "id": "finance",
  "name": "Finance Extension",
  "version": "1.0.0",
  "description": "Receipt extraction and expense tracking",
  "wasm_file": "finance.wasm",
  "permissions": {
    "methods": ["vdfs.", "ai.ocr"],
    "libraries": ["*"],
    "rate_limits": {
      "requests_per_minute": 1000,
      "concurrent_jobs": 10
    },
    "max_memory_mb": 512
  }
}
```

## Implementation

All implementation is in `core/src/infra/extension/`:

- `mod.rs`: Module exports and public types
- `manager.rs`: Plugin lifecycle management
- `host_functions.rs`: WASM host functions and bridge to Wire registry
- `permissions.rs`: Permission system with rate limiting
- `job_registry.rs`: Runtime job registration
- `wasm_job.rs`: Generic job executor for extensions
- `types.rs`: Shared types and manifest formats