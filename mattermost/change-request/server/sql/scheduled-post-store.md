# Scheduled Post Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/scheduled_post_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## ScheduledPosts table

### CreateScheduledPost

```sql
INSERT INTO ScheduledPosts (Id, UserId, ChannelId, TeamId, Message, Props, ScheduledAt, CreateAt, UpdateAt, ...)
VALUES (...)
```
Returns created scheduled post.

### Get

```sql
SELECT * FROM ScheduledPosts WHERE Id = ?
```

### GetScheduledPostsForUser

```sql
SELECT * FROM ScheduledPosts
WHERE UserId = ? AND (TeamId = ? OR TeamId = '')
ORDER BY CreateAt
```

### GetPendingScheduledPosts

Used by job to publish scheduled posts.

```sql
SELECT * FROM ScheduledPosts
WHERE ScheduledAt BETWEEN ? AND ? AND Id > ?
ORDER BY ScheduledAt, Id
LIMIT ?
```

### UpdatedScheduledPost

```sql
UPDATE ScheduledPosts SET ... WHERE Id = ?
```
Uses toUpdateMap for columns.

### UpdateOldScheduledPosts

Marks as processed/failed.

```sql
UPDATE ScheduledPosts SET Status = ?, ...
WHERE ScheduledAt < ?
```

### PermanentlyDeleteScheduledPosts

```sql
DELETE FROM ScheduledPosts WHERE Id IN (?)
```

### PermanentDeleteByUser

```sql
DELETE FROM ScheduledPosts WHERE UserId = ?
```

### GetMaxMessageSize

Read from information_schema or config for max message size (no table ScheduledPosts write).
