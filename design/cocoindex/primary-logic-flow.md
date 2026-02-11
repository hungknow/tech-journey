# Primary Logic Flows in CocoIndex

A concise map of the main logic flows in the Python and Rust codebase. See also `cr/incremental-update.md` and `cr/memorization.md` for detailed behavior.

---

## 1. Flow definition and build (Python → Rust)

**Purpose:** User defines a flow in Python; the engine builds an internal representation and execution plan.

**Python entry:** `flow.py`
- `open_flow(name, fl_def)` / `@flow_def` → `_create_lazy_flow` → `Flow(name, _create_engine_flow)`.
- On first use, `_internal_flow()` calls `_create_engine_flow()`: creates `_FlowBuilderState(full_name)`, runs `fl_def(FlowBuilder, root_scope)`, then `engine_flow_builder.build_flow()`.
- FlowBuilder: `add_source(spec, ...)`, `transform(fn_spec, *args, **kwargs)`, `declare(spec)`.
- DataSlice: `row()`, `for_each(f)`, `transform(fn_spec, ...)`, `[field]`.
- DataScope: `[field]` get/set, `add_collector()` → DataCollector.
- DataCollector: `collect(**kwargs)` (including `GeneratedField.UUID`), `export(target_name, target_spec, primary_key_fields=..., vector_indexes=..., ...)`.

**Rust:** `rust/cocoindex/src/builder/`
- `flow_builder.rs`: FlowBuilder (PyO3), DataSlice, DataScope, DataCollector, add_source, transform, for_each, collect, export, build_flow.
- `analyzer.rs`: ValueTypeBuilder, StructSchemaBuilder, TableSchemaBuilder; analyzes spec and builds typed flow.
- `plan.rs`: AnalyzedImportOp, AnalyzedTransformOp, AnalyzedForEachOp, AnalyzedCollectOp, AnalyzedExportOp, ExecutionPlan; FieldDefFingerprint for logic fingerprinting.
- `analyzed_flow.rs`: `AnalyzedFlow::from_flow_instance` → analyzer::analyze_flow → data_schema, setup_state, execution_plan future.

**Value:** Single place where “source → transforms → collect → export” becomes an analyzable, executable pipeline with schemas and setup.

---

## 2. Flow analysis and execution plan

**Purpose:** Turn a flow instance spec into a typed schema, setup state, and a runnable execution plan.

**Rust:** `builder/analyzer.rs`, `builder/plan.rs`
- `analyze_flow(flow_instance, flow_instance_ctx)` → FlowSchema, AnalyzedSetupState, future of ExecutionPlan.
- Execution plan: import ops (sources), transform ops, for_each, collect ops, export ops; concurrency controllers; primary key and collector schemas.
- Setup state: tracking table config, source/target/attachment setup (e.g. Postgres, Qdrant).

**Value:** Enables correct execution (types, keys, targets) and incremental/tracking behavior (source keys, target keys, logic fingerprints).

---

## 3. Source streaming and scheduling

**Purpose:** Stream source rows (with ordinals and optional content fingerprints), skip already-processed rows in memory, and schedule work per source.

**Rust:** `execution/source_indexer.rs`, `execution/live_updater.rs`
- Source executor: `read(options)` → stream of `PartialSourceRow` (key, ordinal, content_version_fp, value: Existence/NonExistence).
- In-memory state: `SourceIndexingState` — map of source key → `SourceRowIndexingState` (source_version, content_version_fp, semaphore, touched_generation).
- On each row: `LocalSourceRowStateOperator::advance(source_version, content_version_fp, force_reload)` → skip if `existing_version.should_skip(&source_version)` (ordinal + logic), else take semaphore and run row pipeline.
- Deleted rows: keys seen in a previous scan but not in current scan → processed as NonExistence (delete target keys, then remove or finalize tracking row).
- Live updater: one task per source; either one-pass batch (`update_one_pass`) or live loop with `change_stream` (if source supports it).

**Value:** Only changed or new source rows are processed; deleted rows are detected and cleaned up; concurrency and backpressure are centralized.

---

## 4. Per–source-row pipeline (evaluate → precommit → apply → commit)

**Purpose:** For each source row that is not skipped: evaluate the flow with memoization, stage target keys and memo in the tracking table, apply upserts/deletes to targets, then commit the tracking row.

