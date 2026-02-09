# Post Acknowledgements Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/post_acknowledgements_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## CRUD

### Get

Select PostId, UserId, ChannelId, AcknowledgedAt, RemoteId from PostAcknowledgements WHERE PostId = ? AND UserId = ? AND AcknowledgedAt != 0.

### SaveWithModel

Inside transaction: **buildUpsertQuery** (INSERT into PostAcknowledgements with ON CONFLICT DO UPDATE or equivalent); then **updatePost** (update Posts table for acknowledgement count/timestamp). Upsert by (PostId, UserId).

### Delete

Inside transaction: then **updatePost** for the post.

```sql
UPDATE PostAcknowledgements SET AcknowledgedAt = 0 WHERE PostId = ? AND UserId = ?
```

### DeleteAllForPost

```sql
DELETE FROM PostAcknowledgements WHERE PostId = ?
```
Or UPDATE AcknowledgedAt = 0.

### GetAcknowledgementsForPost

Select from PostAcknowledgements WHERE PostId = ? AND AcknowledgedAt != 0. Returns list.

### GetAcknowledgementsForPosts

Batch: PostAcknowledgements WHERE PostId IN (?) AND AcknowledgedAt != 0. Returns map post id → acknowledgements.
