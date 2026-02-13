# Channel Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/channel_store.go` and the **actual SQL** executed (from raw strings or squirrel builder). Query-builder–generated SQL is shown as the equivalent SQL shape.

---

## Initialization / Shared query builders

### initializeQueries

Builds reusable select builders (not executed by this function; used by other methods).

#### tableSelectQuery

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, TeamId, Type, DisplayName, Name, Header, Purpose,
       LastPostAt, TotalMsgCount, ExtraUpdateAt, CreatorId, SchemeId, GroupConstrained,
       AutoTranslation, Shared, TotalMsgCountRoot, LastRootPostAt, BannerInfo, DefaultCategoryName,
       EXISTS (SELECT 1 FROM AccessControlPolicies acp WHERE acp.ID = Channels.Id) AS PolicyEnforced,
       COALESCE((SELECT acp.Active FROM AccessControlPolicies acp
                 WHERE acp.ID = Channels.Id AND acp.Active = TRUE LIMIT 1), false) AS PolicyIsActive
FROM Channels
```

#### sidebarCategorySelectQuery

```sql
SELECT SidebarCategories.Id, SidebarCategories.UserId, SidebarCategories.TeamId,
       SidebarCategories.SortOrder, SidebarCategories.Sorting, SidebarCategories.Type,
       SidebarCategories.DisplayName, SidebarCategories.Muted, SidebarCategories.Collapsed
FROM SidebarCategories
```

#### channelMembersForTeamWithSchemeSelectQuery

```sql
SELECT ChannelMembers.ChannelId, ChannelMembers.UserId, ChannelMembers.Roles,
       ChannelMembers.LastViewedAt, ChannelMembers.MsgCount, ChannelMembers.MentionCount,
       ChannelMembers.MentionCountRoot,
       COALESCE(ChannelMembers.UrgentMentionCount, 0) AS UrgentMentionCount,
       ChannelMembers.MsgCountRoot, ChannelMembers.NotifyProps, ChannelMembers.LastUpdateAt,
       ChannelMembers.SchemeUser, ChannelMembers.SchemeAdmin, ChannelMembers.SchemeGuest,
       TeamScheme.DefaultChannelGuestRole TeamSchemeDefaultGuestRole,
       TeamScheme.DefaultChannelUserRole TeamSchemeDefaultUserRole,
       TeamScheme.DefaultChannelAdminRole TeamSchemeDefaultAdminRole,
       ChannelScheme.DefaultChannelGuestRole ChannelSchemeDefaultGuestRole,
       ChannelScheme.DefaultChannelUserRole ChannelSchemeDefaultUserRole,
       ChannelScheme.DefaultChannelAdminRole ChannelSchemeDefaultAdminRole,
       ChannelMembers.AutoTranslationDisabled
FROM ChannelMembers
INNER JOIN Channels ON ChannelMembers.ChannelId = Channels.Id
LEFT JOIN Schemes ChannelScheme ON Channels.SchemeId = ChannelScheme.Id
LEFT JOIN Teams ON Channels.TeamId = Teams.Id
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
```

---

## Channel CRUD and lifecycle

### Save

Uses **saveChannelT** and **upsertPublicChannelT** inside a transaction. See those subsections for SQL.

### CreateDirectChannel

Builds a direct channel and two members; calls **SaveDirectChannel**. No direct SQL in this function.

### SaveDirectChannel

Uses **saveChannelT** for the channel, then **saveMultipleMembers** (or **saveMemberT**) for members. See those subsections for SQL.

### upsertPublicChannelT

For non-open channels:

```sql
DELETE FROM PublicChannels WHERE Id=?
```

For open channels:

```sql
INSERT INTO PublicChannels(Id, DeleteAt, TeamId, DisplayName, Name, Header, Purpose)
VALUES (:id, :deleteat, :teamid, :displayname, :name, :header, :purpose)
ON CONFLICT (id) DO UPDATE
SET DeleteAt = :deleteat, TeamId = :teamid, DisplayName = :displayname,
    Name = :name, Header = :header, Purpose = :purpose;
