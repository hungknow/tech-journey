# Group Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/group_store.go` and the SQL executed by that function. For each function, **Purpose** and **When to use** describe why it exists and in what context to call it. SQL is shown in fenced code blocks (lines ≤120 characters).

---

## Initialization

### newSqlGroupStore

**Purpose:** Build reusable SELECT builders for UserGroups, GroupMembers, GroupTeams, and GroupChannels.  
**When to use:** Called once at store init; not called directly by app code.

Base SELECTs (not executed alone; used by other functions):

**userGroupsSelectQuery:**

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
```

**groupMembersSelectQuery:**

```sql
SELECT GroupMembers.GroupId, GroupMembers.UserId, GroupMembers.CreateAt, GroupMembers.DeleteAt
FROM GroupMembers
```

**groupMemberUsersSelectQuery:** `getUsersColumns()` FROM GroupMembers JOIN Users ON Users.Id = GroupMembers.UserId.

**groupTeamsSelectQuery:**

```sql
SELECT GroupTeams.GroupId, GroupTeams.TeamId, GroupTeams.AutoAdd, GroupTeams.SchemeAdmin,
       GroupTeams.CreateAt, GroupTeams.UpdateAt, GroupTeams.DeleteAt
FROM GroupTeams
```

**groupChannelsSelectQuery:**

```sql
SELECT GroupChannels.GroupId, GroupChannels.ChannelId, GroupChannels.AutoAdd,
       GroupChannels.SchemeAdmin, GroupChannels.CreateAt, GroupChannels.UpdateAt,
       GroupChannels.DeleteAt
FROM GroupChannels
```

---

## UserGroups table — CRUD

### Create

**Purpose:** Insert a single group (no members).  
**When to use:** Creating a new LDAP/sync or custom group; app layer ensures name is unique vs usernames.

```sql
INSERT INTO UserGroups
(Id, Name, DisplayName, Description, Source, RemoteId, CreateAt, UpdateAt, DeleteAt, AllowReference)
VALUES
(:Id, :Name, :DisplayName, :Description, :Source, :RemoteId, :CreateAt, :UpdateAt, :DeleteAt, :AllowReference)
```

### CreateWithUserIds

**Purpose:** Create a group and add initial members in one transaction; returns the new group with MemberCount.  
**When to use:** Creating a custom group with a known list of user IDs (e.g. from API or UI).

Transaction: (1) INSERT UserGroups; (2) INSERT GroupMembers for each user; (3) SELECT new group with MemberCount.

**1. INSERT UserGroups** (builder): same columns as Create.

**2. buildInsertGroupUsersQuery — INSERT GroupMembers:**

```sql
INSERT INTO GroupMembers (GroupId, UserId, CreateAt, DeleteAt)
VALUES (?, ?, ?, 0), (?, ?, ?, 0), ...
```

**3. SELECT new group with MemberCount:**

```sql
SELECT UserGroups.*, A.Count AS MemberCount
FROM UserGroups
INNER JOIN (
  SELECT UserGroups.Id, COUNT(GroupMembers.UserId) AS Count
  FROM UserGroups
  LEFT JOIN GroupMembers ON UserGroups.Id = GroupMembers.GroupId
  WHERE UserGroups.Id = ?
  GROUP BY UserGroups.Id
  ORDER BY UserGroups.DisplayName, UserGroups.Id
  LIMIT 1 OFFSET 0
) AS A ON UserGroups.Id = A.Id
ORDER BY UserGroups.CreateAt DESC
```

### checkUsersExist

**Purpose:** Verify that all given user IDs exist and are not deleted (used before inserting GroupMembers).  
**When to use:** Internal use by CreateWithUserIds and UpsertMembers.

```sql
SELECT Id FROM Users WHERE Id IN (?) AND DeleteAt = 0
```

### Get

**Purpose:** Fetch a single group by ID.  
**When to use:** When you have a group ID (e.g. from a link, syncable, or member) and need full group details.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE Id = ?
```

### GetByName

**Purpose:** Fetch a single group by unique name; optionally restrict to groups allowed for @mention (AllowReference).  
**When to use:** Resolving group by name (e.g. from @group-name), or when only referenceable groups should be returned.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE Name = ?
-- optional: AND AllowReference = true
```

### GetByNames

**Purpose:** Fetch multiple groups by their names in one query.  
**When to use:** Resolving a list of group names (e.g. from API params or mention parsing) to group records.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE Name IN (?)
-- optional: AND AllowReference = true
```

### GetByIDs

**Purpose:** Fetch multiple groups by their IDs.  
**When to use:** When you have a list of group IDs (e.g. from syncables or member lists) and need full group data.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE Id IN (?)
```

### GetByRemoteID

**Purpose:** Fetch a group by its external-system identifier and source (e.g. LDAP/SCIM).  
**When to use:** During LDAP/SCIM sync or provisioning to find the local group that corresponds to a remote group.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE RemoteId = ? AND Source = ?
```

