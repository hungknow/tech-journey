# Reaction Store — SQL Commands

This document describes the SQL executed by each function in `server/channels/store/sqlstore/reaction_store.go`. The store manages emoji reactions on posts and keeps the `Posts.HasReactions` flag in sync.

---

## Save

Persists a reaction and updates the post’s `HasReactions` flag. Runs in a transaction. If `reaction.ChannelId` is empty, the post’s channel is resolved first. On duplicate (same user, post, emoji), the row is updated instead of inserted.

**When `ChannelId` is not set:** resolve the post’s channel from `Posts`:

```sql
SELECT ChannelId FROM Posts WHERE Id = ?
```

**Insert or update the reaction** (via `saveReactionAndUpdatePost`):

```sql
INSERT INTO Reactions
  (UserId, PostId, EmojiName, CreateAt, UpdateAt, DeleteAt, RemoteId, ChannelId)
VALUES
  (:UserId, :PostId, :EmojiName, :CreateAt, :UpdateAt, :DeleteAt, :RemoteId, :ChannelId)
ON CONFLICT (UserId, PostId, EmojiName)
  DO UPDATE SET UpdateAt = :UpdateAt, DeleteAt = :DeleteAt, RemoteId = :RemoteId, ChannelId = :ChannelId
```

**Then set the post as having reactions** (via `updatePostForReactionsOnInsert`):

```sql
UPDATE Posts
SET HasReactions = True,
    UpdateAt = ?
WHERE Id = ?
```

---

## Delete

Soft-deletes a reaction (sets `UpdateAt`, `DeleteAt`, `RemoteId`) and then recalculates the post’s `HasReactions` flag. Runs in a transaction.

**Soft-delete the reaction** (via `deleteReactionAndUpdatePost`):

```sql
UPDATE Reactions
SET UpdateAt = ?,
    DeleteAt = ?,
    RemoteId = ?
WHERE PostId = ?
  AND UserId = ?
  AND EmojiName = ?
```

**Then refresh the post’s reaction flag** (via `updatePostForReactionsOnDelete`, using `UpdatePostHasReactionsOnDeleteQuery`):

```sql
UPDATE Posts
SET UpdateAt = ?,
    HasReactions = (SELECT count(0) > 0 FROM Reactions WHERE PostId = ? AND COALESCE(DeleteAt, 0) = 0)
WHERE Id = ?
```

---

## GetForPost

Returns all non-deleted reactions for a given post, ordered by `CreateAt`. Uses replica.

```sql
SELECT UserId, PostId, EmojiName, CreateAt,
       COALESCE(UpdateAt, CreateAt) AS UpdateAt,
       COALESCE(DeleteAt, 0) AS DeleteAt,
       RemoteId, ChannelId
FROM Reactions
WHERE PostId = ?
  AND COALESCE(DeleteAt, 0) = 0
ORDER BY CreateAt
```

---

## ExistsOnPost

Checks whether any non-deleted reaction with the given emoji exists on the post. Returns a boolean. Uses replica.

```sql
SELECT 1
FROM Reactions
WHERE PostId = ?
  AND EmojiName = ?
  AND COALESCE(DeleteAt, 0) = 0
```

---

## GetForPostSince

Returns reactions for a post that were updated after `since`. Can optionally exclude a `RemoteId` and include soft-deleted reactions. Uses replica.

```sql
SELECT UserId, PostId, EmojiName, CreateAt,
       COALESCE(UpdateAt, CreateAt) AS UpdateAt,
       COALESCE(DeleteAt, 0) AS DeleteAt,
       RemoteId
FROM Reactions
WHERE PostId = ?
  AND UpdateAt > ?
  -- optional: AND COALESCE(RemoteId, '') <> ?
  -- optional: AND COALESCE(DeleteAt, 0) = 0
ORDER BY CreateAt
```

---

## GetUniqueCountForPost

Returns the number of distinct emoji names that have at least one non-deleted reaction on the post. Uses replica.

```sql
SELECT COUNT(DISTINCT EmojiName)
FROM Reactions
WHERE PostId = ?
  AND DeleteAt = 0
```

---

## BulkGetForPosts

Returns all non-deleted reactions for a list of post IDs in one query. Uses replica. The `IN` list is built from `constructArrayArgs(postIds)` (placeholder and bound values).

```sql
SELECT UserId, PostId, EmojiName, CreateAt,
       COALESCE(UpdateAt, CreateAt) AS UpdateAt,
       COALESCE(DeleteAt, 0) AS DeleteAt,
       RemoteId, ChannelId
FROM Reactions
WHERE PostId IN (?, ?, ...)
  AND COALESCE(DeleteAt, 0) = 0
ORDER BY CreateAt
```

---

## GetSingle

Fetches a single reaction by user, post, remote id, and emoji name. Uses replica. No filter on `DeleteAt`; can return soft-deleted rows.

