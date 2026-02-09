# Desktop Tokens Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/desktop_tokens_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Read and write

### GetUserId

Returns UserId for valid (non-expired) token.

```sql
SELECT UserId FROM DesktopTokens WHERE Token = ? AND CreateAt >= ?
```

### Insert

```sql
INSERT INTO DesktopTokens (Token, CreateAt, UserId) VALUES (?, ?, ?)
```

### Delete

```sql
DELETE FROM DesktopTokens WHERE Token = ?
```

### DeleteByUserId

```sql
DELETE FROM DesktopTokens WHERE UserId = ?
```

### DeleteOlderThan

Used to expire old tokens.

```sql
DELETE FROM DesktopTokens WHERE CreateAt < ?
```
