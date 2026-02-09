# Upload Session Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/upload_session_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlUploadSessionStore

Builds **uploadSessionQuery** (not executed by this function):

```sql
SELECT Id, Type, CreateAt, UserId, ChannelId, Filename, Path, FileSize, FileOffset, RemoteId, ReqFileId
FROM UploadSessions
```

---

## CRUD

### Save

```sql
INSERT INTO UploadSessions (Id, Type, CreateAt, UserId, ChannelId, Filename, Path, FileSize, FileOffset, RemoteId, ReqFileId)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

### Update

```sql
UPDATE UploadSessions
SET Type = ?, CreateAt = ?, UserId = ?, ChannelId = ?, Filename = ?, Path = ?,
    FileSize = ?, FileOffset = ?, RemoteId = ?, ReqFileId = ?
WHERE Id = ?
```

### Get

**uploadSessionQuery** WHERE Id = ?.

### GetForUser

**uploadSessionQuery** WHERE UserId = ? ORDER BY CreateAt ASC.

### Delete

```sql
DELETE FROM UploadSessions WHERE Id = ?
```

### GetForUserByChannel

**uploadSessionQuery** WHERE UserId = ? AND ChannelId = ? ORDER BY CreateAt ASC.
