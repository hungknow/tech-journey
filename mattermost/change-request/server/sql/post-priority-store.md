# Post Priority Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/post_priority_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PostsPriority table

### GetForPost

Select from PostsPriority WHERE PostId = ?. Returns single PostPriority.

### GetForPosts

Select from PostsPriority WHERE PostId IN (?). Returns list.

### Save

Insert into PostsPriority (PostId, ChannelId, Priority, RequestedAck, PersistentNotifications, ...) with ON CONFLICT DO UPDATE or equivalent. Upsert by PostId.

### Delete

```sql
DELETE FROM PostsPriority WHERE PostId = ?
```
Or UPDATE to clear.
