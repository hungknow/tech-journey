# Session Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/session_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlSessionStore

Builds reusable select builder (not executed by this function):

- **sessionSelectQuery**:

```sql
SELECT Id, Token, CreateAt, ExpiresAt, LastActivityAt, UserId, DeviceId, Roles, IsOAuth, ExpiredNotify, Props
FROM Sessions
```

---

## CRUD and lifecycle

### Save

Props JSON. Then loads TeamMembers via Team store (no SQL in this store for that).

```sql
INSERT INTO Sessions (Id, Token, CreateAt, ExpiresAt, LastActivityAt, UserId, DeviceId, Roles, IsOAuth, ExpiredNotify, Props)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

### Get

**sessionSelectQuery** WHERE (Token = ? OR Id = ?) LIMIT 1. Then Team store for TeamMembers.

### GetSessions

**sessionSelectQuery** WHERE UserId = ? ORDER BY LastActivityAt DESC. Then Team store for TeamMembers.

### GetLRUSessions

**sessionSelectQuery** WHERE UserId = ? ORDER BY LastActivityAt DESC LIMIT ? OFFSET ?.

### GetSessionsWithActiveDeviceIds

**sessionSelectQuery** WHERE UserId = ? AND ExpiresAt != 0 AND ExpiresAt >= now AND DeviceId != '' AND DeviceId != COALESCE(Props->>'last_removed_device_id', '').

### GetMobileSessionMetadata

Select session metadata for mobile (Id, UserId, DeviceId, etc.) with optional filters.

### Update

```sql
UPDATE Sessions
SET Token = ?, CreateAt = ?, ExpiresAt = ?, LastActivityAt = ?, UserId = ?, DeviceId = ?,
    Roles = ?, IsOAuth = ?, ExpiredNotify = ?, Props = ?
WHERE Id = ?
```

### Remove

```sql
DELETE FROM Sessions WHERE Id = ?
-- or WHERE Token = ?
```

### RemoveAllSessionsForUser

```sql
DELETE FROM Sessions WHERE UserId = ?
```

### PermanentDeleteSessionsByUser

```sql
DELETE FROM Sessions WHERE UserId = ?
```

### PermanentDeleteSessionsByDeviceId

```sql
DELETE FROM Sessions WHERE DeviceId = ?
```

### UpdateLastActivityAt

```sql
UPDATE Sessions SET LastActivityAt = ? WHERE Id = ?
```

### UpdateExpiresAt

```sql
UPDATE Sessions SET ExpiresAt = ? WHERE Id = ?
```

### UpdateExpiredNotify

```sql
UPDATE Sessions SET ExpiredNotify = ? WHERE Id = ?
```

### Cleanup

Loop: delete expired sessions in batches with delay.

```sql
DELETE FROM Sessions WHERE ExpiresAt != 0 AND ExpiresAt < ?
```

### GetActiveSessionCountByApp

Count sessions (optionally by app/OAuth). Query builder from Sessions with optional join/filter.

### GetSessionsExpired

Select sessions where ExpiresAt < ? and ExpiredNotify = false (or similar). Used for cleanup/notify.
