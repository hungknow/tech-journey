# Incremental Update: How CocoIndex Stores, Detects, and Updates Results

How the engine stores derived state, detects what is already processed, and updates only what changed.

---

## 1. Example: source key vs target key

Consider a flow that indexes files: the **source** is a file list (for example LocalFile), the **target** is a vector store (for example Qdrant). Each input file is one **source row**, identified by a **source key** (for example the file path). The flow can output many records per file (for example one per page); each output record has a **target key** that uniquely identifies it in the target (for example a UUID or the pair filename and page).

The engine records which target keys each source key produced. That way it can update or remove only what changed:

- **First run:** For file report.pdf we process all pages, write records with keys K1, K2, K3, and store that report.pdf produced K1, K2, K3.
- **No change:** The file appears again with the same data; we already have that version, so we skip.
- **Updated:** report.pdf now has only 2 pages, so we output K1, K2. We compare with the stored K1, K2, K3, delete K3 in the target, and update the stored list to K1, K2.
- **Removed:** The file is gone; we delete K1 and K2 in the target and remove the tracking row for that source key.

So a **source key** identifies one input row; a **target key** identifies one output row in a target. Storing “which target keys came from which source key” lets the engine upsert new or changed rows and delete ones that are no longer produced.

---

## 2. Storage

### Tracking table (PostgreSQL)

Each flow has a **tracking table** in Postgres: one row per source entity, keyed by source id and source key.

That row has two groups of fields. **Precommit** fields are updated when we stage work (before writing to targets): a monotonic counter for this source row, the list of target keys we have staged but not yet committed, and the memoization cache (see below). **Commit** fields are updated after we have applied changes to targets: the source ordinal we last committed, an optional content fingerprint for a fast “no content change” check, the fingerprint of the flow logic (to detect logic changes), the process ordinal and time we last committed, and the final list of target keys this source row produced (used to compute deletes on the next run).

So the “existing result” for a source row is: which source version we last committed and which target keys we wrote. Staging fields hold in-progress state between precommit and commit.

### Memoization

The tracking table also stores a **memoization** blob (JSON): a cache that maps input fingerprints to previously computed results (and related UUIDs). When we evaluate a source row, we load this cache so that repeated work (for example LLM calls or expensive functions) can reuse results. After evaluation we keep only entries that were used in this run and write the updated cache in the precommit phase. So we avoid recomputing identical inputs across runs.

### In-memory and where data lives

When a run starts, we load all tracked source keys from the tracking table into memory and attach the last processed version (ordinal and optional content fingerprint) to each. That lets us skip rows as soon as we see them in the stream if we have already processed that version. The component that applies updates to a single source row does not keep long-lived state; it reads and writes the tracking table and builds the list of upserts and deletes to send to each target.

Actual derived data (index rows, vectors, and so on) lives only in the **target backends** (Postgres, Qdrant, Neo4j, and so on). The engine does not store a copy; it only stores “for this source row we last processed this version and produced these target keys.” When a source row is updated or removed, we use that stored list to know which target rows to delete (any key we had before but did not produce this time).

---

## 3. Detection

### Already processed (ordinal and logic)

Each source row has an **ordinal** (for example a timestamp or sequence number) and optionally a **content fingerprint**. We compare the incoming row’s ordinal and logic fingerprint with what we have stored for that source key. If we already have a version that is newer or the same (and the logic has not changed), we skip: we never reprocess an older source version, and we may skip the same version if nothing changed.

This check happens in two places: when we stream source rows we skip scheduling work for rows we have already processed; and when we are about to process a row we read the tracking row, build the stored version, and if it is not older than the incoming row we skip evaluation and any target writes.

### No content change (content fingerprint)

If the source gives us (or we compute) a content fingerprint and we have a stored fingerprint for that row, we can sometimes skip not only evaluation but also target writes: when the content fingerprint matches and the logic matches, we only advance the stored ordinal in the tracking row. So we record that we have “seen” this version without re-running the flow or writing to targets.

### How detection actually works

**Skipping by ordinal and logic only.**  
The first check is: have we already processed this or a newer version of this row? We compare the stored ordinal with the incoming ordinal, and the stored flow-logic fingerprint with the current one. If the stored ordinal is strictly greater than the incoming one, we skip. If they are equal and the logic is the same or newer, we also skip. The content fingerprint is **not** used in this step. So if the source gives the same ordinal for two different contents (e.g. same file mtime but content changed), we might skip when we shouldn’t — unless the source also provides a content fingerprint and the later “no content change” shortcut applies.

**Where the content fingerprint comes from.**  
For each source row we need a value to compare against what we last committed. That value can come from the source: when listing or fetching a row, the source may return a content fingerprint (e.g. a hash or an ETag). If the source does **not** return one, the engine computes it by hashing the full row content (all field values, as stored). So the fingerprint is either “what the source said” or “a hash of the raw bytes we have.” Any change to a single byte in that content produces a different hash. That is why one whitespace or line-ending change in a file makes the fingerprint change when the engine is doing the hashing.

**The “no content change” shortcut.**  
When we are not doing a full re-export, we compare the current content fingerprint with the one we stored for that row. The stored one lives either in a dedicated column (if the flow uses the fast-fingerprint feature) or inside the memoization blob for that row. If they match and the logic matches, we do not re-run the flow or write to targets; we only update the stored ordinal so we remember we have seen this version. So the content fingerprint is what lets us skip work when the content is unchanged even if we see the row again.

**What we keep in memory at the start of a run.**  
We load from the tracking table the list of source keys we have seen and, for each, the last committed ordinal and logic fingerprint. If the flow uses the fast-fingerprint feature, we also load the last committed content fingerprint per row; otherwise we do not load a content fingerprint there. In the latter case we can still use the “no content change” shortcut later, by comparing against the content hash stored inside the memoization blob once we look up that row.

