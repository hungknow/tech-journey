# Channel Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/channel_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization / Shared query builders

### initializeQueries

Builds reusable select builders (not executed by this function; used by other methods):

- **tableSelectQuery**:

```sql
SELECT (channel columns, including policy-enforcement subqueries)
FROM Channels
```

- **sidebarCategorySelectQuery**:

```sql
SELECT (SidebarCategories columns)
FROM SidebarCategories
```

- **channelMembersForTeamWithSchemeSelectQuery**: ChannelMembers + scheme roles from ChannelMembers INNER JOIN Channels and LEFT JOIN Schemes (ChannelScheme, TeamScheme) and Teams.

---

## Channel CRUD and lifecycle

### Save

Uses **saveChannelT** and **upsertPublicChannelT** inside a transaction. See those subsections for SQL.

### CreateDirectChannel

Builds a direct channel and two members; calls **SaveDirectChannel**. No direct SQL in this function.

### SaveDirectChannel

Uses **saveChannelT** for the channel, then **saveMultipleMembers** (or **saveMemberT**) for members. See those subsections for SQL.

### upsertPublicChannelT

Used inside Save, Update, SetDeleteAt, PermanentDelete flows when the channel is public.

For non-open channels: delete from PublicChannels by id.

```sql
DELETE FROM PublicChannels WHERE Id=?
```

For open channels: upsert one row into PublicChannels.

```sql
INSERT INTO PublicChannels(Id, DeleteAt, TeamId, DisplayName, Name, Header, Purpose)
VALUES (:id, :deleteat, :teamid, :displayname, :name, :header, :purpose)
ON CONFLICT (id) DO UPDATE
SET DeleteAt = :deleteat, TeamId = :teamid, DisplayName = :displayname,
    Name = :name, Header = :header, Purpose = :purpose;
```

### saveChannelT

Used by Save and SaveDirectChannel.

Count existing open/private channels for the team (when enforcing max channels per team):

```sql
SELECT COUNT(0) FROM Channels WHERE TeamId = ? AND DeleteAt = 0 AND (Type = ? OR Type = ?)
```

Insert channel with conflict handling (no update on conflict):

```sql
INSERT INTO Channels (...columns...) VALUES (...)
ON CONFLICT (TeamId, Name) DO NOTHING
```

If insert affected 0 rows (duplicate name): select existing channel by TeamId and Name using `tableSelectQuery` to return the conflicting channel.

### Update

Uses **updateChannelT** and **upsertPublicChannelT** inside a transaction. See those subsections for SQL.

### updateChannelT

Update channel by id (all listed columns):

```sql
UPDATE Channels
SET CreateAt=:CreateAt, UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, TeamId=:TeamId, Type=:Type,
    DisplayName=:DisplayName, Name=:Name, Header=:Header, Purpose=:Purpose,
    LastPostAt=:LastPostAt, TotalMsgCount=:TotalMsgCount, ExtraUpdateAt=:ExtraUpdateAt,
    CreatorId=:CreatorId, SchemeId=:SchemeId, GroupConstrained=:GroupConstrained, Shared=:Shared,
    TotalMsgCountRoot=:TotalMsgCountRoot, LastRootPostAt=:LastRootPostAt,
    BannerInfo=:BannerInfo, DefaultCategoryName=:DefaultCategoryName, AutoTranslation=:AutoTranslation
WHERE Id=:Id
```

### GetChannelUnread

Unread stats for one channel and user (message/mention counts, notify props):

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

Select pinned posts in channel with reply count subquery; from `Posts` with `IsPinned = true`, `ChannelId`, `DeleteAt = 0`, ordered by `CreateAt`.

### Get

Select single channel by id using `tableSelectQuery` + `WHERE Id = ?`.

### GetMany

Select channels by id list:

```sql
SELECT (channel columns)
FROM Channels
WHERE Id IN (?)
```

### Delete

Delegates to **SetDeleteAt**. No additional SQL.

### Restore

Delegates to **SetDeleteAt**. No additional SQL.

### SetDeleteAt

Runs **setDeleteAtT** and syncs PublicChannels inside a transaction.

Soft-delete/restore channel:

