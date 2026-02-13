# Role Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/role_store.go` and the real SQL executed by that function. Each SQL line ≤120 chars. Placeholders: `?` (MySQL) or `$1`,`$2` (PostgreSQL); named `:Name` for NamedExec.

---

## Initialization

### newSqlRoleStore

Builds select from **Roles** (Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn). Not executed by this function.

---

## Table select (base query)

Used by Get, GetAll, GetByName, GetByNames, Delete (read-before-write).

```sql
SELECT Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn
FROM Roles
```

---

## Roles table — CRUD

### Save

If new (no Id): **createRole** inside transaction. If existing: UPDATE.

#### Create (new role, no Id)

```sql
INSERT INTO Roles (Id, Name, DisplayName, Description, Permissions, CreateAt, UpdateAt, DeleteAt, SchemeManaged, BuiltIn)
VALUES (:Id, :Name, :DisplayName, :Description, :Permissions, :CreateAt, :UpdateAt, :DeleteAt, :SchemeManaged, :BuiltIn)
```

#### Update (existing role)

```sql
UPDATE Roles SET UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, CreateAt=:CreateAt, Name=:Name, DisplayName=:DisplayName,
Description=:Description, Permissions=:Permissions, SchemeManaged=:SchemeManaged, BuiltIn=:BuiltIn WHERE Id=:Id
```

### Get

```sql
SELECT Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn
FROM Roles WHERE Id = ?
```

### GetAll

```sql
SELECT Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn
FROM Roles
```

(No ORDER BY in code.)

### GetByName

```sql
SELECT Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn
FROM Roles WHERE Name = ?
```

### GetByNames

```sql
SELECT Id, Name, DisplayName, Description, CreateAt, UpdateAt, DeleteAt, Permissions, SchemeManaged, BuiltIn
FROM Roles WHERE Name IN (?)
```

(One placeholder; driver expands for multiple names.)

### Delete

Soft-delete: read (same as Get by Id), then:

```sql
UPDATE Roles SET UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, CreateAt=:CreateAt, Name=:Name, DisplayName=:DisplayName,
Description=:Description, Permissions=:Permissions, SchemeManaged=:SchemeManaged, BuiltIn=:BuiltIn WHERE Id=:Id
```

### PermanentDeleteAll

```sql
DELETE FROM Roles
```

---

## Permissions and schemes

### ChannelHigherScopedPermissions

**channelHigherScopedPermissionsQuery** builds SQL: role names interpolated into `'%[1]s'`; then `channel_guest`, `channel_user`, `channel_admin` for `%[2]s`,`%[3]s`,`%[4]s`. Example with `'channel_user','channel_admin'`:

```sql
SELECT '' AS GuestRoleName, RoleSchemes.DefaultChannelUserRole AS UserRoleName,
RoleSchemes.DefaultChannelAdminRole AS AdminRoleName, '' AS HigherScopedGuestPermissions,
UserRoles.Permissions AS HigherScopedUserPermissions, AdminRoles.Permissions AS HigherScopedAdminPermissions
FROM Schemes AS RoleSchemes JOIN Channels ON Channels.SchemeId = RoleSchemes.Id
JOIN Teams ON Teams.Id = Channels.TeamId JOIN Schemes ON Schemes.Id = Teams.SchemeId
RIGHT JOIN Roles AS UserRoles ON UserRoles.Name = Schemes.DefaultChannelUserRole
RIGHT JOIN Roles AS AdminRoles ON AdminRoles.Name = Schemes.DefaultChannelAdminRole
WHERE RoleSchemes.DefaultChannelUserRole IN ('channel_user','channel_admin')
OR RoleSchemes.DefaultChannelAdminRole IN ('channel_user','channel_admin')
UNION
SELECT RoleSchemes.DefaultChannelGuestRole AS GuestRoleName, '' AS UserRoleName, '' AS AdminRoleName,
GuestRoles.Permissions AS HigherScopedGuestPermissions, '' AS HigherScopedUserPermissions,
'' AS HigherScopedAdminPermissions FROM Schemes AS RoleSchemes
JOIN Channels ON Channels.SchemeId = RoleSchemes.Id JOIN Teams ON Teams.Id = Channels.TeamId
JOIN Schemes ON Schemes.Id = Teams.SchemeId
RIGHT JOIN Roles AS GuestRoles ON GuestRoles.Name = Schemes.DefaultChannelGuestRole
WHERE RoleSchemes.DefaultChannelGuestRole IN ('channel_user','channel_admin')
UNION
SELECT Schemes.DefaultChannelGuestRole, Schemes.DefaultChannelUserRole, Schemes.DefaultChannelAdminRole,
GuestRoles.Permissions AS HigherScopedGuestPermissions, UserRoles.Permissions AS HigherScopedUserPermissions,
AdminRoles.Permissions AS HigherScopedAdminPermissions FROM Schemes
JOIN Channels ON Channels.SchemeId = Schemes.Id JOIN Teams ON Teams.Id = Channels.TeamId
JOIN Roles AS GuestRoles ON GuestRoles.Name = 'channel_guest' JOIN Roles AS UserRoles ON UserRoles.Name = 'channel_user'
JOIN Roles AS AdminRoles ON AdminRoles.Name = 'channel_admin'
WHERE (Schemes.DefaultChannelGuestRole IN ('channel_user','channel_admin')
OR Schemes.DefaultChannelUserRole IN ('channel_user','channel_admin')
OR Schemes.DefaultChannelAdminRole IN ('channel_user','channel_admin'))
AND (Teams.SchemeId = '' OR Teams.SchemeId IS NULL)
```

