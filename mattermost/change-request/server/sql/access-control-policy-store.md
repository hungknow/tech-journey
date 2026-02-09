# Access Control Policy Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/access_control_policy_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlAccessControlPolicyStore

Builds reusable select builder (not executed by this function):

- **selectQueryBuilder**:

```sql
SELECT ID, Name, Type, Active, CreateAt, Revision, Version, Data, Props
FROM AccessControlPolicies
```

---

## CRUD and lifecycle

### Save

Inside a transaction:

1. **getT**: select policy by ID from AccessControlPolicies.
2. If existing: insert current version into AccessControlPolicyHistory (ID, Name, Type, CreateAt, Revision, Version, Data, Props); then **deleteT** (delete from AccessControlPolicies where ID = ?).
3. If new: optionally **getHistoryT** to avoid overwriting; then preSave (revision, CreateAt).
4. Insert new policy:

```sql
INSERT INTO AccessControlPolicies (ID, Name, Type, Active, CreateAt, Revision, Version, Data, Props)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
```

### Delete

Inside a transaction: **getT**; if found, insert into AccessControlPolicyHistory then **deleteT**.

### deleteT

Within transaction:

```sql
DELETE FROM AccessControlPolicies WHERE ID = ?
```

### SetActiveStatus

Inside a transaction: **getT**; then update. If policy type is parent, also update child policies.

```sql
UPDATE AccessControlPolicies SET Active = ? WHERE ID = ?
```

```sql
UPDATE AccessControlPolicies SET Active = ? WHERE Data->'imports' @> ?::jsonb
```

### SetActiveStatusMultiple

Inside a transaction: batch update then select by **selectQueryBuilder** WHERE ID IN (ids).

```sql
UPDATE AccessControlPolicies SET Active = true WHERE ID IN (?);
UPDATE AccessControlPolicies SET Active = false WHERE ID IN (?)
```

### Get

**selectQueryBuilder** `WHERE ID = ?` on master.

### getT

Select policy columns from AccessControlPolicies WHERE ID = ? (used inside transactions).

### getHistoryT

Select from AccessControlPolicyHistory WHERE ID = ? ORDER BY Revision DESC LIMIT 1 (used inside Save/Delete).

### GetAll

**selectQueryBuilder** with optional Data->'imports' @> ?, Type = ?, Id > cursor, LIMIT. Returns policies and cursor.

### SearchPolicies

Select from AccessControlPolicies (optionally with COALESCE subquery for ChildIDs when IncludeChildren and no ParentID); count query from AccessControlPolicies. Filters: Term (Name LIKE), Type, ParentID (Data->'imports' @> ?), Active, IDs, cursor Id > ?, LIMIT, ORDER BY Id ASC. Returns policies, total count, cursor.
