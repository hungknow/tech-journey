# Post Store — SQL Commands by Function

This document lists the SQL executed by each function in `server/channels/store/sqlstore/post_store.go`. Queries are built with Squirrel (sq) or raw SQL; the effective SQL and purpose are described below.

Function names are section headings (e.g. **SaveMultiple**) so you can jump to them. "Used by" / "Uses" tie callers and helpers together.

---

## Save and create

### SaveMultiple

Used by: **Save** (single-post path).

- Inserts new posts in a single batch within a transaction (built via Squirrel `Insert("Posts")`):

```sql
INSERT INTO Posts (...) VALUES (...), (...), ...
```

- Updates channel last-post timestamps and message counts after saving posts:

```sql
UPDATE Channels
SET LastPostAt = GREATEST(:lastpostat, LastPostAt),
    LastRootPostAt = GREATEST(:lastrootpostat, LastRootPostAt),
    TotalMsgCount = TotalMsgCount + :count,
    TotalMsgCountRoot = TotalMsgCountRoot + :countroot
WHERE Id = :channelid
```

- Updates the root post’s `UpdateAt` when the batch includes replies to that root:

```sql
UPDATE Posts SET UpdateAt = ? WHERE Id = ?
```

### populateReplyCount

Uses: called after **SaveMultiple**.

- Counts replies per root to fill `ReplyCount` on the given posts:

```sql
SELECT RootId, COUNT(Id) AS Count
FROM Posts
WHERE RootId IN (...)
  AND Posts.DeleteAt = 0
GROUP BY RootId
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Speeds up filtering by `RootId IN (...)` and `DeleteAt = 0`, and supports the GROUP BY on `RootId`.

---

## Update and overwrite

### Update

- Full row update of the post (named parameters from `newPost`):

```sql
UPDATE Posts
SET CreateAt = :CreateAt, UpdateAt = :UpdateAt, EditAt = :EditAt, DeleteAt = :DeleteAt,
    IsPinned = :IsPinned, UserId = :UserId, ChannelId = :ChannelId, RootId = :RootId,
    OriginalId = :OriginalId, Message = :Message, Type = :Type, Props = :Props,
    Hashtags = :Hashtags, Filenames = :Filenames, FileIds = :FileIds,
    HasReactions = :HasReactions, RemoteId = :RemoteId
WHERE Id = :Id
```

- Refreshes channel last-post time when the updated post is newer:

```sql
UPDATE Channels SET LastPostAt = ? WHERE Id = ? AND LastPostAt < ?
```

- When the post is a reply, updates the root post’s `UpdateAt`:

```sql
UPDATE Posts SET UpdateAt = ? WHERE Id = ? AND UpdateAt < ?
```

- Inserts the previous version of the post as an edit-history row (soft copy with new id, OriginalId, DeleteAt set):

```sql
INSERT INTO Posts (...)
```

### OverwriteMultiple

Used by: **Overwrite** (single-post path).

- In-place overwrite of each post in the batch (named exec per post):

```sql
UPDATE Posts
SET CreateAt = :CreateAt, UpdateAt = :UpdateAt, ...
WHERE Id = :Id
```

- When a post in the batch is a reply, updates the thread’s last-reply time:

```sql
UPDATE Threads SET LastReplyAt = ? WHERE PostId = ?
```

---

## Delete (soft and permanent)

### Delete (soft delete)

- Loads root and user for the post to delete:

```sql
SELECT RootId, UserId FROM Posts WHERE Id = ?
```

- Soft-deletes the post and all its replies; sets delete-by in props:

```sql
UPDATE Posts
SET DeleteAt = $1, UpdateAt = $1, Props = jsonb_set(Props, $2, $3)
WHERE Id = $4 OR RootId = $4
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Speeds up the `OR RootId = $4` branch; the planner can use this index for the RootId predicate (Id uses primary key).

- If the post is a root: update Threads (via `deleteThread`) and update FileInfo (via `deleteThreadFiles`). If it is a reply: update Threads (via `updateThreadAfterReplyDeletion`) and update root post `UpdateAt`.

### permanentDelete

Used by: **PermanentDelete** (and other batch delete paths).

- Removes thread rows for the given root post ids:

```sql
DELETE FROM Threads WHERE PostId IN (...)
```

- Removes thread memberships for those posts:

```sql
DELETE FROM ThreadMemberships WHERE PostId IN (...)
```

- Removes reactions on those posts:

```sql
DELETE FROM Reactions WHERE PostId IN (...)
```

**No index.**  
**Suggestion:** Add `CREATE INDEX IF NOT EXISTS idx_reactions_post_id ON reactions(postid);` to speed up deletes by `PostId`. The schema only has `idx_reactions_channel_id`.

- Removes temporary (e.g. burn-on-read) posts:

```sql
DELETE FROM TemporaryPosts WHERE PostId IN (...)
```

- Removes read receipts for those posts:

```sql
DELETE FROM ReadReceipts WHERE PostId IN (...)
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_read_receipts_post_id ON ReadReceipts(PostId);`  
**Purpose:** Speeds up `WHERE PostId IN (...)` for bulk deletes.

