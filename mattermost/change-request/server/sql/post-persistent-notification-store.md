# Post Persistent Notification Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/post_persistent_notification_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PersistentNotifications table

### GetSingle

Select from PersistentNotifications WHERE PostId = ? (or equivalent). Returns single post persistent notification.

### Get

Select from PersistentNotifications with filters (params: user, channel, team, since, etc.); ORDER BY, LIMIT/OFFSET. Returns list.

### UpdateLastActivity

```sql
UPDATE PersistentNotifications SET LastActivityAt = ? WHERE PostId IN (?)
```

### Delete

```sql
DELETE FROM PersistentNotifications WHERE PostId IN (?)
```
Or UPDATE to soft-delete.

### DeleteExpired

Delete rows where SentCount >= maxSentCount or similar expiry condition.

### DeleteByChannel

```sql
DELETE FROM PersistentNotifications
WHERE PostId IN (SELECT Id FROM Posts WHERE ChannelId IN (?))
```

Alternatively implemented via join on Posts by ChannelId.

### DeleteByTeam

Delete from PersistentNotifications where post belongs to team (via Posts join Channels/TeamId).
