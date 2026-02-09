# OAuth Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/oauth_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlOAuthStore

Builds reusable select builders (not executed by this function):

- **oAuthAppsSelectQuery**:

```sql
SELECT (OAuthApps columns)
FROM OAuthApps o
```

- **oAuthAccessDataQuery**:

```sql
SELECT ClientId, UserId, Token, RefreshToken, RedirectUri, ExpiresAt, Scope, Audience
FROM OAuthAccessData
```

- **oAuthAuthDataQuery**:

```sql
SELECT ClientId, UserId, Code, ExpiresIn, CreateAt, RedirectUri, State, Scope, CodeChallenge, CodeChallengeMethod, Resource
FROM OAuthAuthData
```

---

## OAuth Apps

### SaveApp

```sql
INSERT INTO OAuthApps (Id, CreatorId, CreateAt, UpdateAt, ClientSecret, Name, Description, IconURL, CallbackUrls, Homepage, IsTrusted, MattermostAppID, IsDynamicallyRegistered)
VALUES (:Id, :CreatorId, ...)
```

### UpdateApp

Read with **oAuthAppsSelectQuery** WHERE o.Id = ?; then:

```sql
UPDATE OAuthApps SET UpdateAt = ?, ClientSecret = ?, Name = ?, ... WHERE Id = :Id
```

### GetApp

**oAuthAppsSelectQuery** WHERE o.Id = ?.

### GetAppByUser

**oAuthAppsSelectQuery** WHERE o.CreatorId = ? LIMIT/OFFSET.

### GetApps

**oAuthAppsSelectQuery** LIMIT/OFFSET.

### GetAuthorizedApps

**oAuthAppsSelectQuery** INNER JOIN Preferences p ON p.Name = o.Id AND p.UserId = ? LIMIT/OFFSET.

### DeleteApp

Inside transaction: **deleteApp**, **deleteOAuthAppSessions**, **deleteOAuthTokens**, **deleteAppExtras**.

**deleteApp**:

```sql
DELETE FROM OAuthApps WHERE Id = ?
```

### deleteApp / deleteOAuthAppSessions / deleteOAuthTokens / deleteAppExtras

Delete from OAuthApps, Sessions (for app), OAuthAccessData/OAuthAuthData by client id. Used inside DeleteApp transaction.

---

## OAuth Access Data

### SaveAccessData

```sql
INSERT INTO OAuthAccessData (ClientId, UserId, Token, RefreshToken, RedirectUri, ExpiresAt, Scope, Audience) VALUES (:ClientId, ...)
```

### GetAccessData

**oAuthAccessDataQuery** WHERE Token = ?.

### GetAccessDataByUserForApp

**oAuthAccessDataQuery** WHERE UserId = ? AND ClientId = ?.

### GetAccessDataByRefreshToken

**oAuthAccessDataQuery** WHERE RefreshToken = ?.

### GetPreviousAccessData

**oAuthAccessDataQuery** WHERE UserId = ? AND ClientId = ? (and optional scope/audience). Returns one row.

### UpdateAccessData

```sql
UPDATE OAuthAccessData SET ... WHERE Token = ?
```
Named params.

### RemoveAccessData

```sql
DELETE FROM OAuthAccessData WHERE Token = ?
```

### RemoveAllAccessData

```sql
DELETE FROM OAuthAccessData
```

---

## OAuth Auth Data

### SaveAuthData

INSERT INTO OAuthAuthData (ClientId, UserId, Code, ...) VALUES (...).

### GetAuthData

**oAuthAuthDataQuery** WHERE Code = ?.

### RemoveAuthData

```sql
DELETE FROM OAuthAuthData WHERE Code = ?
```

### RemoveAuthDataByClientId

```sql
DELETE FROM OAuthAuthData WHERE ClientId = ? AND UserId = ?
```

### RemoveAuthDataByUserId

```sql
DELETE FROM OAuthAuthData WHERE UserId = ?
```

### PermanentDeleteAuthDataByUser

```sql
DELETE FROM OAuthAuthData WHERE UserId = ?
```
