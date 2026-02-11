# Memorization (Memoization) in CocoIndex

How the engine caches expensive computations per source row so that repeated or unchanged work (e.g. LLM calls, embeddings) is reused across runs instead of recomputed.

---

## 1. What it is and why

When a flow runs, some steps are expensive: calling an LLM, computing embeddings, or running a heavy transform. For a given **source row**, the same inputs often produce the same outputs. **Memoization** is a cache keyed by a **fingerprint** of (flow logic + inputs). If we’ve already computed that before, we reuse the result instead of calling the LLM or recomputing.

- **Within a run:** Same input in two places (e.g. same text embedded twice) is computed once and reused.
- **Across runs:** When we re-process a source row (e.g. after a crash or re-run), we load the cache from the tracking table; if the inputs haven’t changed, we skip the expensive call and use the stored result.

So we avoid redundant work both inside one evaluation and between runs.

---

## 2. Where it lives

- **Storage:** The **tracking table** (PostgreSQL) has a JSONB column `memoization_info` **per source row**. That blob holds:
  - **cache:** map from fingerprint → `{ time_sec, value }` (the cached result),
  - **uuids:** map from fingerprint → list of UUIDs (for deterministic target keys; see below).
- **When it’s used:** During evaluation of a **single source row**, the engine:
  1. Reads that row’s `memoization_info` from the tracking table,
  2. Builds an in-memory **EvaluationMemory** from it (cache + uuids),
  3. Runs the flow; any cacheable step looks up by fingerprint and either reuses a value or computes and stores it,
  4. After evaluation, converts the in-memory state back to **StoredMemoizationInfo** (keeping only what was used this run),
  5. In the **precommit** phase, writes the updated `memoization_info` back to the tracking row (before applying target writes).

So memoization is **per source key**: each source row has its own cache blob. There is no global cache across source rows.

---

## 3. Cache key: fingerprint

For a step that supports caching (e.g. a transform with `enable_cache: true`), the cache key is a **fingerprint** of:

- The **op’s logic** (built at flow build time: op name, behavior version, schema, etc.),
- The **input values** to that op for this evaluation.

So “same logic + same inputs” ⇒ same fingerprint ⇒ same cache entry. The fingerprint is computed in Rust (e.g. in `evaluator.rs`) using a `Fingerprinter` that hashes the op’s identity and the input `Value`s.

---

## 4. Cache lookup and compute

- **Lookup:** For a cacheable op, the evaluator calls `memory.get_cache_entry(key, output_type, ttl)`. The `key` is a closure that computes the fingerprint from the op and its inputs.
- **Hit:** If there is an entry and it’s not expired (TTL is optional), the engine returns a **cell** that either already holds the value (from this run) or will be filled from the stored JSON (from a previous run). The actual async work (LLM, embed) is run only if the cell is still empty, via `evaluate_with_cell(cell, compute)`.
- **Miss:** If there is no entry (or TTL expired), a new cell is created, the engine runs the expensive `compute`, and the result is stored in the cell and in the in-memory cache.
- **After the run:** When we call `into_stored()`, we keep **only entries that were used in this run** (i.e. that were either read from “Previous” or newly computed and are “Current”). Entries that were in the blob from a previous run but never touched this time are dropped. So the stored blob doesn’t grow without bound; it only keeps cache entries that this run actually used.

---

## 5. UUID stability (why uuids are in the memo blob)

Flows often generate **stable IDs** for collected rows (e.g. `id=cocoindex.GeneratedField.UUID`). Those UUIDs are produced by `memory.next_uuid(fingerprint)`. The fingerprint is derived from the “logical” inputs to the collect (e.g. field values excluding the id). So:

- **Same logical row** (same inputs) ⇒ same fingerprint ⇒ same sequence of UUIDs from `next_uuid`.
- The engine stores the list of UUIDs per fingerprint in the memo blob. When we load the cache for the next run, we restore those UUID sequences. So the same logical row gets the **same UUID** across runs, which keeps target keys stable and avoids unnecessary churn (e.g. in a vector DB or graph).

So the “uuids” part of memoization is not just for caching computed values; it’s for **deterministic, stable target keys** across runs.

---

## 6. Lifecycle summary

