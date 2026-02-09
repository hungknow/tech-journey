# System Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/system_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlSystemStore

Builds **systemSelectQuery** (not executed by this function):

```sql
SELECT Name, Value
FROM Systems
```

---

## CRUD

### Save

```sql
INSERT INTO Systems (Name, Value) VALUES (:Name, :Value)
```

### SaveOrUpdate

Insert with `ON CONFLICT (name) DO UPDATE SET Value = ?`. Upsert by Name.

### Update

```sql
UPDATE Systems SET Value=:Value WHERE Name=:Name
```

### Get / GetWithContext

Select all rows: **systemSelectQuery**; returns StringMap (name → value).

### GetByName / GetByNameWithContext

**systemSelectQuery** WHERE Name = ?.

### PermanentDeleteByName

```sql
DELETE FROM Systems WHERE Name = ?
```

### InsertIfExists

Inside transaction: get by name; if exists do nothing (or return existing); else:

```sql
INSERT INTO Systems (Name, Value) VALUES (:Name, :Value)
```