### GetAllBySource

**Purpose:** List all non-deleted groups for a given source (e.g. LDAP, custom).  
**When to use:** Syncing or listing groups by provider (e.g. “all LDAP groups” or “all custom groups”).

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
WHERE DeleteAt = 0 AND Source = ?
```

### GetByUser

**Purpose:** List all groups a user belongs to (optionally only referenceable).  
**When to use:** “My groups” views, APIs that return a user’s groups, or permission checks based on group membership.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
FROM UserGroups
JOIN GroupMembers ON GroupMembers.GroupId = UserGroups.Id
WHERE GroupMembers.DeleteAt = 0 AND GroupMembers.UserId = ?
-- optional: AND UserGroups.AllowReference = true
```

### Update

**Purpose:** Update group metadata (name, display name, description, source, remote ID, timestamps, allow reference).  
**When to use:** Editing a group from API/UI or after syncing from LDAP/SCIM.

```sql
UPDATE UserGroups
SET Name=:Name, DisplayName=:DisplayName, Description=:Description, Source=:Source,
    RemoteId=:RemoteId, CreateAt=:CreateAt, UpdateAt=:UpdateAt, DeleteAt=:DeleteAt, AllowReference=:AllowReference
WHERE Id=:Id
```

### Delete

**Purpose:** Soft-delete a group (set DeleteAt).  
**When to use:** Removing a group from use while keeping history; sync or admin flows.

```sql
UPDATE UserGroups SET DeleteAt=?, UpdateAt=? WHERE Id=? AND DeleteAt=0
```

### Restore

**Purpose:** Restore a soft-deleted group (clear DeleteAt).  
**When to use:** Undelete flow in admin or when a previously deleted group is re-synced.

```sql
UPDATE UserGroups SET DeleteAt=0, UpdateAt=? WHERE Id=? AND DeleteAt!=0
```

---

## GroupMembers table

### GetMember

**Purpose:** Check whether a user is an active member of a group (single GroupMember row).  
**When to use:** Before add/remove, or to decide if a user has group-based access to a team/channel.

```sql
SELECT GroupMembers.GroupId, GroupMembers.UserId, GroupMembers.CreateAt, GroupMembers.DeleteAt
FROM GroupMembers
WHERE UserId = ? AND GroupId = ? AND DeleteAt = 0
```

### GetMemberUsers

**Purpose:** Return all active (non-deleted) users who are members of a group.  
**When to use:** Group member list, “add members” prefetch, or including member IDs in GetGroups (IncludeMemberIDs).

```sql
SELECT Users.*
FROM GroupMembers
JOIN Users ON Users.Id = GroupMembers.UserId
WHERE GroupMembers.DeleteAt = 0 AND Users.DeleteAt = 0 AND GroupMembers.GroupId = ?
```

### GetMemberUsersPage / GetMemberUsersSortedPage

**Purpose:** Paginated, sortable list of group members (optionally respecting view restrictions).  
**When to use:** Group member list UI with page size and sort (username, nickname, or full name).

Same as GetMemberUsers; then wrapped in subselect, optional ORDER BY (Username or nickname/fullname CASE),
LIMIT ? OFFSET ?; optional view-restrictions filter.

### GetNonMemberUsersPage

**Purpose:** Paginated list of users who are not (active) members of the group, for “add members” UI.  
**When to use:** Add-members modal or page when selecting users to add to a group.

```sql
SELECT Users.*
FROM Users
LEFT JOIN GroupMembers ON (GroupMembers.UserId = Users.Id AND GroupMembers.GroupId = ?)
WHERE Users.DeleteAt = 0
  AND (GroupMembers.UserID IS NULL OR GroupMembers.DeleteAt != 0)
ORDER BY Users.Username ASC
LIMIT ? OFFSET ?
```
Optional view-restrictions filter applied.

### GetMemberCount / GetMemberCountWithRestrictions

**Purpose:** Count distinct active users in a group (optionally respecting view restrictions).  
**When to use:** Displaying member count on group cards/lists or in sync/admin logic.

```sql
SELECT COUNT(DISTINCT Users.Id)
FROM GroupMembers
JOIN Users ON Users.Id = GroupMembers.UserId
WHERE GroupMembers.GroupId = ? AND Users.DeleteAt = 0 AND GroupMembers.DeleteAt = 0
```
Optional view-restrictions filter applied.

### GetMemberUsersInTeam

**Purpose:** List group members who are also members of a given team (intersection).  
**When to use:** Showing “group members in this team” or pre-filling add-to-channel from group+team.