- **Read:** Load `memoization_info` for this source key from the tracking table.
- **Eval:** Build `EvaluationMemory` from that blob. Run the flow; cache hits reuse results and UUIDs; misses compute and store.
- **Into stored:** From in-memory state, keep only cache entries and UUID entries that were **used this run**. Serialize to `StoredMemoizationInfo`.
- **Precommit:** Write the new `memoization_info` (and staging target keys) to the tracking row.
- **Full reprocess:** If the run is in “full reprocess” mode, the cache for that row is **cleared** before evaluation, so every step is recomputed (memoization is still used within that single run).

---

## 7. How data is compared (what makes a cache key)

Comparison is by **fingerprint equality**, not by value equality. The fingerprint is a 16-byte hash (Blake2b). Two lookups are treated as the same if and only if their fingerprints are equal.

**What goes into the fingerprint for a cacheable step:**

- **Op identity:** op name, output type, behavior version (so if you change the op or its version, the key changes and you get a miss).
- **Input values:** the exact input values passed to that op in this evaluation (serialized and hashed).

So the engine does **not** compare raw values byte-by-byte. It compares the hash of (op identity + inputs). Any change to the op or to any input value produces a different fingerprint and therefore a cache miss.

**Example (conceptual):** For an “embed text” step with input `"hello"`, the fingerprint might be `F1`. For `"hello"` again, it’s still `F1` → cache hit. For `"world"`, it’s `F2` → cache miss. For the same “embed text” op but with behavior_version bumped, `"hello"` gets a different fingerprint `F1'` → cache miss, because the op identity changed.

---

## 8. How new changes are detected (hit vs miss, and pruning)

**When is a change detected?**

- **Cache hit:** The fingerprint exists in the in-memory cache (either loaded from the blob or just computed this run), and if TTL is set, the stored timestamp + TTL is not before “now”. Then we reuse the stored value; no change, no recompute.
- **Cache miss:** The fingerprint is not in the cache, or the entry is expired (TTL). Then we treat it as “new” or “changed”: we run the expensive step and store the result under that fingerprint.

So “change” here means “this (op + inputs) combination is not present in the cache (or is expired)”. The engine does not diff content; it only checks presence of the fingerprint and optional TTL.

**After the run: which entries are kept?**

When we persist the memo blob, we **only keep entries that were used in this run**:

- **Used:** The evaluator either (a) looked up this fingerprint and found a value (from a previous run or from earlier in this run), or (b) computed a new value and stored it under this fingerprint. Those entries are marked “Current” and are written back.
- **Not used:** Entries that were loaded from the blob from a previous run but were never looked up this run (e.g. the flow path didn’t touch that step, or the inputs changed so we never generated that fingerprint). Those stay “Previous” and are **dropped** when we call `into_stored()` — they never get written back.

So “new change” in the sense of persistence is: we only keep cache entries that this run actually needed. That way the blob shrinks when the flow or data evolves and old fingerprints are no longer reached.

**Example (conceptual):** Last run, source row had chunks A and B; we had cache entries for embed(A) and embed(B). This run, the source row only has chunk A. We load the blob with both entries. We evaluate; we only look up embed(A). So we only “use” the entry for A. When we persist, we keep only the entry for A. The entry for B is dropped. Next run, if the row has B again, we’ll get a cache miss for B and recompute.

**Full reprocess:** If the run is in full-reprocess mode, the engine clears the entire memo cache for that source row before evaluation. So every step is treated as “changed” (miss), and we recompute everything. The blob is then repopulated only with what this run uses.

---

## 9. Who enables caching

Ops that want memoization must declare `enable_cache: true` (Rust) or the equivalent in Python (`cache=True` on the executor). The engine only does fingerprint lookup and storage for those ops. If caching is disabled, every call is a “miss” and the result is never stored in the memo blob.

---

## 10. Summary

- **Memoization** = per–source-row cache (and UUID store) in the tracking table.
- **Key** = fingerprint of (op logic + inputs). **Value** = computed result (and optionally TTL).
- **Used** to skip redundant LLM/embedding/heavy transforms within a run and across runs.
- **UUID store** in the same blob gives stable target keys for collected rows.
- **Lifecycle:** load from DB → use during eval → keep only “used” entries → write back at precommit. Full reprocess clears the cache for that row first.