```sql
UPDATE Channels SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

Sync PublicChannels:

```sql
UPDATE PublicChannels SET DeleteAt = ? WHERE Id = ?
```

### setDeleteAtT

```sql
UPDATE Channels SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?
```

### PermanentDeleteByTeam

Runs **permanentDeleteByTeamtT** and deletes from PublicChannels inside a transaction.

Delete all channels for a team:

```sql
DELETE FROM Channels WHERE TeamId = ?
```

Then:

```sql
DELETE FROM PublicChannels WHERE TeamId = ?
```

### permanentDeleteByTeamtT

```sql
DELETE FROM Channels WHERE TeamId = ?
```

### PermanentDelete

Runs **permanentDeleteT** and deletes from PublicChannels inside a transaction.

Delete one channel:

```sql
DELETE FROM Channels WHERE Id = ?
```

Then:

```sql
DELETE FROM PublicChannels WHERE Id = ?
```

### permanentDeleteT

```sql
DELETE FROM Channels WHERE Id = ?
```

### PermanentDeleteMembersByChannel

Remove all members of a channel:

```sql
DELETE FROM ChannelMembers WHERE ChannelId = ?
```

---

## Channel listing and filtering

### GetChannels

Select channels for a user (optionally scoped by team): from `Channels ch, ChannelMembers cm` where `ch.Id = cm.ChannelId` and `cm.UserId = ?`, with optional filters (TeamId, DeleteAt, LastUpdateAt), ordered by `ch.DisplayName`. Uses full channel select including policy columns.

### GetChannelsByUser

Select channels the user is a member of: `Channels` `INNER JOIN ChannelMembers` `LEFT JOIN Teams`, `WHERE ChannelMembers.UserId = ?`, optional `Channels.Id > fromChannelID`, pagination, and DeleteAt/team filters. Ordered by `Channels.Id`.

### GetAllChannelMemberIdsByChannelId

```sql
SELECT UserId FROM ChannelMembers WHERE ChannelId=?
```

### GetAllChannels

Uses **getAllChannelsQuery(opts, false)**: select channels (with team data, optional PolicyID) from `Channels AS c` where type in (private, open), join Teams, optional filters (IncludeDeleted, NotAssociatedToGroup, GroupConstrained, ExcludeChannelNames, retention policy, access control). Order by `c.DisplayName, Teams.DisplayName`, limit/offset.

### GetAllChannelsCount

Uses **getAllChannelsQuery(opts, true)** with same filters as GetAllChannels (no team columns).

```sql
SELECT count(c.Id) FROM ... -- same filters as GetAllChannels
```

### getAllChannelsQuery

Helper that builds the select/count query for GetAllChannels and GetAllChannelsCount. Not called alone; see **GetAllChannels** and **GetAllChannelsCount**.

### GetMoreChannels

Subquery: public channel ids for team + user from `PublicChannels` join `ChannelMembers`. Main query: channels from `Channels` join `PublicChannels` for team, excluding that subquery, ordered by display name, limit/offset.

### GetPrivateChannelsForTeam

Select channels where `Type = private`, `TeamId = ?`, `DeleteAt = 0`, order by DisplayName, limit/offset.

### GetPublicChannelsForTeam

Select channels from `Channels` join `PublicChannels` where `PublicChannels.TeamId = ?` and `DeleteAt = 0`, order by display name, limit/offset.

### GetPublicChannelsByIdsForTeam

Same join as GetPublicChannelsForTeam, plus `PublicChannels.Id IN (channelIds)` for given team.

### GetChannelCounts

Channel message counts and update times for a user in a team:

```sql
SELECT Id, TotalMsgCount, TotalMsgCountRoot, UpdateAt
FROM Channels
WHERE Id IN (SELECT ChannelId FROM ChannelMembers WHERE UserId = ?)
  AND (TeamId = ? OR TeamId = '') AND DeleteAt = 0