```sql
SELECT Users.*
FROM GroupMembers
JOIN Users ON Users.Id = GroupMembers.UserId
WHERE GroupMembers.GroupId = ?
  AND GroupMembers.DeleteAt = 0 AND Users.DeleteAt = 0
  AND GroupMembers.UserId IN (
    SELECT TeamMembers.UserId FROM TeamMembers
    JOIN Teams ON Teams.Id = TeamMembers.TeamId
    WHERE TeamMembers.TeamId = ? AND TeamMembers.DeleteAt = 0
  )
```

### GetMemberUsersNotInChannel

**Purpose:** List group members who are on the channel’s team but not yet in the channel (candidates to add).  
**When to use:** “Add group members to channel” UI: users who can be added from the group to this channel.

```sql
SELECT Users.*
FROM GroupMembers
JOIN Users ON Users.Id = GroupMembers.UserId
WHERE GroupMembers.GroupId = ?
  AND GroupMembers.UserId NOT IN (SELECT ChannelMembers.UserId FROM ChannelMembers WHERE ChannelMembers.ChannelId = ?)
  AND GroupMembers.UserId IN (
    SELECT TeamMembers.UserId FROM Channels
    JOIN TeamMembers ON TeamMembers.TeamId = Channels.TeamId
    WHERE Channels.Id = ? AND TeamMembers.DeleteAt = 0
  )
  AND GroupMembers.DeleteAt = 0 AND Users.DeleteAt = 0
```

### UpsertMember / buildUpsertMembersQuery

**Purpose:** Add a user to a group or re-activate a soft-deleted membership (upsert by GroupId+UserId).  
**When to use:** Adding a single member from UI/API, or sync adding one user to a group.

```sql
INSERT INTO GroupMembers (GroupId, UserId, CreateAt, DeleteAt)
VALUES (?, ?, ?, 0)
ON CONFLICT (groupid, userid) DO UPDATE SET CreateAt = ?, DeleteAt = ?
```

### DeleteMember

**Purpose:** Soft-remove one user from a group (set DeleteAt on GroupMembers).  
**When to use:** Removing a single member from a group from UI/API or sync.

```sql
UPDATE GroupMembers SET DeleteAt=? WHERE GroupId=? AND UserId IN (?)
```

### UpsertMembers / DeleteMembers

**Purpose:** Bulk add (or re-activate) or bulk remove members for a group.  
**When to use:** Sync applying full member list for a group, or UI “add/remove several members” in one go.

**UpsertMembers:** same INSERT...ON CONFLICT shape for multiple rows. **DeleteMembers:** same UPDATE with UserId IN (?).

### PermanentDeleteMembersByUser

**Purpose:** Permanently remove all group memberships for a user (hard delete).  
**When to use:** User permanent delete; clean up after deprovisioning.

```sql
DELETE FROM GroupMembers WHERE UserId = ?
```

---

## GroupSyncables (Team and Channel)

### CreateGroupSyncable

**Purpose:** Link a group to a team or channel (create GroupTeams or GroupChannels row with AutoAdd, SchemeAdmin).  
**When to use:** UI or API “link this group to team/channel”; first step before group-based sync applies.

**GroupTeams:**

```sql
INSERT INTO GroupTeams
(GroupId, AutoAdd, SchemeAdmin, CreateAt, DeleteAt, UpdateAt, TeamId)
VALUES
(:GroupId, :AutoAdd, :SchemeAdmin, :CreateAt, :DeleteAt, :UpdateAt, :TeamId)
```

**GroupChannels:**

```sql
INSERT INTO GroupChannels
(GroupId, AutoAdd, SchemeAdmin, CreateAt, DeleteAt, UpdateAt, ChannelId)
VALUES
(:GroupId, :AutoAdd, :SchemeAdmin, :CreateAt, :DeleteAt, :UpdateAt, :ChannelId)
```

### GetGroupSyncable / getGroupSyncable

**Purpose:** Fetch the link (GroupSyncable) between a group and a team or channel.  
**When to use:** Checking if a group is linked, reading AutoAdd/SchemeAdmin, or before update/delete of the link.

**Team:**

```sql
SELECT GroupTeams.GroupId, GroupTeams.TeamId, GroupTeams.AutoAdd, GroupTeams.SchemeAdmin,
       GroupTeams.CreateAt, GroupTeams.UpdateAt, GroupTeams.DeleteAt
FROM GroupTeams
WHERE GroupTeams.GroupId = ? AND GroupTeams.TeamId = ?
```

**Channel:**

```sql
SELECT GroupChannels.GroupId, GroupChannels.ChannelId, GroupChannels.AutoAdd,
       GroupChannels.SchemeAdmin, GroupChannels.CreateAt, GroupChannels.UpdateAt,
       GroupChannels.DeleteAt
FROM GroupChannels
WHERE GroupChannels.GroupId = ? AND GroupChannels.ChannelId = ?
```

