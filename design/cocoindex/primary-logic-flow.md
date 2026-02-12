# Primary Logic Flows in CocoIndex

A concise map of the main logic flows in the Python and Rust codebase. See also `cr/incremental-update.md` and `cr/memorization.md` for detailed behavior.

---

## 1. Flow definition and build (Python → Rust)

**Purpose:** User defines a flow in Python; the engine builds an internal representation and execution plan. The flow is a declarative pipeline: which sources to read, how to transform rows, what to collect, and where to export.

You define the flow by receiving a `FlowBuilder` and a root `DataScope`. You call `add_source` to register a data source and its output type. On a `DataSlice` (a handle over source or transformed data), `transform` adds a function step whose output becomes the new slice, and `for_each` opens a nested scope per row. In each scope, `DataScope` holds field values and `add_collector` creates a `DataCollector` that accumulates rows via `collect(...)` and sends them to targets via `export(...)`. No source rows are read at definition time—only a spec graph is built.

When the flow is first used, `_create_engine_flow()` runs this definition; then Rust’s `build_flow()` (in `builder/flow_builder.rs`) turns the graph into an engine flow instance (sources, transforms, collectors, exports). The analyzer (`analyzer.rs`) type-checks it and builds an execution plan (`plan.rs`); `AnalyzedFlow::from_flow_instance` in `analyzed_flow.rs` produces the final data schema, setup state, and plan.

**Code:**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/builder/
  flow_builder.rs
  analyzer.rs
  plan.rs
  analyzed_flow.rs
```

**Value:** Single place where “source → transforms → collect → export” becomes an analyzable, executable pipeline with schemas and setup.

---

## 2. Flow analysis and execution plan

**Purpose:** Turn a flow instance spec into a typed schema, setup state, and a runnable execution plan. This is where the engine infers types, resolves sources/targets, and produces a linearized plan the runtime can execute.

The analyzer walks the flow graph (sources, transforms, for_each, collect, export) and builds a `ValueTypeBuilder` tree for each value type (struct/table fields, collector schemas). It resolves function specs to executors and attaches concurrency controllers. You get a `FlowSchema` (root and collector schemas), `AnalyzedSetupState` (tracking table, source/target/attachment configs), and an `ExecutionPlan`.

The plan is a sequence of ops: `AnalyzedImportOp` (source + primary key), `AnalyzedTransformOp` (inputs → function → output), `AnalyzedForEachOp` (nested scope per row), `AnalyzedCollectOp` (input mapping → collector rows), `AnalyzedExportOp` (collector → target + primary key). Field definitions get a `FieldDefFingerprint` (sources + logic fingerprint) so the runtime can detect logic changes and decide reprocessing. All of this lives in `builder/analyzer.rs` and `builder/plan.rs`: `analyze_flow(flow_instance, flow_instance_ctx)` returns the schema, setup state, and a future of the execution plan.

**Code:**
```
rust/cocoindex/src/builder/
  analyzer.rs
  plan.rs
```

**Value:** Enables correct execution (types, keys, targets) and incremental/tracking behavior (source keys, target keys, logic fingerprints).

---

## 3. Source streaming and scheduling

**Purpose:** Stream source rows (with ordinals and optional content fingerprints), skip already-processed rows in memory, and schedule work per source so only new or changed data triggers the per-row pipeline.

Each source is driven by its executor’s `read(options)`, which yields a stream of `PartialSourceRow`: source key, ordinal, optional content_version_fp, and value as Existence(field_values) or NonExistence. The runtime keeps an in-memory `SourceIndexingState` (in `execution/source_indexer.rs`): for each source key, the last known `SourceVersion` (ordinal + logic kind) and optional content fingerprint.

When a row arrives, `LocalSourceRowStateOperator::advance(source_version, content_version_fp, force_reload)` compares with this state: if the stored version is newer or equal (same ordinal, same or newer logic), the row is skipped and no pipeline runs; otherwise the runtime takes a per-key semaphore and runs the full row pipeline (evaluate → precommit → apply → commit). Keys that appeared in a prior scan but not in the current scan are treated as deleted—the pipeline runs with NonExistence to remove target keys and update or remove the tracking row.

The live updater (`execution/live_updater.rs`) runs one task per source: either a single `update_one_pass` (batch) or a long-lived loop that consumes `change_stream` events and optionally does periodic refresh.

**Code:**
```
rust/cocoindex/src/execution/
  source_indexer.rs
  live_updater.rs
