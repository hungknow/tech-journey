# Schema Terms in CocoIndex

This document describes schema-related types and terms used in the Python and Rust codebase, and where each is used.

---

## Core schema types (Rust: `base::schema`)

### BasicValueType

Primitive and composite scalar types. Variants: `Bytes`, `Str`, `Bool`, `Int64`, `Float32`, `Float64`, `Range`, `Uuid`, `Date`, `Time`, `LocalDateTime`, `OffsetDateTime`, `TimeDelta`, `Json`, `Vector(VectorTypeSchema)`, `Union(UnionTypeSchema)`.

**Where used:** Building and matching types everywhere (sources, targets, functions, flow builder, analyzer). PyArrow/JSON conversion in `py/convert.rs`. LLM JSON schema generation uses it to map to JSON Schema primitive types. Targets (Doris, Qdrant, etc.) use it to map to backend types (e.g. vector element type, SQL types).

### VectorTypeSchema

Schema for vector (embedding) types: `element_type` (a `BasicValueType`) and optional `dimension` (fixed length).

**Where used:** Vector fields in table/struct schemas; Qdrant target parses it for collection config; Doris/LanceDB/ChromaDB Python targets use it for dimension and element type when creating vector columns or indexes.

### UnionTypeSchema

Schema for union types: `types` is a list of `BasicValueType` variants.

**Where used:** Type system and value conversion; JSON schema builder emits `oneOf` for unions.

### ValueType

Top-level type for any value. One of: `Struct(StructSchema)`, `Basic(BasicValueType)`, or `Table(TableSchema)`. For tables, `key_schema()` returns the key fields (for KTable); for UTable/LTable it returns an empty slice.

**Where used:** Source setup state (`keys_schema` as `[ValueType]`), target setup state (`key_type`), exec context (output type and key type). Flow builder and analyzer work with ValueType (or ValueTypeBuilder) for outputs and keys. Value decoding/encoding and PyArrow conversion branch on ValueType.

### EnrichedValueType

A `ValueType` plus `nullable` (bool) and `attrs` (map of string to JSON). Used for field and argument types. Serialized with key `"type"` for the inner type.

**Where used:** Every field in `FieldSchema`, op output types in `OpScopeSchema`, function/op argument types (`OpArgSchema`), flow builder `DataType` and `output_type`, export target `output_schema`, LLM extract output type. Python `encode_enriched_type` / `EnrichedValueType.decode` bridge Python types to the engine.

### FieldSchema

A named field: `name` (FieldName), `value_type` (EnrichedValueType), and optional `description`. Identifies a field in a struct or table row.

**Where used:** Struct and table row definitions; `FlowSchema.schema.fields`; source connectors (Postgres `FieldSchemaInfo`, local_file/google_drive/azure_blob/s3 building struct output with `FieldSchema::new`); export targets’ `key_fields_schema` / `value_fields_schema` (Postgres, Qdrant, Neo4j, Kuzu, FalkorDB, property_graph); analyzer building collectors and data collections; evaluator/dumper resolving field indices; `value::FieldValues::from_json` and struct/table conversion in `py/convert.rs`. Python targets (Doris, LanceDB, ChromaDB) receive and use lists of `FieldSchema` for key/value columns.

### StructSchema

A product type: `fields` (list of `FieldSchema`) and optional `description`. Used for structs and for the row shape of tables.

**Where used:** Root output of a flow (`FlowSchema.schema`); row shape of `TableSchema`; source connectors build StructSchema for blob/table output (local_file, S3, Azure, Google Drive, Postgres); functions (e.g. extract_by_llm) build StructSchema for output; analyzer’s `StructSchemaBuilder`; evaluator `ScopeEntry` and struct/table resolution; Kuzu target `struct_schema_to_kuzu`; JSON schema builder for object types.

### TableKind

Kind of table: `UTable` (unordered, no key), `KTable(KTableInfo)` (keyed; first N fields are the key), or `LTable` (list; order preserved). Serialized as `"kind"` with alias `"Table"` for KTable and `"List"` for LTable.

**Where used:** Inside `TableSchema`; flow builder maps Python KTable/LTable to TableKind; analyzer and execution treat KTable key vs value fields differently.

### KTableInfo

For KTable: `num_key_parts` (number of leading row fields that form the key; default 1).

**Where used:** Only in `TableSchema.kind` when kind is KTable; determines `key_schema()` slice; setup driver and row indexer use it for key encoding.

### TableSchema

A table type: `kind` (TableKind) and `row` (StructSchema). `key_schema()` returns the key fields for KTable, or empty for UTable/LTable.

