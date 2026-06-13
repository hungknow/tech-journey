# Wire Module

The wire module provides the infrastructure for type-safe communication between client applications and the Spacedrive daemon via Unix domain sockets.

## Features

- [Operation Registry](#operation-registry)
- [Type Extraction System](#type-extraction-system)
- [Handler Functions](#handler-functions)
- [API Type Wrappers](#api-type-wrappers)
- [Swift Code Generation](#swift-code-generation)

---

## Operation Registry

The operation registry enables compile-time registration of all actions and queries using the `inventory` crate. This creates a central mapping between wire method strings and their handler functions.

**Purpose:** Operations register automatically at compile time without manual registration code. The daemon looks up handlers by method string when requests arrive, eliminating manual dispatch logic.

**What it solves:**

- Removes boilerplate for registering operations
- Ensures all operations are discoverable without runtime registration
- Provides type-safe method strings through macros like `register_library_action!`
- Separates registration from business logic

**Implementation:** `core/src/infra/wire/registry.rs`

The registry maintains four global hashmaps:

- `CORE_ACTIONS` - Core-level state-changing operations
- `LIBRARY_ACTIONS` - Library-level state-changing operations
- `CORE_QUERIES` - Core-level data retrieval
- `LIBRARY_QUERIES` - Library-level data retrieval

Each operation uses registration macros that:
1. Implement the `Wire` trait with the correct method string
2. Submit an entry to `inventory` for compile-time collection
3. Automatically implement type extraction traits

---

## Type Extraction System

The type extraction system enables automatic discovery and extraction of Input/Output types from registered operations at compile time using trait-based metadata.

**Purpose:** Generate TypeScript and Swift clients automatically without manually defining type mappings. The system discovers all registered operations and extracts their types for code generation.

**What it solves:**

- Eliminates manual type synchronization between backend and frontend
- Ensures type safety across the client-daemon boundary
- Generates type information at compile time rather than runtime
- Solves the timeline problem where type generation needs type data before daemon startup

**Implementation:** `core/src/infra/wire/type_extraction.rs`

Key components:

- `OperationTypeInfo` trait - Provides metadata for actions
- `QueryTypeInfo` trait - Provides metadata for queries
- `TypeExtractorEntry` and `QueryExtractorEntry` - Collected via `inventory`
- `generate_spacedrive_api()` - Main entry point that iterates over all registered extractors

The registration macros automatically implement these traits, so operations don't need manual type extraction code.

---

## Handler Functions

Handler functions provide thin wrappers that deserialize inputs, dispatch to business logic, and serialize outputs. They convert between JSON-RPC payloads and typed business logic calls.

**Purpose:** Bridge the gap between JSON-RPC wire protocol and typed Rust operations. Each handler follows the same pattern: deserialize payload, call dispatcher, serialize result.

**What it solves:**

- Centralizes JSON serialization/deserialization logic
- Provides consistent error handling across all operations
- Separates protocol handling from business logic
- Allows the dispatcher to handle session and library context

**Implementation:** `core/src/infra/wire/registry.rs`

Four handler functions exist:

- `handle_library_query()` - Library-scoped queries
- `handle_core_query()` - Core-scoped queries
- `handle_library_action()` - Library-scoped actions
- `handle_core_action()` - Core-scoped actions

All handlers return `Pin<Box<dyn Future<Output = Result<serde_json::Value, String>> + Send + 'static>>` for async execution.

---

## API Type Wrappers

API type wrappers convert internal types to API-safe types for export to clients like Swift. This allows the daemon to use internal types while exposing client-compatible types.

**Purpose:** Convert internal implementation types to types suitable for client code generation without changing internal APIs.

**What it solves:**

- Internal types like `JobHandle` can remain unchanged
- Clients receive compatible types like `JobReceipt`
- Conversion is automatic through the `ToApiType` trait
- Keeps business logic clean while handling API compatibility

**Implementation:** `core/src/infra/wire/api_types.rs`

Current wrappers include:

- `ApiJobHandle` - Wraps `JobReceipt` for API export
- `ToApiType` trait - Generic conversion interface

---

## Swift Code Generation

Swift code generation automatically produces Swift client code from Rust types, including namespace structs and async methods for all registered operations.

**Purpose:** Generate complete Swift client libraries that mirror the Rust backend API, ensuring type safety across platforms.

**What it solves:**

- Eliminates manual Swift client maintenance
- Ensures Swift types always match Rust types
- Provides async/await interface for Swift apps
- Organizes operations into namespaces for cleaner API

**Implementation:** `core/src/infra/wire/type_extraction.rs`

Key functions:

- `generate_swift_api_code()` - Generates namespace structs with methods
- `generate_swift_method()` - Generates individual async methods
- `extract_api_functions()` - Organizes operations into namespace/grouped functions
- Helper functions for naming conventions (`to_pascal_case`, `to_camel_case`)

Generated Swift code includes:
- Namespace structs like `LibrariesAPI`, `JobsAPI`, `NetworkAPI`
- Async methods that take input and return output types
- Automatic wire method string generation
- Proper error handling with `throws`

---

## Registration Macros

The wire module provides registration macros that handle trait implementation, registry submission, and type extraction in a single macro call.

### `register_library_action!`

Registers a library-scoped action:

```rust
crate::register_library_action!(FileCopyAction, "files.copy");
// Generates method: "action:files.copy.input"
```

### `register_core_action!`

Registers a core-scoped action:

```rust
crate::register_core_action!(LibraryCreateAction, "libraries.create");
// Generates method: "action:libraries.create.input"
```

### `register_library_query!`

Registers a library-scoped query:

```rust
crate::register_library_query!(LibraryStatusQuery, "libraries.status");
// Generates method: "query:libraries.status"
```

### `register_core_query!`

Registers a core-scoped query:

```rust
crate::register_core_query!(CoreStatusQuery, "core.status");
// Generates method: "query:core.status"
```

Each macro automatically:
- Implements the `Wire` trait with the correct method string
- Submits an entry to `inventory` for handler registration
- Implements the corresponding `TypeInfo` trait for type extraction
- Submits a type extractor for automatic client generation

**Implementation:** `core/src/infra/wire/registry.rs`

---

## Testing

The wire module includes comprehensive tests:

- `test_type_extraction_system()` - Verifies type discovery works
- `test_api_functions_extraction()` - Tests namespace and function organization
- `test_swift_code_generation()` - Validates generated Swift code structure
- `list_registered_ops()` - Lists all registered operations for debugging

Run tests with:

```bash
cargo test -p sd_core --lib wire
```