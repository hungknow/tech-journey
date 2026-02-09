# Content Flagging Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/content_flagging_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Save (transaction)

### SaveReviewerSettings

Runs inside a single transaction: **saveCommonReviewers**, **saveTeamSettings**, **saveTeamReviewers**.

### saveCommonReviewers

```sql
DELETE FROM ContentFlaggingCommonReviewers;
INSERT INTO ContentFlaggingCommonReviewers (userid) VALUES (?), ...
```

### saveTeamSettings

```sql
DELETE FROM ContentFlaggingTeamSettings;
INSERT INTO ContentFlaggingTeamSettings (teamid, enabled) VALUES (?, ?), ...
```

### saveTeamReviewers

```sql
DELETE FROM ContentFlaggingTeamReviewers;
INSERT INTO ContentFlaggingTeamReviewers (teamid, userid) VALUES (?, ?), ...
```

---

## Read

### GetReviewerSettings

Calls **getCommonReviewers**, **getTeamSettings**, **getTeamReviewers** and assembles ReviewerIDsSettings.

### getCommonReviewers

```sql
SELECT userid FROM ContentFlaggingCommonReviewers
```

### getTeamSettings

Builds map team id → TeamReviewerSetting (Enabled set, ReviewerIds empty).

```sql
SELECT teamid, enabled FROM ContentFlaggingTeamSettings
```

### getTeamReviewers

Appends each userid to the corresponding team in the map from getTeamSettings.

```sql
SELECT teamid, userid FROM ContentFlaggingTeamReviewers
```

---

## No-op (no SQL)

### ClearCaches

No SQL.
