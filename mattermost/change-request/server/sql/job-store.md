# Job Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/job_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlJobStore

Builds reusable select builder and column list (not executed by this function):

- **jobColumns**: Id, Type, Priority, CreateAt, StartAt, LastActivityAt, Status, Progress, Data
- **jobQuery**:

```sql
SELECT Id, Type, Priority, CreateAt, StartAt, LastActivityAt, Status, Progress, Data
FROM Jobs
```

---

## CRUD and lifecycle

### Save

```sql
INSERT INTO Jobs (Id, Type, Priority, CreateAt, StartAt, LastActivityAt, Status, Progress, Data)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
```
Data is JSON (optional binary flag).

### SaveOnce

Inside serializable transaction: if count > 0, return nil; else same INSERT as **Save**. Used to avoid duplicate job types.

```sql
SELECT COUNT(*) FROM Jobs
WHERE Status IN ('pending', 'in_progress') AND Type = ?
```

### UpdateOptimistically

Returns true only if exactly one row affected.

```sql
UPDATE Jobs
SET LastActivityAt = ?, Status = ?, Data = ?, Progress = ?
WHERE Id = ? AND Status = ?
```

### UpdateStatus

```sql
UPDATE Jobs SET Status=:Status, LastActivityAt=:LastActivityAt WHERE Id=:Id
```

### UpdateStatusOptimistically

Returns updated job or nil if no row updated (uses RETURNING).

```sql
UPDATE Jobs
SET LastActivityAt = ?, Status = ?, ...
WHERE Id = ? AND Status = ?
RETURNING ...
```

### Get

**jobQuery** WHERE Id = ?.

### GetAllByTypesPage

**jobQuery** WHERE Type IN (?) ORDER BY CreateAt DESC LIMIT ? OFFSET ?.

### GetAllByType

**jobQuery** WHERE Type = ? ORDER BY CreateAt DESC.

### GetAllByTypeAndStatus

**jobQuery** WHERE Type = ? AND Status = ? ORDER BY CreateAt DESC.

### GetAllByTypePage

**jobQuery** WHERE Type = ? ORDER BY CreateAt DESC LIMIT ? OFFSET ?.

### GetAllByStatus

**jobQuery** WHERE Status = ? ORDER BY CreateAt ASC.

### GetAllByTypesAndStatusesPage

**jobQuery** WHERE Type IN (?) AND Status IN (?) ORDER BY CreateAt DESC LIMIT ? OFFSET ?.

### GetNewestJobByStatusAndType / GetNewestJobByStatusesAndType

**jobQuery** WHERE Status IN (?) AND Type = ? ORDER BY CreateAt DESC LIMIT 1.

### GetCountByStatusAndType

```sql
SELECT COUNT(*) FROM Jobs
WHERE Status = ? AND Type = ?
```

### GetByTypeAndData

**jobQuery** WHERE Type = ? and optional Status IN (?); for each key in data, `Data->key = value`. Can use master for consistency.

### Delete

```sql
DELETE FROM Jobs WHERE Id = ?
```

### Cleanup

Loop until no rows affected (exclude InProgress and Pending).

```sql
DELETE FROM Jobs
WHERE Id IN (
  SELECT Id FROM Jobs
  WHERE CreateAt < ? AND Status NOT IN (?, ?)
  ORDER BY CreateAt ASC
  LIMIT ?
)
```