### UpdateGroupSyncable / DeleteGroupSyncable

**Purpose:** Update link settings (AutoAdd, SchemeAdmin) or soft-unlink group from team/channel.  
**When to use:** Editing link options in UI; or removing a group from a team/channel (DeleteGroupSyncable).

**GroupTeams** (update and soft-delete use same UPDATE):

```sql
UPDATE GroupTeams
SET AutoAdd=:AutoAdd, SchemeAdmin=:SchemeAdmin, CreateAt=:CreateAt,
    DeleteAt=:DeleteAt, UpdateAt=:UpdateAt
WHERE GroupId=:GroupId AND TeamId=:TeamId
```

**GroupChannels** (update and soft-delete use same UPDATE):

```sql
UPDATE GroupChannels
SET AutoAdd=:AutoAdd, SchemeAdmin=:SchemeAdmin, CreateAt=:CreateAt,
    DeleteAt=:DeleteAt, UpdateAt=:UpdateAt
WHERE GroupId=:GroupId AND ChannelId=:ChannelId
```

### GetAllGroupSyncablesByGroupId

**Purpose:** List all teams or all channels linked to a group (with display names and types).  
**When to use:** “Where is this group linked?” UI; building sync or admin views per group.

**Team:**

```sql
SELECT GroupTeams.GroupId, GroupTeams.TeamId, GroupTeams.AutoAdd, GroupTeams.SchemeAdmin,
       GroupTeams.CreateAt, GroupTeams.UpdateAt, GroupTeams.DeleteAt,
       Teams.DisplayName AS TeamDisplayName, Teams.Type AS TeamType
FROM GroupTeams
JOIN Teams ON Teams.Id = GroupTeams.TeamId
WHERE GroupTeams.GroupId = ? AND GroupTeams.DeleteAt = 0
```

**Channel:**

```sql
SELECT GroupChannels.GroupId, GroupChannels.ChannelId, GroupChannels.AutoAdd,
       GroupChannels.SchemeAdmin, GroupChannels.CreateAt, GroupChannels.UpdateAt,
       GroupChannels.DeleteAt,
       Channels.DisplayName AS ChannelDisplayName, Teams.DisplayName AS TeamDisplayName,
       Channels.Type AS ChannelType, Teams.Type AS TeamType, Teams.Id AS TeamId
FROM GroupChannels
JOIN Channels ON Channels.Id = GroupChannels.ChannelId
JOIN Teams ON Teams.Id = Channels.TeamId
WHERE GroupChannels.GroupId = ? AND GroupChannels.DeleteAt = 0
```

### TeamMembersToAdd

**Purpose:** Return (UserId, TeamId) pairs that should get new team membership based on group sync (AutoAdd groups). Optionally scoped to one team; `since` and `reAddRemovedMembers` control incremental vs full re-add.  
**When to use:** Group sync job: determine which users to add to which teams; `since` is typically last successful sync time.

```sql
SELECT GroupMembers.UserId AS UserID, GroupTeams.TeamId AS TeamID
FROM GroupMembers
JOIN GroupTeams ON GroupTeams.GroupId = GroupMembers.GroupId
JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
JOIN Teams ON Teams.Id = GroupTeams.TeamId
WHERE UserGroups.DeleteAt = 0 AND GroupTeams.DeleteAt = 0 AND GroupTeams.AutoAdd = true
  AND GroupMembers.DeleteAt = 0 AND Teams.DeleteAt = 0
-- if !reAddRemovedMembers: LEFT JOIN TeamMembers ... WHERE TeamMembers.UserId IS NULL
--   AND (GroupMembers.CreateAt >= ? OR GroupTeams.UpdateAt >= ?)
-- if teamID != nil: AND Teams.Id = ?
```

### ChannelMembersToAdd

**Purpose:** Return (UserId, ChannelId) pairs that should get new channel membership based on group sync (AutoAdd). Optionally scoped to one channel; `since` and `reAddRemovedMembers` control incremental vs full re-add.  
**When to use:** Group sync job: determine which users to add to which channels; `since` is typically last successful sync time.

```sql
SELECT GroupMembers.UserId AS UserID, GroupChannels.ChannelId AS ChannelID
FROM GroupMembers
JOIN GroupChannels ON GroupChannels.GroupId = GroupMembers.GroupId
JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
JOIN Channels ON Channels.Id = GroupChannels.ChannelId
WHERE UserGroups.DeleteAt = 0 AND GroupChannels.DeleteAt = 0 AND GroupChannels.AutoAdd = true
  AND GroupMembers.DeleteAt = 0 AND Channels.DeleteAt = 0
-- if !reAddRemovedMembers: LEFT JOIN ChannelMemberHistory ... WHERE ... LeaveTime IS NULL, etc.
-- if channelID != nil: AND Channels.Id = ?
```

