# Channel Member History Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/channel_member_history_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlChannelMemberHistoryStore

Builds reusable select builder (not executed by this function):

- **channelMemberHistoryQuery**:

```sql
SELECT ChannelId, UserId, JoinTime, LeaveTime
FROM ChannelMemberHistory
```

---

## Log events

### LogJoinEvent

```sql
INSERT INTO ChannelMemberHistory
(UserId, ChannelId, JoinTime)
VALUES
(:UserId, :ChannelId, :JoinTime)
```

### LogLeaveEvent

```sql
UPDATE ChannelMemberHistory
SET LeaveTime = ?
WHERE UserId = ? AND ChannelId = ? AND LeaveTime IS NULL
```

---

## Read and export

### GetChannelsWithActivityDuring

Returns list of channel ids from union of posts and history.

```sql
SELECT ChannelId FROM (
  SELECT DISTINCT ChannelId FROM Posts
  WHERE UpdateAt >= ? AND UpdateAt <= ? AND Type NOT LIKE 'system_%'
  UNION
  SELECT DISTINCT ChannelId FROM ChannelMemberHistory
  WHERE (JoinTime BETWEEN ? AND ? OR LeaveTime BETWEEN ? AND ?)
) AS cm
```

### GetUsersInChannelDuring

If **hasDataAtOrBefore**(startTime): **getFromChannelMemberHistoryTable**(startTime, endTime, channelIds). Else: **getFromChannelMembersTable**(startTime, endTime, channelIds).

### hasDataAtOrBefore

Returns whether Min <= time (or false if no rows).

```sql
SELECT MIN(JoinTime) AS Min FROM ChannelMemberHistory
```

### getFromChannelMemberHistoryTable

**channelMemberHistoryQuery** plus u.Email, u.Username, Bots.UserId IS NOT NULL AS IsBot, u.DeleteAt; JOIN Users u, LEFT JOIN Bots; WHERE ChannelId IN (?), JoinTime <= endTime, (LeaveTime IS NULL OR LeaveTime >= startTime). ORDER BY JoinTime ASC.

### getFromChannelMembersTable

```sql
SELECT DISTINCT ch.ChannelId, ch.UserId, u.Email AS "Email", u.Username, Bots.UserId IS NOT NULL AS IsBot, u.DeleteAt AS UserDeleteAt
FROM ChannelMembers ch
JOIN Users u ON ch.UserId = u.id
LEFT JOIN Bots ON Bots.UserId = u.id
WHERE ch.ChannelId IN (?)
```

Join/leave times are filled in memory (startTime, endTime).

### GetChannelsLeftSince

```sql
SELECT ChannelId FROM ChannelMemberHistory
WHERE UserId = ?
GROUP BY ChannelId
HAVING MAX(LeaveTime) > MAX(JoinTime)
   AND MAX(LeaveTime) IS NOT NULL
   AND MAX(LeaveTime) >= ?
```

---

## Retention and cleanup

### PermanentDeleteBatchForRetentionPolicies

Uses **genericPermanentDeleteBatchForRetentionPolicies** with table ChannelMemberHistory, time column LeaveTime, primary keys ChannelId, UserId, JoinTime.

### DeleteOrphanedRows

```sql
DELETE FROM ChannelMemberHistory WHERE ctid IN (
  SELECT ChannelMemberHistory.ctid FROM ChannelMemberHistory
  LEFT JOIN Channels ON ChannelMemberHistory.ChannelId = Channels.Id
  WHERE Channels.Id IS NULL
  LIMIT $1
)
```

### PermanentDeleteBatch

```sql
-- Inner select
SELECT ctid FROM ChannelMemberHistory
WHERE LeaveTime IS NOT NULL AND LeaveTime <= ?
LIMIT ?

-- Then delete
DELETE FROM ChannelMemberHistory WHERE ctid IN (inner)
```
