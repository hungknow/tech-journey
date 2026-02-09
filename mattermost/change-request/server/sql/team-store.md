# Team Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/team_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization / Shared query builders

### newSqlTeamStore

Builds reusable select builders (not executed by this function):

- **teamsQuery**:

```sql
SELECT (teamSliceColumns)
FROM Teams
```

- **teamMembersQuery**:

```sql
SELECT (TeamMembers columns)
FROM TeamMembers
```

### getTeamMembersWithSchemeSelectQuery

Adds scheme role columns and joins: TeamMembers + `LEFT JOIN Teams`, `LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id`. Used for member reads with scheme-derived roles.

### teamSearchQuery

Builds search/count query for teams: from `Teams as t`, optional retention policy joins, filters (Term ILIKE Name/DisplayName, AllowOpenInvite, GroupConstrained, TeamType, PolicyID), order/limit/offset. Used by SearchAll, SearchAllPaged, SearchOpen, SearchPrivate, GetAllPage, AnalyticsTeamCount.

---

## Team CRUD and lifecycle

### Save

```sql
INSERT INTO Teams
(Id, CreateAt, UpdateAt, DeleteAt, DisplayName, Name, Description, Email, Type, CompanyName, AllowedDomains,
InviteId, AllowOpenInvite, LastTeamIconUpdate, SchemeId, GroupConstrained, CloudLimitsArchived)
VALUES
(:Id, :CreateAt, :UpdateAt, :DeleteAt, :DisplayName, :Name, :Description, :Email, :Type, :CompanyName, :AllowedDomains,
:InviteId, :AllowOpenInvite, :LastTeamIconUpdate, :SchemeId, :GroupConstrained, :CloudLimitsArchived)
```

### Update

Read existing team with **teamsQuery** `WHERE Id = ?`; then:

```sql
UPDATE Teams
SET CreateAt=:CreateAt, UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, DisplayName=:DisplayName, Name=:Name,
    Description=:Description, Email=:Email, Type=:Type, CompanyName=:CompanyName, AllowedDomains=:AllowedDomains,
    InviteId=:InviteId, AllowOpenInvite=:AllowOpenInvite, LastTeamIconUpdate=:LastTeamIconUpdate,
    SchemeId=:SchemeId, GroupConstrained=:GroupConstrained, CloudLimitsArchived=:CloudLimitsArchived
WHERE Id=:Id
```

### Get

**teamsQuery** `WHERE Id = ?`.

### GetMany

**teamsQuery** `WHERE Teams.Id IN (?)`.

### GetByInviteId

**teamsQuery** `WHERE InviteId = ?`.

### GetByEmptyInviteID

**teamsQuery** `WHERE InviteId = ''`.

### GetByName

**teamsQuery** `WHERE Name = ?`.

### GetByNames

**teamsQuery** `WHERE Name IN (?)`.

### PermanentDelete

```sql
DELETE FROM Teams WHERE Id = ?
```

---

## Search and listing

### teamSearchQuery

Helper that builds the select/count query for SearchAll, SearchAllPaged, SearchOpen, SearchPrivate, GetAllPage, AnalyticsTeamCount. Not called alone.

### SearchAll

Runs **teamSearchQuery(opts, false)** and executes on replica.

### SearchAllPaged

Runs **teamSearchQuery(opts, false)** for data; **teamSearchQuery(opts, true)** for total count.

### SearchOpen

**teamSearchQuery** with AllowOpenInvite = true.

### SearchPrivate

**teamSearchQuery** with AllowOpenInvite = false (and GroupConstrained filters).

### GetAll

**teamsQuery** (no extra filters).

### GetAllPage

**teamSearchQuery** with pagination (limit/offset).

### GetTeamsByUserId

Select teams from Teams join TeamMembers where TeamMembers.UserId = ? and DeleteAt = 0.

### GetAllPrivateTeamListing

**teamsQuery** with Type = 'I' (invite), DeleteAt = 0.

### GetAllTeamListing

**teamsQuery** with DeleteAt = 0.

### GetTeamsByScheme

**teamsQuery** `WHERE SchemeId = ?` ORDER BY DisplayName LIMIT/OFFSET.

---

## Analytics

### AnalyticsTeamCount

```sql
SELECT COUNT(*) FROM Teams
-- optional: WHERE DeleteAt = 0, AllowOpenInvite = ?
```

### AnalyticsGetTeamCountForScheme

```sql
SELECT count(*) FROM Teams WHERE SchemeId = ? AND DeleteAt = 0
```

### GroupSyncedTeamCount

```sql
SELECT COUNT(*) FROM Teams WHERE GroupConstrained = true AND DeleteAt = 0
```

---

## Team members — save / update

### SaveMultipleMembers

- Optional: select default scheme roles from Teams left join Schemes for team ids.
- Optional (maxUsersPerTeam >= 0): count members per team from TeamMembers join Users where DeleteAt = 0, GroupBy TeamId; enforce max per team.
- Bulk insert:

```sql
INSERT INTO TeamMembers (TeamId, UserId, Roles, DeleteAt, SchemeUser, SchemeAdmin, SchemeGuest, CreateAt)
VALUES (...), (...), ...
```
- After insert, returns members with scheme roles applied in memory (no second query for list).

### SaveMember

Calls **SaveMultipleMembers** with a single member.

### UpdateMultipleMembers

For each member:

```sql
UPDATE TeamMembers
SET Roles=:Roles, DeleteAt=:DeleteAt, CreateAt=:CreateAt, SchemeGuest=:SchemeGuest,
    SchemeUser=:SchemeUser, SchemeAdmin=:SchemeAdmin
WHERE TeamId=:TeamId AND UserId=:UserId
```

Then select default scheme roles for affected teams (Teams left join Schemes) and returns updated members with roles applied in memory.

### UpdateMember

Calls **UpdateMultipleMembers** with a single member.

### UpdateLastTeamIconUpdate

```sql
UPDATE Teams SET LastTeamIconUpdate = ?, UpdateAt = ? WHERE Id = ?
```

---

## Team members — read

### GetMember

**getTeamMembersWithSchemeSelectQuery** `WHERE TeamMembers.TeamId = ? AND TeamMembers.UserId = ?`.

### GetMembers

**getTeamMembersWithSchemeSelectQuery** with optional view restrictions (join Users, TeamMembers rtm, ChannelMembers rcm), `WHERE TeamMembers.TeamId = ?`, optional DeleteAt, ORDER BY UserId, LIMIT/OFFSET.

### GetTotalMemberCount

Count from TeamMembers (with optional view restrictions join) where TeamId = ? and DeleteAt = 0.

### GetActiveMemberCount

Same as GetTotalMemberCount but also join Users and Users.DeleteAt = 0.

### GetMembersByIds

**getTeamMembersWithSchemeSelectQuery** with optional view restrictions, `WHERE TeamMembers.TeamId = ? AND TeamMembers.UserId IN (?)`.

### GetTeamsForUser

**getTeamMembersWithSchemeSelectQuery** where UserId = ? and optionally exclude team and include deleted.

### GetTeamsForUserWithPagination

**getTeamMembersWithSchemeSelectQuery** where UserId = ?, ORDER BY TeamId, LIMIT/OFFSET.

### GetChannelUnreadsForAllTeams

Select ChannelId, TeamId, MsgCount, MentionCount, etc. from ChannelMembers join Channels where UserId = ? and optional excludeTeamId, DeleteAt = 0.

### GetChannelUnreadsForTeam

Same shape for a single team.

---

## Team members — remove

### RemoveMembers

```sql
DELETE FROM TeamMembers WHERE TeamId = ? AND UserId IN (?)
```

### RemoveMember

Calls **RemoveMembers** for a single user.

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

### MigrateTeamMembers

Batch select: **teamMembersQuery** `WHERE (TeamMembers.TeamId, TeamMembers.UserId) > (?, ?)` ORDER BY TeamMembers.TeamId, TeamMembers.UserId LIMIT 100. For each row:

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

### ClearAllCustomRoleAssignments

In a loop: select batch of TeamMembers with `(TeamId, UserId) > (?, ?)` ORDER BY TeamId, UserId LIMIT 1000. For each member, compute built-in-only roles; if changed:

```sql
UPDATE TeamMembers SET Roles = ? WHERE UserId = ? AND TeamId = ?
```

---

## Export and ids

### GetAllForExportAfter

Select team columns + Schemes.Name from Teams left join Schemes where Teams.Id > afterId, ORDER BY Id, LIMIT.

### GetUserTeamIds

```sql
SELECT TeamId FROM TeamMembers
JOIN Teams ON TeamMembers.TeamId = Teams.Id
WHERE TeamMembers.UserId = ?
  AND TeamMembers.DeleteAt = 0
  AND Teams.DeleteAt = 0
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

### GetCommonTeamIDsForMultipleUsers

Subquery: TeamId, UserId from TeamMembers where UserId IN (?) and DeleteAt = 0. Main: select Teams.Id from Teams join (subquery) group by Id HAVING COUNT(UserId) = len(userIDs), Teams.DeleteAt = 0.

### GetTeamMembersForExport

Select TeamMembers fields + Teams.Name from TeamMembers join Teams where TeamMembers.UserId = ? and Teams.DeleteAt = 0.

### UserBelongsToTeams

Returns whether count > 0.

```sql
SELECT Count(*) FROM TeamMembers
WHERE UserId = ? AND TeamId IN (?) AND DeleteAt = 0
```

### UpdateMembersRole

SchemeGuest false/null, restricted to new or demoted admins, with RETURNING columns. Returns updated members.

```sql
UPDATE TeamMembers
SET SchemeAdmin = CASE WHEN UserId IN (?) THEN true ELSE false END, ...
WHERE TeamId = ? AND DeleteAt = 0
RETURNING ...
```

---

## No-op / cache-only (no SQL in this store)

### ClearCaches

No SQL. Cache invalidation only.

### InvalidateAllTeamIdsForUser

No SQL. Cache invalidation only.