- Permanently deletes the posts and all their replies:

```sql
DELETE FROM Posts WHERE Id IN (...) OR RootId IN (...)
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Speeds up the `RootId IN (...)` branch; `Id IN (...)` uses the primary key.

### permanentDeleteAllCommentByUser

- Fetches all comment ids and roots for the user:

```sql
SELECT Id, RootId FROM Posts WHERE UserId = ? AND RootId != ''
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(userid);`  
**Purpose:** Speeds up `WHERE UserId = ?`; filter on `RootId != ''` is applied on the result set.

- Permanently deletes all comments by that user; then uses `updateThreadAfterReplyDeletion` per root and `permanentDeleteReactions`, `permanentDeleteTemporaryPosts`, `permanentDeleteReadReceipts` for those comment ids:

```sql
DELETE FROM Posts WHERE UserId = ? AND RootId != ''
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(userid);`  
**Purpose:** Speeds up locating rows by `UserId` for the delete.

### PermanentDeleteByUser

Uses: **permanentDeleteAllCommentByUser**, then **permanentDelete** in a loop.

- In a loop:

```sql
SELECT Id FROM Posts WHERE UserId = ? LIMIT 1000
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(userid);`  
**Purpose:** Speeds up `WHERE UserId = ?` for batched id fetch.

and `permanentDelete(ids)` until no more posts.

### PermanentDeleteByChannel

- In a loop:

```sql
SELECT Id FROM Posts WHERE ChannelId = ? AND Id > ? ORDER BY Id ASC LIMIT 500
```

**No index.**  
**Suggestion:** Add `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_id ON posts(channelid, id);` for cursor-based pagination by `(ChannelId, Id)`. Existing `idx_posts_channel_id_delete_at_create_at` is on `(channelid, deleteat, createat)` and does not match `ORDER BY Id`.

For each batch, runs `permanentDeleteThreads`, `permanentDeleteReactions`, `permanentDeleteTemporaryPosts`, `permanentDeleteReadReceipts`, then:

```sql
DELETE FROM Posts WHERE Id IN (ids)
```

Repeats until no posts remain.

### PermanentDeleteBatch

- Deletes up to `limit` posts with `CreateAt` before `endTime`:

```sql
DELETE FROM Posts
WHERE Id = any (array (SELECT Id FROM Posts WHERE CreateAt < ? LIMIT ?))
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);` or `CREATE INDEX IF NOT EXISTS idx_posts_create_at_id on posts(createat, id);`  
**Purpose:** The subquery filters by `CreateAt < ?` and LIMIT; `idx_posts_create_at_id` supports both the predicate and returning `Id` in order.

### PermanentDeleteBatchForRetentionPolicies

Uses: **genericPermanentDeleteBatchForRetentionPolicies**. Squirrel builder with optional filter for non-pinned or already-deleted pinned posts.

- Shape:

```sql
SELECT Posts.Id
FROM Posts
-- optional: non-pinned or already-deleted pinned filter
```

**Existing index:** Depends on filters (e.g. `idx_posts_delete_at`, `idx_posts_is_pinned`, or composite channel/time indexes).  
**Purpose:** Use the index that matches the optional filter columns (DeleteAt, IsPinned, ChannelId, CreateAt, etc.).

---

## Get single post and etag

### Get (non–collapsed-threads path)

- Fetches the post and its reply count:

```sql
SELECT p.*,
  (SELECT count(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN p.RootId = '' THEN p.Id ELSE p.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM Posts p
WHERE p.Id = ? AND p.DeleteAt = 0
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` (subquery: reply count by RootId and DeleteAt = 0).  

- Optional thread fetch (with ordering and limit for thread replies):

```sql
WITH replycount AS (SELECT count(*) AS num FROM posts WHERE RootId = ? AND DeleteAt = 0)
SELECT p.*, replycount.num AS ReplyCount
FROM Posts p, replycount
WHERE (p.Id = ? OR p.RootId = ?) AND p.DeleteAt = 0
ORDER BY ... LIMIT ...
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` for the subquery `WHERE RootId = ? AND DeleteAt = 0`. Main query uses primary key on `Id`.  
**Purpose:** Speeds up reply count and thread-reply fetch by RootId and DeleteAt.

### Get (collapsed-threads path)

Uses: **getPostWithCollapsedThreads**.

- Single post with thread metadata:

```sql
SELECT Posts.*, COALESCE(Threads.ReplyCount, 0), COALESCE(Threads.LastReplyAt, 0),
       COALESCE(Threads.Participants, '[]'), ThreadMemberships.Following
FROM Posts
LEFT JOIN Threads ON Threads.PostId = Id
LEFT JOIN ThreadMemberships ON ThreadMemberships.PostId = Id AND ThreadMemberships.UserId = ?
WHERE Posts.DeleteAt = 0 AND Posts.Id = ?
```

- Fetches thread replies (optional ordering and pagination):

```sql
SELECT * FROM Posts WHERE Posts.RootId = ? AND Posts.DeleteAt = 0
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Speeds up `WHERE RootId = ? AND DeleteAt = 0` for thread replies.

### GetSingle

- Returns one post by id, optionally including deleted:

```sql
SELECT Posts.*,
  (SELECT COUNT(*) FROM Posts p
   WHERE p.RootId = (CASE WHEN Posts.RootId = '' THEN Posts.Id ELSE Posts.RootId END)
     AND p.DeleteAt = 0) AS ReplyCount
FROM Posts
WHERE Posts.Id = ?
  -- AND Posts.DeleteAt = 0  (when not inclDeleted)
```

**Existing index:** Lookup by `Posts.Id` (primary key). Reply-count subquery: `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Same as Get (non–collapsed): primary key for main row, root_id+delete_at for reply count.

### GetEtag

**What is etag?** An *entity tag* used for cache validation. The server builds a short value that represents “how up to date” the channel’s post list is (from the latest post’s `Id` and `UpdateAt`). The client can send this etag on the next request (e.g. in `If-None-Match`); if nothing changed, the server can respond 304 Not Modified so the client keeps using its cached list.

- Builds that etag from the channel’s most recently updated post:

```sql
SELECT Id, UpdateAt FROM Posts WHERE ChannelId = ?
-- AND RootId = ''  (when collapsedThreads)
ORDER BY UpdateAt DESC LIMIT 1
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);`  
**Purpose:** Speeds up `WHERE ChannelId = ?` and `ORDER BY UpdateAt DESC LIMIT 1` for etag.

---

## Flagged posts

**What is a flagged post?** A post that a user has saved (bookmarked) for later. The app stores this in the `Preferences` table: `Category = 'flagged_post'` and the post id in `Name`. The store returns only posts in channels the user is a member of.

### getFlaggedPosts

Used by: **GetFlaggedPosts**, **GetFlaggedPostsForTeam**, **GetFlaggedPostsForChannel**.

- Returns flagged posts for the user, optionally scoped by channel or team (with optional channel/team filter clauses):

```sql
SELECT A.*,
  (SELECT count(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN A.RootId = '' THEN A.Id ELSE A.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM (
  SELECT Posts.*
  FROM Posts
  WHERE Id IN (SELECT Name FROM Preferences WHERE UserId = ? AND Category = ?)
    -- CHANNEL_FILTER
    AND Posts.DeleteAt = 0
) AS A
INNER JOIN Channels AS B ON B.Id = A.ChannelId
WHERE ChannelId IN (SELECT ChannelId FROM ChannelMembers WHERE UserId = ?)
  -- TEAM_FILTER
ORDER BY CreateAt DESC
LIMIT ? OFFSET ?
```

**Existing index:** `Posts.Id IN (...)` uses primary key. `idx_preferences_category` / preferences by (UserId, Category) via PK. `idx_channelmembers_user_id_channel_id_last_viewed_at` or channel membership by UserId. Reply-count subquery: `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`. Ordering: `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);` helps only indirectly (posts already restricted by Id IN).  
**Purpose:** Main filter is `Id IN (SELECT Name FROM Preferences ...)`; primary key covers Id. RootId reply count uses `idx_posts_root_id_delete_at`. Consider composite on (CreateAt, Id) if sorting large flagged sets is slow.

---

## Get posts by channel / time / thread

**What is root vs parent post?** A **root post** is a top-level post in a channel (it has `RootId = ''` and starts a thread). A **parent post** is the post that a reply belongs to—i.e. the post whose `Id` equals that reply’s `RootId`. In the schema, every reply points to the thread’s root, so the parent of a reply is always that thread’s root post. The same post can be called “root” when we mean “top-level in the channel” and “parent” when we mean “the post that owns these replies.” **getRootPosts** returns the channel’s main timeline (root posts). **getParentsPosts** returns only the roots that are parents of replies visible on the current page, so the UI can show thread context for those replies.

### GetPosts (non–collapsed path)

Uses: **getRootPosts**, **getParentsPosts** (in parallel).

### getRootPosts

- With reply count (optional `AND Posts.DeleteAt = 0`):

```sql
SELECT p.*,
  (SELECT COUNT(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN p.RootId = '' THEN p.Id ELSE p.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM Posts p
WHERE p.ChannelId = ? AND p.DeleteAt = 0
ORDER BY p.CreateAt DESC
LIMIT ? OFFSET ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);`  
**Purpose:** Speeds up `WHERE ChannelId = ? AND DeleteAt = 0` and `ORDER BY CreateAt DESC` for root posts.

- Without reply count:

```sql
SELECT Posts.* FROM Posts WHERE Posts.ChannelId = ? AND Posts.DeleteAt = 0 ORDER BY Posts.CreateAt DESC LIMIT ? OFFSET ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);`  
**Purpose:** Same as getRootPosts: channel + delete filter and CreateAt ordering.

### getParentsPosts

- Fetches parent posts (and optionally reply counts) for the same channel page:

```sql
SELECT q2.*,
  (SELECT COUNT(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN q2.RootId = '' THEN q2.Id ELSE q2.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM Posts q2
INNER JOIN (
  SELECT DISTINCT q3.RootId
  FROM (
    SELECT Posts.RootId
    FROM Posts
    WHERE Posts.ChannelId = ? AND DeleteAt = 0
    ORDER BY Posts.CreateAt DESC
    LIMIT ? OFFSET ?
  ) q3
  WHERE q3.RootId != ''
) q1 ON q1.RootId = q2.Id
WHERE q2.ChannelId = ? AND q2.DeleteAt = 0
ORDER BY q2.CreateAt
```

**Existing index:** Inner subquery: `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` for `WHERE ChannelId = ? AND DeleteAt = 0 ORDER BY CreateAt DESC`. Join and outer filter on `q2.Id` / `q2.ChannelId` + `DeleteAt`: same index or primary key. Reply-count subquery: `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Channel timeline and root id list use channel+delete_at+create_at; parent lookup and reply count use root_id+delete_at.

### GetPosts (collapsed-threads path)

Uses: **getPostsCollapsedThreads**.

```sql
SELECT Posts.*, COALESCE(Threads.ReplyCount, 0), COALESCE(Threads.LastReplyAt, 0),
       COALESCE(Threads.Participants, '[]'), ThreadMemberships.Following
FROM Posts
LEFT JOIN Threads ON Threads.PostId = Posts.Id
LEFT JOIN ThreadMemberships ON ThreadMemberships.PostId = Posts.Id AND ThreadMemberships.UserId = ?
WHERE Posts.DeleteAt = 0 AND Posts.ChannelId = ? AND Posts.RootId = ''
ORDER BY Posts.CreateAt DESC
LIMIT ? OFFSET ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` (for `ChannelId`, `RootId = ''`, `DeleteAt = 0`, `ORDER BY CreateAt DESC`). Threads join on PostId (PK); ThreadMemberships on (PostId, UserId) (PK).  
**Purpose:** Channel root posts with thread metadata; channel+delete_at+create_at index covers the main Posts filter and sort.

### GetPostsSince (non–collapsed path)

- Fetches recently updated posts and their root posts:

```sql
WITH cte AS (
  SELECT * FROM Posts WHERE UpdateAt > ? AND ChannelId = ? LIMIT 1000
)
(SELECT * FROM cte)
UNION
(SELECT * FROM Posts p1 WHERE id IN (SELECT rootid FROM cte))
ORDER BY CreateAt DESC
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);`  
**Purpose:** Speeds up `WHERE ChannelId = ? AND UpdateAt > ?`; ordering may use this index or idx_posts_create_at depending on planner.

### getPostsSinceCollapsedThreads

```sql
SELECT Posts.*, Threads.*, ThreadMemberships.Following
FROM Posts
LEFT JOIN Threads ON Threads.PostId = Posts.Id
LEFT JOIN ThreadMemberships ON ...
WHERE Posts.ChannelId = ? AND Posts.UpdateAt > ? AND Posts.RootId = ''
ORDER BY Posts.CreateAt DESC
LIMIT 1000
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);`  
**Purpose:** Speeds up `WHERE ChannelId = ? AND UpdateAt > ? AND RootId = ''` and ordering by CreateAt for collapsed-threads “since” feed.

### HasAutoResponsePostByUserSince

- Checks for at least one auto-responder post in the channel since the given time:

```sql
SELECT EXISTS (
  SELECT 1 FROM Posts
  WHERE UpdateAt >= ? AND ChannelId = ? AND UserId = ? AND Type = ?
  LIMIT 1
)
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);` and `CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(userid);` can be used; no single composite on (ChannelId, UpdateAt, UserId, Type).  
**Purpose:** Planner may use channel_id_update_at then filter UserId/Type. **Suggestion:** For a hot path, add `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at_user_id_type ON posts(channelid, updateat, userid, type);` to cover the full predicate.

### GetPostsSinceForSync

- Used for sync/export; Squirrel SELECT from Posts with ORDER BY UpdateAt/Id, LIMIT, and optional filters (cursor, ChannelId, DeleteAt, ExcludeRemoteId, Type).

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);`, `CREATE INDEX IF NOT EXISTS idx_posts_create_at_id on posts(createat, id);`, and filter-related indexes (`idx_posts_delete_at`, `idx_posts_user_id`) depending on filters.  
**Purpose:** Cursor-based export/sync by UpdateAt or (CreateAt, Id); channel and other filters use the listed indexes.

### GetPostsBefore / GetPostsAfter

Uses: **getPostsAround** (runs a SELECT from Posts p with optional Threads/ThreadMemberships and ReplyCount subquery), e.g.:

```sql
SELECT p.*, ...
FROM Posts p
WHERE CreateAt < (SELECT CreateAt FROM Posts WHERE Id = ?)  -- or > for After
  AND p.ChannelId = ? AND p.DeleteAt = 0
ORDER BY p.CreateAt DESC
LIMIT ? OFFSET ?
```

**Existing index:** Subquery `(SELECT CreateAt FROM Posts WHERE Id = ?)` uses primary key. Main query: `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` for `WHERE ChannelId = ? AND DeleteAt = 0` and `CreateAt < ... ORDER BY CreateAt DESC`.  
**Purpose:** Lookup by Id for cursor; then channel + delete_at + create_at for before/after page.

May then run a second query to fetch root/parent posts for reply counts.

### GetPostsForReporting

- Paginated posts for reporting:

```sql
SELECT * FROM Posts
WHERE ChannelId = ?
  AND (CreateAt, Id) > (?, ?)  -- or < for DESC
  AND DeleteAt = 0
  AND Type NOT LIKE 'system_%'
ORDER BY CreateAt ASC, Id ASC
LIMIT perPage + 1
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` — column order is (channelid, deleteat, createat); the query uses `(CreateAt, Id) > (?, ?)` and `ORDER BY CreateAt ASC, Id ASC`. The index supports channel + DeleteAt + CreateAt; for strict (CreateAt, Id) cursor, `idx_posts_create_at_id` on (createat, id) helps ordering but not ChannelId filter.  
**Purpose:** Composite (channelid, deleteat, createat, id) would be ideal. Existing: use `idx_posts_channel_id_delete_at_create_at` for filter; planner may add id from table. **Suggestion:** Consider `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at_id ON posts(channelid, deleteat, createat, id);` for reporting pagination.

### GetPostsByThread

- All replies in a thread since a given time:

```sql
SELECT * FROM Posts WHERE RootId = ? AND DeleteAt = 0 AND CreateAt >= ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Speeds up `WHERE RootId = ? AND DeleteAt = 0`; filter `CreateAt >= ?` applied on index result. For optimal range on CreateAt, **suggestion:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at_create_at ON posts(rootid, deleteat, createat);` if this query is frequent.

### GetPostIdBeforeTime / GetPostIdAfterTime

Uses: **getPostIdAroundTime**.

- Single post id before/after a timestamp:

```sql
SELECT Id FROM Posts
WHERE CreateAt < ?  -- or > for After
  AND Posts.ChannelId = ?
  AND Posts.DeleteAt = 0
  -- AND Posts.RootId = ''  (when collapsedThreads)
ORDER BY Posts.CreateAt DESC  -- or ASC for After
LIMIT 1
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` for `WHERE ChannelId = ? AND DeleteAt = 0` and `ORDER BY CreateAt DESC` (or ASC for After).  
**Purpose:** Cursor-based before/after by CreateAt; channel + delete_at + create_at supports the predicate and sort.

### GetPostAfterTime

```sql
SELECT * FROM Posts
WHERE CreateAt > ? AND ChannelId = ? AND DeleteAt = 0
ORDER BY Posts.CreateAt ASC
LIMIT 1
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);`  
**Purpose:** Speeds up `WHERE ChannelId = ? AND DeleteAt = 0` and `CreateAt > ? ORDER BY CreateAt ASC LIMIT 1`.

---

## Get by ids and history

### GetPostsByIds

```sql
SELECT p.*,
  (SELECT count(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN p.RootId = '' THEN p.Id ELSE p.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM Posts p
WHERE p.Id IN (?)
ORDER BY CreateAt DESC
```

**Existing index:** Lookup by `p.Id IN (...)` uses primary key. Reply-count subquery: `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);`  
**Purpose:** Id list uses PK; reply count uses root_id + delete_at.

### GetEditHistoryForPost

- Edit history (previous versions) for a post:

```sql
SELECT * FROM Posts WHERE Posts.OriginalId = ? ORDER BY Posts.EditAt DESC
```

**No index.**  
**Suggestion:** Add `CREATE INDEX IF NOT EXISTS idx_posts_original_id_edit_at ON posts(originalid, editat DESC);` to speed up edit-history lookup and ordering. The schema has no index on `OriginalId`.

### GetPostsCreatedAt

```sql
SELECT * FROM Posts WHERE CreateAt = ? AND ChannelId = ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);` or `idx_posts_create_at` — the composite matches (ChannelId, CreateAt) if DeleteAt is not in the query; otherwise `idx_posts_create_at` + filter.  
**Purpose:** Supports equality on CreateAt and ChannelId (composite covers both when deleteat is constant or not filtered).

---

## Search

### search

Used by: **Search**, **SearchPostsForUser**.

- Base query with optional full-text and date filters; channel subquery restricts to accessible channels:

```sql
SELECT q2.*,
  (SELECT COUNT(*) FROM Posts
   WHERE Posts.RootId = (CASE WHEN q2.RootId = '' THEN q2.Id ELSE q2.RootId END)
     AND Posts.DeleteAt = 0) AS ReplyCount
FROM Posts q2
WHERE q2.DeleteAt = 0
  AND q2.Type NOT LIKE 'system_%'
  -- optional: to_tsvector('...', Message) @@ to_tsquery('...', ?)
  -- optional: CreateAt date filters
  AND ChannelId IN (
    SELECT Id FROM Channels, ChannelMembers
    WHERE Id = ChannelId
      -- AND Channels.DeleteAt = 0
      -- AND ChannelMembers.UserId = ?
      -- team/channel filters
  )
  -- optional: UserId IN (subquery from buildSearchPostFilterClause)
ORDER BY q2.CreateAt DESC
LIMIT 100
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_message_txt ON posts USING gin(to_tsvector('english', message));` for full-text on Message. `idx_posts_create_at` for CreateAt date filters. `idx_posts_delete_at`, channel membership and Channels.Id (PK). Optional UserId: `idx_posts_user_id`. Reply-count subquery: `idx_posts_root_id_delete_at`.  
**Purpose:** Full-text uses message GIN index; date and channel/user filters use the listed indexes; ordering by CreateAt uses idx_posts_create_at.

---

## Analytics

### AnalyticsUserCountsWithPostsByDay

```sql
SELECT TO_CHAR(DATE(TO_TIMESTAMP(Posts.CreateAt / 1000)), 'YYYY-MM-DD') AS Name,
       COUNT(DISTINCT Posts.UserId) AS Value
FROM Posts
-- INNER JOIN Channels ON Posts.ChannelId = Channels.Id AND Channels.TeamId = ?
WHERE Posts.CreateAt >= ? AND Posts.CreateAt <= ?
GROUP BY DATE(TO_TIMESTAMP(Posts.CreateAt / 1000))
ORDER BY Name DESC
LIMIT 30
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);`  
**Purpose:** Speeds up `WHERE CreateAt >= ? AND CreateAt <= ?` for the date range; GROUP BY on date uses the same range scan.

### countBotPostsByDay

```sql
SELECT TO_CHAR(day, 'YYYY-MM-DD') AS Name, num AS Value
FROM bot_posts_by_team_day
WHERE teamid = ?
  AND day >= ? AND day <= ?
ORDER BY Name DESC
LIMIT 30
```

(Or `SUM(num) ... GROUP BY` when no team.)

### countPostsByDay

- Same pattern against materialized view `posts_by_team_day` with optional `teamid` and date range.

### AnalyticsPostCountsByDay

Uses: **countBotPostsByDay** or **countPostsByDay**.

### countByTeam / AnalyticsPostCountByTeam

```sql
SELECT COALESCE(SUM(num), 0) AS total FROM posts_by_team_day
-- WHERE teamid = ?
```

### AnalyticsPostCount

```sql
SELECT COUNT(*) AS Value
FROM Posts p
-- JOIN Channels c ON c.Id = p.ChannelId AND c.TeamId = ?
WHERE 1=1
  -- AND p.Type = '' AND p.UserId NOT IN (SELECT UserId FROM Bots)
  -- AND (file/hashtag filters)
  -- AND p.DeleteAt = 0
  -- AND p.Type NOT LIKE 'system_%'
  -- AND (SinceUpdateAt/UntilUpdateAt cursor)
```

**Existing index:** Depends on filters: `idx_posts_create_at`, `idx_posts_update_at`, `idx_posts_delete_at`, `idx_posts_user_id`, etc. Full table count uses sequential scan unless filtered.  
**Purpose:** Use the index that matches the active filter (CreateAt, UpdateAt, Type, UserId, etc.).

---

## Indexing and export

### GetPostsBatchForIndexing

- Batch of posts for search index, ordered by (CreateAt, Id):

```sql
SELECT Posts.*, Channels.TeamId
FROM Posts
LEFT JOIN Channels ON Posts.ChannelId = Channels.Id
WHERE (Posts.CreateAt, Posts.Id) > (?, ?)
ORDER BY Posts.CreateAt ASC, Posts.Id ASC
LIMIT ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at_id on posts(createat, id);`  
**Purpose:** Speeds up `WHERE (CreateAt, Id) > (?, ?) ORDER BY CreateAt ASC, Id ASC LIMIT ?` for indexing cursor.

### GetOldest

```sql
SELECT * FROM Posts ORDER BY CreateAt LIMIT 1
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);` or `idx_posts_create_at_id`  
**Purpose:** Speeds up `ORDER BY CreateAt LIMIT 1` for oldest post.

### GetNthRecentPostTime

- CreateAt of the nth most recent user (non-bot) post:

```sql
SELECT CreateAt FROM Posts p
WHERE p.Type = '' AND p.UserId NOT IN (SELECT UserId FROM Bots)
ORDER BY p.CreateAt DESC
LIMIT 1 OFFSET (n - 1)
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);` or `idx_posts_create_at_id` for `ORDER BY CreateAt DESC`.  
**Purpose:** Supports ordering by CreateAt; UserId/Type filters may use idx_posts_user_id or table filter.

### GetParentsForExportAfter

- First, get root ids:

```sql
SELECT Id FROM Posts
WHERE Posts.Id > ? AND Posts.RootId = '' AND Posts.DeleteAt = 0
ORDER BY Posts.Id
LIMIT ?
```

**Existing index:** No index on (Id, RootId, DeleteAt) for `WHERE Id > ? AND RootId = '' AND DeleteAt = 0 ORDER BY Id`. Primary key gives Id order; filter RootId = '' and DeleteAt = 0 on rows.  
**Purpose:** Id range uses PK. **Suggestion:** For large exports, consider `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at_id ON posts(rootid, deleteat, id);` with condition `WHERE rootid = '' AND deleteat = 0` (partial index) to speed up export cursor.

- Then join with Users, Teams, Channels, Preferences for export (with deleted team/channel filter).

### GetRepliesForExport

```sql
SELECT Posts.*, u2.Username, COALESCE(json_agg(u1.username) FILTER (WHERE u1.username IS NOT NULL), '[]') AS FlaggedBy
FROM Posts
LEFT JOIN Preferences ON Posts.Id = Preferences.Name
LEFT JOIN Users u1 ON Preferences.UserId = u1.Id
INNER JOIN Users u2 ON Posts.UserId = u2.Id
WHERE Posts.RootId = ? AND Posts.DeleteAt = 0
GROUP BY Posts.Id, u2.Username
ORDER BY Posts.Id
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` helps filter RootId and DeleteAt; Id order from table/ PK.  
**Purpose:** Join and filter on RootId = ? and DeleteAt = 0; reply order by Id.

### GetDirectPostParentsForExportAfter

- Root posts in DM/GM channels, then channel members:

```sql
SELECT p.*, u2.Username, json_agg(...) ...
FROM Posts p
JOIN Channels ON p.ChannelId = Channels.Id
WHERE p.Id > ? AND p.RootId = '' AND p.DeleteAt = 0
  AND Channels.Type IN ('D', 'G')
