# Emoji Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/emoji_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Initialization

### newSqlEmojiStore

Builds reusable select builder (not executed by this function):

- **emojiSelectQuery**:

```sql
SELECT Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name
FROM Emoji
WHERE DeleteAt = 0
```

---

## CRUD and lifecycle

### Save

```sql
INSERT INTO Emoji
(Id, CreateAt, UpdateAt, DeleteAt, CreatorId, Name)
VALUES
(:Id, :CreateAt, :UpdateAt, :DeleteAt, :CreatorId, :Name)
```

### Get

**getBy**(rctx, "Id", id): **emojiSelectQuery** WHERE Id = ?.

### GetByName

**getBy**(rctx, "Name", name): **emojiSelectQuery** WHERE Name = ?.

### getBy

**emojiSelectQuery** WHERE <what> = <key>. Returns one active emoji.

### GetMultipleByName

**emojiSelectQuery** WHERE Name IN (?).

### GetList

**emojiSelectQuery** with optional ORDER BY Name, LIMIT ? OFFSET ?.

### Delete

```sql
UPDATE Emoji SET DeleteAt = ?, UpdateAt = ? WHERE Id = ? AND DeleteAt = 0
```

### Search

**emojiSelectQuery** WHERE Name LIKE ? (term with optional leading % for prefixOnly), ORDER BY Name, LIMIT ?.