**Where used:** Flow output fields that are tables (sources output KTable; functions can output LTable/KTable); analyzer infers table types for data collections; evaluator/dumper use it to build scope values and iterate rows; Python flow builder builds TableSchema from annotated types (KTable/LTable).

### CollectorSchema

Schema for a collector: `fields` (list of FieldSchema) and optional `auto_uuid_field_idx` (index of an auto-generated UUID field).

**Where used:** Builder’s `OpScope.collectors` and `CollectorDef`; analyzer’s `OpScopeSchema.collectors` and collector merging; flow builder builds it from Python collector defs (`CollectorSchema::from_fields`); execution uses it when materializing collected values.

### OpScopeSchema

Per-scope schema for a flow: `op_output_types` (output field name → EnrichedValueType), `op_scopes` (nested scope name → OpScopeSchema), and `collectors` (named CollectorSchema). Used during flow analysis.

**Where used:** Built in analyzer from `OpScope` (`build_op_scope_schema`); stored in `FlowSchema.root_op_scope`; drives which outputs exist at each scope for resolution and execution.

### FlowSchema

Top-level schema for a flow instance. Contains `schema` (StructSchema: the root output struct) and `root_op_scope` (OpScopeSchema). The flow’s `data_schema` is a FlowSchema. API endpoint `GET /flows/{name}/schema` returns it.

**Where used:** Built in analyzer (`build_flow_schema`), stored on `AnalyzedFlow` and `AnalyzedTransientFlow` as `data_schema`. Passed into evaluator (`SourceRowEvaluationContext.schema`, `evaluate_transient_flow`), dumper (`Dumper.schema`), source indexer, and builder exec context. Returned by `get_flow_schema` API and used by run-flow and import handlers; Python flow exposes it for `get_schema()` and spec rendering.

### OpArgSchema

Schema for an operation argument: `name`, `value_type` (EnrichedValueType), and `analyzed_value` (AnalyzedValueMapping). Exposed in Python as `PyOpArgSchema`.

**Where used:** Built in analyzer when resolving op args (`build_op_arg_schemas`); `OpFactory::build` receives `input_schema: Vec<OpArgSchema>`; function executors and Py export/source factories use it to convert Python args to engine values. Python sees it as `PyOpArgSchema` for introspection.

---

## JSON schema (Rust: `base::json_schema`)

### ToJsonSchemaOptions

Options when converting CocoIndex types to JSON Schema: `fields_always_required`, `supports_format`, `extract_descriptions`, `top_level_must_be_object`, `supports_additional_properties`.

**Where used:** Each LLM client implements `json_schema_options()` and returns a `ToJsonSchemaOptions` (OpenAI, Ollama, Gemini, Bedrock, Anthropic); options differ per provider (e.g. Gemini omits `additionalProperties`, some require top-level object or always-required fields). Passed into `build_json_schema`.

### build_json_schema

Builds a JSON Schema (and optional extra instructions, and a ValueExtractor) from an `EnrichedValueType` and options. Used for LLM and other consumers that need JSON Schema.

**Where used:** LLM extract/structured-output: `extract_by_llm` calls it with the spec’s output type and the client’s options to get a JSON Schema sent to the LLM API; the returned `ValueExtractor` is used to parse the LLM response back into engine values. Tests in `json_schema.rs` cover basic types, structs, tables, nullable, and options.

---

## Other schema-related terms

### data_schema

The flow’s schema; type `FlowSchema`. Stored on the flow/analyzed flow and passed to execution (evaluator, dumper, source indexer). Returned by the API as the flow schema.

**Where used:** Set in `AnalyzedFlow` / `AnalyzedTransientFlow` after analyzer builds it; read in `lib_context` for flow context; evaluator’s `SourceRowEvaluationContext.schema` and `evaluate_transient_flow(flow.data_schema.schema)`; dumper holds `schema` and passes it to `evaluate_source_entry_with_memory`; source indexer uses it to know output shape; service `get_flow_schema` and run/import handlers; Python flow’s `get_schema()` and spec rendering read `flow.data_schema`.

### key_schema / keys_schema

Source setup state: `keys_schema` is `Option<Box<[ValueType]>>` (one type per key part). Legacy `key_schema` is a single `ValueType`.

**Where used:** `SourceSetupState` in `setup/states.rs`; in setup driver / exec context, existing source state’s `keys_schema` is compared to the analyzed import output’s key types to decide if the source is compatible and whether to reuse or recreate tracking.

### schema_version_id / max_schema_version_id

On target setup state: used to detect when the exported row shape or target schema changed so the runtime knows whether a row can be reused or must be re-exported.