```

### saveChannelT

Count existing open/private channels for the team (when enforcing max channels per team):

```sql
SELECT COUNT(0) FROM Channels WHERE TeamId = ? AND DeleteAt = 0 AND (Type = ? OR Type = ?)
```

Insert: squirrel `Insert("Channels").Columns(...).Values(...).SuffixExpr("ON CONFLICT (TeamId, Name) DO NOTHING")` — equivalent to:

```sql
INSERT INTO Channels (Id, CreateAt, UpdateAt, DeleteAt, TeamId, Type, DisplayName, Name, Header,
    Purpose, LastPostAt, TotalMsgCount, ExtraUpdateAt, CreatorId, SchemeId, GroupConstrained,
    AutoTranslation, Shared, TotalMsgCountRoot, LastRootPostAt, BannerInfo, DefaultCategoryName)
VALUES (?, ?, ?, ...)
ON CONFLICT (TeamId, Name) DO NOTHING
```

If insert affected 0 rows: **tableSelectQuery** + `WHERE TeamId = ? AND Name = ?` to return the conflicting channel.

### Update

Uses **updateChannelT** and **upsertPublicChannelT** inside a transaction.

### updateChannelT

```sql
UPDATE Channels
SET CreateAt=:CreateAt, UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, TeamId=:TeamId, Type=:Type,
    DisplayName=:DisplayName, Name=:Name, Header=:Header, Purpose=:Purpose,
    LastPostAt=:LastPostAt, TotalMsgCount=:TotalMsgCount, ExtraUpdateAt=:ExtraUpdateAt,
    CreatorId=:CreatorId, SchemeId=:SchemeId, GroupConstrained=:GroupConstrained, Shared=:Shared,
    TotalMsgCountRoot=:TotalMsgCountRoot, LastRootPostAt=:LastRootPostAt,
    BannerInfo=:BannerInfo, DefaultCategoryName=:DefaultCategoryName,
    AutoTranslation=:AutoTranslation
WHERE Id=:Id
```

### GetChannelUnread

```sql
SELECT Channels.TeamId TeamId, Channels.Id ChannelId,
       (Channels.TotalMsgCount - ChannelMembers.MsgCount) MsgCount,
       (Channels.TotalMsgCountRoot - ChannelMembers.MsgCountRoot) MsgCountRoot,
       ChannelMembers.MentionCount MentionCount, ChannelMembers.MentionCountRoot MentionCountRoot,
       COALESCE(ChannelMembers.UrgentMentionCount, 0) UrgentMentionCount,
       ChannelMembers.NotifyProps NotifyProps
FROM Channels, ChannelMembers
WHERE Id = ChannelId AND Id = ? AND UserId = ? AND DeleteAt = 0
```

### GetPinnedPosts

Squirrel: `Select(postSliceColumns()...).Column("(SELECT count(Posts.Id) FROM Posts WHERE ...) as ReplyCount").From("Posts p").Where(IsPinned=true, ChannelId, DeleteAt=0).OrderBy("CreateAt ASC")` — from `Posts p` with reply-count subquery, `IsPinned = true`, `ChannelId`, `DeleteAt = 0`, ordered by `CreateAt`.

### Get

**tableSelectQuery** + `WHERE Id = ?`.

### GetMany

```sql
SELECT (channel columns from channelSliceColumns(true))
FROM Channels
WHERE Id IN (?)
```

### Delete

Delegates to **SetDeleteAt**. No additional SQL.

### Restore

Delegates to **SetDeleteAt**. No additional SQL.

### SetDeleteAt

Runs **setDeleteAtT** then syncs PublicChannels in a transaction.

### setDeleteAtT

```sql
UPDATE Channels SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

Sync PublicChannels:

```sql
UPDATE PublicChannels SET DeleteAt = ? WHERE Id = ?
```

### PermanentDeleteByTeam

Runs **permanentDeleteByTeamtT** then deletes from PublicChannels in a transaction.

### permanentDeleteByTeamtT

```sql
DELETE FROM Channels WHERE TeamId = ?
```

Then:

```sql
DELETE FROM PublicChannels WHERE TeamId = ?
```

### PermanentDelete

Runs **permanentDeleteT** then deletes from PublicChannels in a transaction.

### permanentDeleteT

```sql
DELETE FROM Channels WHERE Id = ?
```

Then:

```sql
DELETE FROM PublicChannels WHERE Id = ?
```

### PermanentDeleteMembersByChannel

```sql
DELETE FROM ChannelMembers WHERE ChannelId = ?
```

---

## Channel listing and filtering

### GetChannels

Squirrel: from `Channels ch`, `ChannelMembers cm` where `ch.Id = cm.ChannelId`, `cm.UserId = ?`, optional TeamId/DeleteAt/LastUpdateAt, order by `ch.DisplayName`. Uses full channel select (channelSliceColumns with policy subqueries).