ORDER BY DisplayName
```

### GetTeamChannels

`tableSelectQuery` where `TeamId = ?` and `Type != direct`, order by DisplayName.

### GetByNamesIncludeDeleted

Delegates to **getByNames** with includeArchivedChannels = true.

### GetByNames

Delegates to **getByNames** with includeArchivedChannels = false.

### getByNames

Select channels by name list, optional team, optional `DeleteAt = 0`.

### GetByNameIncludeDeleted

Delegates to **getByName** with includeDeleted = true.

### GetByName

Delegates to **getByName** with includeDeleted = false.

### getByName

Select one channel by name and team (or empty team), optional `DeleteAt = 0`.

### GetDeletedByName

Select one channel by team/name with `DeleteAt != 0` using `tableSelectQuery`.

### GetDeleted

Select deleted channels for team (and optionally only those user is member of), ordered by DisplayName, limit/offset.

---

## Channel members — save / update

### SaveMultipleMembers

Calls **saveMultipleMembers** for the given list. See **saveMultipleMembers** for SQL.

### SaveMember

Calls **SaveMultipleMembers** with a single member. See **saveMultipleMembers** for SQL.

### saveMultipleMembers

Used by SaveMember, SaveMultipleMembers, SaveDirectChannel.

Two reads for scheme roles:

- Channel scheme roles (for channel ids):

```sql
SELECT Channels.Id, ChannelScheme.DefaultChannelGuestRole, DefaultChannelUserRole, DefaultChannelAdminRole
FROM Channels
LEFT JOIN Schemes ChannelScheme ON ...
WHERE Channels.Id IN (?)
```

- Team scheme roles: same idea from Channels LEFT JOIN Teams and Schemes (TeamScheme), for same channel ids.

Bulk insert members:

```sql
INSERT INTO ChannelMembers (ChannelId, UserId, Roles, LastViewedAt, MsgCount, MsgCountRoot, MentionCount, MentionCountRoot, UrgentMentionCount, NotifyProps, LastUpdateAt, SchemeUser, SchemeAdmin, SchemeGuest, AutoTranslationDisabled)
VALUES (...), (...), ...
```

### saveMemberT

Calls **saveMultipleMembers** with a single member. See **saveMultipleMembers** for SQL.

### UpdateMultipleMembers

Used by UpdateMember. For each member: update all member fields; then select updated row using **channelMembersForTeamWithSchemeSelectQuery** filtered by ChannelId and UserId.

```sql
UPDATE ChannelMembers SET ... (all member fields) WHERE ChannelId = ? AND UserId = ?
```

### UpdateMember

Calls **UpdateMultipleMembers** with a single member. See **UpdateMultipleMembers** for SQL.

### UpdateMemberNotifyProps

Merge notify props (Postgres jsonb concat) and bump LastUpdateAt:

```sql
UPDATE channelmembers SET notifyprops = notifyprops || ?::jsonb, LastUpdateAt = ?
WHERE userid = ? AND channelid = ?
```

Then select member with scheme query by ChannelId and UserId.

### PatchMultipleMembersNotifyProps

Single update; then select all updated rows with same scheme query and same (ChannelId, UserId) list.

```sql
UPDATE ChannelMembers
SET notifyprops = notifyprops || ?::jsonb, LastUpdateAt = ?
WHERE (ChannelId, UserId) IN (...)
```

---

## Channel members — read

### GetMembers

`channelMembersForTeamWithSchemeSelectQuery` where `ChannelId = ?`, optional `LastUpdateAt > ?`, limit/offset. Returns members with scheme roles.

### GetChannelMembersTimezones

```sql
SELECT Users.Timezone
FROM ChannelMembers
LEFT JOIN Users ON ChannelMembers.UserId = Id
WHERE ChannelId = ?
```

### GetChannelsWithUnreadsAndWithMentions

Select channel id, type, TotalMsgCount, LastPostAt, member MsgCount, MentionCount, NotifyProps, LastViewedAt from ChannelMembers join Channels where ChannelId in list and UserId = ?. Used to compute unread and mention lists and read times.

### GetMember

Single member by channel and user using `channelMembersForTeamWithSchemeSelectQuery` + `WHERE ChannelId = ? AND UserId = ?`.

### GetMemberLastViewedAt

```sql
SELECT COALESCE(LastViewedAt, 0) AS LastViewedAt
FROM ChannelMembers WHERE ChannelId=? AND UserId=?
```

### GetMemberForPost

Select channel member (with scheme roles) for the channel of a given post and a user: ChannelMembers join Posts (on ChannelId), Channels, Schemes (ChannelScheme, TeamScheme), where `ChannelMembers.UserId = ?` and `Posts.Id = ?`.

### GetAllChannelMembersForUser

Select ChannelId, Roles, scheme guest/user/admin flags and default roles from ChannelMembers join Channels and Schemes, where `UserId = ?`, optional `Channels.DeleteAt = 0`. Returns map of channel id → roles string.

### GetChannelsMemberCount

Count non-deleted users per channel.

```sql
SELECT ChannelMembers.ChannelId, COUNT(*)
FROM ChannelMembers
INNER JOIN Users ON UserId = Users.Id
WHERE ChannelId IN (?) AND Users.DeleteAt = 0
GROUP BY ChannelId
```

### GetAllChannelMembersNotifyPropsForChannel

```sql
SELECT UserId, NotifyProps FROM ChannelMembers WHERE ChannelId = ?
```

### GetFileCount

```sql
SELECT COUNT(*) FROM FileInfo
WHERE FileInfo.DeleteAt = 0 AND FileInfo.PostId != '' AND FileInfo.ChannelId = ?
```

### GetMemberCount

```sql
SELECT count(*) FROM ChannelMembers, Users
WHERE ChannelMembers.UserId = Users.Id AND ChannelMembers.ChannelId = ? AND Users.DeleteAt = 0
```

### GetMemberCountsByGroup

Select GroupId and count of channel members (and optionally distinct timezones) from ChannelMembers join GroupMembers (and optionally Users), where `ChannelMembers.ChannelId = ?`, group by GroupId.

### GetPinnedPostCount

```sql
SELECT count(*) FROM Posts WHERE IsPinned = true AND ChannelId = ? AND DeleteAt = 0
```

### GetGuestCount

```sql
SELECT count(*) FROM ChannelMembers, Users
WHERE ChannelMembers.UserId = Users.Id AND ChannelMembers.ChannelId = ?
  AND ChannelMembers.SchemeGuest = TRUE AND Users.DeleteAt = 0
