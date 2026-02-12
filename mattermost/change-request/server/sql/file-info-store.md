# File Info Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/file_info_store.go`
and the SQL executed by that function. SQL is shown in fenced code blocks for correct display.
Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlFileInfoStore

Sets **queryFields**: FileInfo columns including COALESCE(FileInfo.ChannelId, ''), Coalesce(Content, ''),
Coalesce(RemoteId, ''), Archived. No shared select builder; queries built per method.

---

## CRUD and lifecycle

### Save

```sql
INSERT INTO FileInfo
(Id, CreatorId, PostId, ChannelId, CreateAt, UpdateAt, DeleteAt, Path, ThumbnailPath, PreviewPath,
 Name, Extension, Size, MimeType, Width, Height, HasPreviewImage, MiniPreview, Content, RemoteId)
VALUES
(:Id, :CreatorId, :PostId, :ChannelId, :CreateAt, :UpdateAt, :DeleteAt, :Path, :ThumbnailPath, :PreviewPath,
 :Name, :Extension, :Size, :MimeType, :Width, :Height, :HasPreviewImage, :MiniPreview, :Content, :RemoteId)
```

### GetByIds

```sql
SELECT queryFields FROM FileInfo
WHERE Id IN (?)
  -- optional: AND DeleteAt = 0
ORDER BY CreateAt DESC
```

### Upsert

If 0 rows affected, calls **Save**.

```sql
UPDATE FileInfo
SET UpdateAt = ?, DeleteAt = ?, Path = ?, ThumbnailPath = ?, PreviewPath = ?, Name = ?,
    Extension = ?, Size = ?, MimeType = ?, Width = ?, Height = ?, HasPreviewImage = ?,
    MiniPreview = ?, Content = ?, RemoteId = ?
WHERE Id = ?
```

### get / Get / GetFromMaster

```sql
SELECT queryFields FROM FileInfo WHERE Id = ? AND DeleteAt = 0
```

### GetWithOptions

```sql
SELECT queryFields FROM FileInfo
-- optional: ChannelIds, UserIds, Since, IncludeDeleted
ORDER BY CreateAt | Size (ASC/DESC), Id
LIMIT ? OFFSET ?
```

### GetByPath

```sql
SELECT queryFields FROM FileInfo WHERE Path = ? AND DeleteAt = 0 LIMIT 1
```

### GetForPost

```sql
SELECT queryFields FROM FileInfo
WHERE PostId = ?
  -- optional: AND DeleteAt = 0
ORDER BY CreateAt
```

### GetForUser

```sql
SELECT queryFields FROM FileInfo
WHERE CreatorId = ? AND DeleteAt = 0
ORDER BY CreateAt
```

### AttachToPost

```sql
UPDATE FileInfo
SET PostId = ?, ChannelId = ?
WHERE Id = ? AND PostId = '' AND (CreatorId = ? OR CreatorId = 'nouser')
```

### SetContent

```sql
UPDATE FileInfo SET Content = ? WHERE Id = ?
```

### DeleteForPost

```sql
UPDATE FileInfo SET DeleteAt = ? WHERE PostId = ?
```

### DeleteForPostByIds

```sql
UPDATE FileInfo SET DeleteAt = ? WHERE PostId = ? AND Id IN (?)
```

### PermanentDeleteForPost

```sql
DELETE FROM FileInfo WHERE PostId = ?
```

### PermanentDelete

```sql
DELETE FROM FileInfo WHERE Id = ?
```

### PermanentDeleteBatch

Batch delete by endTime and limit.

```sql
DELETE FROM FileInfo
WHERE Id = ANY(ARRAY(
  SELECT Id FROM FileInfo
  WHERE CreateAt < ? AND CreatorId != ?
  LIMIT ?
))
```

### PermanentDeleteByUser

```sql
DELETE FROM FileInfo WHERE CreatorId = ?
```

### RestoreForPostByIds

```sql
UPDATE FileInfo SET DeleteAt = 0 WHERE PostId = ? AND Id IN (?)
```

---

## Search and analytics

### Search

Complex query builder: from FileInfo with optional joins (Channels, Posts, User), filters (channel, user,
date range, extensions, etc.), full-text or LIKE on Name/Content, ORDER BY, LIMIT/OFFSET.
Returns FileInfoList with total count.

### CountAll

```sql
SELECT COUNT(*) FROM FileInfo
```

### GetFilesBatchForIndexing

```sql
-- Select file columns for indexing
SELECT ... FROM FileInfo
WHERE (CreateAt > ? OR (CreateAt = ? AND Id > ?))
  -- optional: IncludeDeleted
ORDER BY CreateAt, Id
LIMIT ?
```

### GetStorageUsage

```sql
SELECT COALESCE(SUM(Size), 0) FROM FileInfo
-- optional: WHERE DeleteAt = 0
```

### GetUptoNSizeFileTime

Subquery/raw SQL to compute file time for storage reporting (nth largest size).

### RefreshFileStats

```sql
ANALYZE FileInfo
```

---

## No-op / cache

### ClearCaches

No SQL.

### InvalidateFileInfosForPostCache

No SQL. Cache invalidation only.