### GetChannelsByUser

Squirrel: `Channels` INNER JOIN `ChannelMembers` LEFT JOIN `Teams`, `WHERE ChannelMembers.UserId = ?`, optional `Channels.Id > fromChannelID`, pagination, DeleteAt/team filters, order by `Channels.Id`.

### GetAllChannelMemberIdsByChannelId

```sql
SELECT UserId FROM ChannelMembers WHERE ChannelId=?
```

### GetAllChannels

Uses **getAllChannelsQuery(opts, false)**: select from `Channels AS c` (with team data, optional PolicyID), join Teams, filters (IncludeDeleted, NotAssociatedToGroup, GroupConstrained, ExcludeChannelNames, retention, access control). Order by `c.DisplayName, Teams.DisplayName`, limit/offset.

### GetAllChannelsCount

Uses **getAllChannelsQuery(opts, true)** — same filters, `SELECT count(c.Id) FROM ...`.

### GetMoreChannels

Subquery: public channel ids from `PublicChannels` join `ChannelMembers` for team + user. Main: channels from `Channels` join `PublicChannels` for team, id not in subquery, order by display name, limit/offset.

### GetPrivateChannelsForTeam

Squirrel: `Channels` where `Type = 'P'`, `TeamId = ?`, `DeleteAt = 0`, order by DisplayName, limit/offset.

### GetPublicChannelsForTeam

Squirrel: `Channels` JOIN `PublicChannels pc ON (pc.Id = Channels.Id)` WHERE `pc.TeamId = ?`, `pc.DeleteAt = 0`, order by display name, limit/offset.

### GetPublicChannelsByIdsForTeam

Same join as GetPublicChannelsForTeam + `PublicChannels.Id IN (channelIds)` for given team.

### GetChannelCounts

```sql
SELECT Id, TotalMsgCount, TotalMsgCountRoot, UpdateAt
FROM Channels
WHERE Id IN (SELECT ChannelId FROM ChannelMembers WHERE UserId = ?)
  AND (TeamId = ? OR TeamId = '') AND DeleteAt = 0
ORDER BY DisplayName
```

### GetTeamChannels

**tableSelectQuery** + `WHERE TeamId = ? AND Type != 'D'`, order by DisplayName.

### GetByNamesIncludeDeleted / GetByNames / getByNames

Select channels by name list (and optional team, optional `DeleteAt = 0`) using **tableSelectQuery**-style select and WHERE on Name/TeamId.

### GetByNameIncludeDeleted / GetByName / getByName

Select one channel by name and team (or empty team), optional `DeleteAt = 0`.

### GetDeletedByName

**tableSelectQuery** + `WHERE TeamId = ? AND Name = ? AND DeleteAt != 0`.

### GetDeleted

Squirrel: deleted channels for team (optionally only those user is member of), order by DisplayName, limit/offset.

---

## Channel members — save / update

### SaveMultipleMembers / SaveMember / saveMemberT

See **saveMultipleMembers**.

### saveMultipleMembers

Two reads for scheme roles:

Channel scheme roles:

```sql
SELECT Channels.Id as Id,
       ChannelScheme.DefaultChannelGuestRole as Guest,
       ChannelScheme.DefaultChannelUserRole as User,
       ChannelScheme.DefaultChannelAdminRole as Admin
FROM Channels
LEFT JOIN Schemes ChannelScheme ON Channels.SchemeId = ChannelScheme.Id
WHERE Channels.Id IN (?)
```

Team scheme roles (same shape, from Channels LEFT JOIN Teams, LEFT JOIN Schemes TeamScheme, same channel ids):

```sql
SELECT Channels.Id as Id,
       TeamScheme.DefaultChannelGuestRole as Guest,
       TeamScheme.DefaultChannelUserRole as User,
       TeamScheme.DefaultChannelAdminRole as Admin
FROM Channels
LEFT JOIN Teams ON Teams.Id = Channels.TeamId
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
WHERE Channels.Id IN (?)
```

Bulk insert:

```sql
INSERT INTO ChannelMembers (ChannelId, UserId, Roles, LastViewedAt, MsgCount, MsgCountRoot,
    MentionCount, MentionCountRoot, UrgentMentionCount, NotifyProps, LastUpdateAt,
    SchemeUser, SchemeAdmin, SchemeGuest, AutoTranslationDisabled)
VALUES (?, ?, ...), (?, ?, ...), ...
```