GROUP BY p.Id, u2.Username
ORDER BY p.Id
LIMIT ?
```

**Existing index:** Same as GetParentsForExportAfter: Id range; RootId = '' and DeleteAt = 0. `idx_posts_channel_id_delete_at_create_at` or PK for Id. Channels by Type uses `idx_channels_team_id_type` or table.  
**Purpose:** Root posts in DM/GM; filter by channel type and post root/delete.

```sql
SELECT u.Username, ChannelId, UserId, ... FROM ChannelMembers cm
JOIN Users u ON u.Id = cm.UserId
WHERE cm.ChannelId IN (...)
```

### GetOldestEntityCreationTime

- Oldest create time across Posts, Users, and Channels:

```sql
SELECT MIN(min_createat) AS min_createat
FROM (
  (SELECT MIN(createat) AS min_createat FROM Posts)
  UNION
  (SELECT MIN(createat) AS min_createat FROM Users)
  UNION
  (SELECT MIN(createat) AS min_createat FROM Channels)
) entities
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);`, `idx_users_create_at`, `idx_channels_create_at`  
**Purpose:** Each subquery uses MIN(createat) with an index on createat for that table.

---

## Post size and schema

### determineMaxPostSize / GetMaxPostSize

- Reads the Message column max length to derive max runes for a post:

```sql
SELECT COALESCE(character_maximum_length, 0)
FROM information_schema.columns
WHERE table_name = 'posts' AND column_name = 'message'
```

---

## Thread helpers (used by save/delete/restore)

### deleteThread

```sql
UPDATE Threads SET ThreadDeleteAt = ? WHERE PostId = ?
```

Then **deleteThreadFiles**.

### deleteThreadFiles

- Soft-deletes file infos for replies of a root post:

```sql
UPDATE FileInfo SET DeleteAt = ?
FROM Posts
WHERE FileInfo.PostId = Posts.Id AND Posts.RootId = ?
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_fileinfo_postid_at ON fileinfo (postid);` for the join/lookup by PostId. `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` for `Posts.RootId = ?`.  
**Purpose:** FileInfo by PostId; Posts by RootId for the join.

### updateThreadAfterReplyDeletion

- Count user’s posts in thread:

```sql
SELECT COUNT(Posts.Id) FROM Posts
WHERE Posts.RootId = ? AND Posts.UserId = ? AND Posts.DeleteAt = 0
```

**Existing index:** `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` (UserId can be applied on the result).  
**Purpose:** Count by RootId and DeleteAt; UserId filter on indexed rows.

- Then update thread (participants, LastReplyAt, ReplyCount):

```sql
UPDATE Threads
SET Participants = Participants - ?,
    LastReplyAt = (SELECT COALESCE(MAX(CreateAt), 0) FROM Posts WHERE RootId = ? AND DeleteAt = 0),
    ReplyCount = (SELECT Count(*) FROM Posts WHERE RootId = ? AND DeleteAt = 0)