**Rust:** `execution/row_indexer.rs`, `execution/evaluator.rs`, `execution/db_tracking.rs`
- **Read tracking:** `read_source_tracking_info_for_processing(source_id, source_key_json, ...)` → memoization_info, processed_source_ordinal, process_logic_fingerprint, etc.
- **Skip:** If not full reprocess and `SourceVersion::from_stored_processing_info(...).should_skip(source_version)` → return Skipped (no DB/target writes). Optional content-fingerprint shortcut: if content fingerprint matches stored, advance ordinal only and skip evaluation/targets.
- **Evaluate:** Load memoization blob into `EvaluationMemory`, run `evaluate_source_entry` (evaluator) for the row; get output rows + `StoredMemoizationInfo` (only entries used this run). Full reprocess clears memo cache for that row before eval.
- **Precommit:** In a transaction: `read_source_tracking_info_for_precommit` again; re-check “already processed?”; compute new target keys and diff with existing → upserts + deletes per target; write to tracking row only precommit fields (staging keys, memoization_info); commit transaction.
- **Apply to targets:** For each target, call executor with `ExportTargetMutation` (upserts + deletes).
- **Commit tracking:** New transaction: `read_source_tracking_info_for_commit`; if another process committed with process_ordinal ≥ ours, do not overwrite; else write committed source ordinal, content fingerprint, logic fingerprint, process ordinal/time, final target keys; or delete tracking row if source row is gone and no staged keys.

**Value:** Correct, serializable incremental updates: no double-apply, no lost deletes, and tracking table always reflects last committed state and target keys produced.

---

## 5. Incremental detection (ordinal, fingerprint, skip)

**Purpose:** Decide whether to skip processing a source row using stored vs incoming ordinal and optional content fingerprint.

**Rust:** `execution/row_indexer.rs` (`SourceVersion`, `SourceVersionKind`), `execution/indexing_status.rs`
- `SourceVersion`: ordinal (Option<i64>) + kind (UnknownLogic, DifferentLogic, CurrentLogic, NonExistence). From stored: `from_stored_processing_info` / `from_stored_precommit_info` using process_logic_fingerprint.
- `should_skip(target, update_stats)`: skip if stored ordinal > target ordinal, or same ordinal with same/newer logic; otherwise process. Never process an older ordinal than committed.
- Content fingerprint: if provided and matches stored, can skip evaluation and target writes and only advance stored ordinal (content-hash collapsing in row_indexer).

**Value:** Minimal recomputation and target writes; preserves consistency (never apply an older source version).

---

## 6. Memoization (cache + UUID stability)

**Purpose:** Cache expensive per-row computations (e.g. LLM, embeddings) by (op logic + inputs) and keep UUID sequences stable for collected rows across runs.

**Rust:** `execution/memoization.rs`, used in `evaluator.rs` and `row_indexer.rs`
- Stored: `StoredMemoizationInfo` — cache (fingerprint → { time_sec, value }), uuids (fingerprint → list of UUIDs). Stored per source row in tracking table (`memoization_info`).
- At eval: build `EvaluationMemory` from stored blob; cacheable ops use `get_cache_entry(key, output_type, ttl)` and `evaluate_with_cell(cell, compute)`; UUIDs via `next_uuid(fingerprint)`.
- After eval: `into_stored()` keeps only entries used this run (Current); Previous-only entries are dropped.
- Precommit: updated `memoization_info` written to tracking row with staging keys.

**Value:** Fewer redundant LLM/embedding calls; stable target keys (e.g. vector DB) across runs.

---

## 7. Tracking table and target key lifecycle

**Purpose:** Persist, per source row, what was last committed and which target keys were produced, so the engine can compute upserts and deletes on the next run.

**Rust:** `execution/db_tracking.rs`, `execution/db_tracking_setup.rs`
- Tracking table: (source_id, source_key) → precommit fields (staging target keys, memoization_info) and commit fields (processed_source_ordinal, processed_source_fp, process_logic_fingerprint, max_process_ordinal, process_ordinal, target keys list).
- Precommit updates staging + memo; commit updates committed ordinal/fingerprints/process_ordinal/time and final target keys. Delete list for targets = old keys minus (staging + new keys).

**Value:** Enables correct incremental updates and deletes when source rows change or are removed (see `cr/incremental-update.md`).

---

## 8. Live updater (batch vs change stream)

**Purpose:** Run one-pass batch update or long-lived live update with optional change streams.

**Rust:** `execution/live_updater.rs`
- `FlowLiveUpdater`: holds flow context, per-source tasks in a JoinSet, status watch (active_sources, updated_sources), options (live_mode, reexport_targets, full_reprocess, print_stats).
- Non–live mode: each source runs `update_one_pass(...)` then task ends.
- Live mode: if source has `change_stream()`, spawn a loop that consumes change events and runs updates (with retries); also optional periodic refresh. Progress/status reported via `next_status_updates_async()`.

