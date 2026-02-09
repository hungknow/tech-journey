# Property Group Store — SQL Reference

This document lists each store function in `server/channels/store/sqlstore/property_group_store.go` and the SQL executed by that function. SQL is shown in fenced code blocks for correct display. Query-builder–generated SQL is described by intent and equivalent shape where helpful.

---

## PropertyGroups table

### Register

INSERT into PropertyGroups (Name, ...) with ON CONFLICT DO NOTHING or equivalent. Registers a property group by name; returns existing or new.

### Get

Select from PropertyGroups WHERE Name = ?.
