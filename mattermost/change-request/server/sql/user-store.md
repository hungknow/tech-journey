# User Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/user_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Overview

The User store is large and touches the **Users** table and related tables (UserTermsOfService, Status, Sessions, Preferences, etc.). It uses shared query builders (e.g. **usersQuery**), raw INSERT/UPDATE/DELETE, and squirrel builders. Below is a summary of main operations; each public method corresponds to one or more SQL statements.

---

## Initialization

### newSqlUserStore

Builds **usersQuery** (select Users columns), **userSearchQuery**, and other helpers. Not executed by this function.

---

## Users table — CRUD and lifecycle

### Save

```sql
INSERT INTO Users (Id, CreateAt, UpdateAt, DeleteAt, Username, Password, AuthData, AuthService, Email, ...)
VALUES (:Id, :CreateAt, ...)
```
Unique on Username, Email.

### Update

```sql
UPDATE Users
SET UpdateAt = ?, Username = ?, Password = ?, ..., NotifyProps = ?, ...
WHERE Id = ?
```
Various Update* methods update specific columns (UpdateLastPictureUpdate, UpdatePassword, etc.).

### Get

```sql
SELECT * FROM Users WHERE Id = ?
```
Optional: `AND DeleteAt = 0`.

### GetMany

```sql
SELECT * FROM Users WHERE Id IN (?)
```

### GetByUsername

```sql
SELECT * FROM Users WHERE Username = ?
```
Optional: `AND DeleteAt = 0`.

### GetByEmail

```sql
SELECT * FROM Users WHERE Email = ?
```
Optional: `AND DeleteAt = 0`.

### GetByAuthData

```sql
SELECT * FROM Users WHERE AuthData = ? AND AuthService = ?
```

### GetAll

```sql
SELECT * FROM Users
-- optional filters
ORDER BY ... LIMIT ? OFFSET ?
```

### GetAllUsingOptions

Select with ViewRestrictions, RoleFilter, etc.

### GetProfilesByUsernames

```sql
SELECT * FROM Users WHERE Username IN (?)
```

### GetSystemAdminProfiles

```sql
SELECT * FROM Users WHERE Roles LIKE '%system_admin%'
```

### PermanentDelete

```sql
DELETE FROM Users WHERE Id = ?
```
May cascade or clear related tables (Sessions, Preferences, etc.) in same store or other stores.

### Count

```sql
SELECT COUNT(*) FROM Users
```
Optional: IncludeDeleted, ViewRestrictions, RoleFilter.

---

## Search and autocomplete

### Search

Query builder from Users with optional join UserBots, TeamMembers, ChannelMembers; filters (TeamId, ChannelId, ViewRestrictions, AllowInactive, RoleFilter); full-text or LIKE on Username, Email, Nickname; ORDER BY, LIMIT/OFFSET. Returns user list and total count.

### Autocomplete

Similar to Search with prefix/term on Username/Nickname/Email; LIMIT.

### GetKnownUsers

Subquery or join to get user ids “known” to a user (e.g. from channel/team membership).

---

## Analytics and counts

### AnalyticsActiveCount

Count users with LastActivityAt in date range (and optional team). Raw or builder.

### GetUnreadCount

Unread message count for user (may use ChannelMembers and Posts/Channels).

### GetAnyUnreadPostCountForChannel

Unread count for user in channel.

### GetRecentlyActiveUsersForTeam

```sql
SELECT * FROM Users
JOIN TeamMembers ON ...
WHERE LastActivityAt > ?
```

### GetProfileByIds

```sql
SELECT * FROM Users WHERE Id IN (?)
```
Optional IncludeDeleted; order preserved.

---

## User terms of service, notify props, status

### SaveTermsOfService / GetUserTermsOfService

```sql
INSERT INTO UserTermsOfService (UserId, TermsOfServiceId, CreateAt) ...
-- or UPDATE / SELECT
```

### UpdateNotifyProps

```sql
UPDATE Users SET NotifyProps = ? WHERE Id = ?
```
Merge or replace notify props.

### GetTotalUsersCount

```sql
SELECT COUNT(*) FROM Users
```
Optional IncludeDeleted.

### InferSystemInstallationDate

```sql
SELECT MIN(CreateAt) FROM Users
```
To infer install date.

---

## Cache and invalidation

### InvalidateUserCache

No SQL. Cache invalidation only.

### InvalidateProfileCacheForUser

No SQL. Cache invalidation only.

Many other Invalidate* methods: no SQL in this store; they invalidate caches.
