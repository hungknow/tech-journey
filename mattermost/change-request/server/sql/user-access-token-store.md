# User Access Token Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/user_access_token_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlUserAccessTokenStore

Builds **userAccessTokensSelectQuery** (not executed by this function):

```sql
SELECT UserAccessTokens.Id, Token, UserId, Description, IsActive
FROM UserAccessTokens
```

---

## CRUD and lifecycle

### Save

```sql
INSERT INTO UserAccessTokens (Id, Token, UserId, Description, IsActive) VALUES (?, ?, ?, ?, ?)
```

### Get

**userAccessTokensSelectQuery** WHERE Id = ?.

### GetAll

**userAccessTokensSelectQuery** with optional UserId filter; ORDER BY CreateAt (or similar) LIMIT/OFFSET. (Note: CreateAt may be in a joined table.)

### GetByToken

**userAccessTokensSelectQuery** WHERE Token = ? (join UserAccessTokens with token hash table if used).

### GetByUser

**userAccessTokensSelectQuery** WHERE UserId = ?.

### Delete

Inside transaction: **deleteSessionsAndTokensById** then **deleteTokensById** then commit.

```sql
DELETE FROM Sessions s
USING UserAccessTokens o
WHERE o.Token = s.Token AND o.Id = ?
```

```sql
DELETE FROM UserAccessTokens WHERE Id = ?
```

### DeleteAllForUser

Inside transaction: **deleteSessionsandTokensByUser** (DELETE Sessions via UserAccessTokens where UserId = ?; DELETE UserAccessTokens WHERE UserId = ?); commit.

### UpdateTokenDisable

```sql
UPDATE UserAccessTokens SET IsActive = ? WHERE Id = ?
```

### UpdateTokenEnable

```sql
UPDATE UserAccessTokens SET IsActive = true WHERE Id = ?
```

### Search

Query builder from UserAccessTokens (optional join Users) with filters; LIMIT/OFFSET.

### Count

```sql
SELECT COUNT(*) FROM UserAccessTokens
```
Optional filters.
