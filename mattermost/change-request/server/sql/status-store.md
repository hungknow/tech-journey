# Status Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/status_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlStatusStore

Builds select from **Status** table (UserId, Status, Manual, LastActivityAt, DNDEndTime, PrevStatus). Not executed by this function.

---

## Save and update

### SaveOrUpdate

Upsert by UserId.

```sql
INSERT INTO Status (UserId, Status, Manual, LastActivityAt, DNDEndTime, PrevStatus, ...)
VALUES (...)
ON CONFLICT (UserId) DO UPDATE SET
  Status = EXCLUDED.Status,
  Manual = EXCLUDED.Manual,
  LastActivityAt = EXCLUDED.LastActivityAt,
  DNDEndTime = EXCLUDED.DNDEndTime,
  PrevStatus = EXCLUDED.PrevStatus
```

### SaveOrUpdateMany

Same upsert for multiple statuses (batch insert/conflict update).

### UpdateLastActivityAt

```sql
UPDATE Status SET LastActivityAt = ? WHERE UserId = ?
```

### UpdateExpiredDNDStatuses

Update statuses where DNDEndTime < now and Status = dnd; set Status = PrevStatus (or offline). Returns updated list.

### ResetAll

```sql
UPDATE Status SET Status = ? WHERE Manual = false
```
(Sets non-manual statuses to offline.)

---

## Read and analytics

### Get

Select from Status WHERE UserId = ?.

### GetByIds

Select from Status WHERE UserId IN (?).

### GetTotalActiveUsersCount

```sql
SELECT COUNT(*) FROM Status WHERE Status != 'offline'
-- optional: AND LastActivityAt > ?
```

---

## No-op (no SQL)

### InvalidateCache

No SQL. Cache invalidation only.
