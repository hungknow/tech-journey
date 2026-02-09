# Product Notices Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/product_notices_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlProductNoticesStore

Builds select from **ProductNoticeViewState** (UserId, NoticeId, Viewed, Timestamp). Not executed by this function.

---

## View state

### View

Inside transaction: for each notice, try UPDATE; if no row affected, INSERT. Marks notices as viewed for user.

```sql
UPDATE ProductNoticeViewState SET Viewed = ?, Timestamp = ? WHERE UserId = ? AND NoticeId = ?
```

```sql
INSERT INTO ProductNoticeViewState (UserId, NoticeId, Viewed, Timestamp) VALUES (?, ?, ?, ?)
```

### GetViews

Select from ProductNoticeViewState WHERE UserId = ?. Returns list of view states.

### Clear

Delete from ProductNoticeViewState WHERE NoticeId IN (?). Clears view state for given notice ids.

### ClearOldNotices

Delete from ProductNoticeViewState where NoticeId not in current product notices list (removes obsolete notice view state).
