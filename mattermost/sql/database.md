# Mattermost Channels Database Schema

This document describes the PostgreSQL schema produced by applying all migrations in order. The unified script is **final.sql**.

## Overview

The Mattermost Channels database stores:

- **Core entities**: users, teams, channels, posts, and their memberships
- **Collaboration**: threads, reactions, drafts, acknowledgements, bookmarks
- **Integrations**: webhooks, commands, OAuth, bots, shared channels
- **Compliance & governance**: audits, retention policies, schemes, roles
- **Plugins & extensibility**: plugin key-value store, jobs
- **Feature-specific**: recaps, translations, content flagging, access control, properties

---

## Schema Objects

### Custom types (ENUMs)

| Type | Values | Used by |
|------|--------|---------|
| `channel_type` | `'P'`, `'G'`, `'O'`, `'D'` | `channels.type` |
| `team_type` | `'I'`, `'O'` | `teams.type` |
| `upload_session_type` | `'attachment'`, `'import'` | `uploadsessions.type` |

### Materialized view

- **AttributeView** – Built from `PropertyValues` and `PropertyFields`; exposes target attributes as JSON. Created/refreshed via procedure in migration 000137.

---

## Tables (alphabetical)

| Table | Purpose |
|-------|---------|
| **AccessControlPolicies** | Access control policy definitions |
| **AccessControlPolicyHistory** | History of policy changes |
| **audits** | Audit log entries |
| **bots** | Bot users |
| **channelbookmarks** | Per-channel bookmarks |
| **channelmemberhistory** | History of channel membership (join/leave) |
| **channelmembers** | User membership in channels (with roles, notify props, etc.) |
| **channels** | Channels (public, private, DM, etc.); references `teams` |
| **clusterdiscovery** | Cluster discovery for high availability |
| **commandwebhooks** | Webhooks for slash commands |
| **commands** | Slash command definitions |
| **compliances** | Compliance export/job metadata |
| **ContentFlaggingCommonReviewers** | Common reviewers for content flagging |
| **ContentFlaggingTeamSettings** | Team-level content flagging settings |
| **ContentFlaggingTeamReviewers** | Team reviewers for content flagging |
| **desktoptokens** | Desktop app tokens |
| **drafts** | Message drafts (with optional priority) |
| **emoji** | Custom emoji |
| **fileinfo** | File upload metadata (references posts, channels) |
| **groupchannels** | Link between user groups and channels |
| **groupmembers** | User membership in groups |
| **groupteams** | Link between user groups and teams |
| **incomingwebhooks** | Incoming webhook definitions |
| **jobs** | Background job queue |
| **licenses** | License data |
| **linkmetadata** | Metadata for linked URLs |
| **NotifyAdmin** | Notify admin (e.g. upgrade) notifications |
| **oauthaccessdata** | OAuth access tokens |
| **oauthapps** | OAuth application definitions (including DCR) |
| **oauthauthdata** | OAuth authorization flow state (including PKCE) |
| **outgoingoauthconnections** | Outgoing OAuth connections |
| **outgoingwebhooks** | Outgoing webhook definitions |
| **persistentnotifications** | Persistent notification state |
| **pluginkeyvaluestore** | Plugin key-value storage |
| **postacknowledgements** | Post read/acknowledgement state (optional remoteid/channelid) |
| **posts** | Messages in channels (root and replies; optional originalid, priority) |
| **postspriority** | Post priority metadata |
| **postreminders** | Reminders for posts |
| **preferences** | User preferences (category, name, value) |
| **productnoticeviewstate** | Product notice view state per user |
| **PropertyFields** | Attribute field definitions (for property system) |
| **PropertyGroups** | Property group definitions |
| **PropertyValues** | Attribute values per target (user/team/channel, etc.) |
| **publicchannels** | Materialized/list of public channels (derived) |
| **ReadReceipts** | Read receipts for burn-on-read / ephemeral posts |
| **reactions** | Emoji reactions on posts (with channelid) |
| **recentsearches** | Recent search queries per user |
| **RecapChannels** | Per-channel recap summaries (FK to Recaps) |
| **Recaps** | Recap metadata (user, title, status, message count, etc.) |
| **remoteclusters** | Remote cluster config (with defaultteamid, lastglobalusersyncat) |
| **retentionidsfordeletion** | IDs queued for retention-based deletion |
| **retentionpolicies** | Retention policy definitions |
| **retentionpolicieschannels** | Channel–retention policy association |
| **retentionpoliciesteams** | Team–retention policy association |
| **roles** | Role definitions |
| **schemes** | Permission schemes (team/channel) |
| **scheduledposts** | Scheduled post definitions (with type for burn-on-read etc.) |
| **sessions** | User sessions |
| **sharedchannelattachments** | Shared channel file attachments |
| **sharedchannelremotes** | Remote endpoints for shared channels (with deleteat, lastmemberssyncat) |
| **sharedchannels** | Shared channel metadata |
| **sharedchannelusers** | User sync state for shared channels |
| **sidebarcategories** | Sidebar category definitions |
| **sidebarchannels** | Sidebar channel ordering (with categoryid) |
| **status** | User online/away/DND status |
| **systems** | Key-value system store (e.g. Version, console stats) |
| **teammembers** | User membership in teams (with roles, scheme flags, createat) |
| **teams** | Teams (name, displayname, schemeid, type, etc.) |
| **termsofservice** | Terms of service content |
| **threads** | Thread root metadata (channelid, reply count, lastreplyat, teamid, deleteat, etc.) |
| **threadmemberships** | User membership in threads (unread, following) |
| **TemporaryPosts** | Ephemeral/burn-on-read post metadata (postid, type, expireat) |
| **translations** | Cached translations (objectId, objectType, dstLang, state, etc.) |
| **uploadsessions** | Resumable upload sessions |
| **useraccesstokens** | User-level access tokens |
| **usertermsofservice** | User acceptance of terms of service |
| **usergroups** | User groups (with displayname index) |
| **users** | User accounts (auth, profile, roles, locale, MFA, remoteid, etc.) |