### TeamMembersToRemove

**Purpose:** Return team members who should be removed because they are no longer in any group linked to that group-constrained team.  
**When to use:** Group sync job: list users to remove from a team when group membership no longer permits access.

```sql
SELECT TeamMembers.TeamId, TeamMembers.UserId, TeamMembers.Roles, TeamMembers.DeleteAt,
       TeamMembers.SchemeUser, TeamMembers.SchemeAdmin,
       (TeamMembers.SchemeGuest IS NOT NULL AND TeamMembers.SchemeGuest) AS SchemeGuest
FROM TeamMembers
JOIN Teams ON Teams.Id = TeamMembers.TeamId
LEFT JOIN Bots ON Bots.UserId = TeamMembers.UserId
WHERE TeamMembers.DeleteAt = 0 AND Teams.DeleteAt = 0 AND Teams.GroupConstrained = true
  AND Bots.UserId IS NULL
  AND (TeamMembers.TeamId, TeamMembers.UserId) NOT IN (
    SELECT Teams.Id AS TeamId, GroupMembers.UserId
    FROM Teams
    JOIN GroupTeams ON GroupTeams.TeamId = Teams.Id
    JOIN UserGroups ON UserGroups.Id = GroupTeams.GroupId
    JOIN GroupMembers ON GroupMembers.GroupId = UserGroups.Id
    WHERE Teams.GroupConstrained = TRUE AND GroupTeams.DeleteAt = 0
      AND UserGroups.DeleteAt = 0 AND Teams.DeleteAt = 0 AND GroupMembers.DeleteAt = 0
    GROUP BY Teams.Id, GroupMembers.UserId
  )
-- if teamID != nil: AND TeamMembers.TeamId = ?
```

### ChannelMembersToRemove

**Purpose:** Return channel members who should be removed because they are no longer in any group linked to that group-constrained channel.  
**When to use:** Group sync job: list users to remove from a channel when group membership no longer permits access.

```sql
SELECT ChannelMembers.ChannelId, ChannelMembers.UserId, ChannelMembers.LastViewedAt,
       ChannelMembers.MsgCount, ChannelMembers.MsgCountRoot, ChannelMembers.MentionCount,
       ChannelMembers.MentionCountRoot, ChannelMembers.NotifyProps, ChannelMembers.LastUpdateAt,
       ChannelMembers.SchemeUser, ChannelMembers.SchemeAdmin,
       (ChannelMembers.SchemeGuest IS NOT NULL AND ChannelMembers.SchemeGuest) AS SchemeGuest
FROM ChannelMembers
JOIN Channels ON Channels.Id = ChannelMembers.ChannelId
LEFT JOIN Bots ON Bots.UserId = ChannelMembers.UserId
WHERE Channels.DeleteAt = 0 AND Channels.GroupConstrained = true AND Bots.UserId IS NULL
  AND (ChannelMembers.ChannelId, ChannelMembers.UserId) NOT IN (
    SELECT Channels.Id AS ChannelId, GroupMembers.UserId
    FROM Channels
    JOIN GroupChannels ON GroupChannels.ChannelId = Channels.Id
    JOIN UserGroups ON UserGroups.Id = GroupChannels.GroupId
    JOIN GroupMembers ON GroupMembers.GroupId = UserGroups.Id
    WHERE Channels.GroupConstrained = TRUE AND GroupChannels.DeleteAt = 0
      AND UserGroups.DeleteAt = 0 AND Channels.DeleteAt = 0 AND GroupMembers.DeleteAt = 0
    GROUP BY Channels.Id, GroupMembers.UserId
  )
-- if channelID != nil: AND ChannelMembers.ChannelId = ?
```

### CountGroupsByChannel

**Purpose:** Count groups linked to a channel (optionally filtered by AllowReference, search Q).  
**When to use:** Pagination total for “groups in this channel” UI; APIs that return count + list.

Uses **groupsBySyncableBaseQuery** with selectCountGroups:

```sql
SELECT COUNT(*)
FROM UserGroups
JOIN GroupChannels gs ON gs.GroupId = UserGroups.Id
WHERE gs.ChannelId = ? AND gs.DeleteAt = 0 AND UserGroups.DeleteAt = 0
-- optional: UserGroups.AllowReference = true, (Name ILIKE ? OR DisplayName ILIKE ?)
```

### GetGroupsByChannel (groupsBySyncableBaseQuery selectGroups)

**Purpose:** List groups linked to a channel (with SchemeAdmin for the link); optional member count, filter, pagination.  
**When to use:** Channel settings “linked groups” list; @mention allowed-groups in channel; notification/mention logic.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference,
       gs.SchemeAdmin AS SyncableSchemeAdmin
