# License Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/license_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## CRUD and listing

### Save

Only inserts if no row with same Id exists.

```sql
INSERT INTO Licenses (Id, CreateAt, Bytes) VALUES (?, ?, ?)
ON CONFLICT (Id) DO NOTHING
```

### Get

```sql
SELECT Id, CreateAt, Bytes FROM Licenses WHERE Id = ?
```

### GetAll

```sql
SELECT Id, CreateAt, Bytes FROM Licenses
```