```

**Value:** Only changed or new source rows are processed; deleted rows are detected and cleaned up; concurrency and backpressure are centralized.

---

## 4. Per–source-row pipeline (evaluate → precommit → apply → commit)

**Purpose:** For each source row that is not skipped: evaluate the flow with memoization, stage target keys and memo in the tracking table, apply upserts/deletes to targets, then commit the tracking row. This ensures each row is applied at most once and tracking stays consistent with targets.

For one (source_id, source_key) the runtime first **reads tracking** via `read_source_tracking_info_for_processing` to get stored memoization_info, processed_source_ordinal, process_logic_fingerprint, etc. If it’s not a full reprocess and the stored version `should_skip` the incoming source version (ordinal + logic), it returns Skipped and does nothing. Optionally, if a content fingerprint is present and matches the stored one, it only advances the stored ordinal and skips evaluation and targets.

Next it **evaluates**: it rehydrates `EvaluationMemory` from the stored memoization blob and runs `evaluate_source_entry`; the evaluator fills the root scope with the source row and runs the plan’s reactive ops (transforms, for_each, collect) in order, with cacheable ops using the memory for cache and UUIDs. Output is the root scope value (including collected rows per collector) and a new `StoredMemoizationInfo` containing only entries used in this run; full reprocess clears that row’s memo cache before eval.

In the **precommit** phase, inside a DB transaction the runtime re-reads tracking with `read_source_tracking_info_for_precommit` and re-checks skip; from the evaluation output it computes the new target keys per export, diffs with existing/staging keys to build upserts and deletes per target, and writes to the tracking row only the precommit fields (staging target keys and memoization_info), then commits the transaction—no target writes yet. It then **applies to targets**: for each export group it calls the target executor’s `apply_mutation` with the computed `ExportTargetMutation` (upserts and deletes).

Finally it **commits tracking** in a new transaction: `read_source_tracking_info_for_commit`; if another process has committed with process_ordinal ≥ ours, it does not overwrite (lost race); otherwise it writes the committed source ordinal, content fingerprint, logic fingerprint, process ordinal/time, and final target keys, or deletes the tracking row if the source row is gone and there are no staged keys. This logic lives in `execution/row_indexer.rs`, `execution/evaluator.rs`, and `execution/db_tracking.rs`.

**Code:**
```
rust/cocoindex/src/execution/
  row_indexer.rs
  evaluator.rs
  db_tracking.rs
```

**Value:** Correct, serializable incremental updates: no double-apply, no lost deletes, and tracking table always reflects last committed state and target keys produced.

---

## 5. Incremental detection (ordinal, fingerprint, skip)

**Purpose:** Decide whether to skip processing a source row using stored vs incoming ordinal and optional content fingerprint, so the engine never re-applies older data and avoids redundant work when nothing changed.

A `SourceVersion` pairs an ordinal (monotonic per source) with a kind: UnknownLogic (no stored fingerprint), DifferentLogic (stored fingerprint differs from current flow logic), CurrentLogic (matches), or NonExistence (row deleted). The stored version is built from the tracking row via `from_stored_processing_info` / `from_stored_precommit_info` using process_logic_fingerprint.

`should_skip(target, update_stats)` compares stored vs incoming: skip if the stored ordinal is greater than the incoming ordinal (we already applied a newer version), or if ordinals are equal and the stored kind is same or newer; otherwise the row is processed, so we never apply an older ordinal than what’s committed. If the source supplies a content fingerprint and it matches the stored one (and logic is current), we can skip the full evaluation and target writes and only advance the stored ordinal in the tracking table (content-hash collapsing). Implemented in `execution/row_indexer.rs` (`SourceVersion`, `SourceVersionKind`) and `execution/indexing_status.rs`.

**Code:**
```
rust/cocoindex/src/execution/
  row_indexer.rs
  indexing_status.rs
