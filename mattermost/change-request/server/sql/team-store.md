# Team Store — SQL Reference

Real SQL executed by `server/channels/store/sqlstore/team_store.go`. Placeholders: `?` or `:Name`.

---

## Initialization (builder definitions, not executed alone)

### teamsQuery

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
```

### teamMembersQuery

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, TeamMembers.SchemeGuest, TeamMembers.CreateAt
FROM TeamMembers
```

### getTeamMembersWithSchemeSelectQuery

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, TeamMembers.SchemeGuest, TeamMembers.CreateAt,
  TeamScheme.DefaultTeamGuestRole TeamSchemeDefaultGuestRole,
  TeamScheme.DefaultTeamUserRole TeamSchemeDefaultUserRole,
  TeamScheme.DefaultTeamAdminRole TeamSchemeDefaultAdminRole
FROM TeamMembers
LEFT JOIN Teams ON TeamMembers.TeamId = Teams.Id
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
```

---

## Team CRUD and lifecycle

### Save

```sql
INSERT INTO Teams
  (Id, CreateAt, UpdateAt, DeleteAt, DisplayName, Name, Description, Email, Type,
   CompanyName, AllowedDomains, InviteId, AllowOpenInvite, LastTeamIconUpdate,
   SchemeId, GroupConstrained, CloudLimitsArchived)
VALUES
  (:Id, :CreateAt, :UpdateAt, :DeleteAt, :DisplayName, :Name, :Description, :Email, :Type,
   :CompanyName, :AllowedDomains, :InviteId, :AllowOpenInvite, :LastTeamIconUpdate,
   :SchemeId, :GroupConstrained, :CloudLimitsArchived)
```

### Update

```sql
UPDATE Teams
SET CreateAt=:CreateAt, UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, DisplayName=:DisplayName,
    Name=:Name, Description=:Description, Email=:Email, Type=:Type, CompanyName=:CompanyName,
    AllowedDomains=:AllowedDomains, InviteId=:InviteId, AllowOpenInvite=:AllowOpenInvite,
    LastTeamIconUpdate=:LastTeamIconUpdate, SchemeId=:SchemeId, GroupConstrained=:GroupConstrained,
    CloudLimitsArchived=:CloudLimitsArchived
WHERE Id=:Id
```

### Get

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE Id = ?
```

### GetMany

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE Teams.Id IN (?)
```

### GetByInviteId

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE InviteId = ?
```

### GetByEmptyInviteID

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE InviteId = ''
```

### GetByName

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE Name = ?
```

### GetByNames

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE Name IN (?)
```

### PermanentDelete

```sql
DELETE FROM Teams WHERE Id = ?
```

---

## Search and listing

### teamSearchQuery (data)

```sql
SELECT t.*
FROM Teams as t
WHERE (Name ILIKE ? OR DisplayName ILIKE ?)
  AND (AllowOpenInvite / GroupConstrained / Type filters per opts)
ORDER BY t.DisplayName
LIMIT ? OFFSET ?
```

Optional: `INNER JOIN RetentionPoliciesTeams ON t.Id = RetentionPoliciesTeams.TeamId`,
`LEFT JOIN RetentionPoliciesTeams ... WHERE RetentionPoliciesTeams.TeamId IS NULL`,
or `LEFT JOIN RetentionPoliciesTeams`; optional `, RetentionPoliciesTeams.PolicyId as PolicyID`.

### teamSearchQuery (count)

```sql
SELECT count(*)
FROM Teams as t
WHERE (Name ILIKE ? OR DisplayName ILIKE ?)
  AND (AllowOpenInvite / GroupConstrained / Type filters per opts)
```

### GetAll

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
ORDER BY DisplayName
```

### GetAllPage

```sql
SELECT Teams.*
FROM Teams
ORDER BY DisplayName
LIMIT ? OFFSET ?
```

Optional: `LEFT JOIN RetentionPoliciesTeams ON Teams.Id = RetentionPoliciesTeams.TeamId`,
`WHERE RetentionPoliciesTeams.TeamId IS NULL`, `WHERE AllowOpenInvite = ?`;
optional column: `, RetentionPoliciesTeams.PolicyId as PolicyID`.

