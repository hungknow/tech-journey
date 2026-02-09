# Terms of Service Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/terms_of_service_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlTermsOfServiceStore

Builds reusable select builder (not executed by this function):

- **termsOfServiceSelectQuery**:

```sql
SELECT Id, CreateAt, UserId, Text
FROM TermsOfService
```

---

## CRUD and lifecycle

### Save

Insert one terms-of-service row. Id must be empty (new record).

```sql
INSERT INTO TermsOfService
(Id, CreateAt, UserId, Text)
VALUES
(:Id, :CreateAt, :UserId, :Text)
```

### GetLatest

Select single row using **termsOfServiceSelectQuery** with `ORDER BY CreateAt DESC LIMIT 1`. Returns the latest terms.

### Get

Select single row using **termsOfServiceSelectQuery** with `WHERE Id = ?`.