**Where used:** `TargetSetupStateCommon` in `setup/states.rs`; computed in builder `exec_ctx` when building target setup (per-target `schema_version_id`, global `max_schema_version_id`); row indexer and indexing status use `export_op_exec_ctx.schema_version_id` when writing/reading tracking rows so unchanged rows can be skipped when the schema version matches.

### key_type

On target setup state common: `Option<Box<[ValueType]>>` for the key types of the exported target.

**Where used:** Stored on `TargetSetupStateCommon`; set in exec context from analyzed target key types; setup driver uses it (with `key_field_schemas`) to build key encoding; compatibility checks compare `key_type` across existing target states when reusing schema version.

### db_schema_name

In settings: optional PostgreSQL (or DB) schema name for table creation and metadata (e.g. `CREATE SCHEMA IF NOT EXISTS`).

**Where used:** `Settings` in `settings.rs`; `db_metadata.rs` uses it to create the schema if missing and to qualify table names for metadata/tracking; `db_tracking_setup` uses it for tracking table placement; Python `setting.py` and env `COCOINDEX_DATABASE_SCHEMA_NAME` map to this field.

### TableColumnsSchema

Used by table-like targets: `key_columns` and `value_columns` (each an ordered map of column name to column type/config). Serde aliases: `key_fields_schema`, `value_fields_schema`.

**Where used:** `table_columns.rs`; Postgres and Kuzu targets use it (e.g. `TableColumnsSchema<ColumnType>` or `TableColumnsSchema<String>`) to derive `TableMainSetupAction` and compare desired vs existing columns for create/update; `from_states` and compatibility helpers consume it.

### GraphElementSchema

For property-graph targets: `key_fields`, `value_fields` (key/value FieldSchema lists), and element type. Used for nodes and relationships.

**Where used:** `property_graph.rs`: built by `GraphElementSchemaBuilder` from data collection mappings; attached to node and relationship descriptors (`NodeDescriptor.schema`, `RelationshipDescriptor.schema`); Neo4j, Kuzu, FalkorDB targets take `schema: &GraphElementSchema` when writing nodes/edges and mapping key/value fields to properties.

### key_fields_schema / value_fields_schema

In Python targets (e.g. Doris, LanceDB, ChromaDB): lists of `FieldSchema` for key and value columns. Often come from the engine’s view of the exported table (key vs value columns).

**Where used:** Rust: `ExportDataCollection` and `TypedExportDataCollectionBuildOutput` in factory_bases/interface; analyzer fills them from table key_schema and remaining row fields; passed to Postgres/Qdrant/Neo4j/Kuzu/FalkorDB and property_graph; py_factory pythonizes them for Python export context. Python: `op.py` `ExportContext` and target build/setup receive `key_fields_schema` and `value_fields_schema` from the engine; Doris/LanceDB/ChromaDB use them for table/collection schema, compatibility, and column mapping; `engine_value` uses them for key extraction and value encoding.

### PyOpArgSchema

Python binding for OpArgSchema; exposes `value_type` and `analyzed_value` for operation arguments.

**Where used:** Registered in `py/mod.rs`; built in py_factory when preparing op input schema and passed to Python op factories so they can validate and convert arguments.

### get_schema (Python Flow)

Returns a list of `(field_name, field_type_str, attrs_str)` by walking the flow’s `data_schema.schema.fields` recursively (including nested structs and table row fields). Used for introspection.

**Where used:** Implemented in `py/mod.rs` on the flow wrapper; calls into Rust `process_fields` over `flow.data_schema.schema.fields`; Python callers can use it to list all output fields and their types without parsing the full schema.

---

## Python exposure (`engine_type` and engine)

Schema types are exposed in Python mainly as dataclasses that decode from the engine’s JSON.

### VectorTypeSchema (Python)

`element_type`, `dimension`; `decode`/`encode` from/to dict.

**Where used:** Doris/LanceDB tests and targets when building vector field schemas; engine_type encode/decode.

### UnionTypeSchema (Python)

`variants` (list of BasicValueType); `decode`/`encode`.

**Where used:** Type encoding and engine_value when handling union values.

### BasicValueType (Python)

`kind` (e.g. `"Str"`, `"Vector"`, `"Union"`), optional `vector` or `union`; `decode`/`encode`.

**Where used:** Everywhere a scalar or vector type is represented; targets map it to SQL/backend types; engine_value and engine_object use it for encoding/validation.

### EnrichedValueType (Python)

`type` (ValueType), `nullable`, `attrs`; `decode`/`encode`.

**Where used:** FieldSchema and op args; flow builder and op.py when decoding engine types; targets receive field value types as EnrichedValueType inside FieldSchema.