### GetTeamsByUserId

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
JOIN TeamMembers ON TeamMembers.TeamId = Teams.Id
WHERE TeamMembers.UserId = ? AND TeamMembers.DeleteAt = 0 AND Teams.DeleteAt = 0
```

### GetAllPrivateTeamListing

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE AllowOpenInvite = false
ORDER BY DisplayName
```

### GetAllTeamListing

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE AllowOpenInvite = true
ORDER BY DisplayName
```

### GetTeamsByScheme

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived
FROM Teams
WHERE SchemeId = ?
ORDER BY DisplayName
LIMIT ? OFFSET ?
```

---

## Analytics

### AnalyticsTeamCount

```sql
SELECT COUNT(*) FROM Teams
WHERE DeleteAt = 0 AND AllowOpenInvite = ?
```

(DeleteAt and AllowOpenInvite are optional per opts.)

### AnalyticsGetTeamCountForScheme

```sql
SELECT count(*)
FROM Teams
WHERE SchemeId = ? AND DeleteAt = 0
```

### GroupSyncedTeamCount

```sql
SELECT COUNT(*)
FROM Teams
WHERE GroupConstrained = true AND DeleteAt = 0
```

---

## Team members — save / update

### SaveMultipleMembers — default scheme roles

```sql
SELECT Teams.Id as Id, TeamScheme.DefaultTeamGuestRole as Guest,
  TeamScheme.DefaultTeamUserRole as User, TeamScheme.DefaultTeamAdminRole as Admin
FROM Teams
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
WHERE Teams.Id IN (?)
```

### SaveMultipleMembers — member count (maxUsersPerTeam)

```sql
SELECT COUNT(0) as Count, TeamMembers.TeamId as TeamId
FROM TeamMembers
JOIN Users ON TeamMembers.UserId = Users.Id
WHERE TeamMembers.TeamId IN (?) AND TeamMembers.DeleteAt = 0 AND Users.DeleteAt = 0
GROUP BY TeamMembers.TeamId
```

### SaveMultipleMembers — insert

```sql
INSERT INTO TeamMembers (TeamId, UserId, Roles, DeleteAt, SchemeUser, SchemeAdmin, SchemeGuest, CreateAt)
VALUES (?, ?, ?, ?, ?, ?, ?, ?), (?, ?, ?, ?, ?, ?, ?, ?), ...
```

### UpdateMultipleMembers — update

```sql
UPDATE TeamMembers
SET Roles=:Roles, DeleteAt=:DeleteAt, CreateAt=:CreateAt, SchemeGuest=:SchemeGuest,
    SchemeUser=:SchemeUser, SchemeAdmin=:SchemeAdmin
WHERE TeamId=:TeamId AND UserId=:UserId
```

### UpdateMultipleMembers — default scheme roles

```sql
SELECT Teams.Id as Id, TeamScheme.DefaultTeamGuestRole as Guest,
  TeamScheme.DefaultTeamUserRole as User, TeamScheme.DefaultTeamAdminRole as Admin
FROM Teams
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
WHERE Teams.Id IN (?)
```

### UpdateLastTeamIconUpdate

```sql
UPDATE Teams SET LastTeamIconUpdate = ?, UpdateAt = ? WHERE Id = ?
```

---

## Team members — read

### GetMember

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, TeamMembers.SchemeGuest, TeamMembers.CreateAt,
  TeamScheme.DefaultTeamGuestRole TeamSchemeDefaultGuestRole,
  TeamScheme.DefaultTeamUserRole TeamSchemeDefaultUserRole,
  TeamScheme.DefaultTeamAdminRole TeamSchemeDefaultAdminRole
FROM TeamMembers
LEFT JOIN Teams ON TeamMembers.TeamId = Teams.Id
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
WHERE TeamMembers.TeamId = ? AND TeamMembers.UserId = ?
```

### GetMembers

Same SELECT and JOINs as GetMember, plus optional `LEFT JOIN Users ON TeamMembers.UserId = Users.Id`,
optional `WHERE Users.DeleteAt = 0`, optional view-restriction joins (rtm, rcm), then:

```sql
WHERE TeamMembers.TeamId = ? AND TeamMembers.DeleteAt = 0
ORDER BY UserId
LIMIT ? OFFSET ?
```

(Or ORDER BY Username when Sort = USERNAME.)

### GetTotalMemberCount

```sql
SELECT count(DISTINCT TeamMembers.UserId)
FROM TeamMembers, Users
WHERE TeamMembers.DeleteAt = 0 AND TeamMembers.UserId = Users.Id AND TeamMembers.TeamId = ?
```

Plus optional view-restriction joins (rtm, rcm).

### GetActiveMemberCount

```sql
SELECT count(DISTINCT TeamMembers.UserId)
FROM TeamMembers, Users
WHERE TeamMembers.DeleteAt = 0 AND TeamMembers.UserId = Users.Id AND Users.DeleteAt = 0
  AND TeamMembers.TeamId = ?