**Built-in file source.**  
The built-in local-file source never returns a content fingerprint. It only returns the file path, ordinal (e.g. modification time), and the file contents. So the engine always computes the fingerprint by hashing the file contents. One whitespace or line-ending change therefore changes the hash, the shortcut does not apply, and we do a full reprocess and re-export for that file.

### Trivial changes (e.g. one file per row, whitespace)

When each source row is coarse-grained (e.g. one file per row) and the content fingerprint is the **engine-computed** hash of the raw content (as with the built-in file source), a single trivial change — a space, a newline, or different line endings — changes the hash and thus the content fingerprint. The engine then treats the row as changed and does a full reprocess and re-export even when the derived result would be the same.

**Ways to improve this:**

1. **Normalized content fingerprint**  
   Compute the fingerprint over **normalized** content so trivial edits do not change it (e.g. strip trailing whitespace, normalize line endings, collapse repeated spaces).  
   - **From the source:** The source can return a fingerprint that is based on normalized content. The engine uses whatever fingerprint the source provides; it does not re-hash. So a source that hashes normalized content will get the “no content change” shortcut even when only whitespace or line endings changed.  
   - **In the engine (future):** When the source does not provide a fingerprint, the engine could optionally normalize the content before hashing (e.g. per flow or per field). Then built-in sources like the file source could benefit without every source implementing its own normalization.

2. **Pluggable fingerprint strategy**  
   Allow the flow or source to choose how the content fingerprint is derived (e.g. raw bytes vs normalized). File-based sources could then opt into a normalized strategy so trivial edits do not invalidate the cache.

3. **Chunk-level granularity (optional)**  
   If one source row is one file but the flow logically chunks it (e.g. by page), we could store fingerprints per chunk and only reprocess chunks whose fingerprint changed. That would require tracking at chunk level.

**Recommendation:** Document that for one-file-per-row (or similar coarse rows), sources should supply a **normalized** content fingerprint when trivial changes should not trigger reprocessing. Optionally add engine-side normalization when the engine auto-computes the fingerprint, so built-in file-like sources benefit without each source implementing its own hashing.

### Precommit and which keys to delete

Before applying changes to targets we **precommit**: we read the tracking row again and re-run the “already processed?” check. If another process has already committed a newer version we do not apply our mutation. We also compute the list of target keys we are about to write. We compare that with the existing list (staging and committed): keys we are keeping unchanged we carry over; keys we are changing or adding we upsert; any key we had before but are not producing now we add to the delete list. So we detect what to delete by the set difference (old keys minus keys we are keeping or upserting).

---

## 4. Update

### Steps for one source row

For each source row we do the following in spirit:

1. **Read** the existing tracking row for this source key.
2. **Decide whether to skip:** Compare stored version with the incoming row. If we already have this version or newer and logic matches, skip (no database or target writes).
3. **Optional shortcut:** If we are not doing a full reprocess and the content fingerprint matches the stored one, we can skip evaluation and only update the stored ordinal in the tracking row; then we are done.
4. **Evaluate:** Load the memoization cache for this row, run the flow (with that cache), and get the new output and updated cache.
5. **Precommit:** In a transaction we read the tracking row again and re-check skip. We compute the new target keys and the diff with existing keys to build the list of upserts and deletes per target. We write to the tracking row only the precommit fields (staging keys and memoization) and commit the transaction.
6. **Apply to targets:** For each target we send the upserts and deletes so they are applied to the real index or storage.
7. **Commit tracking:** In a new transaction we read the tracking row again. If someone else already committed with a process ordinal at least as high as ours we do not overwrite. Otherwise we finalize the tracking row: write the committed source ordinal, content fingerprint, logic fingerprint, process ordinal and time, and the final list of target keys. If the source row is gone and there are no staged keys we delete the tracking row instead.

So updating an existing result means: update the tracking row (precommit then commit) and apply the mutation (upserts and deletes) to target backends. The tracking row always reflects the latest committed source version and the set of target keys we produced.

### Modes

**Normal** uses ordinal and content-fingerprint skipping and carries over unchanged target keys. **Full reprocess** ignores those optimizations and reprocesses everything; the memoization cache for a row can be cleared before evaluation. **Reexport targets** re-sends data to targets even when we would otherwise skip. The Python Flow update and the CLI cocoindex update command can request full reprocess or reexport, which turns off or relaxes the detection and update behavior above.

### When a source row is removed

When we list the source we note which source keys were seen in this scan. Keys that were in memory from a previous run but were not seen this time are treated as deleted. For each such key we run the same pipeline with “non-existence”: we produce a mutation that deletes all target keys we had for that source row, then we commit (or delete the tracking row if there is nothing left to stage). So when the source row is gone we do one update that only performs deletes and then finalizes or removes the tracking row.

---

## 5. Summary

**Store.** The tracking table holds per source row the last processed ordinal and fingerprint, logic fingerprint, target keys, and memoization. Actual derived data lives in target backends; the engine only tracks which keys we wrote.

**Detect.** We skip when the stored ordinal is at least as large as the incoming one and the logic is the same or newer. When the content fingerprint is unchanged we can also skip evaluation and target writes and only advance the stored ordinal.

**Update.** We read tracking, then maybe skip or use the content shortcut, then evaluate (with memoization), then precommit (stage keys and memo), then apply upserts and deletes to targets, then commit the tracking row. New or changed keys are upserted; keys no longer produced are deleted.

The design ensures we never apply an older source version than what we committed, we only re-evaluate and re-export when the source version or content actually changed (or when a mode forces it), and we always fix the set of target keys by deleting ones the source row no longer produces.
