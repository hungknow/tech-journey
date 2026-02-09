# Attributes Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/attributes_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlAttributesStore

Builds reusable select builder (not executed by this function):

- **selectQueryBuilder**:

```sql
SELECT TargetID AS ID, TargetType AS Type, Attributes
FROM AttributeView
```

---

## Materialized view and read

### RefreshAttributes

Refreshes the materialized view used for attribute queries:

```sql
REFRESH MATERIALIZED VIEW AttributeView
```

### GetSubject

**selectQueryBuilder** with `WHERE TargetID = ? AND GroupID = ?`. Returns one row (ID, Type, Attributes). AttributeView is a materialized view.

### SearchUsers

Select user columns from Users LEFT JOIN AttributeView ON Users.Id = AttributeView.TargetID, with optional: opts.Query expression, Limit, AllowInactive (Users.DeleteAt = 0), TeamID (subquery UserId FROM TeamMembers WHERE TeamId = ? AND DeleteAt = 0), ExcludeChannelMembers (NOT EXISTS ChannelMembers), SubjectID, Cursor (TargetID > ?), and search term (LIKE on user search fields). Order by Users.Id ASC. Separate count query with same filters (no limit). Returns users and total count.

### GetChannelMembersToRemove

Select ChannelMembers columns from ChannelMembers LEFT JOIN AttributeView ON ChannelMembers.UserId = AttributeView.TargetID. Optional: (NOT COALESCE(opts.Query) OR AttributeView.TargetID IS NULL), ChannelId = ?, Limit, Cursor (UserId > ?). Order by ChannelMembers.UserId ASC.