```

Plus optional view-restriction joins.

### GetMembersByIds

Same base as GetMember with:

```sql
WHERE TeamMembers.TeamId = ? AND TeamMembers.UserId IN (?) AND TeamMembers.DeleteAt = 0
```

Plus optional view-restriction filter.

### GetTeamsForUser

Same base as GetMember with:

```sql
WHERE TeamMembers.UserId = ?
  AND (TeamMembers.TeamId != ? OR exclude not applied)
  AND (TeamMembers.DeleteAt = 0 OR includeDeleted)
```

### GetTeamsForUserWithPagination

Same as GetTeamsForUser with:

```sql
ORDER BY TeamMembers.TeamId
LIMIT ? OFFSET ?
```

### GetChannelUnreadsForAllTeams

```sql
SELECT Channels.TeamId TeamId, Channels.Id ChannelId,
  (Channels.TotalMsgCount - ChannelMembers.MsgCount) MsgCount,
  (Channels.TotalMsgCountRoot - ChannelMembers.MsgCountRoot) MsgCountRoot,
  ChannelMembers.MentionCount MentionCount, ChannelMembers.MentionCountRoot MentionCountRoot,
  ChannelMembers.NotifyProps NotifyProps
FROM Channels
JOIN ChannelMembers ON Id = ChannelId
WHERE UserId = ? AND DeleteAt = 0 AND TeamId != ?
```

### GetChannelUnreadsForTeam

```sql
SELECT Channels.TeamId TeamId, Channels.Id ChannelId,
  (Channels.TotalMsgCount - ChannelMembers.MsgCount) MsgCount,
  (Channels.TotalMsgCountRoot - ChannelMembers.MsgCountRoot) MsgCountRoot,
  ChannelMembers.MentionCount MentionCount, ChannelMembers.MentionCountRoot MentionCountRoot,
  ChannelMembers.NotifyProps NotifyProps
FROM Channels
JOIN ChannelMembers ON Id = ChannelId
WHERE UserId = ? AND TeamId = ? AND DeleteAt = 0
```

---

## Team members — remove

### RemoveMembers

```sql
DELETE FROM TeamMembers WHERE TeamId = ? AND UserId IN (?)
```

### RemoveAllMembersByTeam

```sql
DELETE FROM TeamMembers WHERE TeamId = ?
```

### RemoveAllMembersByUser

```sql
DELETE FROM TeamMembers WHERE UserId = ?
```

---

## Migration and schemes

### MigrateTeamMembers — batch select

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, TeamMembers.SchemeGuest, TeamMembers.CreateAt
FROM TeamMembers
WHERE (TeamMembers.TeamId, TeamMembers.UserId) > (?, ?)
ORDER BY TeamMembers.TeamId, TeamMembers.UserId
LIMIT 100
```

### MigrateTeamMembers — update

```sql
UPDATE TeamMembers
SET TeamId=:TeamId, UserId=:UserId, Roles=:Roles, DeleteAt=:DeleteAt,
    SchemeUser=:SchemeUser, SchemeAdmin=:SchemeAdmin, SchemeGuest=:SchemeGuest
WHERE TeamId=:TeamId AND UserId=:UserId
```

### ResetAllTeamSchemes

```sql
UPDATE Teams SET SchemeId=''
```