```sql
SELECT UserId, PostId, EmojiName, CreateAt,
       COALESCE(UpdateAt, CreateAt) AS UpdateAt,
       COALESCE(DeleteAt, 0) AS DeleteAt,
       RemoteId, ChannelId
FROM Reactions
WHERE UserId = ?
  AND PostId = ?
  AND COALESCE(RemoteId, '') = ?
  AND EmojiName = ?
```

---

## DeleteAllWithEmojiName

Soft-deletes all reactions with the given emoji name and then updates `HasReactions` for each affected post. First loads matching reactions from replica, then runs updates on master.

**Load affected reactions (replica):**

```sql
SELECT UserId, PostId, EmojiName, CreateAt,
       COALESCE(UpdateAt, CreateAt) AS UpdateAt,
       COALESCE(DeleteAt, 0) AS DeleteAt,
       RemoteId
FROM Reactions
WHERE EmojiName = ?
  AND COALESCE(DeleteAt, 0) = 0
```

**Soft-delete by emoji (master):**

```sql
UPDATE Reactions
SET UpdateAt = ?,
    DeleteAt = ?
WHERE EmojiName = ?
  AND COALESCE(DeleteAt, 0) = 0
```

**For each affected post, refresh `HasReactions` (master):**

```sql
UPDATE Posts
SET UpdateAt = ?,
    HasReactions = (SELECT count(0) > 0 FROM Reactions WHERE PostId = ? AND COALESCE(DeleteAt, 0) = 0)
WHERE Id = ?
```

---

## permanentDeleteReactions

Internal helper used by `PermanentDeleteByUser`. In a transaction, collects all post IDs for the user’s reactions, then permanently deletes those reactions. Returns the list of affected post IDs.

**Collect post IDs:**

```sql
SELECT PostId FROM Reactions WHERE UserId = ?
```

**Permanently delete reactions (squirrel delete builder):**

```sql
DELETE FROM Reactions
WHERE PostId IN (?, ?, ...)
  AND UserId = ?
```

---

## PermanentDeleteByUser

Permanently removes all reactions for a user and then updates `HasReactions` for each affected post. Uses `permanentDeleteReactions` for the delete, then in a separate transaction runs the post update for each post ID.

**Post update applied per affected post (same as in Delete / updatePostForReactionsOnDelete):**

```sql
UPDATE Posts
SET UpdateAt = ?,
    HasReactions = (SELECT count(0) > 0 FROM Reactions WHERE PostId = ? AND COALESCE(DeleteAt, 0) = 0)
WHERE Id = ?
```

---

## DeleteOrphanedRowsByIds

Used for retention/cleanup. Permanently deletes reactions whose `PostId` is in the given set of IDs, then removes the retention ID record. Runs in a transaction.

**Delete reactions by post IDs:**

```sql
DELETE FROM Reactions
WHERE PostId IN (?, ?, ...)
```

**Then** the same transaction calls `deleteFromRetentionIdsTx`, which runs:

```sql
DELETE FROM RetentionIdsForDeletion WHERE Id = ?
```

---

## PermanentDeleteBatch

Permanently deletes a batch of reactions with `CreateAt` before `endTime`, limited by `limit`. Used for retention or batch cleanup. Executed on master.

```sql
DELETE FROM Reactions
WHERE CreateAt = ANY (ARRAY (SELECT CreateAt FROM Reactions WHERE CreateAt < ? LIMIT ?))
```

---

## saveReactionAndUpdatePost

Internal helper used by `Save`. Inserts the reaction (or updates on conflict) and then marks the post as having reactions. Expects `reaction.DeleteAt = 0`.

**Insert/upsert:** same as in **Save** (INSERT … ON CONFLICT … DO UPDATE).

**Post update:** same as in **Save** (UPDATE Posts SET HasReactions = True, UpdateAt = ? WHERE Id = ?).

---

## deleteReactionAndUpdatePost

Package-level helper used by `Delete`. Soft-updates the reaction row then calls `updatePostForReactionsOnDelete`. SQL is the same as in **Delete**.

---

## updatePostForReactionsOnDelete

Helper that runs `UpdatePostHasReactionsOnDeleteQuery` to recalculate and set `Posts.HasReactions` for one post after a reaction is removed. Used by `Delete`, `DeleteAllWithEmojiName`, and `PermanentDeleteByUser`.

```sql
UPDATE Posts
SET UpdateAt = ?,
    HasReactions = (SELECT count(0) > 0 FROM Reactions WHERE PostId = ? AND COALESCE(DeleteAt, 0) = 0)
WHERE Id = ?
```

---

## updatePostForReactionsOnInsert

Helper that sets the post’s `HasReactions` to true and updates `UpdateAt` when a new reaction is added. Used by `Save` and `saveReactionAndUpdatePost`.

```sql
UPDATE Posts
SET HasReactions = True,
    UpdateAt = ?
WHERE Id = ?
```
