# Audit Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/audit_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlAuditStore

Builds reusable select builder (not executed by this function):

- **auditQuery**:

```sql
SELECT Id, CreateAt, UserId, Action, ExtraInfo, IpAddress, SessionId
FROM Audits
```

---

## CRUD and lifecycle

### Save

Insert one audit row with named parameters:

```sql
INSERT INTO Audits
(Id, CreateAt, UserId, Action, ExtraInfo, IpAddress, SessionId)
VALUES
(:Id, :CreateAt, :UserId, :Action, :ExtraInfo, :IpAddress, :SessionId)
```

### Get

Select audits using **auditQuery** with optional `WHERE UserId = ?`, `ORDER BY CreateAt DESC`, `LIMIT ? OFFSET ?`. Limit is capped at 1000.

### PermanentDeleteByUser

Delete all audits for a user:

```sql
DELETE FROM Audits WHERE UserId = ?
```