### UpdateMultipleMembers / UpdateMember

For each member:

```sql
UPDATE ChannelMembers
SET Roles=?, LastViewedAt=?, MsgCount=?, MentionCount=?, UrgentMentionCount=?, NotifyProps=?,
    LastUpdateAt=?, SchemeUser=?, SchemeAdmin=?, SchemeGuest=?, MentionCountRoot=?,
    MsgCountRoot=?
WHERE ChannelId=? AND UserId=?
```

Then select updated row using **channelMembersForTeamWithSchemeSelectQuery** + `WHERE ChannelMembers.ChannelId = ? AND ChannelMembers.UserId = ?`.

### UpdateMemberNotifyProps

Postgres (squirrel Set with Expr):

```sql
UPDATE channelmembers
SET notifyprops = notifyprops || ?::jsonb, LastUpdateAt = ?
WHERE userid = ? AND channelid = ?
```

Then select member with **channelMembersForTeamWithSchemeSelectQuery** by ChannelId and UserId.

### PatchMultipleMembersNotifyProps

```sql
UPDATE ChannelMembers
SET notifyprops = notifyprops || ?::jsonb, LastUpdateAt = ?
WHERE (ChannelId, UserId) IN ((?, ?), (?, ?), ...)
```

Then select all updated rows with **channelMembersForTeamWithSchemeSelectQuery** and same (ChannelId, UserId) list.

---

## Channel members — read

### GetMembers

**channelMembersForTeamWithSchemeSelectQuery** + `WHERE ChannelId = ?`, optional `LastUpdateAt > ?`, limit/offset.

### GetChannelMembersTimezones

```sql
SELECT Users.Timezone
FROM ChannelMembers
LEFT JOIN Users ON ChannelMembers.UserId = Id
WHERE ChannelId = ?
```

### GetChannelsWithUnreadsAndWithMentions

Squirrel: ChannelMembers join Channels, select channel id, type, TotalMsgCount, LastPostAt, member MsgCount, MentionCount, NotifyProps, LastViewedAt where ChannelId IN list and UserId = ?.

### GetMember

**channelMembersForTeamWithSchemeSelectQuery** + `WHERE ChannelMembers.ChannelId = ? AND ChannelMembers.UserId = ?`.

### GetMemberLastViewedAt

```sql
SELECT COALESCE(LastViewedAt, 0) AS LastViewedAt
FROM ChannelMembers WHERE ChannelId=? AND UserId=?
```

### GetMemberForPost

Raw SQL:

```sql
SELECT ChannelMembers.ChannelId, ChannelMembers.UserId, ChannelMembers.Roles,
       ChannelMembers.LastViewedAt, ChannelMembers.MsgCount, ChannelMembers.MentionCount,
       ChannelMembers.MentionCountRoot,
       COALESCE(ChannelMembers.UrgentMentionCount, 0) AS UrgentMentionCount,
       ChannelMembers.MsgCountRoot, ChannelMembers.NotifyProps, ChannelMembers.LastUpdateAt,
       ChannelMembers.SchemeUser, ChannelMembers.SchemeAdmin, ChannelMembers.SchemeGuest,
       ChannelMembers.AutoTranslationDisabled,
       TeamScheme.DefaultChannelGuestRole TeamSchemeDefaultGuestRole,
       TeamScheme.DefaultChannelUserRole TeamSchemeDefaultUserRole,
       TeamScheme.DefaultChannelAdminRole TeamSchemeDefaultAdminRole,
       ChannelScheme.DefaultChannelGuestRole ChannelSchemeDefaultGuestRole,
       ChannelScheme.DefaultChannelUserRole ChannelSchemeDefaultUserRole,
       ChannelScheme.DefaultChannelAdminRole ChannelSchemeDefaultAdminRole
FROM ChannelMembers
INNER JOIN Posts ON ChannelMembers.ChannelId = Posts.ChannelId
INNER JOIN Channels ON ChannelMembers.ChannelId = Channels.Id
LEFT JOIN Schemes ChannelScheme ON Channels.SchemeId = ChannelScheme.Id
LEFT JOIN Teams ON Channels.TeamId = Teams.Id
LEFT JOIN Schemes TeamScheme ON Teams.SchemeId = TeamScheme.Id
WHERE ChannelMembers.UserId = ? AND Posts.Id = ?
```

