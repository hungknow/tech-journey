# Bot Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/bot_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlBotStore

Builds reusable select builder (not executed by this function):

- **botsQuery**:

```sql
SELECT b.UserId, u.Username, u.FirstName AS DisplayName, b.Description, b.OwnerId,
       COALESCE(b.LastIconUpdate, 0) AS LastIconUpdate, b.CreateAt, b.UpdateAt, b.DeleteAt
FROM Bots b
JOIN Users u ON (u.Id = b.UserId)
```

---

## CRUD and lifecycle

### Get

Raw SQL: select bot + user fields from Bots b JOIN Users u ON u.Id = b.UserId WHERE b.UserId = ? with optional `AND b.DeleteAt = 0` (when not includeDeleted).

```sql
SELECT b.UserId, u.Username, u.FirstName AS DisplayName, b.Description, b.OwnerId,
       COALESCE(b.LastIconUpdate, 0) AS LastIconUpdate, b.CreateAt, b.UpdateAt, b.DeleteAt
FROM Bots b JOIN Users u ON (u.Id = b.UserId)
WHERE b.UserId = ?
```

### GetAll

Raw SQL: same select from Bots b JOIN Users u; optional WHERE b.DeleteAt = 0, b.OwnerId = ?, and for OnlyOrphaned: JOIN Users o ON o.Id = b.OwnerId and o.DeleteAt != 0. ORDER BY b.CreateAt ASC, u.Username ASC LIMIT ? OFFSET ?.

### Save

```sql
INSERT INTO Bots
(UserId, Description, OwnerId, LastIconUpdate, CreateAt, UpdateAt, DeleteAt)
VALUES
(:UserId, :Description, :OwnerId, :LastIconUpdate, :CreateAt, :UpdateAt, :DeleteAt)
```

### Update

Read with Get(userId, true); then:

```sql
UPDATE Bots
SET Description=:Description, OwnerId=:OwnerId, LastIconUpdate=:LastIconUpdate,
    UpdateAt=:UpdateAt, DeleteAt=:DeleteAt
WHERE UserId=:UserId
```

### PermanentDelete

```sql
DELETE FROM Bots WHERE UserId = ?
```

### GetAllAfter

**botsQuery** WHERE b.UserId > ? ORDER BY b.UserId ASC LIMIT ?.

### GetByUsername

**botsQuery** WHERE u.Username = lower(?).
