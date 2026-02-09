# Preference Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/preference_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlPreferenceStore

Builds reusable select builder (not executed by this function):

- **preferenceSelectQuery**:

```sql
SELECT UserId, Category, Name, Value
FROM Preferences
```

---

## Save and delete

### Save

Inside transaction: for each preference **saveTx**:

```sql
INSERT INTO Preferences (UserId, Category, Name, Value) VALUES (?, ?, ?, ?)
ON CONFLICT (userid, category, name) DO UPDATE SET Value = ?
```

### save / saveTx

Same upsert as above (saveTx runs inside transaction).

### deleteUnusedFeatures

Feature toggles. Called internally; may log on error.

```sql
DELETE FROM Preferences WHERE Category = ? AND Value = 'false' AND Name LIKE ?
```

### PermanentDeleteByUser

```sql
DELETE FROM Preferences WHERE UserId = ?
```

### Delete

```sql
DELETE FROM Preferences WHERE UserId = ? AND Category = ? AND Name = ?
```

### DeleteCategory

```sql
DELETE FROM Preferences WHERE UserId = ? AND Category = ?
```

### DeleteCategoryAndName

```sql
DELETE FROM Preferences WHERE Category = ? AND Name = ?
```

---

## Read

### Get

**preferenceSelectQuery** WHERE UserId = ? AND Category = ? AND Name = ?.

### GetCategoryAndName

**preferenceSelectQuery** WHERE Category = ? AND Name = ?.

### GetCategory

**preferenceSelectQuery** WHERE UserId = ? AND Category = ?.

### GetAll

**preferenceSelectQuery** WHERE UserId = ?.

### GetAllUsersByCategory

**preferenceSelectQuery** WHERE Category = ? (returns UserIds / preferences by user).

### GetKnownUsers

Subquery or distinct UserIds from Preferences for given user (known from preferences). Used for “known users” list.