```

**Value:** Minimal recomputation and target writes; preserves consistency (never apply an older source version).

---

## 6. Memoization (cache + UUID stability)

**Purpose:** Cache expensive per-row computations (e.g. LLM, embeddings) by (op logic + inputs) and keep UUID sequences stable for collected rows across runs, so re-runs reuse results and target keys don’t flip.

Per source row, the tracking table holds `memoization_info`: a `StoredMemoizationInfo` with (1) a cache (fingerprint → { time_sec, value }) for past cacheable op results, and (2) uuids (fingerprint → list of UUIDs) for stable generated IDs. At evaluation start this blob is loaded into `EvaluationMemory`: cache entries become Previous (available for lookup) and the UUID lists are restored.

During eval, cacheable ops call `get_cache_entry(key, output_type, ttl)`; on miss they call `evaluate_with_cell(cell, compute)` and store the result as Current. UUIDs are handed out via `next_uuid(fingerprint)` from the restored list or by appending new ones. After eval, `into_stored()` produces a new `StoredMemoizationInfo` that keeps only entries used in this run (Current); entries that were only in Previous and unused are dropped. That updated blob is written to the tracking row at precommit along with staging keys. Implemented in `execution/memoization.rs`, used in `evaluator.rs` and `row_indexer.rs`.

**Code:**
```
rust/cocoindex/src/execution/
  memoization.rs
  evaluator.rs
  row_indexer.rs
```

**Value:** Fewer redundant LLM/embedding calls; stable target keys (e.g. vector DB) across runs.

---

## 7. Tracking table and target key lifecycle

**Purpose:** Persist, per source row, what was last committed and which target keys were produced, so the engine can compute upserts and deletes on the next run and avoid double-applies or lost deletes.

The tracking table is keyed by (source_id, source_key). Each row has two groups of columns. **Precommit fields** (written in the precommit transaction): staging target keys (per target: list of key + additional_key + process_ordinal + fingerprint) and memoization_info. **Commit fields** (written in the commit transaction): processed_source_ordinal, processed_source_fp, process_logic_fingerprint, max_process_ordinal, process_ordinal, and the final list of target keys per target.

On precommit we write only staging + memo and do not overwrite committed fields; on commit we overwrite committed fields with the new ordinal, fingerprints, process_ordinal/time, and final target keys—or we delete the tracking row if the source row is gone and there are no staged keys. When computing mutations for a target, the delete list is (old committed keys + old staging keys) minus (new staging keys), so keys that disappeared from the flow output are deleted from the target. Schema and read/write logic live in `execution/db_tracking.rs` and `execution/db_tracking_setup.rs`.

**Code:**
```
rust/cocoindex/src/execution/
  db_tracking.rs
  db_tracking_setup.rs