```

---

## Channel members — remove

### RemoveMembers

```sql
DELETE FROM ChannelMembers WHERE ChannelId = ? AND UserId IN (?)
```

```sql
DELETE FROM SidebarChannels WHERE ChannelId = ? AND UserId IN (?)
```

### RemoveMember

Calls **RemoveMembers** for a single user. No additional SQL.

### RemoveAllDeactivatedMembers

```sql
DELETE FROM ChannelMembers
WHERE UserId IN (SELECT Id FROM Users WHERE Users.DeleteAt != 0) AND ChannelMembers.ChannelId = ?
```

### PermanentDeleteMembersByUser

```sql
DELETE FROM ChannelMembers WHERE UserId = ?
```

---

## Last viewed and mentions

### UpdateLastViewedAt

Uses a CTE for given channel ids, then updates ChannelMembers and returns Id, LastPostAt.

```sql
WITH cte AS (
  SELECT Id, LastPostAt, TotalMsgCount, TotalMsgCountRoot
  FROM Channels
  WHERE Id IN (?)
)
UPDATE ChannelMembers
SET MentionCount = 0, MentionCountRoot = 0, UrgentMentionCount = 0,
    MsgCount = cte.TotalMsgCount - ..., MsgCountRoot = cte.TotalMsgCountRoot - ...,
    LastViewedAt = cte.LastPostAt, LastUpdateAt = cte.LastPostAt
FROM cte
WHERE ChannelMembers.ChannelId = cte.Id AND ChannelMembers.UserId = ?;

SELECT Id, LastPostAt FROM cte ...
```

### CountUrgentPostsAfter

Count from PostsPriority join Posts where priority = urgent, channel id, CreateAt > timestamp, DeleteAt = 0, optional UserId != excludedUserID.

### CountPostsAfter

Count posts in channel with CreateAt > timestamp, DeleteAt = 0, Type not in join/leave types, optional UserId != excludedUserID. Second query adds `RootId = ''` for root-only count.

### UpdateLastViewedAtPost

Uses CountPostsAfter; then single update of ChannelMembers with named params:

```sql
UPDATE ChannelMembers
SET MentionCount = :mentions, MentionCountRoot = :mentionsroot, UrgentMentionCount = :urgentmentions,
    MsgCount = (SELECT TotalMsgCount FROM Channels WHERE ID = :channelid) - :unreadcount,
    MsgCountRoot = (SELECT TotalMsgCountRoot FROM Channels WHERE ID = :channelid) - :unreadcountroot,
    LastViewedAt = :lastviewedat, LastUpdateAt = :updatedat
WHERE UserId = :userid AND ChannelId = :channelid
```

Then select ChannelMembers + Channel join for that user/channel to return ChannelUnreadAt.

### IncrementMentionCount

```sql
UPDATE ChannelMembers
SET MentionCount = MentionCount + 1,
    MentionCountRoot = MentionCountRoot + ?,
    UrgentMentionCount = UrgentMentionCount + ?,
    LastUpdateAt = ?