### GetAllChannelMembersForUser

Squirrel: ChannelMembers JOIN Channels, LEFT JOIN Schemes (ChannelScheme, TeamScheme via Teams), WHERE `ChannelMembers.UserId = ?`, optional `Channels.DeleteAt = 0`. Returns ChannelId, Roles, scheme guest/user/admin and default roles.

### GetChannelsMemberCount

```sql
SELECT ChannelMembers.ChannelId, COUNT(*) AS Count
FROM ChannelMembers
INNER JOIN Users ON ChannelMembers.UserId = Users.Id
WHERE ChannelMembers.ChannelId IN (?) AND Users.DeleteAt = 0
GROUP BY ChannelMembers.ChannelId
```

### GetAllChannelMembersNotifyPropsForChannel

```sql
SELECT UserId, NotifyProps FROM ChannelMembers WHERE ChannelId = ?
```

### GetFileCount

```sql
SELECT COUNT(*)
FROM FileInfo
WHERE FileInfo.DeleteAt = 0 AND FileInfo.PostId != '' AND FileInfo.ChannelId = ?
```

### GetMemberCount

```sql
SELECT count(*)
FROM ChannelMembers, Users
WHERE ChannelMembers.UserId = Users.Id AND ChannelMembers.ChannelId = ?
  AND Users.DeleteAt = 0
```

### GetMemberCountsByGroup

Squirrel: ChannelMembers JOIN GroupMembers (and optionally Users for timezones), WHERE `ChannelMembers.ChannelId = ?`, GROUP BY GroupMembers.GroupId, with optional COUNT(DISTINCT timezone expression).

### GetPinnedPostCount

```sql
SELECT count(*) FROM Posts
WHERE IsPinned = true AND ChannelId = ? AND DeleteAt = 0
```

### GetGuestCount

```sql
SELECT count(*)
FROM ChannelMembers, Users
WHERE ChannelMembers.UserId = Users.Id AND ChannelMembers.ChannelId = ?
  AND ChannelMembers.SchemeGuest = TRUE AND Users.DeleteAt = 0
```

---

## Channel members — remove

### RemoveMembers

```sql
DELETE FROM ChannelMembers WHERE ChannelId = ? AND UserId IN (?)
```

Then:

```sql
DELETE FROM SidebarChannels WHERE ChannelId = ? AND UserId IN (?)
```

### RemoveMember

Calls **RemoveMembers** for a single user.

### RemoveAllDeactivatedMembers

```sql
DELETE FROM ChannelMembers
WHERE UserId IN (SELECT Id FROM Users WHERE Users.DeleteAt != 0)
  AND ChannelMembers.ChannelId = ?
```

### PermanentDeleteMembersByUser

```sql
DELETE FROM ChannelMembers WHERE UserId = ?
```

---

## Last viewed and mentions

### UpdateLastViewedAt

CTE + update (squirrel with Prefix/Suffix); equivalent shape:

```sql
WITH c AS (
  SELECT Id, LastPostAt, TotalMsgCount, TotalMsgCountRoot FROM Channels WHERE Id IN (?)
),
updated AS (
  UPDATE ChannelMembers cm
  SET MentionCount = 0, MentionCountRoot = 0, UrgentMentionCount = 0,
      MsgCount = greatest(cm.MsgCount, c.TotalMsgCount),
      MsgCountRoot = greatest(cm.MsgCountRoot, c.TotalMsgCountRoot),
      LastViewedAt = greatest(cm.LastViewedAt, c.LastPostAt),
      LastUpdateAt = greatest(cm.LastViewedAt, c.LastPostAt)
  FROM c
  WHERE cm.UserId = ? AND c.Id = cm.ChannelId
)
SELECT Id, LastPostAt FROM c
```

### CountUrgentPostsAfter

Squirrel: `PostsPriority` JOIN `Posts`, WHERE priority = urgent, ChannelId, CreateAt > timestamp, DeleteAt = 0, optional UserId != excludedUserID.

### CountPostsAfter

Squirrel: count from `Posts` WHERE ChannelId, CreateAt > timestamp, Type NOT IN (join/leave types), DeleteAt = 0, optional UserId != excludedUserID. Second query adds `RootId = ''` for root-only count.

### UpdateLastViewedAtPost

Uses CountPostsAfter; then:

```sql
UPDATE ChannelMembers
SET MentionCount = :mentions, MentionCountRoot = :mentionsroot,
    UrgentMentionCount = :urgentmentions,
    MsgCount = (SELECT TotalMsgCount FROM Channels WHERE ID = :channelid) - :unreadcount,
    MsgCountRoot = (SELECT TotalMsgCountRoot FROM Channels WHERE ID = :channelid)
        - :unreadcountroot,
    LastViewedAt = :lastviewedat, LastUpdateAt = :updatedat
WHERE UserId = :userid AND ChannelId = :channelid
```

Then:

```sql
SELECT c.TeamId TeamId, cm.UserId UserId, cm.ChannelId ChannelId, cm.MsgCount MsgCount,
       cm.MsgCountRoot MsgCountRoot, cm.MentionCount MentionCount,
       cm.MentionCountRoot MentionCountRoot,
       COALESCE(cm.UrgentMentionCount, 0) UrgentMentionCount,
       cm.LastViewedAt LastViewedAt, cm.NotifyProps NotifyProps
FROM ChannelMembers cm
LEFT JOIN Channels c ON c.Id = cm.ChannelId
WHERE cm.UserId = ? AND cm.ChannelId = ? AND c.DeleteAt = 0
```

### IncrementMentionCount

Squirrel generates:

```sql
UPDATE ChannelMembers
SET MentionCount = MentionCount + 1, MentionCountRoot = MentionCountRoot + ?,
    UrgentMentionCount = UrgentMentionCount + ?, LastUpdateAt = ?
WHERE UserId IN (?) AND ChannelId = ?
```

---

## Channels by id / team / post

### GetAll

**tableSelectQuery** + `WHERE TeamId = ? AND Type != 'D'`, order by Name.

### GetChannelsByIds

Squirrel: select from Channels WHERE Id IN (?), optional DeleteAt = 0, order by Name.

### GetChannelsWithTeamDataByIds

Channels c LEFT JOIN Teams t, same ids, optional DeleteAt, order by c.Name.

### GetForPost

Channels JOIN Posts on channel id, WHERE `Posts.Id = ?`.

---

## Analytics

### AnalyticsTypeCount

```sql
SELECT COUNT(*) AS Value FROM Channels
-- optional: WHERE Type = ? AND TeamId = ?
```

### AnalyticsDeletedTypeCount

```sql
SELECT COUNT(Id) AS Value FROM Channels WHERE Type = ? AND DeleteAt > 0
-- optional: AND TeamId = ?
```

### AnalyticsCountAll

```sql
SELECT Type, COUNT(*) AS Count FROM Channels
-- optional: WHERE TeamId = ?
GROUP BY Type
```

---

## Members for user / team

### GetMembersForUser

**channelMembersForTeamWithSchemeSelectQuery** + `WHERE ChannelMembers.UserId = ?` and (Teams.Id = teamID or Teams.Id empty/null).

### GetMembersForUserWithPagination

Static **channelMembersWithSchemeSelectQuery** (ChannelMembers + Channels + Schemes + Teams) + `WHERE ChannelMembers.UserId = ? ORDER BY ChannelId ASC LIMIT ? OFFSET ?`.

### GetMembersForUserWithCursorPagination

Same base + `WHERE ChannelMembers.UserId = ? AND ChannelId > ? ORDER BY ChannelId ASC LIMIT ?`.

### GetTeamMembersForChannel

```sql
SELECT tm.UserId
FROM Channels c, Teams t, TeamMembers tm
WHERE c.TeamId = t.Id AND t.Id = tm.TeamId AND c.Id = ?
```

---

## Search and autocomplete

(These use squirrel builders and optional full-text/LIKE; see function names in code. **performSearch** runs the built select on replica. **channelSearchQuery** builds select/count for SearchAllChannels. **searchGroupChannelsQuery** builds group-channel search. **autocompleteInTeamForSearchDirectMessages** builds DM/group channel search by other member’s username/nickname.)

---

## Members by id

### GetMembersByIds

**channelMembersForTeamWithSchemeSelectQuery** + `WHERE ChannelId = ? AND UserId IN (?)`.

### GetMembersByChannelIds

Same query + `WHERE ChannelId IN (?) AND UserId = ?`.

### GetMembersInfoByChannelIds

Squirrel: ChannelId, User id/name from ChannelMembers JOIN Channels and Users, WHERE ChannelId IN list, Channels.DeleteAt = 0.

---

## Schemes and migration