WHERE PostId = ? AND ReplyCount > 0
```

**Existing index:** Subqueries on Posts: `CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);` for `WHERE RootId = ? AND DeleteAt = 0`. Update by `Threads.PostId` (PK).  
**Purpose:** Aggregates for thread use root_id_delete_at; thread update by PostId.

### updateThreadsFromPosts

- Load existing threads:

```sql
SELECT Threads.PostId, Threads.ChannelId, Threads.ReplyCount, Threads.LastReplyAt, Threads.Participants, ...
FROM Threads
WHERE Threads.PostId IN (rootIds)
```

**Existing index:** Lookup by `Threads.PostId IN (rootIds)` uses primary key of `threads` (PostId).  
**Purpose:** Fetch threads by root post ids; PK on Threads.PostId.

- Per root: participant/reply aggregates, then either:

```sql
INSERT INTO Threads (PostId, ChannelId, ReplyCount, LastReplyAt, Participants, ThreadTeamId) VALUES (...)
```

or:

```sql
UPDATE Threads SET ChannelId = ?, ReplyCount = ?, LastReplyAt = ?, Participants = ? WHERE PostId = ?
```

### savePostsPriority

```sql
INSERT INTO PostsPriority (PostId, ChannelId, Priority, RequestedAck, PersistentNotifications)
VALUES (:PostId, :ChannelId, :Priority, :RequestedAck, :PersistentNotifications)
```

### savePostsPersistentNotifications

```sql
INSERT INTO PersistentNotifications (PostId, CreateAt, LastSentAt, DeleteAt, SentCount)
VALUES (:PostId, :CreateAt, :LastSentAt, :DeleteAt, :SentCount)
```

---

## Post reminders

### SetPostReminder

- Ensure post exists:

```sql
SELECT EXISTS (SELECT 1 FROM Posts WHERE Id = ?)
```

- Upsert reminder:

```sql
INSERT INTO PostReminders (PostId, UserId, TargetTime) VALUES (?, ?, ?)
ON CONFLICT (postid, userid) DO UPDATE SET TargetTime = ?
```

### GetPostReminders

- Deletes due reminders and returns them in one step:

```sql
DELETE FROM PostReminders WHERE TargetTime <= $1 RETURNING PostId, UserId
```

**No index.**  
**Suggestion:** If PostReminders exists and this query is used often, add `CREATE INDEX IF NOT EXISTS idx_post_reminders_target_time ON postreminders(targettime);` to speed up `WHERE TargetTime <= ?`.

### DeleteAllPostRemindersForPost

```sql
DELETE FROM PostReminders WHERE PostId = ?
```

**No index.**  
**Suggestion:** If PostReminders exists, add `CREATE INDEX IF NOT EXISTS idx_post_reminders_post_id ON postreminders(postid);` for deletes by PostId.

### GetPostReminderMetadata

```sql
SELECT c.id AS ChannelID,
       COALESCE(t.name, '') AS TeamName,
       u.locale AS UserLocale,
       u.username AS Username
