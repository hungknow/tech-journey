# Remote Cluster Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/remote_cluster_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## RemoteClusters table

### Save

```sql
INSERT INTO RemoteClusters (RemoteId, RemoteTeamId, Name, DisplayName, SiteURL, CreateAt, LastPingAt, Token, RemoteToken, Topics, Scheme, ...)
VALUES (:RemoteId, ...)
```
Or upsert by RemoteId.

### Update

UPDATE RemoteClusters SET Name, DisplayName, SiteURL, Token, RemoteToken, Topics, LastPingAt, ... WHERE RemoteId = ?.

### Delete

DELETE FROM RemoteClusters WHERE RemoteId = ? (or soft-delete). Returns whether row existed.

### Get

Select from RemoteClusters WHERE RemoteId = ?; optional IncludeDeleted.

### GetByPluginID

Select from RemoteClusters WHERE PluginId = ? (or equivalent).

### GetAll

Select from RemoteClusters with optional filter (ExcludeOffline, Topic, etc.); ORDER BY, LIMIT/OFFSET.

### UpdateTopics

UPDATE RemoteClusters SET Topics = ? WHERE RemoteId = ?.

### SetLastPingAt

UPDATE RemoteClusters SET LastPingAt = ? WHERE RemoteId = ?.

### UpdateLastGlobalUserSyncAt

UPDATE RemoteClusters SET LastGlobalUserSyncAt = ? WHERE RemoteId = ?.