**Note:** The `tokens` table and `trueupreviewhistory` table were removed in later migrations (000105, 000121).

---

## Key relationships

### Core hierarchy

```
teams
  └── teammembers (userid, teamid)
  └── channels (teamid)  [teamid can be null for DM/GM]
        └── channelmembers (channelid, userid)
        └── posts (channelid, userid; rootid/parentid for threads)
        └── threads (channelid, etc.)
              └── threadmemberships (postid, userid)
```

- **teams** – Top-level workspace.
- **teammembers** – Links **users** to **teams** (roles, schemeuser/schemeadmin/schemeguest).
- **channels** – Belong to a **team** (or none for DMs); have **creatorid** (user).
- **channelmembers** – Links **users** to **channels** (roles, notify props, autotranslation flags).
- **posts** – Belong to a **channel** and **user**; **rootid**/**parentid** (and **originalid**) for threading/edits.
- **threads** – One row per thread root (post); **channelid**, **teamid**, **rootid**, etc.
- **threadmemberships** – Per-user thread state (e.g. following, last read).

### Users and auth

- **users** – Central user table; referenced by teammembers, channelmembers, posts, sessions, preferences, audits, etc.
- **sessions** – userid.
- **useraccesstokens** – userid.
- **preferences** – userid, (category, name, value).
- **status** – userid.
- **bots** – bot users (linked to users).
- **usertermsofservice** – userid, termsofserviceid.

### OAuth and integrations

- **oauthapps** – OAuth apps (creator, client id/secret, DCR, etc.).
- **oauthauthdata** – OAuth auth flow (code, redirect, PKCE, resource).
- **oauthaccessdata** – OAuth access tokens (userid, client id, token, audience).
- **outgoingoauthconnections** – Outgoing OAuth connections.
- **incomingwebhooks** – channelid, userid.
- **outgoingwebhooks** – teamid, channelid, creatorid.
- **commands** – teamid (optional).
- **commandwebhooks** – commandid, userid, channelid.

### Groups and schemes

- **usergroups** – Group definition.
- **groupmembers** – userid, groupid.
- **groupteams** – groupid, teamid.
- **groupchannels** – groupid, channelid.
- **schemes** – Permission schemes.
- **roles** – Role definitions; **teams** and **channels** reference **schemes** (schemeid).

### Files and uploads

- **fileinfo** – postid, channelid, creatorid; optional archived, channelid.
- **uploadsessions** – userid, channelid, type (enum).

### Shared channels and remotes

- **remoteclusters** – Remote cluster config.
- **sharedchannels** – Shared channel header.
- **sharedchannelremotes** – Remote for a shared channel (deleteat, lastmemberssyncat).
- **sharedchannelusers** – User sync for shared channels.
- **sharedchannelattachments** – File sync for shared channels.

### Retention and compliance

- **retentionpolicies** – Retention policy.
- **retentionpoliciesteams** – policyid, teamid.
- **retentionpolicieschannels** – policyid, channelid.
- **retentionidsfordeletion** – IDs to delete by retention.
- **compliances** – Compliance job metadata.
- **audits** – Audit log (userid, etc.).

### Other feature tables

- **reactions** – postid, userid, emoji; channelid for indexing.
- **postacknowledgements** – postid, userid; optional remoteid, channelid.
- **postspriority** – Post priority.
- **postreminders** – userid, postid.
- **drafts** – userid, channelid, rootid; optional priority, type.
- **scheduledposts** – userid, channelid; optional type.
- **channelbookmarks** – channelid, ownerid, etc.
- **translations** – objectId, objectType, dstLang (cached translations).
- **Recaps** – userid, botid; **RecapChannels** – recapid (FK to Recaps), channelid.
- **ReadReceipts** – postid, userid, expireat.
- **TemporaryPosts** – postid, type, expireat.
- **NotifyAdmin** – user/team data, sentat.
- **ContentFlaggingTeamSettings** – teamid; **ContentFlaggingTeamReviewers** – userid; **ContentFlaggingCommonReviewers** – userid.
- **AccessControlPolicies** / **AccessControlPolicyHistory** – Policy and history.
- **PropertyGroups** – **PropertyFields** – **PropertyValues** – Attribute system; **AttributeView** materialized view built from these.
- **persistentnotifications** – Persistent notification state.
- **desktoptokens** – Desktop tokens.
- **recentsearches** – userid.
- **productnoticeviewstate** – userid.
- **linkmetadata** – URL metadata.
- **emoji** – Custom emoji.
- **termsofservice** – ToS content.
- **licenses** – License data.
- **systems** – System key-value (Version, etc.).
- **jobs** – Background jobs.
- **pluginkeyvaluestore** – Plugin storage.

---

## Indexes and performance

Migrations add many indexes on:

- Foreign keys (teamid, channelid, userid, postid, rootid, etc.)
- Timestamps (createat, updateat, deleteat, lastpostat) for listing and cleanup
- Full-text search (posts message/hashtags, channels name/displayname/purpose, users name/email)
- Partial indexes (e.g. unread threads, autotranslation enabled, non-terminal translation state)
- Composite indexes for common queries (e.g. channelid + updateat, userid + deleteat)

Some migrations use `CREATE INDEX CONCURRENTLY` (e.g. content flagging) and are marked `-- morph:nontransactional`.