-- optional: , coalesce(Members.MemberCount, 0) AS MemberCount
FROM UserGroups
JOIN GroupChannels gs ON gs.GroupId = UserGroups.Id
-- optional LEFT JOIN (Members subquery) ON Members.GroupId = UserGroups.Id
WHERE gs.ChannelId = ? AND gs.DeleteAt = 0 AND UserGroups.DeleteAt = 0
-- optional: AND UserGroups.AllowReference = true
-- optional: AND (UserGroups.Name ILIKE ? OR UserGroups.DisplayName ILIKE ?)
ORDER BY UserGroups.DisplayName
-- optional: LIMIT ? OFFSET ?
```

### CountGroupsByTeam

**Purpose:** Count groups linked to a team (optionally filtered).  
**When to use:** Pagination total for “groups in this team” UI; APIs that return count + list.

```sql
SELECT COUNT(*)
FROM UserGroups
JOIN GroupTeams gs ON gs.GroupId = UserGroups.Id
WHERE gs.TeamId = ? AND gs.DeleteAt = 0 AND UserGroups.DeleteAt = 0
-- optional: FilterAllowReference, Q
```

### GetGroupsByTeam (groupsBySyncableBaseQuery selectGroups)

**Purpose:** List groups linked to a team (with SchemeAdmin for the link); optional member count, filter, pagination.  
**When to use:** Team settings “linked groups” list; resolving allowed groups for channels in the team; mention/permission logic.

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference,
       gs.SchemeAdmin AS SyncableSchemeAdmin
-- optional: , coalesce(Members.MemberCount, 0) AS MemberCount
FROM UserGroups
JOIN GroupTeams gs ON gs.GroupId = UserGroups.Id
-- optional LEFT JOIN (Members subquery) ON Members.GroupId = UserGroups.Id
WHERE gs.TeamId = ? AND gs.DeleteAt = 0 AND UserGroups.DeleteAt = 0
-- optional: AND UserGroups.AllowReference = true
-- optional: AND (UserGroups.Name ILIKE ? OR UserGroups.DisplayName ILIKE ?)
ORDER BY UserGroups.DisplayName
-- optional: LIMIT ? OFFSET ?
```

### getGroupsAssociatedToChannelsByTeam

**Purpose:** For a team, list groups linked to each channel (map channelId → groups with SchemeAdmin).  
**When to use:** Bulk “groups per channel” for team; channel settings when many channels share the same team.

```sql
SELECT UserGroups.*, gc.ChannelId, gc.SchemeAdmin AS SyncableSchemeAdmin
FROM UserGroups
LEFT JOIN (
  SELECT GroupChannels.GroupId, GroupChannels.ChannelId, GroupChannels.DeleteAt,
         GroupChannels.SchemeAdmin
  FROM GroupChannels
  LEFT JOIN Channels ON Channels.Id = GroupChannels.ChannelId
  WHERE GroupChannels.DeleteAt = 0 AND Channels.DeleteAt = 0 AND Channels.TeamId = ?
) AS gc ON gc.GroupId = UserGroups.Id
WHERE UserGroups.DeleteAt = 0 AND gc.DeleteAt = 0
ORDER BY UserGroups.DisplayName
```
Optional IncludeMemberCount (Members subquery), FilterAllowReference, Q.

### GetGroupsAssociatedToChannelsByTeam

**Purpose:** Return a map of channel ID → list of groups linked to that channel, for all channels in a team.  
**When to use:** Team/channel admin UI that shows linked groups for every channel in the team in one call.

Uses getGroupsAssociatedToChannelsByTeam; optional PageOpts (LIMIT OFFSET).

### TeamMembersMinusGroupMembers

**Purpose:** List team members who are not in any of the given groups (with aggregated group IDs for display). Used to see who would be removed if the team were constrained to those groups.  
**When to use:** “Preview who would be removed” when linking groups to a group-constrained team; sync or admin UI.

```sql
SELECT Users.*, COALESCE(TeamMembers.SchemeGuest, false) AS SchemeGuest,
       TeamMembers.SchemeAdmin, TeamMembers.SchemeUser,
       string_agg(UserGroups.Id, ',') AS GroupIDs
FROM TeamMembers
JOIN Teams ON Teams.Id = TeamMembers.TeamId
JOIN Users ON Users.Id = TeamMembers.UserId
LEFT JOIN Bots ON Bots.UserId = TeamMembers.UserId
LEFT JOIN GroupMembers ON GroupMembers.UserId = Users.Id
LEFT JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
WHERE TeamMembers.DeleteAt = 0 AND Teams.DeleteAt = 0 AND Users.DeleteAt = 0
  AND Bots.UserId IS NULL AND Teams.Id = ?
  AND Users.Id NOT IN (SELECT GroupMembers.UserId FROM GroupMembers
    JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
    WHERE GroupMembers.DeleteAt = 0 AND GroupMembers.GroupId IN (?, ?, ...))
GROUP BY Users.Id, TeamMembers.SchemeGuest, TeamMembers.SchemeAdmin, TeamMembers.SchemeUser
ORDER BY Users.Username ASC
LIMIT ? OFFSET ?
```

