# Outgoing OAuth Connection Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/outgoing_oauth_connection_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlOutgoingOAuthConnectionStore

Builds reusable select builder (not executed by this function):

- **tableSelectQuery**:

```sql
SELECT Id, CreatorId, CreateAt, UpdateAt, Name, ClientId, ClientSecret, CredentialsUsername, CredentialsPassword, OAuthTokenURL, GrantType, Audiences
FROM OutgoingOAuthConnections
```

---

## CRUD and listing

### SaveConnection

```sql
INSERT INTO OutgoingOAuthConnections
(Id, Name, ClientId, ClientSecret, CreateAt, UpdateAt, CreatorId, OAuthTokenURL, GrantType, Audiences)
VALUES (:Id, :Name, :ClientId, :ClientSecret, :CreateAt, :UpdateAt, :CreatorId, :OAuthTokenURL, :GrantType, :Audiences)
```

### UpdateConnection

UpdateAt and only non-empty fields (Name, ClientId, ClientSecret, OAuthTokenURL, GrantType, Audiences, CredentialsUsername, CredentialsPassword).

```sql
UPDATE OutgoingOAuthConnections
SET UpdateAt = ?, Name = ?, ClientId = ?, ...
WHERE Id = ?
```

### GetConnection

**tableSelectQuery** WHERE Id = ?.

### GetConnections

**tableSelectQuery** with optional Id > OffsetId, Audience filter; ORDER BY Id LIMIT ?.

### DeleteConnection

```sql
DELETE FROM OutgoingOAuthConnections WHERE Id = ?
```
