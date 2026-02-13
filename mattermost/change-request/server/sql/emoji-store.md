# Emoji Store — SQL Reference

Final SQL for each function in `server/channels/store/sqlstore/emoji_store.go`.

---

## Base query (emojiSelectQuery)

Used by Get, GetByName, GetMultipleByName, GetList, Search. Squirrel builds:

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
```

---

## Save

Raw SQL (NamedExec). Params: `:Id`, `:CreateAt`, `:UpdateAt`, `:DeleteAt`, `:CreatorId`, `:Name`.

```sql
INSERT INTO Emoji
    (Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name)
VALUES
    (:Id, :CreateAt, :UpdateAt, :DeleteAt, :CreatorId, :Name)
```

---

## Get

Uses **getBy**(rctx, `"Id"`, id). Final SQL:

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
  AND Id = ?
```

---

## GetByName

Uses **getBy**(rctx, `"Name"`, name). Final SQL:

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
  AND Name = ?
```

---

## GetMultipleByName

Params: `names` (slice) → `IN (?, ?, ...)`.

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
  AND Name IN (?, ?, ...)
```

---

## GetList

Params: `offset`, `limit`, `sort`. If `sort == model.EmojiSortByName` then ORDER BY Name is added.

**Without sort (or sort != by name):**

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
LIMIT ?
OFFSET ?
```

**With sort by name:**

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
ORDER BY Name
LIMIT ?
OFFSET ?
```

---

## Delete

Raw SQL (Exec). Params: `time`, `time`, `emoji.Id`.

```sql
UPDATE Emoji
SET
    DeleteAt = ?,
    UpdateAt = ?
WHERE Id = ?
  AND DeleteAt = 0
```

---

## Search

Params: `term` (built from `name`: prefix-only → `name%`, else `%name%`), `limit`. `name` is sanitized before.

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
  AND Name LIKE ?
ORDER BY Name
LIMIT ?
```
