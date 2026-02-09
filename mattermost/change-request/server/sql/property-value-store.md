# Property Value Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/property_value_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PropertyValues table

### Create

INSERT into PropertyValues (GroupId, Id, FieldId, TargetType, TargetId, Value, CreateAt, UpdateAt). Returns created value.

### CreateMany

Batch INSERT into PropertyValues for multiple values.

### Get

Select from PropertyValues WHERE GroupId = ? AND Id = ?.

### GetMany

Select from PropertyValues WHERE GroupId = ? AND Id IN (?).

### SearchPropertyValues

Select from PropertyValues (and optionally PropertyFields) with filters (group, field, target type/id, term); ORDER BY, LIMIT.

### Update

For each value: UPDATE PropertyValues SET ... WHERE GroupId = ? AND Id = ?. In transaction.

### Upsert

INSERT into PropertyValues with ON CONFLICT DO UPDATE for list of values. In transaction.

### Delete

```sql
DELETE FROM PropertyValues WHERE GroupId = ? AND Id = ?
```

### DeleteForField

```sql
DELETE FROM PropertyValues WHERE GroupId = ? AND FieldId = ?
```

### DeleteForTarget

```sql
DELETE FROM PropertyValues WHERE GroupId = ? AND TargetType = ? AND TargetId = ?
```
