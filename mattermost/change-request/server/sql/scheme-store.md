# Scheme Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/scheme_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlSchemeStore

Builds reusable select builder (not executed by this function):

- **schemeSelectQuery**:

```sql
SELECT Id, Name, DisplayName, Description, Scope, DefaultTeamAdminRole, DefaultTeamUserRole, DefaultTeamGuestRole,
       DefaultChannelAdminRole, DefaultChannelUserRole, DefaultChannelGuestRole, CreateAt, UpdateAt, DeleteAt,
       DefaultPlaybookAdminRole, DefaultPlaybookMemberRole, DefaultRunAdminRole, DefaultRunMemberRole
FROM Schemes
```

---

## CRUD and lifecycle

### Save

If Id is empty: transaction with **createScheme** (insert scheme + create default roles via Role store). If Id set:

```sql
UPDATE Schemes SET UpdateAt = ?, Name = ?, DisplayName = ?, ... DefaultRunAdminRole = ... WHERE Id = :Id
```

### createScheme

Used inside Save for new schemes. Fetches default system roles; creates scheme-specific roles (Team/Channel/Playbook/Run admin and member/guest) via Role store **createRole**; then INSERT into Schemes with those role names. Not called alone.

### Get

**schemeSelectQuery** WHERE Id = ?.

### GetByName

**schemeSelectQuery** WHERE Name = ?; optional DeleteAt = 0.

### GetAllPage

**schemeSelectQuery** with optional Scope = ?; ORDER BY CreateAt DESC LIMIT/OFFSET.

### GetPage

**schemeSelectQuery** with optional Scope, IncludeDeleted; ORDER BY CreateAt DESC LIMIT/OFFSET.

### Delete

Soft-delete:

```sql
UPDATE Schemes SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

### PermanentDeleteAll

```sql
DELETE FROM Schemes
```

### Restore

```sql
UPDATE Schemes SET DeleteAt = 0, UpdateAt = ? WHERE Id = ?
```

### CountByScope

```sql
SELECT COUNT(*) FROM Schemes WHERE Scope = ?
```
Optional DeleteAt = 0.

### CountWithoutPermission

Count schemes that lack a given permission (subquery on Roles for permission). Used for migration/audit.
