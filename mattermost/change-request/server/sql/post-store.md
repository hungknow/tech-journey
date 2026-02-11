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

- Removes temporary (e.g. burn-on-read) posts:

```sql
DELETE FROM TemporaryPosts WHERE PostId IN (...)
```

- Removes read receipts for those posts:

```sql
DELETE FROM ReadReceipts WHERE PostId IN (...)
```

- Permanently deletes the posts and all their replies:

```sql
DELETE FROM Posts WHERE Id IN (...) OR RootId IN (...)
```

### permanentDeleteAllCommentByUser

- Fetches all comment ids and roots for the user:

```sql
SELECT Id, RootId FROM Posts WHERE UserId = ? AND RootId != ''
```

- Permanently deletes all comments by that user; then uses `updateThreadAfterReplyDeletion` per root and `permanentDeleteReactions`, `permanentDeleteTemporaryPosts`, `permanentDeleteReadReceipts` for those comment ids:

```sql
DELETE FROM Posts WHERE UserId = ? AND RootId != ''
```

### PermanentDeleteByUser

Uses: **permanentDeleteAllCommentByUser**, then **permanentDelete** in a loop.

- In a loop:

```sql
SELECT Id FROM Posts WHERE UserId = ? LIMIT 1000
```

and `permanentDelete(ids)` until no more posts.

### PermanentDeleteByChannel

- In a loop:

```sql
SELECT Id FROM Posts WHERE ChannelId = ? AND Id > ? ORDER BY Id ASC LIMIT 500
```

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

### PermanentDeleteBatchForRetentionPolicies

Uses: **genericPermanentDeleteBatchForRetentionPolicies**. Squirrel builder with optional filter for non-pinned or already-deleted pinned posts.

- Shape:

```sql
SELECT Posts.Id
FROM Posts
-- optional: non-pinned or already-deleted pinned filter
```

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

- Optional thread fetch (with ordering and limit for thread replies):

```sql
WITH replycount AS (SELECT count(*) AS num FROM posts WHERE RootId = ? AND DeleteAt = 0)
SELECT p.*, replycount.num AS ReplyCount
FROM Posts p, replycount
WHERE (p.Id = ? OR p.RootId = ?) AND p.DeleteAt = 0
ORDER BY ... LIMIT ...
```

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

### GetEtag

**What is etag?** An *entity tag* used for cache validation. The server builds a short value that represents “how up to date” the channel’s post list is (from the latest post’s `Id` and `UpdateAt`). The client can send this etag on the next request (e.g. in `If-None-Match`); if nothing changed, the server can respond 304 Not Modified so the client keeps using its cached list.

- Builds that etag from the channel’s most recently updated post:

```sql
SELECT Id, UpdateAt FROM Posts WHERE ChannelId = ?
-- AND RootId = ''  (when collapsedThreads)
ORDER BY UpdateAt DESC LIMIT 1
```

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

- Without reply count:

```sql
SELECT Posts.* FROM Posts WHERE Posts.ChannelId = ? AND Posts.DeleteAt = 0 ORDER BY Posts.CreateAt DESC LIMIT ? OFFSET ?
```

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

### HasAutoResponsePostByUserSince

- Checks for at least one auto-responder post in the channel since the given time:

```sql
SELECT EXISTS (
  SELECT 1 FROM Posts
  WHERE UpdateAt >= ? AND ChannelId = ? AND UserId = ? AND Type = ?
  LIMIT 1
)
```

### GetPostsSinceForSync

- Used for sync/export; Squirrel SELECT from Posts with ORDER BY UpdateAt/Id, LIMIT, and optional filters (cursor, ChannelId, DeleteAt, ExcludeRemoteId, Type).

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

### GetPostsByThread

- All replies in a thread since a given time:

```sql
SELECT * FROM Posts WHERE RootId = ? AND DeleteAt = 0 AND CreateAt >= ?
```

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

### GetPostAfterTime

```sql
SELECT * FROM Posts
WHERE CreateAt > ? AND ChannelId = ? AND DeleteAt = 0
ORDER BY Posts.CreateAt ASC
LIMIT 1
```

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

### GetEditHistoryForPost

- Edit history (previous versions) for a post:

```sql
SELECT * FROM Posts WHERE Posts.OriginalId = ? ORDER BY Posts.EditAt DESC
```

### GetPostsCreatedAt

```sql
SELECT * FROM Posts WHERE CreateAt = ? AND ChannelId = ?
```

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

### GetOldest

```sql
SELECT * FROM Posts ORDER BY CreateAt LIMIT 1
```

### GetNthRecentPostTime

- CreateAt of the nth most recent user (non-bot) post:

```sql
SELECT CreateAt FROM Posts p
WHERE p.Type = '' AND p.UserId NOT IN (SELECT UserId FROM Bots)
ORDER BY p.CreateAt DESC
LIMIT 1 OFFSET (n - 1)
```

### GetParentsForExportAfter

- First, get root ids:

```sql
SELECT Id FROM Posts
WHERE Posts.Id > ? AND Posts.RootId = '' AND Posts.DeleteAt = 0
ORDER BY Posts.Id
LIMIT ?
```

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

### updateThreadAfterReplyDeletion

- Count user’s posts in thread:

```sql
SELECT COUNT(Posts.Id) FROM Posts
WHERE Posts.RootId = ? AND Posts.UserId = ? AND Posts.DeleteAt = 0
```

- Then update thread (participants, LastReplyAt, ReplyCount):

```sql
UPDATE Threads
SET Participants = Participants - ?,
    LastReplyAt = (SELECT COALESCE(MAX(CreateAt), 0) FROM Posts WHERE RootId = ? AND DeleteAt = 0),
    ReplyCount = (SELECT Count(*) FROM Posts WHERE RootId = ? AND DeleteAt = 0)
WHERE PostId = ? AND ReplyCount > 0
```

### updateThreadsFromPosts

- Load existing threads:

```sql
SELECT Threads.PostId, Threads.ChannelId, Threads.ReplyCount, Threads.LastReplyAt, Threads.Participants, ...
FROM Threads
WHERE Threads.PostId IN (rootIds)
```

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

### DeleteAllPostRemindersForPost

```sql
DELETE FROM PostReminders WHERE PostId = ?
```

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