```

**Value:** Enables correct incremental updates and deletes when source rows change or are removed (see `cr/incremental-update.md`).

---

## 8. Live updater (batch vs change stream)

**Purpose:** Run either a one-pass batch update (process all sources once and exit) or a long-lived live update that keeps sources in sync using change streams and optional periodic refresh.

The `FlowLiveUpdater` (in `execution/live_updater.rs`) holds the flow context, a JoinSet of per-source tasks, and status channels (active_sources, updated_sources). In non–live mode, each source runs a single `update_one_pass`: it reads the source stream, advances row state, and runs the per-row pipeline for each non-skipped row (including handling deletes), then the task completes.

In live mode, for each source the updater spawns a task that either (1) uses the source’s `change_stream()` if available—consuming change events and running updates with retries for affected keys—or (2) runs periodic full refreshes. Status (which sources are active, which have been updated) is reported via `next_status_updates_async()`. Data flow is the same as in sections 3–4: source rows stream in, skip logic and per-row pipeline run, and targets are updated; the only difference is whether the source task runs once or loops. Python’s `flow.py` exposes `FlowLiveUpdater`, `Flow.update_async` (creates the updater with live_mode=False), and `Flow.update()`.

**Code:**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/execution/
  live_updater.rs
```

**Value:** Single API for “run once” and “keep updating” with minimal code paths.

---

## 9. Setup and drop (backends, tracking)

**Purpose:** Create or tear down persistent resources (tracking table, target DBs, indexes, etc.) so flows have a consistent environment and can be reset cleanly.

Setup takes a list of flow full names and builds a setup bundle: for each flow, the engine describes what changes are needed (e.g. create tracking table, create target schema/indexes, register attachments). No user data is read or written—only DDL and backend registration. The tracking table schema is fixed: source_id, source_key, plus precommit columns (e.g. staging_target_keys, memoization_info) and commit columns (processed_source_ordinal, processed_source_fp, process_logic_fingerprint, max_process_ordinal, process_ordinal, target_keys, etc.). Apply runs these changes in order.

Drop produces a drop bundle that reverses or removes the same resources (e.g. drop tracking table, drop target objects). Rust implements this in `setup/` (driver, components, db_metadata, flow_features) and `execution/db_tracking_setup.rs`. Python’s `Flow.setup_async` / `setup()` and `Flow.drop_async` / `drop()` build the bundle via `make_setup_bundle_async` / `make_drop_bundle_async` and call the generic describe-and-apply path; `setup.py` provides SetupChangeBundle and describe_and_apply.

**Code:**
```
python/cocoindex/
  flow.py
  setup.py
rust/cocoindex/src/
  setup/
  execution/
    db_tracking_setup.rs
```

**Value:** Reproducible environment for development and production; flows can be reset via drop then setup.

---

## 10. Transform flows (transient, in-memory)

**Purpose:** Run a pure transformation on in-memory inputs without sources, targets, or tracking—e.g. for one-off or query-time transforms.

The user defines a transform flow with a function that takes one or more `DataSlice[T]` arguments and returns a `DataSlice[T]`. On first use, the engine builds a transient flow: direct inputs are declared for each argument, and the function body is executed in the same builder DSL (transforms, for_each, etc.) but with no sources or exports; the result is the direct output. That yields an `AnalyzedTransientFlow` (schema + transient execution plan) from `analyzer::analyze_transient_flow` in `builder/analyzed_flow.rs`.

On `eval` / `eval_async`, the Python side encodes the argument values and calls the engine’s `evaluate_async(params)`. The Rust evaluator runs the same execution path as indexed flows (same op scope evaluation), but with no import/export ops and no tracking or memoization persistence: the root scope is filled from the encoded params, reactive ops run, and the output is decoded and returned to Python. No DB or target I/O occurs. Python entry points are `flow.py` — `TransformFlow`, `@transform_flow()`, `TransformFlow.eval` / `eval_async`; build uses `_build_flow_info_async` (add_direct_input, set_direct_output, build_transient_flow_async).

**Code:**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/builder/
  analyzed_flow.rs
rust/cocoindex/src/execution/
  evaluator.rs
