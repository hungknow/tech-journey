# Command Webhook Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/command_webhook_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlCommandWebhookStore

Builds reusable select builder and column list (not executed by this function):

- **commandWebhookColumns**: Id, CreateAt, CommandId, UserId, ChannelId, RootId, UseCount
- **commandWebhookQuery**:

```sql
SELECT Id, CreateAt, CommandId, UserId, ChannelId, RootId, UseCount
FROM CommandWebhooks
```

---

## CRUD and lifecycle

### Save

Id must be empty; PreSave sets Id and CreateAt.

```sql
INSERT INTO CommandWebhooks (Id, CreateAt, CommandId, UserId, ChannelId, RootId, UseCount)
VALUES (?, ?, ?, ?, ?, ?, ?)
```

### Get

**commandWebhookQuery** WHERE Id = ? AND CreateAt > exptime (exptime = now - CommandWebhookLifetime). Returns only non-expired webhooks.

### TryUse

Fails if no row updated (expired or already at limit).

```sql
UPDATE CommandWebhooks SET UseCount = UseCount + 1 WHERE Id = ? AND UseCount < ?
```

### Cleanup

Removes expired webhooks (exptime = now - CommandWebhookLifetime).

```sql
DELETE FROM CommandWebhooks WHERE CreateAt < ?
```