### AllChannelSchemeRoles

Select from Roles join Schemes (channel scope); roles that are default channel roles in schemes.

```sql
SELECT Roles.Id, Roles.Name, Roles.DisplayName, Roles.Description, Roles.CreateAt, Roles.UpdateAt, Roles.DeleteAt,
Roles.Permissions, Roles.SchemeManaged, Roles.BuiltIn FROM Schemes
JOIN Roles ON Schemes.DefaultChannelGuestRole = Roles.Name OR Schemes.DefaultChannelUserRole = Roles.Name
OR Schemes.DefaultChannelAdminRole = Roles.Name WHERE Schemes.Scope = ? AND Roles.DeleteAt = 0 AND Schemes.DeleteAt = 0
```

(Scope placeholder = `channel`.)

### ChannelRolesUnderTeamRole

Select channel roles that are under a given team role (scheme hierarchy).

```sql
SELECT ChannelSchemeRoles.Id, ChannelSchemeRoles.Name, ChannelSchemeRoles.DisplayName, ChannelSchemeRoles.Description,
ChannelSchemeRoles.CreateAt, ChannelSchemeRoles.UpdateAt, ChannelSchemeRoles.DeleteAt, ChannelSchemeRoles.Permissions,
ChannelSchemeRoles.SchemeManaged, ChannelSchemeRoles.BuiltIn FROM Roles AS HigherScopedRoles
JOIN Schemes AS HigherScopedSchemes ON (HigherScopedRoles.Name = HigherScopedSchemes.DefaultChannelGuestRole
OR HigherScopedRoles.Name = HigherScopedSchemes.DefaultChannelUserRole
OR HigherScopedRoles.Name = HigherScopedSchemes.DefaultChannelAdminRole)
JOIN Teams ON Teams.SchemeId = HigherScopedSchemes.Id JOIN Channels ON Channels.TeamId = Teams.Id
JOIN Schemes AS ChannelSchemes ON Channels.SchemeId = ChannelSchemes.Id
JOIN Roles AS ChannelSchemeRoles ON (ChannelSchemeRoles.Name = ChannelSchemes.DefaultChannelGuestRole
OR ChannelSchemeRoles.Name = ChannelSchemes.DefaultChannelUserRole
OR ChannelSchemeRoles.Name = ChannelSchemes.DefaultChannelAdminRole)
WHERE HigherScopedSchemes.Scope = ? AND HigherScopedRoles.Name = ? AND HigherScopedRoles.DeleteAt = 0
AND HigherScopedSchemes.DeleteAt = 0 AND Teams.DeleteAt = 0 AND Channels.DeleteAt = 0
AND ChannelSchemes.DeleteAt = 0 AND ChannelSchemeRoles.DeleteAt = 0
```

(First ? = team scope, second ? = role name, e.g. `team_user`.)

---

## Example role names (Name column)

| Scope   | Guest           | User            | Admin             |
|--------|-----------------|-----------------|-------------------|
| System | system_guest    | system_user     | system_admin      |
| Team   | team_guest      | team_user       | team_admin        |
| Channel| channel_guest   | channel_user    | channel_admin     |

Other system: `system_post_all`, `system_post_all_public`, `system_user_access_token`, `system_user_manager`, `system_read_only_admin`, `system_manager`, `system_custom_group_admin`.  
Team: `team_post_all`, `team_post_all_public`.  
Example custom/scheme: `tscheme_guest`, `tscheme_user`, `tscheme_admin` (scheme-derived names).

---

## Example row (Roles table)

| Column        | Example value |
|---------------|----------------|
| Id            | (26-char model.NewId()) |
| Name          | system_user    |
| DisplayName   | automatic     |
| Description   | ...           |
| CreateAt      | 1640000000000 |
| UpdateAt      | 1640000000000 |
| DeleteAt      | 0             |
| Permissions   | ` create_post edit_post ...` (space-separated) |
| SchemeManaged | false         |
| BuiltIn       | true          |
