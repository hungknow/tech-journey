# Read Receipt Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/read_receipt_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlReadReceiptStore

Builds **selectQueryBuilder** (not executed by this function):

```sql
SELECT (readReceiptSliceColumns)
FROM ReadReceipts
```

---

## CRUD

### Save

Upsert by (PostId, UserId):

```sql
INSERT INTO ReadReceipts (PostId, UserId, ReadAt, ThreadReadAt, ...)
VALUES (?, ?, ?, ?, ...)
ON CONFLICT (PostId, UserId) DO UPDATE SET ReadAt = ?, ThreadReadAt = ?, ...
```

### Update

```sql
UPDATE ReadReceipts SET ReadAt = ?, ThreadReadAt = ?, ... WHERE PostId = ? AND UserId = ?
```

### Delete

```sql
DELETE FROM ReadReceipts WHERE PostId = ? AND UserId = ?
```

### DeleteByPost

```sql
DELETE FROM ReadReceipts WHERE PostId = ?
```

---

## Read

### Get

**selectQueryBuilder** WHERE PostId = ? AND UserId = ?.

### GetByPost

**selectQueryBuilder** WHERE PostId = ?.

### GetReadCountForPost

```sql
SELECT COUNT(*) FROM ReadReceipts WHERE PostId = ?
```
Or COUNT(DISTINCT UserId).

### GetUnreadCountForPost

Count ChannelMembers for post’s channel minus read count (ChannelMembers join/count minus ReadReceipts count for post).

---

## No-op (no SQL)

### InvalidateReadReceiptForPostsCache

No SQL. Cache invalidation only.
