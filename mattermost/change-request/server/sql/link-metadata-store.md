# Link Metadata Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/link_metadata_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlLinkMetadataStore

Builds reusable select builder and column list (not executed by this function):

- **linkMetadataColumns**: Hash, URL, Timestamp, Type, Data
- **linkMetadataQuery**:

```sql
SELECT Hash, URL, Timestamp, Type, Data
FROM LinkMetadata
```

---

## CRUD

### Save

Upserts by hash.

```sql
INSERT INTO LinkMetadata (Hash, URL, Timestamp, Type, Data) VALUES (?, ?, ?, ?, ?)
ON CONFLICT (hash) DO UPDATE SET URL = ?, Timestamp = ?, Type = ?, Data = ?
```

### Get

**linkMetadataQuery** WHERE URL = ? AND Timestamp = ?. Then deserializes Data in memory.
