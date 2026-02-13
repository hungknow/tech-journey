# File Info Store — SQL Reference

This document lists each store function in
`server/channels/store/sqlstore/file_info_store.go` and the real SQL executed by that
function. Lines are under 120 characters. SELECTs use queryFields (see Initialization).

---

## Initialization

### newSqlFileInfoStore

queryFields (used in SELECTs):

- FileInfo.Id, FileInfo.CreatorId, FileInfo.PostId,
- COALESCE(FileInfo.ChannelId, '') AS ChannelId, FileInfo.CreateAt, FileInfo.UpdateAt,
  FileInfo.DeleteAt,
- FileInfo.Path, FileInfo.ThumbnailPath, FileInfo.PreviewPath, FileInfo.Name, FileInfo.Extension,
- FileInfo.Size, FileInfo.MimeType, FileInfo.Width, FileInfo.Height, FileInfo.HasPreviewImage,
- FileInfo.MiniPreview, Coalesce(FileInfo.Content, '') AS Content,
  Coalesce(FileInfo.RemoteId, '') AS RemoteId,
- FileInfo.Archived

---

## CRUD and lifecycle

### Save

Placeholders are named (`:Id`, `:CreatorId`, etc.).

```sql
INSERT INTO FileInfo
(Id, CreatorId, PostId, ChannelId, CreateAt, UpdateAt, DeleteAt, Path, ThumbnailPath,
 PreviewPath, Name, Extension, Size, MimeType, Width, Height, HasPreviewImage, MiniPreview,
 Content, RemoteId)
VALUES
(:Id, :CreatorId, :PostId, :ChannelId, :CreateAt, :UpdateAt, :DeleteAt, :Path, :ThumbnailPath,
 :PreviewPath, :Name, :Extension, :Size, :MimeType, :Width, :Height, :HasPreviewImage,
 :MiniPreview, :Content, :RemoteId)
```

### GetByIds

```sql
SELECT queryFields FROM FileInfo
WHERE FileInfo.Id IN (?)
  -- optional: AND FileInfo.DeleteAt = 0
ORDER BY FileInfo.CreateAt DESC
```

### Upsert

If 0 rows affected, code calls Save.

```sql
UPDATE FileInfo
SET UpdateAt = ?, DeleteAt = ?, Path = ?, ThumbnailPath = ?, PreviewPath = ?, Name = ?,
    Extension = ?, Size = ?, MimeType = ?, Width = ?, Height = ?, HasPreviewImage = ?,
    MiniPreview = ?, Content = ?, RemoteId = ?
WHERE Id = ?
```

### get / Get / GetFromMaster

```sql
SELECT queryFields FROM FileInfo WHERE FileInfo.Id = ? AND FileInfo.DeleteAt = 0
```

### GetWithOptions

```sql
SELECT queryFields FROM FileInfo
-- optional: AND FileInfo.ChannelId IN (?), FileInfo.CreatorId IN (?),
--           FileInfo.CreateAt >= ?, FileInfo.DeleteAt = 0
ORDER BY FileInfo.CreateAt ASC, FileInfo.Id ASC
LIMIT ? OFFSET ?
```

### GetByPath

```sql
SELECT queryFields FROM FileInfo
WHERE FileInfo.Path = ? AND FileInfo.DeleteAt = 0 LIMIT 1
```

### GetForPost

```sql
SELECT queryFields FROM FileInfo
WHERE FileInfo.PostId = ?
  -- optional: AND FileInfo.DeleteAt = 0
ORDER BY FileInfo.CreateAt
```

### GetForUser

```sql
SELECT queryFields FROM FileInfo
WHERE FileInfo.CreatorId = ? AND FileInfo.DeleteAt = 0
ORDER BY FileInfo.CreateAt
```

### AttachToPost

```sql
UPDATE FileInfo SET PostId = ?, ChannelId = ?
WHERE FileInfo.Id = ? AND FileInfo.PostId = ''
  AND (FileInfo.CreatorId = ? OR FileInfo.CreatorId = 'nouser')
```

### SetContent

```sql
UPDATE FileInfo SET Content = ? WHERE FileInfo.Id = ?
```

### DeleteForPost

```sql
UPDATE FileInfo SET DeleteAt = ? WHERE PostId = ?
```

### DeleteForPostByIds

```sql
UPDATE FileInfo SET DeleteAt = ? WHERE FileInfo.PostId = ? AND FileInfo.Id IN (?)
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
UPDATE FileInfo SET DeleteAt = 0 WHERE FileInfo.PostId = ? AND FileInfo.Id IN (?)
```

---

## Search and analytics

### Search

Simplified shape; full query adds optional filters (team, channels, users, dates,
full-text on Name/Content).

```sql
SELECT queryFields FROM FileInfo
LEFT JOIN Channels AS C ON C.Id = FileInfo.ChannelId
LEFT JOIN ChannelMembers AS CM ON C.Id = CM.ChannelId
WHERE FileInfo.DeleteAt = 0
  AND (FileInfo.CreatorId = 'bookmarkfileowner' OR FileInfo.PostId != '')
  AND NOT EXISTS (
    SELECT 1 FROM TemporaryPosts WHERE TemporaryPosts.PostId = FileInfo.PostId)
ORDER BY FileInfo.CreateAt DESC
LIMIT 100
```

### CountAll

```sql
SELECT num FROM file_stats
```

### GetFilesBatchForIndexing

```sql
SELECT queryFields FROM FileInfo
WHERE (FileInfo.CreateAt > ? OR (FileInfo.CreateAt = ? AND FileInfo.Id > ?))
  -- optional: AND FileInfo.DeleteAt = 0
ORDER BY FileInfo.CreateAt ASC, FileInfo.Id ASC
LIMIT ?
```

### GetStorageUsage

```sql
-- when includeDeleted = false (default)
SELECT usage FROM file_stats

-- when includeDeleted = true
SELECT COALESCE(SUM(Size), 0) FROM FileInfo
```

### GetUptoNSizeFileTime

```sql
SELECT fi2.CreateAt FROM (
  SELECT SUM(fi.Size) OVER (ORDER BY CreateAt DESC, fi.Id) RunningTotal, fi.CreateAt
  FROM FileInfo fi
  WHERE fi.DeleteAt = 0
) fi2
WHERE fi2.RunningTotal <= ?
ORDER BY fi2.CreateAt
LIMIT 1
```

### RefreshFileStats

```sql
REFRESH MATERIALIZED VIEW file_stats
```

---

## No-op / cache

### ClearCaches

No SQL.

### InvalidateFileInfosForPostCache

No SQL. Cache invalidation only.
