# Shared Channel Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/shared_channel_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## SharedChannels table

### Save

Upsert or conflict handling.

```sql
INSERT INTO SharedChannels (ChannelId, TeamId, Home, ReadOnly, ShareName, ShareDisplayName, SharePurpose, ShareHeader, CreatorId, CreateAt, ...)
VALUES (...)
ON CONFLICT (ChannelId) DO UPDATE SET ...
```

### Get

```sql
SELECT * FROM SharedChannels WHERE ChannelId = ?
```

### HasChannel

Returns bool (or EXISTS).

```sql
SELECT COUNT(*) FROM SharedChannels WHERE ChannelId = ?
```

### GetAll / GetAllCount

**getSharedChannelsQuery**: select from SharedChannels with filters (TeamId, CreatorId, ...); ORDER BY, LIMIT/OFFSET. Count query same filters.

### Update

```sql
UPDATE SharedChannels SET ... WHERE ChannelId = ?
```

### Delete

Returns whether row existed.

```sql
DELETE FROM SharedChannels WHERE ChannelId = ?
```

---

## SharedChannelRemotes table

### SaveRemote / UpdateRemote

INSERT/UPDATE SharedChannelRemotes (Id, ChannelId, RemoteId, ...).

### GetRemote / GetRemoteByIds

Select from SharedChannelRemotes WHERE Id = ? or (ChannelId = ? AND RemoteId = ?).

### GetRemotes

Select from SharedChannelRemotes with filters; LIMIT/OFFSET.

### HasRemote

Count/Exists SharedChannelRemotes WHERE ChannelId = ? AND RemoteId = ?.

### UpdateRemoteCursor

```sql
UPDATE SharedChannelRemotes SET Cursor = ?, ... WHERE Id = ?
```

### DeleteRemote

```sql
DELETE FROM SharedChannelRemotes WHERE Id = ?
```

### GetRemotesStatus

Select status info for remotes of a channel (last sync, etc.).

---

## SharedChannelUsers table

### SaveUser

INSERT into SharedChannelUsers (UserId, ChannelId, RemoteId, ...) with ON CONFLICT DO UPDATE.

### GetSingleUser / GetUsersForUser

Select from SharedChannelUsers WHERE UserId = ?, ChannelId = ?, RemoteId = ?; or WHERE UserId = ?.

### GetUsersForSync

Select users to sync (SharedChannelUsers join Users) with filter.

### UpdateUserLastSyncAt / UpdateUserLastMembershipSyncAt

```sql
UPDATE SharedChannelUsers SET LastSyncAt = ? WHERE UserId = ? AND ChannelId = ? AND RemoteId = ?
```

---

## SharedChannelAttachments table

### SaveAttachment / UpsertAttachment

INSERT into SharedChannelAttachments (FileId, RemoteId, ...) with ON CONFLICT DO UPDATE.

### GetAttachment

Select from SharedChannelAttachments WHERE FileId = ? AND RemoteId = ?.

### UpdateAttachmentLastSyncAt

```sql
UPDATE SharedChannelAttachments SET LastSyncAt = ? WHERE Id = ?
```
