# Group Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/group_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlGroupStore

Builds **userGroupsSelectQuery** from UserGroups table. Not executed by this function.

---

## UserGroups table — CRUD

### Create

```sql
INSERT INTO UserGroups (Id, Name, DisplayName, Description, Source, RemoteId, CreateAt, UpdateAt, DeleteAt, AllowReference)
VALUES (:Id, :Name, :DisplayName, :Description, :Source, :RemoteId, :CreateAt, :UpdateAt, :DeleteAt, :AllowReference)
```

### CreateWithUserIds

Transaction: INSERT UserGroups; **buildInsertGroupUsersQuery** (INSERT into GroupMembers GroupId, UserId, CreateAt, DeleteAt for each user); then select new group with MemberCount join.

### Get

**userGroupsSelectQuery** WHERE Id = ?.

### GetByName

**userGroupsSelectQuery** WHERE Name = ?; optional AllowReference = true.

### GetByNames

**userGroupsSelectQuery** WHERE Name IN (?); optional view restrictions.

### GetByIDs

**userGroupsSelectQuery** WHERE Id IN (?).

### GetByRemoteID

**userGroupsSelectQuery** WHERE RemoteId = ? AND Source = ?.

### GetAllBySource

**userGroupsSelectQuery** WHERE Source = ?.

### GetByUser

Select groups for user (UserGroups join GroupMembers where UserId = ?); optional filters and view restrictions.

### Update

```sql
UPDATE UserGroups
SET Name = ?, DisplayName = ?, Description = ?, UpdateAt = ?, DeleteAt = ?, AllowReference = ?
WHERE Id = ?
```

### Delete / Restore

Soft-delete: UPDATE UserGroups SET DeleteAt = ?, UpdateAt = ? WHERE Id = ?. Restore: DeleteAt = 0.

---

## GroupMembers table

### GetMember

Select from GroupMembers WHERE GroupId = ? AND UserId = ? (and DeleteAt = 0).

### GetMemberUsers / GetMemberUsersPage / GetMemberUsersSortedPage

GroupMembers join Users for group; optional view restrictions; pagination and sort.

### GetNonMemberUsersPage

Users not in GroupMembers for group (EXCEPT or NOT IN), with view restrictions and pagination.

### GetMemberCount / GetMemberCountWithRestrictions

COUNT from GroupMembers WHERE GroupId = ? (optional join for view restrictions).

### UpsertMember

INSERT into GroupMembers with ON CONFLICT DO UPDATE (or delete then insert). Upsert (GroupId, UserId).

### DeleteMember

UPDATE GroupMembers SET DeleteAt = ? WHERE GroupId = ? AND UserId = ? (soft-delete) or DELETE.

### UpsertMembers / DeleteMembers

Bulk upsert or delete GroupMembers for group and user list.

### PermanentDeleteMembersByUser

```sql
DELETE FROM GroupMembers WHERE UserId = ?
```

---

## GroupSyncables (Team and Channel)

### CreateGroupSyncable / GetGroupSyncable / UpdateGroupSyncable / DeleteGroupSyncable

INSERT/SELECT/UPDATE/DELETE on GroupSyncables (or equivalent table) for (GroupId, SyncableId, SyncableType). AutoAdd, SchemeAdmin, etc.

### TeamMembersToAdd / ChannelMembersToAdd

Queries to compute users to add to team/channel from group membership (GroupMembers, GroupSyncables, TeamMembers/ChannelMembers).

### TeamMembersToRemove / ChannelMembersToRemove

Queries to compute members to remove (in team/channel but not in synced groups).

### GetGroupsByChannel / GetGroupsByTeam / CountGroupsByChannel / CountGroupsByTeam

Select groups linked to channel/team via GroupSyncables; optional filters and view restrictions.

### TeamMembersMinusGroupMembers / ChannelMembersMinusGroupMembers

Members in team/channel who are not in given groups (for UI and sync).

---

## Counts and admin

### GroupCount / GroupCountBySource / GroupTeamCount / GroupChannelCount / GroupMemberCount / DistinctGroupMemberCount / GroupCountWithAllowReference

Various COUNT queries on UserGroups, GroupSyncables, GroupMembers.

### AdminRoleGroupsForSyncableMember / PermittedSyncableAdmins

Queries for admin roles and permitted admins for a syncable (channel/team).

### GetGroups

Paginated list of groups with filters (IncludeMemberCount, search term, view restrictions).
