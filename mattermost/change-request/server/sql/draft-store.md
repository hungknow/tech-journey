# Draft Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/draft_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Columns and helpers

### draftSliceColumns

Returns: CreateAt, UpdateAt, DeleteAt, Message, RootId, ChannelId, UserId, FileIds, Props, Priority, Type.

---

## CRUD and listing

### Get

Select **draftSliceColumns** from Drafts WHERE UserId = ?, ChannelId = ?, RootId = ?; optional DeleteAt = 0.

### Upsert

```sql
INSERT INTO Drafts (UserId, ChannelId, RootId, CreateAt, UpdateAt, Message, Props, FileIds, Priority, Type, DeleteAt, ...)
VALUES (...)
ON CONFLICT (UserId, ChannelId, RootId)
DO UPDATE SET UpdateAt = ?, Message = ?, Props = ?, FileIds = ?, Priority = ?, Type = ?, DeleteAt = 0
```

### GetDraftsForUser

```sql
SELECT draft columns
FROM Drafts
INNER JOIN ChannelMembers ON ChannelMembers.ChannelId = Drafts.ChannelId
WHERE Drafts.DeleteAt = 0 AND Drafts.UserId = ? AND ChannelMembers.UserId = ?
-- optional: JOIN Channels ... AND (Channels.TeamId = ? OR Channels.TeamId = '')
ORDER BY Drafts.UpdateAt DESC
```

### Delete

```sql
DELETE FROM Drafts WHERE UserId = ? AND ChannelId = ? AND RootId = ?
```

### PermanentDeleteByUser

```sql
DELETE FROM Drafts WHERE UserId = ?
```

### DeleteDraftsAssociatedWithPost

```sql
DELETE FROM Drafts WHERE ChannelId = ? AND RootId = ?
```

---

## Migration and metadata

### GetLastCreateAtAndUserIdValuesForEmptyDraftsMigration

Select CreateAt, UserId from Drafts WHERE (CreateAt > ? OR (CreateAt = ? AND UserId > ?)) ORDER BY CreateAt, UserId ASC LIMIT 100. Used for batch migration.

### determineMaxDraftSize

```sql
SELECT COALESCE(character_maximum_length, 0)
FROM information_schema.columns
WHERE table_name = 'drafts' AND column_name = 'message'
```

Uses result to compute max draft size (bytes/4 for runes). Cached via sync.Once.

### GetMaxDraftSize

Returns cached value from **determineMaxDraftSize** (no SQL when cached).