**Python:** `flow.py` — `FlowLiveUpdater`, `Flow.update_async` (creates updater with live_mode=False), `Flow.update()`.

**Value:** Single API for “run once” and “keep updating” with minimal code paths.

---

## 9. Setup and drop (backends, tracking)

**Purpose:** Create or tear down persistent resources (tracking table, target DBs, etc.) for flows.

**Rust:** `setup/` (driver, components, db_metadata, flow_features), `execution/db_tracking_setup.rs`
- Setup bundle: list of flow full names → describe changes (e.g. create tracking table, create target tables/indexes) → apply.
- Tracking table: schema with source_id, source_key, precommit and commit columns.

**Python:** `flow.py` — `Flow.setup_async` / `setup()`, `Flow.drop_async` / `drop()`, `make_setup_bundle_async`, `make_drop_bundle_async`; `setup.py` for SetupChangeBundle and describe_and_apply.

**Value:** Reproducible environment for development and production; flows can be reset via drop then setup.

---

## 10. Transform flows (transient, in-memory)

**Purpose:** Run a pure transformation on in-memory inputs without sources/targets or tracking.

**Python:** `flow.py` — `TransformFlow`, `@transform_flow()`, `TransformFlow.eval` / `eval_async`.
- User function takes `DataSlice[T]` args and returns `DataSlice[T]`; first use builds transient flow via `_build_flow_info_async` (add_direct_input, set_direct_output, build_transient_flow_async).
- Eval: encode args, call `engine_flow.evaluate_async(params)`, decode result.

**Rust:** `builder/analyzed_flow.rs` — `AnalyzedTransientFlow`, `analyzer::analyze_transient_flow`; execution uses same evaluator on transient plan (no tracking, no targets).

**Value:** Reuse same flow DSL and evaluator for ad-hoc or embedded transforms (e.g. query-time or batch scripts).

---

## 11. Query handlers and service API

**Purpose:** Expose flow-specific query endpoints (e.g. vector search, graph query) via a common API.

**Python:** `flow.py` — `Flow.add_query_handler(name, handler, result_fields=...)`, `@Flow.query_handler(name=..., result_fields=...)`; handler is made async and serialized via `dump_engine_object`.
**Rust:** `service/flows.rs` — list_flows, get_flow_schema, get_flow, get_keys, run_query_handler, etc.; `service/query_handler.rs` — invoke registered handler with query string and return structured results.

**Value:** One place to add “query this flow” semantics without touching core indexing logic.

---

## 12. CLI and app loading

**Purpose:** Load user app (flows + ops), run setup/update/drop/serve from the command line.

**Python:** `cli.py` — load_dotenv, load_user_app(app_target), add_user_app; commands (e.g. setup, update, drop, serve) that call into `flow` and `setup`. `flow_names_with_setup` for flows that need setup.

**Value:** Standard way to run CocoIndex in production or scripts (single entry point, env and app dir config).

---

## Summary table

| Flow | Python | Rust |
|------|--------|------|
| Flow definition & build | `flow.py`: FlowBuilder, DataSlice, DataScope, DataCollector, open_flow, build_flow | `builder/flow_builder.rs`, `analyzer.rs`, `plan.rs`, `analyzed_flow.rs` |
| Execution plan | — | `builder/plan.rs`, `analyzer.rs` |
| Source streaming & scheduling | — | `execution/source_indexer.rs`, `live_updater.rs` |
| Per-row: evaluate → precommit → apply → commit | — | `execution/row_indexer.rs`, `evaluator.rs`, `db_tracking.rs` |
| Incremental skip (ordinal/fp) | — | `execution/row_indexer.rs` (SourceVersion), `indexing_status.rs` |
| Memoization | — | `execution/memoization.rs`, `evaluator.rs`, `row_indexer.rs` |
| Tracking table lifecycle | — | `execution/db_tracking.rs`, `db_tracking_setup.rs` |
| Live updater | `flow.py`: FlowLiveUpdater, Flow.update_async | `execution/live_updater.rs` |
| Setup / drop | `flow.py`: setup_async, drop_async; `setup.py` | `setup/`, `execution/db_tracking_setup.rs` |
| Transform flows | `flow.py`: TransformFlow, transform_flow(), eval_async | `builder/analyzed_flow.rs` (transient), evaluator |
| Query handlers & API | `flow.py`: add_query_handler; `query_handler.py` | `service/flows.rs`, `query_handler.rs` |
| CLI & app load | `cli.py`, `user_app_loader.py` | — |
