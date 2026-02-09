# Property Field Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/property_field_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PropertyFields table

### Create

INSERT into PropertyFields (GroupId, Id, Name, Type, TargetType, TargetId, CreateAt, UpdateAt, DeleteAt, ...). Returns created field.

### Get

Select from PropertyFields WHERE GroupId = ? AND Id = ?.

### GetFieldByName

Select from PropertyFields WHERE GroupId = ? AND TargetId = ? AND Name = ? (and optional DeleteAt = 0).

### GetMany

Select from PropertyFields WHERE GroupId = ? AND Id IN (?).

### CountForGroup

```sql
SELECT COUNT(*) FROM PropertyFields WHERE GroupId = ?
```
Optional IncludeDeleted.

### CountForTarget

```sql
SELECT COUNT(*) FROM PropertyFields WHERE GroupId = ? AND TargetType = ? AND TargetId = ?
```
Optional IncludeDeleted.

### SearchPropertyFields

Select from PropertyFields with filters (group, target, name, type); ORDER BY, LIMIT.

### Update

For each field: UPDATE PropertyFields SET ... WHERE GroupId = ? AND Id = ?. In transaction.

### Delete

```sql
DELETE FROM PropertyFields WHERE GroupId = ? AND Id = ?
```
Or soft-delete: UPDATE PropertyFields SET DeleteAt = ? WHERE ...