### FieldSchema (Python)

`name`, `value_type`, `description`; `decode`/`encode`.

**Where used:** Export context and all Python targets (Doris, LanceDB, ChromaDB) for key_fields_schema/value_fields_schema; op.py decodes raw key/value field lists via `decode_field_schemas`; engine_object can decode FieldSchema from engine output.

### StructSchema (Python)

`fields`, `description`; `decode`/`encode`.

**Where used:** StructType and TableType row; engine_type encoding of struct/table from Python types.

### StructType (Python)

Subclass of StructSchema with `kind: "Struct"`.

**Where used:** decode_value_type when kind is Struct; flow/output type representation.

### TableType (Python)

`kind` (`"KTable"` or `"LTable"`), `row` (StructSchema), optional `num_key_parts`; `decode`/`encode`.

**Where used:** decode_value_type for table output fields; op.py builds TableType for KTable/LTable from key/value type info and uses row.fields for key_fields_schema.

### ValueType (Python) and helpers

**ValueType** in Python is `BasicValueType | StructType | TableType`. Helpers: `decode_field_schemas`, `decode_value_type`, `encode_value_type`, `encode_enriched_type` (from Python types/datatype info to engine dict).

**Where used:** Targets and engine_value use `FieldSchema`, `EnrichedValueType`, `BasicValueType`, and sometimes `ValueType` from `cocoindex.engine_type` (or `cocoindex._engine` where the Rust extension is used). Flow builder uses `encode_enriched_type` to send type specs to the engine; export targets receive key/value field schemas from the engine and use them for setup and row serialization (Doris DDL/upsert, LanceDB PyArrow schema, ChromaDB metadata). Tests (e.g. test_doris_unit, test_engine_type, test_engine_object) construct and assert on these types.

---

## Sample schemas

**Basic types (EnrichedValueType with Basic inner type):**

```json
{ "type": { "kind": "Str" } }
{ "type": { "kind": "Int64" }, "nullable": true }
{ "type": { "kind": "Vector", "element_type": { "kind": "Float32" }, "dimension": 384 } }
{ "type": { "kind": "Union", "types": [ { "kind": "Str" }, { "kind": "Int64" } ] } }
```

**StructSchema (two fields):**

```json
{
  "fields": [
    { "name": "id", "type": { "kind": "Int64" } },
    { "name": "title", "type": { "kind": "Str" }, "description": "Document title" }
  ],
  "description": "A document row"
}
```

**KTable with one key part (id) and two value fields:**

```json
{
  "kind": "KTable",
  "num_key_parts": 1,
  "row": {
    "fields": [
      { "name": "id", "type": { "kind": "Int64" } },
      { "name": "title", "type": { "kind": "Str" } },
      { "name": "embedding", "type": { "kind": "Vector", "element_type": { "kind": "Float32" }, "dimension": 768 } }
    ]
  }
}
```

**LTable (ordered list of structs):**

```json
{
  "kind": "LTable",
  "row": {
    "fields": [
      { "name": "chunk_index", "type": { "kind": "Int64" } },
      { "name": "text", "type": { "kind": "Str" } }
    ]
  }
}
```

**FlowSchema (root struct + op scope):**

```json
{
  "schema": {
    "fields": [
      { "name": "doc_id", "type": { "kind": "Str" } },
      { "name": "chunks", "type": { "kind": "LTable", "row": { "fields": [
        { "name": "text", "type": { "kind": "Str" } }
      ] } } }
    ]
  },
  "root_op_scope": {
    "op_output_types": {},
    "op_scopes": {},
    "collectors": []
  }
}
```

**FieldSchema as used by targets (key_fields_schema / value_fields_schema):**

```json
[
  { "name": "id", "type": { "kind": "Int64" } }
]
```

```json
[
  { "name": "content", "type": { "kind": "Str" } },
  { "name": "embedding", "type": { "kind": "Vector", "element_type": { "kind": "Float32" }, "dimension": 384 } }
]
```

**CollectorSchema with auto UUID:**

```json
{
  "fields": [
    { "name": "_uuid", "type": { "kind": "Uuid" } },
    { "name": "payload", "type": { "kind": "Str" } }
  ],
  "auto_uuid_field_idx": 0
}
```

**TableColumnsSchema-style (key/value columns for a table target):**

Key columns and value columns are typically derived from the flow’s table type: key columns from `key_schema()` and value columns from the remaining row fields. Each column is often represented with a name and a type (or target-specific config); the exact shape is target-dependent (e.g. Doris, LanceDB, ChromaDB use `key_fields_schema` / `value_fields_schema` as lists of `FieldSchema`).