WHERE UserId IN (?) AND ChannelId = ?
```

---

## Channels by id / team / post

### GetAll

`tableSelectQuery` where `TeamId = ?` and `Type != direct`, order by Name.

### GetChannelsByIds

Select channels by id list from Channels, optional `DeleteAt = 0`, order by Name.

### GetChannelsWithTeamDataByIds

Same ids, from Channels c left join Teams t, optional DeleteAt filter, order by c.Name; returns channel + team display name, name, update at.

### GetForPost

Select channel by joining Channels and Posts on channel id, where `Posts.Id = ?`.

---

## Analytics

### AnalyticsTypeCount

```sql
SELECT COUNT(*) FROM Channels
-- optional: WHERE Type = ? AND TeamId = ?
```

### AnalyticsDeletedTypeCount

```sql
SELECT COUNT(Id) FROM Channels WHERE Type = ? AND DeleteAt > 0
```
Optional TeamId.

### AnalyticsCountAll

```sql
SELECT Type, COUNT(*) FROM Channels
-- optional: WHERE TeamId = ?
GROUP BY Type
```

---

## Members for user / team

### GetMembersForUser

`channelMembersForTeamWithSchemeSelectQuery` where UserId = ? and (Teams.Id = teamID or Teams.Id empty/null). Returns members with team/scheme data.

### GetMembersForUserWithPagination

Uses static **channelMembersWithSchemeSelectQuery** (ChannelMembers + Channels + Schemes + Teams) with `WHERE ChannelMembers.UserId = ? ORDER BY ChannelId ASC Limit ? Offset ?`.

### GetMembersForUserWithCursorPagination

Same base query with `WHERE ChannelMembers.UserId = ? AND ChannelId > ? ORDER BY ChannelId ASC Limit ?`.

### GetTeamMembersForChannel

```sql
SELECT tm.UserId
FROM Channels c, Teams t, TeamMembers tm
WHERE c.TeamId = t.Id AND t.Id = tm.TeamId AND c.Id = ?
```

---

## Search and autocomplete

### Autocomplete

Channels from Channels c, Teams t, TeamMembers tm where c.TeamId = t.Id, t.Id = tm.TeamId, tm.UserId = ?, tm.DeleteAt = 0, optional c.DeleteAt = 0; for guests filter to channels user is member of; for non-guests include open or user-member private channels. Optional search clause (LIKE/fulltext on Name, DisplayName, Purpose). Order by DisplayName, limit.

### AutocompleteInTeam

Channels where TeamId = ?, optional DeleteAt = 0, same guest/member and search logic, then **performSearch**.

### AutocompleteInTeamForSearch

Subquery: channels from Channels C join ChannelMembers CM where (TeamId = ? or (TeamId = '' and Type = group)) and CM.UserId = ?, optional DeleteAt = 0, limit 50. Then either plain query or UNION of LIKE and fulltext search on Name, DisplayName, Purpose (limit 50). Also appends **autocompleteInTeamForSearchDirectMessages** (DM/group channels by term on other user’s username/nickname).

### autocompleteInTeamForSearchDirectMessages

Channels type direct where user is member, join subquery on other member’s User (Username/Nickname) with LIKE/fulltext on term; limit 50.

### SearchInTeam

Channels join PublicChannels on id where team id and optional DeleteAt = 0; optional search clause; then **performSearch**.

### SearchForUserInTeam

Same as SearchInTeam but also join ChannelMembers and filter by userId; then **performSearch**.

### channelSearchQuery

Builds select (count or channel columns, optional team info, optional PolicyID) from Channels c join Teams t; filters: deleted, policy, like/fulltext term, ExcludeChannelNames, NotAssociatedToGroup, TeamIds, GroupConstrained, Public/Private, ExcludeRemote, access control; order/limit/offset. Used by SearchAllChannels.

### SearchAllChannels

Runs **channelSearchQuery** for results; if paginated, runs it again with CountOnly for total count.

### SearchMore

Subquery: public channel ids for team + user. Main: channels join PublicChannels for team, id not in subquery; optional search clause; **performSearch**.

### performSearch

Executes the given select builder (replica) and returns ChannelList.

### searchGroupChannelsQuery

Helper that builds the group-channel search query. Subquery: group channels where user is member, grouped by channel, HAVING on aggregated usernames (LIKE terms). Then select channels where Id IN (subquery), limit.

### SearchGroupChannels

Uses **searchGroupChannelsQuery**; executes and returns ChannelList.

---

## Members by id

### GetMembersByIds

`channelMembersForTeamWithSchemeSelectQuery` where ChannelId = ? and UserId IN (?).

### GetMembersByChannelIds

Same query where ChannelId IN (?) and UserId = ?.

### GetMembersInfoByChannelIds

Select ChannelId, User id and name fields from ChannelMembers join Channels and Users where ChannelId in list and Channels.DeleteAt = 0. Used to build map channel id → user list (e.g. DM names).

---

## Schemes and migration

### GetChannelsByScheme

`tableSelectQuery` where SchemeId = ?, order by DisplayName, limit/offset.

### MigrateChannelMembers

Select batch of ChannelMembers: (ChannelId, UserId) > (?, ?) order by ChannelId, UserId limit 100. For each row (named params):

```sql
UPDATE ChannelMembers
SET Roles = ?, LastViewedAt = ?, MsgCount = ?, ... SchemeUser = ?, SchemeAdmin = ?, SchemeGuest = ?, ...
WHERE ChannelId = ? AND UserId = ?
```

### ResetAllChannelSchemes

Runs **resetAllChannelSchemesT** inside a transaction.

### resetAllChannelSchemesT

```sql
UPDATE Channels SET SchemeId=''
```

### ClearAllCustomRoleAssignments

In a loop: select ChannelMembers batch with (ChannelId, UserId) > (?, ?) order by ChannelId, UserId limit 1000. For each member, keep only built-in roles and update if roles changed:

```sql
UPDATE ChannelMembers SET Roles = ? WHERE UserId = ? AND ChannelId = ?
```

---

## Export and indexing

### GetAllChannelsForExportAfter

Select channels (with team name, scheme name) from Channels inner join Teams, left join Schemes, where Id > afterId and Type in (open, private), order by Id, limit.

### GetChannelMembersForExport

Select channel member and channel name from ChannelMembers inner join Channels where UserId = ? and TeamId = ?; optional `Channels.DeleteAt = 0`.

### GetAllDirectChannelsForExportAfter

Select direct/group channels where Id > afterId, optional DeleteAt = 0, order by Id, limit. Then select members (with username) for those channel ids from ChannelMembers join Users.

### GetChannelsBatchForIndexing

Select channels (no policy subqueries) where (CreateAt > startTime) or (CreateAt = startTime and Id > startChannelID), order by CreateAt, Id, limit. Uses search replica.

---

## Misc

### UserBelongsToChannels

Returns whether count > 0.

```sql
SELECT Count(*) FROM ChannelMembers WHERE UserId = ? AND ChannelId IN (?)
```

### UpdateMembersRole

SchemeGuest false/null, and (new admins or demoted admins), with RETURNING columns. Returns updated members.

```sql
UPDATE ChannelMembers
SET SchemeAdmin = CASE WHEN UserId IN (?) THEN true ELSE false END, ...
WHERE ChannelId = ?
RETURNING ...
```

### GroupSyncedChannelCount

```sql
SELECT COUNT(*) FROM Channels WHERE GroupConstrained = true AND DeleteAt = 0
```

### SetShared

```sql
UPDATE Channels SET Shared = ? WHERE Id = ?
```

### GetTeamForChannel

```sql
SELECT TeamId FROM Channels WHERE Id = ?
```
Main: select team columns from Teams where Id = (subquery).

### IsReadOnlyChannel

```sql
SELECT schemeid FROM channels WHERE id = ? LIMIT 1
```
If scheme id present, calls **IsChannelReadOnlyScheme**.

### IsChannelReadOnlyScheme

Returns whether the permission list does not contain create_post.

```sql
SELECT roles.permissions FROM roles
INNER JOIN schemes ON roles.name = schemes.defaultchanneluserrole
WHERE schemes.id = ? LIMIT 1
```

---

## No-op / cache-only (no SQL in this store)

### InvalidateChannel

No SQL. Cache invalidation only.

### InvalidateChannelByName

No SQL. Cache invalidation only.

### ClearCaches

No SQL. Cache invalidation only.

### ClearMembersForUserCache

No SQL. Cache invalidation only.

### InvalidateAllChannelMembersForUser

No SQL. Cache invalidation only.

### InvalidateCacheForChannelMembersNotifyProps

No SQL. Cache invalidation only.

### InvalidateMemberCount

No SQL. Cache invalidation only.

### InvalidatePinnedPostCount

No SQL. Cache invalidation only.

### InvalidateGuestCount

No SQL. Cache invalidation only.

### GetMemberCountFromCache

Delegates to **GetMemberCount** with cache allowed; SQL is as in **GetMemberCount** above.
