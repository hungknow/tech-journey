# Recap Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/recap_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## Recaps table

### SaveRecap

INSERT into Recaps (Id, UserId, ChannelId, Status, CreateAt, UpdateAt, ...). Named params.

### GetRecap

Select from Recaps WHERE Id = ?.

### GetRecapsForUser

Select from Recaps WHERE UserId = ? ORDER BY CreateAt DESC LIMIT ? OFFSET ?.

### UpdateRecap

UPDATE Recaps SET ... WHERE Id = ?.

### UpdateRecapStatus

UPDATE Recaps SET Status = ? WHERE Id = ?.

### MarkRecapAsRead

UPDATE Recaps SET ReadAt = ? (or similar) WHERE Id = ?.

### DeleteRecap

DELETE FROM Recaps WHERE Id = ?.

---

## RecapChannels table

### SaveRecapChannel

INSERT into RecapChannels (RecapId, ChannelId, ...) with ON CONFLICT DO UPDATE or equivalent.

### GetRecapChannelsByRecapId

Select from RecapChannels WHERE RecapId = ?.

### DeleteRecapChannels

DELETE FROM RecapChannels WHERE RecapId = ?.
