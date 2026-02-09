# Role Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/role_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlRoleStore

Builds select from **Roles** (Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged). Not executed by this function.

---

## Roles table — CRUD

### Save

If new (no Id): **createRole** inside transaction. If existing: UPDATE.

```sql
INSERT INTO Roles (Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged)
VALUES (:Id, :Name, ...)
```

```sql
UPDATE Roles SET Name = ?, DisplayName = ?, ... WHERE Id = ?
```

### Get

Select from Roles WHERE Id = ?.

### GetAll

Select from Roles (optional DeleteAt = 0). ORDER BY Name.

### GetByName

Select from Roles WHERE Name = ?.

### GetByNames

Select from Roles WHERE Name IN (?).

### Delete

Soft-delete: UPDATE Roles SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?. Returns role before delete.

### PermanentDeleteAll

```sql
DELETE FROM Roles
```

---

## Permissions and schemes

### ChannelHigherScopedPermissions

Raw/subquery: permissions for channel roles that are higher scoped (e.g. team scheme roles). **channelHigherScopedPermissionsQuery** builds SQL for role names. Returns map role name → permissions.

### AllChannelSchemeRoles

Select from Roles join Schemes (channel scope); roles that are default channel roles in schemes.

### ChannelRolesUnderTeamRole

Select channel roles that are under a given team role (scheme hierarchy).
