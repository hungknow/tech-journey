# Webhook Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/webhook_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlWebhookStore

Builds **incomingWebhookSelectQuery** from IncomingWebhooks and **outgoingWebhookSelectQuery** from OutgoingWebhooks. Not executed by this function.

---

## Incoming Webhooks

### SaveIncoming

```sql
INSERT INTO IncomingWebhooks (Id, CreateAt, UpdateAt, DeleteAt, UserId, ChannelId, TeamId, DisplayName, Description, ...) VALUES (:Id, ...)
```

### UpdateIncoming

```sql
UPDATE IncomingWebhooks SET ... WHERE Id = :Id
```
Named params.

### GetIncoming

**incomingWebhookSelectQuery** WHERE Id = ? (and optional DeleteAt = 0).

### DeleteIncoming

Soft-delete.

```sql
UPDATE IncomingWebhooks SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

### PermanentDeleteIncomingByUser

```sql
DELETE FROM IncomingWebhooks WHERE UserId = ?
```

### PermanentDeleteIncomingByChannel

```sql
DELETE FROM IncomingWebhooks WHERE ChannelId = ?
```

### GetIncomingList / GetIncomingListByUser / GetIncomingByTeamByUser / GetIncomingByTeam / GetIncomingByChannel

**incomingWebhookSelectQuery** with filters (DeleteAt = 0, UserId, TeamId, ChannelId), ORDER BY, LIMIT/OFFSET.

---

## Outgoing Webhooks

### SaveOutgoing

```sql
INSERT INTO OutgoingWebhooks (Id, CreateAt, UpdateAt, DeleteAt, CreatorId, ...) VALUES (:Id, ...)
```

### UpdateOutgoing

```sql
UPDATE OutgoingWebhooks SET ... WHERE Id = :Id
```
Named params.

### GetOutgoing

**outgoingWebhookSelectQuery** WHERE Id = ? (and optional DeleteAt = 0).

### DeleteOutgoing

Soft-delete: UPDATE OutgoingWebhooks SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?.

### PermanentDeleteOutgoingByUser

```sql
DELETE FROM OutgoingWebhooks WHERE CreatorId = ?
```

### PermanentDeleteOutgoingByChannel

```sql
DELETE FROM OutgoingWebhooks WHERE ChannelId = ?
```

### GetOutgoingList / GetOutgoingListByUser / GetOutgoingByChannelByUser / GetOutgoingByChannel / GetOutgoingByTeamByUser / GetOutgoingByTeam

**outgoingWebhookSelectQuery** with filters (DeleteAt = 0, CreatorId, ChannelId, TeamId), ORDER BY, LIMIT/OFFSET.

---

## Analytics

### AnalyticsIncomingCount

```sql
SELECT COUNT(*) FROM IncomingWebhooks WHERE DeleteAt = 0
```
Optional TeamId, UserId.

### AnalyticsOutgoingCount

```sql
SELECT COUNT(*) FROM OutgoingWebhooks WHERE DeleteAt = 0
```
Optional TeamId.

---

## No-op (no SQL)

### ClearCaches

No SQL.

### InvalidateWebhookCache

No SQL. Cache invalidation only.
