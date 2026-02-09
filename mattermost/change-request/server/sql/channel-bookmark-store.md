# Channel Bookmark Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/channel_bookmark_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Helpers

### bookmarkWithFileInfoSliceColumns

Returns list of columns for ChannelBookmarks cb + FileInfo fi (Id, OwnerId, ChannelId, FileInfoId, CreateAt, UpdateAt, DeleteAt, DisplayName, SortOrder, LinkUrl, ImageUrl, Emoji, Type, OriginalId, plus COALESCE file columns).

---

## Validation and read

### ErrorIfBookmarkFileInfoAlreadyAttached

Subquery: FileInfoId from ChannelBookmarks where FileInfoId = ? and DeleteAt = 0. Main: COUNT(*) from FileInfo where Id IN (subquery) OR (Id = fileId AND (PostId != '' OR CreatorId != bookmark owner OR ChannelId != channelId OR DeleteAt != 0)). If count > 0, returns error (file already attached or invalid).

### Get

Select **bookmarkWithFileInfoSliceColumns** from ChannelBookmarks cb LEFT JOIN FileInfo fi ON cb.FileInfoId = fi.Id WHERE cb.Id = ?; optional cb.DeleteAt = 0.

### GetBookmarksForChannelSince

Same select from ChannelBookmarks cb LEFT JOIN FileInfo fi WHERE cb.ChannelId = ?; if since > 0 then (cb.UpdateAt >= since OR cb.DeleteAt >= since), else cb.DeleteAt = 0. ORDER BY cb.SortOrder ASC, cb.DeleteAt ASC LIMIT (MaxBookmarksPerChannel * 2).

---

## Write and delete

### Save

Inside a transaction:

1. Enforce max per channel:

```sql
SELECT COUNT(*) FROM ChannelBookmarks WHERE ChannelId = ? AND DeleteAt = 0
```

2. Optionally ErrorIfBookmarkFileInfoAlreadyAttached. If increaseSortOrder:

```sql
SELECT COALESCE(MAX(SortOrder), -1) FROM ChannelBookmarks WHERE ChannelId = ? AND DeleteAt = 0
```

3. Insert bookmark:

```sql
INSERT INTO ChannelBookmarks (Id, CreateAt, UpdateAt, DeleteAt, ChannelId, OwnerId, FileInfoId, DisplayName, SortOrder, LinkUrl, ImageUrl, Emoji, Type)
VALUES (...)
```

If FileId set, select FileInfo by Id.

### Update

```sql
UPDATE ChannelBookmarks
SET DisplayName = ?, SortOrder = ?, LinkUrl = ?, ImageUrl = ?, Emoji = ?, FileInfoId = ?, UpdateAt = ?
WHERE Id = ? AND DeleteAt = 0
```

### UpdateSortOrder

Inside a transaction: get bookmarks for channel (GetBookmarksForChannelSince); reorder in memory; bulk update.

```sql
UPDATE ChannelBookmarks
SET SortOrder = CASE Id WHEN ? THEN ? ... END, UpdateAt = ?
WHERE Id IN (?)
```

### Delete

Inside a transaction: if deleteFile, then update FileInfo.

```sql
UPDATE ChannelBookmarks SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

If deleteFile, then:

```sql
UPDATE FileInfo SET DeleteAt = ?, UpdateAt = ?
WHERE Id IN (SELECT FileInfoId FROM ChannelBookmarks WHERE Id = ?)
```
