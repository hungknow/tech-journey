# Retention Policy Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/retention_policy_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## RetentionPolicies table

### Save

Transaction: INSERT into RetentionPolicies (Id, DisplayName, PostDuration, CreateAt, UpdateAt); **buildInsertRetentionPoliciesChannelsQuery** (INSERT RetentionPoliciesChannels); **buildInsertRetentionPoliciesTeamsQuery** (INSERT RetentionPoliciesTeams). Returns policy with team/channel counts.

### Patch

Update RetentionPolicies; sync RetentionPoliciesChannels and RetentionPoliciesTeams (add/remove channel and team ids). Transaction.

### Get

**buildGetPolicyQuery**: select from RetentionPolicies (and join/aggregate team and channel counts) WHERE Id = ?.

### GetAll

Select from RetentionPolicies with optional filters; ORDER BY, LIMIT/OFFSET. Returns list with counts.

### GetCount

```sql
SELECT COUNT(*) FROM RetentionPolicies
```

### Delete

```sql
DELETE FROM RetentionPoliciesChannels WHERE PolicyId = ?;
DELETE FROM RetentionPoliciesTeams WHERE PolicyId = ?;
DELETE FROM RetentionPolicies WHERE Id = ?;
```

---

## RetentionPoliciesChannels / RetentionPoliciesTeams

### GetChannels / GetChannelsCount

Select from RetentionPoliciesChannels (join Channels) WHERE PolicyId = ?; COUNT(*).

### AddChannels / RemoveChannels

INSERT into RetentionPoliciesChannels (PolicyId, ChannelId) for list; or DELETE WHERE PolicyId = ? AND ChannelId IN (?).

### GetTeams / GetTeamsCount

Select from RetentionPoliciesTeams (join Teams) WHERE PolicyId = ?; COUNT(*).

### AddTeams / RemoveTeams

INSERT into RetentionPoliciesTeams; or DELETE WHERE PolicyId = ? AND TeamId IN (?).

### GetTeamPoliciesForUser / GetChannelPoliciesForUser

Select policies for user (join TeamMembers/ChannelMembers, RetentionPoliciesTeams/Channels). Pagination.

### DeleteOrphanedRows

Delete from RetentionPoliciesChannels/RetentionPoliciesTeams where policy or channel/team no longer exists. LIMIT.

### GetIdsForDeletionByTableName

Select from RetentionIdsForDeletion (or build query) for retention job to get ids to delete. Table-specific.