### GetChannelsByScheme

**tableSelectQuery** + `WHERE SchemeId = ?`, order by DisplayName, limit/offset.

### MigrateChannelMembers

Select batch:

```sql
SELECT ChannelId, UserId, Roles, LastViewedAt, MsgCount, MentionCount, MentionCountRoot,
       COALESCE(UrgentMentionCount, 0) AS UrgentMentionCount, MsgCountRoot, NotifyProps,
       LastUpdateAt, SchemeUser, SchemeAdmin, SchemeGuest
FROM ChannelMembers
WHERE (ChannelId, UserId) > (?, ?)
ORDER BY ChannelId, UserId
LIMIT 100
```

For each row:

```sql
UPDATE ChannelMembers
SET Roles=:Roles, LastViewedAt=:LastViewedAt, MsgCount=:MsgCount, MentionCount=:MentionCount,
    UrgentMentionCount=:UrgentMentionCount, NotifyProps=:NotifyProps,
    LastUpdateAt=:LastUpdateAt, SchemeUser=:SchemeUser, SchemeAdmin=:SchemeAdmin,
    SchemeGuest=:SchemeGuest, MentionCountRoot=:MentionCountRoot, MsgCountRoot=:MsgCountRoot
WHERE ChannelId=:ChannelId AND UserId=:UserId
```

### ResetAllChannelSchemes

Runs **resetAllChannelSchemesT** in a transaction.

### resetAllChannelSchemesT

```sql
UPDATE Channels SET SchemeId=''
```

### ClearAllCustomRoleAssignments

Select batch:

```sql
SELECT ChannelId, UserId, Roles, LastViewedAt, MsgCount, MentionCount, MentionCountRoot,
       COALESCE(UrgentMentionCount, 0) AS UrgentMentionCount, MsgCountRoot, NotifyProps,
       LastUpdateAt, SchemeUser, SchemeAdmin, SchemeGuest
FROM ChannelMembers
WHERE (ChannelId, UserId) > (?, ?)
ORDER BY ChannelId, UserId
LIMIT 1000
```

For each member (if roles changed):

```sql
UPDATE ChannelMembers SET Roles = ? WHERE UserId = ? AND ChannelId = ?
```

---

## Export and indexing

(GetAllChannelsForExportAfter, GetChannelMembersForExport, GetAllDirectChannelsForExportAfter, GetChannelsBatchForIndexing use squirrel with Channels/Teams/Schemes/ChannelMembers/Users and filters; see code for exact columns and WHERE.)

---

## Misc

### UserBelongsToChannels

```sql
SELECT Count(*) FROM ChannelMembers
WHERE UserId = ? AND ChannelId IN (?)
```

Returns whether count > 0.

### UpdateMembersRole

Squirrel: UPDATE ChannelMembers SET SchemeAdmin = CASE WHEN UserId IN (?) THEN true ELSE false END, ... WHERE ChannelId = ? AND (SchemeGuest = false OR SchemeGuest IS NULL) AND (new admins or demoted admins), **RETURNING** channel member columns.

### GroupSyncedChannelCount

```sql
SELECT COUNT(*) FROM Channels
WHERE GroupConstrained = true AND DeleteAt = 0
```

### SetShared

```sql
UPDATE Channels SET Shared = ? WHERE Id = ?
```

### GetTeamForChannel

Subquery:

```sql
SELECT TeamId FROM Channels WHERE Id = ?
```

Main: select team columns from Teams WHERE Id = (subquery).

### IsReadOnlyChannel

```sql
SELECT schemeid FROM channels WHERE id = ? LIMIT 1
```

If scheme id present, calls **IsChannelReadOnlyScheme**.

### IsChannelReadOnlyScheme

```sql
SELECT roles.permissions FROM roles
INNER JOIN schemes ON roles.name = schemes.defaultchanneluserrole
WHERE schemes.id = ?
LIMIT 1
```

Returns whether the permission list does not contain `create_post`.

---

## No-op / cache-only (no SQL in this store)

InvalidateChannel, InvalidateChannelByName, ClearCaches, ClearMembersForUserCache, InvalidateAllChannelMembersForUser, InvalidateCacheForChannelMembersNotifyProps, InvalidateMemberCount, InvalidatePinnedPostCount, InvalidateGuestCount: no SQL. **GetMemberCountFromCache** delegates to **GetMemberCount** (SQL as in **GetMemberCount**).