FROM Posts p
JOIN Channels c ON p.ChannelId = c.Id
LEFT JOIN Teams t ON c.TeamId = t.Id
JOIN Users u ON p.UserId = u.Id AND p.Id = ?
```

**Existing index:** Lookup by `p.Id = ?` uses `Posts.Id` (primary key). Channels join on `c.Id`, Teams on `t.Id`, Users on `u.Id` (all PKs).  
**Purpose:** Single-post metadata; primary keys suffice.

---

## Stats and restore

### RefreshPostStats

- Refreshes analytics materialized views:

```sql
REFRESH MATERIALIZED VIEW posts_by_team_day
```

```sql
REFRESH MATERIALIZED VIEW bot_posts_by_team_day
```

### RestoreContentFlaggedPost

Content-flagging here is the moderation/review feature (PropertyValues), not the user “saved post” feature (Preferences). Uses a base subquery on Posts joined to PropertyValues (content-flagging and status). Then:

- **restoreContentFlaggedRootPost** — Restore root post and its files: `UPDATE Posts SET DeleteAt = 0 WHERE Id IN (subquery)`.
- **restoreContentFlaggedPostReplies** — Restore replies under the root: `UPDATE Posts SET DeleteAt = 0 WHERE Id IN (subquery)`.
- **removeContentFlaggingManagedPropertyValues**: `UPDATE PropertyValues SET DeleteAt = ? WHERE FieldId = ? AND TargetId IN (subquery)`.
- **restoreFilesForSubQuery**: `UPDATE FileInfo SET DeleteAt = 0 WHERE FileInfo.PostId IN (subquery)`.

---

## Helper / filter builders (no standalone execution)

### buildCreateDateFilterClause

Adds `CreateAt` conditions (BETWEEN, >=, <=, excluded ranges) to a search builder.

### buildSearchTeamFilterClause

Adds `Channels.TeamId = ?` or similar to channel subquery.

### buildSearchChannelFilterClause

Adds `Id IN (...)` or `Name IN (...)` for channel include/exclude.

### buildSearchUserFilterClause

Adds `UserId IN (...)` or username-based filter for user include/exclude.

### buildSearchPostFilterClause

Builds a `UserId IN (SELECT ... FROM Users JOIN ...)` subquery for from/excluded users and injects it into the main search query.

### buildFlaggedPostTeamFilterClause / buildFlaggedPostChannelFilterClause

Return SQL fragments and params for team/channel filter in **getFlaggedPosts**.

### prepareThreadedResponse

No SQL; merges thread metadata and participant users into a PostList.

### ClearCaches / InvalidateLastPostTimeCache

No SQL (cache only).
