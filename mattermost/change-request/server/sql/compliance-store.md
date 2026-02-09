# Compliance Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/compliance_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlComplianceStore

Builds reusable select builder (not executed by this function):

- **tableSelectQuery**:

```sql
SELECT Id, CreateAt, UserId, Status, Count, "desc", Type, StartAt, EndAt, Keywords, Emails
FROM Compliances
```

---

## CRUD and listing

### Save

```sql
INSERT INTO Compliances (Id, CreateAt, UserId, Status, Count, "desc", Type, StartAt, EndAt, Keywords, Emails)
VALUES (:Id, :CreateAt, :UserId, :Status, :Count, :Desc, :Type, :StartAt, :EndAt, :Keywords, :Emails)
```

(Column name "desc" is reserved; store uses toReserveCase.)

### Update

```sql
UPDATE Compliances
SET CreateAt = ?, UserId = ?, Status = ?, Count = ?, "desc" = ?, Type = ?,
    StartAt = ?, EndAt = ?, Keywords = ?, Emails = ?
WHERE Id = ?
```

### GetAll

**tableSelectQuery** ORDER BY CreateAt DESC LIMIT ? OFFSET ?.

### Get

**tableSelectQuery** WHERE Id = ?.

---

## Export

### ComplianceExport

Two raw SQL queries (channel posts, then direct message posts) with dynamic keyword and email filters.

**Channel posts:**

```sql
SELECT Teams.Name, Teams.DisplayName, Channels.*, Users.Username, Users.Email, Users.Nickname,
       Posts.*, Bots.UserId IS NOT NULL AS IsBot
FROM Teams, Channels, Users, Posts
LEFT JOIN Bots ON Bots.UserId = Posts.UserId
WHERE Teams.Id = Channels.TeamId
  AND Posts.ChannelId = Channels.Id
  AND Posts.UserId = Users.Id
  AND (Posts.CreateAt > ? OR (Posts.CreateAt = ? AND Posts.Id > ?))
  AND Posts.CreateAt < ?
  -- optional: AND Users.Email = ?
  -- optional: AND LOWER(Posts.Message) LIKE ?
ORDER BY Posts.CreateAt, Posts.Id
LIMIT ?
```

**Direct message posts:** Same shape with TeamName = 'direct-messages', TeamDisplayName = 'Direct Messages', Channels.TeamId = ''; no Teams join. Same cursor, email, keyword, ORDER BY, LIMIT.

### MessageExport

Query builder shape:

```sql
SELECT Posts.*, Teams.*, Channels.*, Users.*,
       Bots.UserId IS NOT NULL AS IsBot,
       CASE ... END AS ChannelDisplayName
FROM Posts
LEFT JOIN Channels ON ...
LEFT JOIN Teams ON ...
LEFT JOIN Users ON ...
LEFT JOIN Bots ON ...
WHERE (Posts.UpdateAt > ? OR (Posts.UpdateAt = ? AND Posts.Id > ?))
  AND Posts.Type NOT LIKE 'system_%'
  -- optional: AND Posts.UpdateAt <= ?
ORDER BY Posts.UpdateAt, Posts.Id
LIMIT ?
```
