# Notify Admin Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/notify_admin_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlNotifyAdminStore

Builds reusable select builder (not executed by this function):

- **notifyAdminQuery**:

```sql
SELECT UserId, CreateAt, RequiredPlan, RequiredFeature, Trial, SentAt
FROM NotifyAdmin
```

---

## CRUD and lifecycle

### insert

```sql
INSERT INTO NotifyAdmin (UserId, CreateAt, RequiredPlan, RequiredFeature, Trial) VALUES (:UserId, :CreateAt, :RequiredPlan, :RequiredFeature, :Trial)
```

### Save

Calls **insert** after PreSave and validation.

### GetDataByUserIdAndFeature

**notifyAdminQuery** WHERE UserId = ? AND RequiredFeature = ?.

### Get

**notifyAdminQuery** WHERE Trial = ? AND SentAt IS NULL. Returns unsent notifications for trial (or non-trial).

### DeleteBefore

```sql
DELETE FROM NotifyAdmin WHERE Trial = ? AND CreateAt < ? AND SentAt IS NULL
```

### Update

```sql
UPDATE NotifyAdmin SET SentAt = ? WHERE UserId = ? AND RequiredPlan = ? AND RequiredFeature = ?
```
