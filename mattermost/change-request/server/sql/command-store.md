# Command Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/command_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlCommandStore

Builds reusable select builder and column list (not executed by this function):

- **commandColumns**: Id, Token, CreateAt, UpdateAt, DeleteAt, CreatorId, TeamId, trigger, Method, Username, IconURL, AutoComplete, AutoCompleteDesc, AutoCompleteHint, DisplayName, Description, URL, PluginId
- **commandsQuery**:

```sql
SELECT Id, Token, CreateAt, UpdateAt, DeleteAt, CreatorId, TeamId, trigger, Method, Username, IconURL, AutoComplete, AutoCompleteDesc, AutoCompleteHint, DisplayName, Description, URL, PluginId
FROM Commands
```

---

## CRUD and lifecycle

### Save

Id must be empty.

```sql
INSERT INTO Commands (Id, Token, CreateAt, UpdateAt, DeleteAt, CreatorId, TeamId, trigger, ...) VALUES (?, ...)
```

### Get

**commandsQuery** `WHERE Id = ? AND DeleteAt = 0`.

### GetByTeam

**commandsQuery** `WHERE TeamId = ? AND DeleteAt = 0`.

### GetByTrigger

**commandsQuery** `WHERE TeamId = ? AND DeleteAt = 0 AND "trigger" = ?`.

### Update

```sql
UPDATE Commands
SET Token = ?, CreateAt = ?, UpdateAt = ?, CreatorId = ?, TeamId = ?, trigger = ?, Method = ?, Username = ?, IconURL = ?, AutoComplete = ?, AutoCompleteDesc = ?, AutoCompleteHint = ?, DisplayName = ?, Description = ?, URL = ?, PluginId = ?
WHERE Id = ?
```

### Delete

Soft-delete:

```sql
UPDATE Commands SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

### PermanentDeleteByTeam

```sql
DELETE FROM Commands WHERE TeamId = ?
```

### PermanentDeleteByUser

```sql
DELETE FROM Commands WHERE CreatorId = ?
```

---

## Analytics

### AnalyticsCommandCount

```sql
SELECT COUNT(*) FROM Commands WHERE DeleteAt = 0
```
Optional TeamId = ?.
