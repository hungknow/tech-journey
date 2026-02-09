# Temporary Post Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/temporary_post_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlTemporaryPostStore

Builds **selectQueryBuilder** (not executed by this function):

```sql
SELECT (temporaryPostSliceColumns)
FROM TemporaryPosts
```

---

## CRUD

### Save

Inside transaction: **saveT** — upsert by Id.

```sql
INSERT INTO TemporaryPosts (Id, CreateAt, UpdateAt, DeleteAt, UserId, ChannelId, RootId, Message, ...)
VALUES (...)
ON CONFLICT (Id) DO UPDATE SET ...
```

### Get

**selectQueryBuilder** WHERE Id = ?.

### Delete

```sql
DELETE FROM TemporaryPosts WHERE Id = ?
```

### GetExpiredPosts

Returns list of ids for cleanup.

```sql
SELECT Id FROM TemporaryPosts WHERE CreateAt < ?
```

---

## No-op (no SQL)

### InvalidateTemporaryPost

No SQL. Cache invalidation only.