```

**Value:** Reuse same flow DSL and evaluator for ad-hoc or embedded transforms (e.g. query-time or batch scripts).

---

## 11. Query handlers and service API

**Purpose:** Expose flow-specific query endpoints (e.g. vector search, graph query) via a common API so clients can query indexed data without coupling to the indexing pipeline.

The user registers a query handler on a flow with `add_query_handler(name, handler, result_fields=...)`. The handler is a callable (optionally async) that is serialized (e.g. via `dump_engine_object`) and stored with the flow.

At runtime, the service layer’s `run_query_handler` receives a flow id, handler name, and query payload (e.g. a string or JSON). It looks up the flow and the registered handler, deserializes and invokes the handler with the query, and returns the result in a structured shape (using result_fields when provided). No source/tracking/target data flows through the handler by default—the handler typically uses the flow’s targets or attachments to serve the query. So the data flow is: request → resolve flow and handler → invoke handler(query) → format response. Python: `flow.py` — `Flow.add_query_handler`, `@Flow.query_handler`; handler is made async and serialized. Rust: `service/flows.rs` (list_flows, get_flow_schema, get_flow, get_keys, run_query_handler, etc.), `service/query_handler.rs` (invoke handler with query string and return structured results).

**Code:**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/service/
  flows.rs
  query_handler.rs
```

**Value:** One place to add “query this flow” semantics without touching core indexing logic.

---

## 12. CLI and app loading

**Purpose:** Load the user app (flows and ops), apply environment config, and run setup/update/drop/serve from a single CLI entry point.

The CLI loads environment (e.g. `load_dotenv`) and then loads the user app via `load_user_app(app_target)` / `add_user_app`: that imports the app module so that flows and ops are registered in the global engine context. No flow data is streamed at load time.

Commands then dispatch: setup/drop build and apply setup/drop bundles for flows that require setup (`flow_names_with_setup`); update creates a `FlowLiveUpdater` and runs it (batch or live); serve starts the service layer so that flow and query-handler APIs are exposed. So the flow is orchestration-only: CLI → load app → run the chosen command (setup, update, drop, serve), which in turn uses the flow and setup logic described in the previous sections. Implemented in `cli.py` (load_dotenv, load_user_app, add_user_app, and the setup/update/drop/serve commands) and `user_app_loader.py`; `flow_names_with_setup` determines which flows need setup.

**Code:**
```
python/cocoindex/
  cli.py
  user_app_loader.py
```

**Value:** Standard way to run CocoIndex in production or scripts (single entry point, env and app dir config).

---

## File tree (by flow)

**1. Flow definition and build**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/builder/
  flow_builder.rs
  analyzer.rs
  plan.rs
  analyzed_flow.rs
```

**2. Flow analysis and execution plan**
```
rust/cocoindex/src/builder/
  analyzer.rs
  plan.rs
```

**3. Source streaming and scheduling**
```
rust/cocoindex/src/execution/
  source_indexer.rs
  live_updater.rs
```

**4. Per-row pipeline (evaluate → precommit → apply → commit)**
```
rust/cocoindex/src/execution/
  row_indexer.rs
  evaluator.rs
  db_tracking.rs
```

**5. Incremental detection (ordinal, fingerprint, skip)**
```
rust/cocoindex/src/execution/
  row_indexer.rs
  indexing_status.rs
```

**6. Memoization**
```
rust/cocoindex/src/execution/
  memoization.rs
  evaluator.rs
  row_indexer.rs
```

**7. Tracking table and target key lifecycle**
```
rust/cocoindex/src/execution/
  db_tracking.rs
  db_tracking_setup.rs
```

**8. Live updater**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/execution/
  live_updater.rs
```

**9. Setup and drop**
```
python/cocoindex/
  flow.py
  setup.py
rust/cocoindex/src/
  setup/
  execution/
    db_tracking_setup.rs
```

**10. Transform flows**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/builder/
  analyzed_flow.rs
rust/cocoindex/src/execution/
  evaluator.rs
```

**11. Query handlers and service API**
```
python/cocoindex/
  flow.py
rust/cocoindex/src/service/
  flows.rs
  query_handler.rs
```

**12. CLI and app loading**
```
python/cocoindex/
  cli.py
  user_app_loader.py
```
