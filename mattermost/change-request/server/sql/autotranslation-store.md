# Auto Translation Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/autotranslation_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## User/channel checks (no Translations table)

### IsUserEnabled

Returns whether user has auto-translation enabled in channel.

```sql
SELECT cm.AutoTranslationDisabled
FROM ChannelMembers cm
JOIN Channels c ON cm.ChannelId = c.Id
WHERE cm.UserId = ? AND cm.ChannelId = ?
  AND cm.AutoTranslationDisabled != true
  AND c.AutoTranslation = true
```

### GetUserLanguage

```sql
SELECT u.Locale
FROM Users u
JOIN ChannelMembers cm ON u.Id = cm.UserId
JOIN Channels c ON cm.ChannelId = c.Id
WHERE u.Id = ? AND c.Id = ?
  AND c.AutoTranslation = true
  AND cm.AutoTranslationDisabled != true
```

### GetActiveDestinationLanguages

```sql
SELECT DISTINCT u.Locale
FROM ChannelMembers cm
JOIN Channels c ON c.Id = cm.ChannelId
JOIN Users u ON u.Id = cm.UserId
WHERE cm.ChannelId = ?
  AND c.AutoTranslation = true
  AND cm.AutoTranslationDisabled != true
  -- optional: AND UserId IN (?)
  -- optional: AND UserId != ?
```

---

## Translations table — read

### Get

```sql
SELECT ObjectType, ObjectId, DstLang, ProviderId, NormHash, Text, Confidence, Meta, State, UpdateAt
FROM Translations
WHERE ObjectType = ? AND ObjectId = ? AND DstLang = ?
```

### GetBatch

Same columns from Translations; returns map by object id.

```sql
SELECT ObjectType, ObjectId, DstLang, ProviderId, NormHash, Text, Confidence, Meta, State, UpdateAt
FROM Translations
WHERE ObjectType = ? AND ObjectId IN (?) AND DstLang = ?
```

### GetAllForObject

```sql
SELECT ObjectType, ObjectId, DstLang, ProviderId, NormHash, Text, Confidence, Meta, State, UpdateAt
FROM Translations
WHERE ObjectType = ? AND ObjectId = ?
```

### GetAllByStatePage

```sql
SELECT *
FROM Translations
WHERE State = ?
ORDER BY UpdateAt ASC
LIMIT ? OFFSET ?
```

### GetByStateOlderThan

```sql
SELECT *
FROM Translations
WHERE State = ? AND UpdateAt < ?
ORDER BY UpdateAt ASC
LIMIT ?
```

---

## Translations table — write

### Save

```sql
INSERT INTO Translations (ObjectId, DstLang, ObjectType, ProviderId, NormHash, Text, Confidence, Meta, State, UpdateAt)
VALUES (...)
ON CONFLICT (ObjectId, ObjectType, DstLang)
DO UPDATE SET
  ProviderId = EXCLUDED.ProviderId,
  NormHash = EXCLUDED.NormHash,
  Text = EXCLUDED.Text,
  Confidence = EXCLUDED.Confidence,
  Meta = EXCLUDED.Meta,
  State = EXCLUDED.State,
  UpdateAt = EXCLUDED.UpdateAt
WHERE Translations.NormHash IS DISTINCT FROM EXCLUDED.NormHash
   OR Translations.State != EXCLUDED.State
```

---

## No-op (no SQL)

### ClearCaches

No SQL.

### InvalidateUserAutoTranslation

No SQL.

### InvalidateUserLocaleCache

No SQL.
