# Tokens Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/tokens_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlTokenStore

Builds **tokensQuery** (not executed by this function):

```sql
SELECT Token, CreateAt, Type, Extra
FROM Tokens
```

---

## CRUD and lifecycle

### Save

```sql
INSERT INTO Tokens (Token, CreateAt, Type, Extra)
VALUES (?, ?, ?, ?)
```
Id must be empty.

### Delete

```sql
DELETE FROM Tokens WHERE Token = ?
```

### GetByToken

**tokensQuery** WHERE Token = ?.

### ConsumeOnce

```sql
DELETE FROM Tokens WHERE Type = ? AND Token = ? RETURNING *
```
Returns the deleted row (one-time use token).

### Cleanup

```sql
DELETE FROM Tokens WHERE CreateAt < ?
```

### GetAllTokensByType

**tokensQuery** WHERE Type = ?.

### RemoveAllTokensByType

```sql
DELETE FROM Tokens WHERE Type = ?
```

### GetTokenByTypeAndEmail

**tokensQuery** (or equivalent) WHERE Type = ? AND Extra (email) matches. Depends on how Extra stores email.