### ClearAllCustomRoleAssignments — batch select

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, TeamMembers.SchemeGuest, TeamMembers.CreateAt
FROM TeamMembers
WHERE (TeamMembers.TeamId, TeamMembers.UserId) > (?, ?)
ORDER BY TeamMembers.TeamId, TeamMembers.UserId
LIMIT 1000
```

### ClearAllCustomRoleAssignments — update

```sql
UPDATE TeamMembers SET Roles = ? WHERE UserId = ? AND TeamId = ?
```

---

## Export and ids

### GetAllForExportAfter

```sql
SELECT Teams.Id, Teams.CreateAt, Teams.UpdateAt, Teams.DeleteAt, Teams.DisplayName,
  Teams.Name, Teams.Description, Teams.Email, Teams.Type, Teams.CompanyName,
  Teams.AllowedDomains, Teams.InviteId, Teams.AllowOpenInvite, Teams.LastTeamIconUpdate,
  Teams.SchemeId, Teams.GroupConstrained, Teams.CloudLimitsArchived, Schemes.Name as SchemeName
FROM Teams
LEFT JOIN Schemes ON Teams.SchemeId = Schemes.Id
WHERE Teams.Id > ?
ORDER BY Id
LIMIT ?
```

### GetUserTeamIds

```sql
SELECT TeamId
FROM TeamMembers
JOIN Teams ON TeamMembers.TeamId = Teams.Id
WHERE TeamMembers.UserId = ? AND TeamMembers.DeleteAt = 0 AND Teams.DeleteAt = 0
```

### GetCommonTeamIDsForTwoUsers

```sql
SELECT TM1.TeamId
FROM TeamMembers AS TM1
INNER JOIN TeamMembers AS TM2 ON TM1.TeamId = TM2.TeamId
INNER JOIN Teams ON TM1.TeamId = Teams.Id
WHERE TM1.UserId = ? AND TM2.UserId = ?
  AND TM1.DeleteAt = 0 AND TM2.DeleteAt = 0 AND Teams.DeleteAt = 0
```

### GetCommonTeamIDsForMultipleUsers — subquery

```sql
SELECT TeamId, UserId
FROM TeamMembers
WHERE UserId IN (?) AND DeleteAt = 0
```

### GetCommonTeamIDsForMultipleUsers — main

```sql
SELECT t.Id
FROM Teams AS t
JOIN (subquery) AS tm ON t.Id = tm.TeamId
WHERE t.DeleteAt = 0
GROUP BY t.Id
HAVING COUNT(UserId) = ?
```

### GetTeamMembersForExport

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
  (TeamMembers.SchemeGuest IS NOT NULL AND TeamMembers.SchemeGuest) as SchemeGuest,
  TeamMembers.SchemeUser, TeamMembers.SchemeAdmin, Teams.Name as TeamName
FROM TeamMembers
JOIN Teams ON TeamMembers.TeamId = Teams.Id
WHERE TeamMembers.UserId = ? AND Teams.DeleteAt = 0
```

### UserBelongsToTeams

```sql
SELECT Count(*)
FROM TeamMembers
WHERE UserId = ? AND TeamId IN (?) AND DeleteAt = 0
```

### UpdateMembersRole

```sql
UPDATE TeamMembers
SET SchemeAdmin = CASE WHEN UserId IN (?) THEN true ELSE false END
WHERE TeamId = ? AND DeleteAt = 0
  AND (SchemeGuest = false OR SchemeGuest IS NULL)
  AND ((SchemeAdmin = false AND UserId IN (?)) OR (SchemeAdmin = true AND UserId NOT IN (?)))
RETURNING TeamId, UserId, Roles, DeleteAt, SchemeUser, SchemeAdmin, SchemeGuest, CreateAt
```

---

## View restriction helpers (applied to member/count queries)

### applyTeamMemberViewRestrictionsFilter

Adds: `JOIN Users ru ON (TeamMembers.UserId = ru.Id)`, and optionally
`JOIN TeamMembers rtm ON (rtm.UserId = ru.Id AND rtm.DeleteAt = 0 AND rtm.TeamId IN (?))`,
`JOIN ChannelMembers rcm ON (rcm.UserId = ru.Id AND rcm.ChannelId IN (?))`, and `DISTINCT`.
If Teams and Channels both empty: `WHERE 1 = 0`.

### applyTeamMemberViewRestrictionsFilterForStats

Same joins on `TeamMembers rtm` and `ChannelMembers rcm` keyed by `Users.Id` (no DISTINCT).
If both empty: `WHERE 1 = 0`.

---

## No SQL in this store

- **ClearCaches**: cache invalidation only.
- **InvalidateAllTeamIdsForUser**: cache invalidation only.
