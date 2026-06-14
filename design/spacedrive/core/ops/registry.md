# Operation Registry

## Purpose

The operation registry (`core/src/ops/registry.rs`) provides a compile-time registration system for all actions and queries in Spacedrive. It uses the `inventory` crate to collect operations across the codebase into global hashmaps, enabling type-safe dispatch from incoming RPC calls to their handlers.

**Key goals:**

- Action-centric API with minimal boilerplate
- Automatic method string generation (`query:network.status`, `action:files.copy.input`)
- No manual trait implementation—use registration macros instead
- Single point of dispatch for `library_id` resolution and execution

## Architecture

### Four Operation Categories

1. **Core Actions**: State changes without library context (`LibraryCreateAction`)
2. **Library Actions**: State changes within a specific library (`FileCopyAction`)
3. **Core Queries**: Data retrieval without library context (`NetworkStatusQuery`)
4. **Library Queries**: Data retrieval within a specific library (`FileListQuery`)

### Registration Flow

```
1. Define operation (Action/Query with Input/Output types)
2. Call registration macro (register_core_action!, register_library_query!, etc.)
3. Macro generates Wire trait impl and submits inventory entry
4. inventory::collect! populates global hashmaps at startup
5. RPC handler looks up method string, executes via dispatcher
```

## Types and Their Usage Sequence

### Entry Types

**Registry Entry Structs**: Hold the method string and handler function pointer for each operation type.

```rust
LibraryQueryEntry   { method: &'static str, handler: LibraryQueryHandlerFn }
CoreQueryEntry      { method: &'static str, handler: CoreQueryHandlerFn }
LibraryActionEntry  { method: &'static str, handler: LibraryActionHandlerFn }
CoreActionEntry     { method: &'static str, handler: CoreActionHandlerFn }
```

**Usage**: Created by registration macros, submitted to inventory, iterated to build global hashmaps.

### Handler Function Types

**Library Query Handler**: Requires `SessionContext` (includes library context).

```rust
type LibraryQueryHandlerFn = fn(
    Arc<CoreContext>,
    SessionContext,
    serde_json::Value,
) -> Pin<Box<dyn Future<Output = Result<serde_json::Value, String>> + Send + 'static>>;
```

**Core Query Handler**: Uses `SessionContext` (no library).

```rust
type CoreQueryHandlerFn = fn(
    Arc<CoreContext>,
    SessionContext,
    serde_json::Value,
) -> Pin<Box<dyn Future<Output = Result<serde_json::Value, String>> + Send + 'static>>;
```

**Library Action Handler**: Requires `SessionContext` (includes library context).

```rust
type LibraryActionHandlerFn = fn(
    Arc<CoreContext>,
    SessionContext,
    serde_json::Value,
) -> Pin<Box<dyn Future<Output = Result<serde_json::Value, String>> + Send + 'static>>;
```

**Core Action Handler**: No session parameter—creates base session internally.

```rust
type CoreActionHandlerFn = fn(
    Arc<CoreContext>,
    serde_json::Value,
) -> Pin<Box<dyn Future<Output = Result<serde_json::Value, String>> + Send + 'static>>;
```

**Usage**: Bound to registry entries, called by RPC layer when method matches.

### Global Hashmaps

**Registry Maps**: Lazily-initialized collections of all registered operations.

```rust
static LIBRARY_QUERIES: Lazy<HashMap<&'static str, LibraryQueryHandlerFn>>;
static CORE_QUERIES:    Lazy<HashMap<&'static str, CoreQueryHandlerFn>>;
static LIBRARY_ACTIONS: Lazy<HashMap<&'static str, LibraryActionHandlerFn>>;
static CORE_ACTIONS:    Lazy<HashMap<&'static str, CoreActionHandlerFn>>;
```

**Usage Sequence**:

1. `inventory::collect!()` runs at compile-time to gather entries
2. `Lazy::new(||)` builds hashmaps on first access by iterating entries
3. RPC handlers look up method strings to get handler function pointers
4. Hashmaps remain in memory for daemon lifetime

## Registration Macros

### Helper Macros

**`action_method!($name)`**: Constructs action method string.

```rust
action_method!("files.copy")  // => "action:files.copy.input"
```

**`query_method!($name)`**: Constructs query method string.

```rust
query_method!("network.status")  // => "query:network.status"
```

### `register_library_query!($query:ty, $name:literal)`

**Purpose**: Registers a library query with automatic type extraction.

**What it does**:

1. Implements `Wire` trait for `Q::Input` with method `"query:$name"`
2. Submits `LibraryQueryEntry` to inventory with `handle_library_query::<Q>` as handler
3. Implements `QueryTypeInfo` for TypeScript type generation
4. Submits `QueryExtractorEntry` to inventory for type extraction

**Usage**:

```rust
use crate::cqrs::LibraryQuery;

pub struct FileListQuery;

crate::register_library_query!(FileListQuery, "files.list");
```

**Resolves**:

- Method string: `"query:files.list"`
- Wire trait for `FileListQuery::Input`
- Type extraction for frontend type generation
- Handler bound to `handle_library_query::<FileListQuery>`

### `register_core_query!($query:ty, $name:literal)`

**Purpose**: Registers a core query without library context.

**What it does**: Same steps as `register_library_query!` but for core scope.

**Usage**:

```rust
use crate::cqrs::CoreQuery;

pub struct NetworkStatusQuery;

crate::register_core_query!(NetworkStatusQuery, "network.status");
```

**Resolves**:

- Method string: `"query:network.status"`
- Wire trait for `NetworkStatusQuery::Input`
- Core scope type extraction
- Handler bound to `handle_core_query::<NetworkStatusQuery>`

### `register_library_action!($action:ty, $name:literal)`

**Purpose**: Registers a library action with automatic type extraction.

**What it does**:

1. Implements `Wire` trait for `A::Input` with method `"action:$name.input"`
2. Submits `LibraryActionEntry` to inventory with `handle_library_action::<A>` as handler
3. Implements `OperationTypeInfo` for TypeScript type generation
4. Submits `TypeExtractorEntry` to inventory for type extraction

**Usage**:

```rust
use crate::infra::action::LibraryAction;

pub struct FileCopyAction;

crate::register_library_action!(FileCopyAction, "files.copy");
```

**Resolves**:

- Method string: `"action:files.copy.input"`
- Wire trait for `FileCopyAction::Input`
- Library scope type extraction
- Handler bound to `handle_library_action::<FileCopyAction>`

### `register_core_action!($action:ty, $name:literal)`

**Purpose**: Registers a core action without library context.

**What it does**: Same steps as `register_library_action!` but for core scope.

**Usage**:

```rust
use crate::infra::action::CoreAction;

pub struct LibraryCreateAction;

crate::register_core_action!(LibraryCreateAction, "libraries.create");
```

**Resolves**:

- Method string: `"action:libraries.create.input"`
- Wire trait for `LibraryCreateAction::Input`
- Core scope type extraction
- Handler bound to `handle_core_action::<LibraryCreateAction>`

## Handler Functions

### `handle_library_query<Q>(context, session, payload)`

**Purpose**: Thin wrapper that deserializes input, executes library query, serializes output.

**Core Steps**:

1. Create `ApiDispatcher` from `CoreContext`
2. Deserialize `payload` into `Q::Input`
3. Call `dispatcher.execute_library_query::<Q>(input, session)`
4. Serialize `Q::Output` to JSON
5. Return result or error as String

**Resolves**:

- JSON-RPC payload to strongly-typed Rust types
- Library context from session for database access
- Business logic dispatch via ApiDispatcher

### `handle_core_query<Q>(context, session, payload)`

**Purpose**: Executes core query without library context.

**Core Steps**:

1. Create `ApiDispatcher` from `CoreContext`
2. Deserialize `payload` into `Q::Input`
3. Call `dispatcher.execute_core_query::<Q>(input, session)`
4. Serialize `Q::Output` to JSON
5. Return result or error as String

**Resolves**:

- Core queries that don't require library context
- Session context for authentication but not library scoping

### `handle_library_action<A>(context, session, payload)`

**Purpose**: Executes library action with library context.

**Core Steps**:

1. Create `ApiDispatcher` from `CoreContext`
2. Deserialize `payload` into `A::Input`
3. Call `dispatcher.execute_library_action::<A>(input, session)`
4. Serialize `A::Output` to JSON
5. Return result or error as String

**Resolves**:

- Actions that modify library-scoped state
- Transaction handling via dispatcher
- Library context for database operations

### `handle_core_action<A>(context, payload)`

**Purpose**: Executes core action without library context.

**Core Steps**:

1. Create `ApiDispatcher` from `CoreContext`
2. Call `dispatcher.create_base_session()` to get default session
3. Deserialize `payload` into `A::Input`
4. Call `dispatcher.execute_core_action::<A>(input, session)`
5. Serialize `A::Output` to JSON
6. Return result or error as String

**Resolves**:

- Core actions like library creation that don't require library context
- Base session creation for authentication without library scoping

## Type Extraction

The registry integrates with TypeScript type generation via `QueryTypeInfo` and `OperationTypeInfo` traits. Registration macros automatically implement these traits and submit extractor entries to inventory.

**Query Type Extraction**:
- Registers `QueryExtractorEntry` for each query
- Used by `generate_typescript_types` binary
- Extracts `Input` and `Output` types for frontend

**Operation Type Extraction**:
- Registers `TypeExtractorEntry` for each action
- Same mechanism as query extraction
- Provides complete type coverage for client code

## Testing

**`list_registered_ops()`**: Test helper that prints all registered operations.

```rust
cargo test list_registered_ops
```

Output shows:
- Core actions count and method names
- Library actions count and method names
- Core queries count and method names
- Library queries count and method names

**Use case**: Verify registration macros are working and operations appear in registry.

## Example Workflow

```rust
// 1. Define action with Input/Output types
#[derive(Debug, Serialize, Deserialize)]
pub struct FileCopyInput {
    pub source_id: i32,
    pub destination_path: PathBuf,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct FileCopyOutput {
    pub new_file_id: i32,
}

pub struct FileCopyAction;

// 2. Implement LibraryAction trait
impl LibraryAction for FileCopyAction {
    type Input = FileCopyInput;
    type Output = FileCopyOutput;

    async fn run(input: Self::Input, ctx: &ActionContext) -> Result<Self::Output> {
        // Implementation
    }
}

// 3. Register operation
crate::register_library_action!(FileCopyAction, "files.copy");

// 4. Registration automatically:
//    - Generates method: "action:files.copy.input"
//    - Implements Wire for FileCopyInput
//    - Binds to handle_library_action::<FileCopyAction>
//    - Submits to inventory for type extraction

// 5. At runtime:
//    - inventory::collect! populates LIBRARY_ACTIONS hashmap
//    - RPC handler looks up "action:files.copy.input"
//    - Calls handle_library_action::<FileCopyAction>(context, session, payload)
//    - Returns serialized FileCopyOutput
```