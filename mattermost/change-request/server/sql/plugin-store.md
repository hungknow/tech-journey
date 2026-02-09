# Plugin Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/plugin_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PluginKeyValueStore table

### SaveOrUpdate

If value is nil, calls **Delete**. Else: upsert by (PluginId, PKey).

```sql
INSERT INTO PluginKeyValueStore (PluginId, PKey, PValue, ExpireAt)
VALUES (?, ?, ?, ?)
ON CONFLICT (PluginId, PKey) DO UPDATE SET PValue = ?, ExpireAt = ?
```

### CompareAndSet

If value is nil, calls **CompareAndDelete**. If oldValue is nil: delete expired rows then INSERT. If oldValue not nil: conditional UPDATE. Returns true only if one row affected (or insert succeeded).

```sql
UPDATE PluginKeyValueStore
SET PValue = ?, ExpireAt = ?
WHERE PluginId = ? AND PKey = ? AND PValue = ? AND (ExpireAt = 0 OR ExpireAt > ?)
```

### CompareAndDelete

Returns true if rows affected > 0.

```sql
DELETE FROM PluginKeyValueStore
WHERE PluginId = ? AND PKey = ? AND PValue = ? AND (ExpireAt = 0 OR ExpireAt > ?)
```

### SetWithOptions

If Atomic: **CompareAndSet**. Else: **SaveOrUpdate**.

### Get

Select PValue, ExpireAt from PluginKeyValueStore WHERE PluginId = ? AND PKey = ? and (ExpireAt = 0 OR ExpireAt > now). Returns nil if expired.

### Delete

```sql
DELETE FROM PluginKeyValueStore WHERE PluginId = ? AND PKey = ?
```

### DeleteAllForPlugin

```sql
DELETE FROM PluginKeyValueStore WHERE PluginId = ?
```

### DeleteAllExpired

```sql
DELETE FROM PluginKeyValueStore WHERE ExpireAt > 0 AND ExpireAt < ?
```

### List

Select PluginId, PKey, PValue, ExpireAt from PluginKeyValueStore WHERE PluginId = ? and optional key prefix; (ExpireAt = 0 OR ExpireAt > now); LIMIT (default 10).