### CountTeamMembersMinusGroupMembers

**Purpose:** Count team members who are not in any of the given groups (for pagination or display).  
**When to use:** Total count for “team members minus group members” preview when linking groups to a team.

Same FROM/WHERE as above; SELECT count(DISTINCT Users.Id) (no GROUP BY, LIMIT, ORDER BY).

### ChannelMembersMinusGroupMembers

**Purpose:** List channel members who are not in any of the given groups. Used to see who would be removed if the channel were constrained to those groups.  
**When to use:** “Preview who would be removed” when linking groups to a group-constrained channel; sync or admin UI.

```sql
SELECT Users.*, COALESCE(ChannelMembers.SchemeGuest, FALSE) AS SchemeGuest,
       ChannelMembers.SchemeAdmin, ChannelMembers.SchemeUser,
       string_agg(UserGroups.Id, ',') AS GroupIDs
FROM ChannelMembers
JOIN Channels ON Channels.Id = ChannelMembers.ChannelId
JOIN Users ON Users.Id = ChannelMembers.UserId
LEFT JOIN Bots ON Bots.UserId = ChannelMembers.UserId
LEFT JOIN GroupMembers ON GroupMembers.UserId = Users.Id
LEFT JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
WHERE Channels.DeleteAt = 0 AND Users.DeleteAt = 0 AND Bots.UserId IS NULL
  AND Channels.Id = ?
  AND Users.Id NOT IN (SELECT GroupMembers.UserId FROM GroupMembers
    JOIN UserGroups ON UserGroups.Id = GroupMembers.GroupId
    WHERE GroupMembers.DeleteAt = 0 AND GroupMembers.GroupId IN (?, ?, ...))
GROUP BY Users.Id, ChannelMembers.SchemeGuest, ChannelMembers.SchemeAdmin, ChannelMembers.SchemeUser
ORDER BY Users.Username ASC
LIMIT ? OFFSET ?
```

### CountChannelMembersMinusGroupMembers

**Purpose:** Count channel members who are not in any of the given groups (for pagination or display).  
**When to use:** Total count for “channel members minus group members” preview when linking groups to a channel.

Same as CountTeamMembersMinusGroupMembers but for channel query; SELECT count(DISTINCT Users.Id).

---

## Counts and admin

### AdminRoleGroupsForSyncableMember

**Purpose:** Return group IDs for which the user is a member and the group is configured as SchemeAdmin for the given team/channel.  
**When to use:** Deciding if a user has group-based admin role on a syncable (e.g. channel admin via group).

**Channel:**

```sql
SELECT GroupMembers.GroupId
FROM GroupMembers
INNER JOIN GroupChannels AS joinGroup ON joinGroup.GroupId = GroupMembers.GroupId
WHERE GroupMembers.UserId = ? AND GroupMembers.DeleteAt = 0
  AND joinGroup.ChannelId = ? AND joinGroup.DeleteAt = 0 AND joinGroup.SchemeAdmin = true
```

**Team:** same with GroupTeams and joinGroup.TeamId = ?.

### PermittedSyncableAdmins

**Purpose:** Return user IDs of users who are permitted by the group syncable to have the admin role for that team/channel (members of groups linked with SchemeAdmin).  
**When to use:** Listing “who can be admin” for a team/channel via groups; permission or admin-assignment UI.

**Team:**

```sql
SELECT UserId
FROM GroupTeams
JOIN GroupMembers ON GroupMembers.GroupId = GroupTeams.GroupId
  AND GroupTeams.SchemeAdmin = TRUE AND GroupMembers.DeleteAt = 0
WHERE GroupTeams.TeamId = ?
```

**Channel:**

```sql
SELECT UserId
FROM GroupChannels
JOIN GroupMembers ON GroupMembers.GroupId = GroupChannels.GroupId
  AND GroupChannels.SchemeAdmin = TRUE AND GroupMembers.DeleteAt = 0
WHERE GroupChannels.ChannelId = ?
```

### countTable

**Purpose:** Generic count of rows in a table with DeleteAt = 0 (used by GroupCount, GroupTeamCount, etc.).  
**When to use:** Internal helper; call the specific GroupCount/GroupTeamCount/… functions instead.

```sql
SELECT COUNT(*) FROM tableName WHERE DeleteAt = 0
```
Used for: UserGroups, GroupTeams, GroupChannels, GroupMembers.

### countTableWithSelectAndWhere

**Purpose:** Generic count with custom SELECT and WHERE (e.g. COUNT(*), COUNT(DISTINCT UserId), or filter by Source/AllowReference).  
**When to use:** Internal helper for GroupCountBySource, DistinctGroupMemberCount, GroupCountWithAllowReference.

```sql
SELECT selectStr FROM tableName WHERE col1 = ? AND col2 = ? ...
```
When whereStmt is nil, default WHERE DeleteAt = 0.

### GroupCount

**Purpose:** Total number of non-deleted groups.  
**When to use:** System stats, admin dashboards, or license/limit checks.

```sql
SELECT COUNT(*) FROM UserGroups WHERE DeleteAt = 0
```

### GroupCountBySource

**Purpose:** Count groups by source (e.g. LDAP, custom).  
**When to use:** Per-source stats or “how many LDAP vs custom groups.”

```sql
SELECT COUNT(*) FROM UserGroups WHERE Source = ? AND DeleteAt = 0
```

### GroupTeamCount

**Purpose:** Total number of group–team links (non-deleted).  
**When to use:** System or sync stats; understanding scale of group-team associations.

```sql
SELECT COUNT(*) FROM GroupTeams WHERE DeleteAt = 0
```

### GroupChannelCount

**Purpose:** Total number of group–channel links (non-deleted).  
**When to use:** System or sync stats; scale of group-channel associations.

```sql
SELECT COUNT(*) FROM GroupChannels WHERE DeleteAt = 0
```

### GroupMemberCount

**Purpose:** Total number of active group membership rows (soft-deleted excluded).  
**When to use:** System stats; total memberships across all groups.

```sql
SELECT COUNT(*) FROM GroupMembers WHERE DeleteAt = 0
```

### DistinctGroupMemberCount

**Purpose:** Count of distinct users who are in at least one group (active membership).  
**When to use:** “How many users are in any group” for stats or licensing.

```sql
SELECT COUNT(DISTINCT UserId) FROM GroupMembers WHERE DeleteAt = 0
```

### DistinctGroupMemberCountForSource

**Purpose:** Count distinct users who are members of at least one group of the given source (e.g. LDAP).  
**When to use:** Per-source stats: “how many users in LDAP groups.”

```sql
SELECT COUNT(DISTINCT GroupMembers.UserId)
FROM GroupMembers
JOIN UserGroups ON GroupMembers.GroupId = UserGroups.Id
WHERE UserGroups.Source = ? AND GroupMembers.DeleteAt = 0
```

### GroupCountWithAllowReference

**Purpose:** Count groups that can be referenced (e.g. in @mentions).  
**When to use:** Stats or limits for referenceable groups; mention/UI eligibility.

```sql
SELECT COUNT(*) FROM UserGroups WHERE AllowReference = true AND DeleteAt = 0
```

### GetGroups

**Purpose:** Paginated, filterable list of groups (search, source, not-associated-to team/channel, member count, allow reference, archived, etc.).  
**When to use:** Main “groups list” API and UI (system console, pickers, add-to-team/channel); mention resolution when not constrained to a single channel/team.

Base query (optional columns and joins vary by opts):

```sql
SELECT UserGroups.Id, UserGroups.Name, UserGroups.DisplayName, UserGroups.Description,
       UserGroups.Source, UserGroups.RemoteId, UserGroups.CreateAt, UserGroups.UpdateAt,
       UserGroups.DeleteAt, UserGroups.AllowReference
-- optional: , coalesce(Members.MemberCount, 0) AS MemberCount
-- optional: , coalesce(ChannelMembers.ChannelMemberCount, 0) AS ChannelMemberCount, ...
FROM UserGroups
-- optional LEFT JOIN (Members subquery), (ChannelMembers subquery), GroupMembers (FilterHasMember)
WHERE 1=1
-- optional: AND UserGroups.UpdateAt > ?
-- optional: AND UserGroups.DeleteAt = 0 | UserGroups.DeleteAt > 0
-- optional: AND UserGroups.AllowReference = true
-- optional: AND (UserGroups.Name ILIKE ? OR UserGroups.DisplayName ILIKE ?)
-- optional: AND UserGroups.Id NOT IN (SELECT ... GroupTeams.TeamId = ?)
-- optional: AND UserGroups.Id NOT IN (SELECT ... GroupChannels.ChannelId = ?)
-- optional: AND CASE WHEN (Teams.GroupConstrained...) THEN UserGroups.Id IN (...)
-- optional: AND UserGroups.Source = ? | UserGroups.Source IN (...)
ORDER BY UserGroups.DisplayName
LIMIT ? OFFSET ?
```
