# Server Audit System

This document describes the Mattermost server audit system: why it exists, how it works, and a complete list of audit events.

---

## Why We Need Audit

**Compliance and accountability.** Auditing creates a trace of who did what, when, and from where. That supports compliance (e.g. SOC2, GDPR), security reviews, and internal policies that require evidence of access and changes.

**Security and forensics.** Audit logs help detect abuse (e.g. privilege escalation, bulk exports, config changes), investigate incidents, and understand the sequence of actions (logins, permission changes, data access).

**Operational visibility.** Admins can see high-impact actions (user/team/channel lifecycle, config, plugins, integrations) and correlate them with support tickets or performance issues.

**Permission and access tracking.** Permission-related events (e.g. `audit-permissions` level) record authorization failures and who attempted which actions, supporting access control reviews and least-privilege tuning.

**Debugging and support.** Structured audit records (parameters, prior/result state, object type) make it easier to reproduce and diagnose issues reported by users or support.

---

## Two Audit Mechanisms

The server has two parallel audit mechanisms:

**Legacy database audit.** The `Audits` table stores simple rows: `UserId`, `Action` (API path), `ExtraInfo` (e.g. "success", "attempt", "fail"), `IpAddress`, `SessionId`, `CreateAt`. Handlers call `c.LogAudit(extraInfo)` or `c.LogAuditWithUserId(userId, extraInfo)` to write to the store. This is used for backward compatibility and for the "get audits" APIs (`GET /api/v4/audits`, `GET /api/v4/users/:user_id/audits`) that return paginated rows from the database.

**Structured audit (AuditRecord).** The preferred path is to build an `AuditRecord` with `c.MakeAuditRecord(eventName, initialStatus)`, attach parameters/prior state/result state via the model helpers, then call `defer c.LogAuditRec(auditRec)`. The record is sent to the audit logger (mlog) and can be routed to files, syslog, or other targets via `ExperimentalAuditSettings` (and optional advanced logging config). It is not stored in the `Audits` table. It includes event name, status (success/attempt/fail), actor (user, session, client, IP), event data (parameters, prior_state, resulting_state, object_type), meta (e.g. api_path, cluster_id), and error details on failure.

Many handlers use both: they create an `AuditRecord` and also call `LogAudit` for the legacy DB so existing "get audits" behavior and UIs keep working.

---

## How Audit Works

**Creating a record.** In API handlers, the context provides `MakeAuditRecord(eventName, initialStatus)`, which fills actor (user, session, client, IP, X-Forwarded-For) and meta (api_path, cluster_id). The handler then:

- Adds parameters: `model.AddEventParameterToAuditRec(rec, "key", value)` or `AddEventParameterAuditableToAuditRec` for types implementing `Auditable`.
- Optionally adds prior state: `rec.AddEventPriorState(oldObj)` and/or result state: `rec.AddEventResultState(newObj)`, and `rec.AddEventObjectType("user")` (or channel, post, etc.).
- On success: `rec.Success()` and optionally add result state/object type.
- On failure: the context’s `LogAuditRec` sees `c.Err`, calls `rec.Fail()` and attaches error code/description; if the error is the permissions error, the record is emitted at `LevelPerms` instead of the default level.

**Logging.** `c.LogAuditRec(auditRec)` uses the default level `LevelAPI`. `LogAuditRecWithLevel(rec, level)` allows `LevelAPI`, `LevelContent`, `LevelPerms`, or `LevelCLI`. The audit engine’s `LogRecord(level, rec)` writes to the mlog audit targets configured for the server (e.g. file, advanced logging). Queue-full and write errors are handled by configurable callbacks (e.g. drop record or log error).

**Sensitive data.** Types that go into audit (User, Channel, Post, etc.) are converted via `AuditModelTypeConv` / `Auditable` and audit-specific structs (e.g. `auditUser` with Id, Name, Roles only) so passwords and other sensitive fields are not written to audit logs.

---

## AuditRecord structure, helpers, and JSON format (implementation guide)

**Go struct definitions** (from `server/public/model/audit_record.go`)

```go
type AuditRecord struct {
    EventName string          `json:"event_name"`
    Status    string          `json:"status"`
    EventData AuditEventData  `json:"event"`
    Actor     AuditEventActor `json:"actor"`
    Meta      map[string]any  `json:"meta"`
    Error     AuditEventError `json:"error"`
}

type AuditEventData struct {
    Parameters  map[string]any `json:"parameters"`       // request payload / query params
    PriorState  map[string]any `json:"prior_state"`      // state before change; nil for create
    ResultState map[string]any `json:"resulting_state"`   // state after change
    ObjectType  string         `json:"object_type"`      // e.g. "user", "channel", "post"
}

type AuditEventActor struct {
    UserId        string `json:"user_id"`
    SessionId     string `json:"session_id"`
    Client        string `json:"client"`
    IpAddress     string `json:"ip_address"`
    XForwardedFor string `json:"x_forwarded_for"`
}

type AuditEventError struct {
    Description string `json:"description,omitempty"`
    Code        int    `json:"status_code,omitempty"`
}
```

**Constants**

- Status: `AuditStatusSuccess`, `AuditStatusAttempt`, `AuditStatusFail` (values `"success"`, `"attempt"`, `"fail"`).
- Field keys used when mapping to mlog (and in JSON): `AuditKeyEventName` = `"event_name"`, `AuditKeyStatus` = `"status"`, `AuditKeyActor` = `"actor"`, `AuditKeyEvent` = `"event"`, `AuditKeyMeta` = `"meta"`, `AuditKeyError` = `"error"`.

**How to build a record (helpers)**

- **Create:** Use `c.MakeAuditRecord(eventName, initialStatus)` so `Actor` and `Meta` (e.g. `api_path`, `cluster_id`) are filled from context. Then add event-specific data:

  - **Parameters (input):**  
    - `model.AddEventParameterToAuditRec(rec, key, val)` — `val` must be one of: `string`, `bool`, `int`, `int64`, `[]string`, `map[string]string`. Stored in `EventData.Parameters[key]`.  
    - `model.AddEventParameterAuditableToAuditRec(rec, key, val)` — `val` implements `Auditable`; stores `val.Auditable()` in `EventData.Parameters[key]`.  
    - `model.AddEventParameterAuditableArrayToAuditRec(rec, key, val)` — `val` is `[]T` with `T` implementing `Auditable`; stores a slice of `Auditable()` maps in `EventData.Parameters[key]`.

  - **Prior/result state and object type:**  
    - `rec.AddEventPriorState(obj)` — sets `EventData.PriorState = obj.Auditable()` (use for updates/deletes).  
    - `rec.AddEventResultState(obj)` — sets `EventData.ResultState = obj.Auditable()` (use after create/update).  
    - `rec.AddEventObjectType(objectType)` — sets `EventData.ObjectType` (e.g. `"user"`).

  - **Meta (extra context):**  
    - `rec.AddMeta(name, val)` — sets `Meta[name] = val` (any type; e.g. `"admin"`, `true` or `"token_type"`, `"guest_invitation"`).

  - **Status:**  
    - `rec.Success()` — set `Status` to success.  
    - `rec.Fail()` — set `Status` to fail.

  - **Error (on failure):**  
    - `rec.AddErrorCode(code)` — set `Error.Code` (e.g. HTTP status).  
    - `rec.AddErrorDesc(description)` — set `Error.Description`.  
    - `rec.AddAppError(appErr)` — sets both from `*model.AppError`.

**Auditable interface**

Types that are safe to log (no secrets) implement:

```go
type Auditable interface {
    Auditable() map[string]any
}
```

Use `AddEventParameterAuditableToAuditRec`, `AddEventPriorState`, or `AddEventResultState` with that type; the map returned by `Auditable()` is what gets stored and later serialized to JSON.

**How it is formatted into JSON**

The audit engine does **not** serialize `AuditRecord` to JSON itself. It passes the record to mlog as six fields:

- `event_name` (string)  
- `status` (string)  
- `actor` (AuditEventActor → JSON object)  
- `event` (AuditEventData → JSON object)  
- `meta` (map[string]any → JSON object)  
- `error` (AuditEventError → JSON object)

So each log line is one JSON object. The file target uses format options that include `timestamp` and omit `msg`/level. The exact top-level keys in that JSON line are the mlog field keys above (e.g. `event_name`, `status`, `actor`, `event`, `meta`, `error`), plus any formatter-added keys like `timestamp`. Nested structures use the same `json` tags as the Go structs.

**Example single-line JSON output** (one AuditRecord as written to the audit file):

```json
{"timestamp":1640000000123,"event_name":"createUser","status":"success","actor":{"user_id":"admin_uid","session_id":"sess_xyz","client":"Mozilla/5.0 ...","ip_address":"192.168.1.100","x_forwarded_for":""},"event":{"parameters":{"invite_id":"","redirect":"","user":{"id":"","username":"newuser","email":"newuser@example.com","roles":"system_user"}},"prior_state":null,"resulting_state":{"id":"new_uid","username":"newuser","email":"newuser@example.com","roles":"system_user"},"object_type":"user"},"meta":{"api_path":"/api/v4/users","cluster_id":"cluster_abc","admin":true},"error":{"description":"","status_code":0}}
```

So to implement a new audited action: create the record with `MakeAuditRecord`, add parameters/prior state/result state/object type and meta with the helpers above, call `Success()` or `Fail()` (and on failure set error code/description), then `defer c.LogAuditRec(auditRec)` so the record is emitted when the handler returns (with failure applied if `c.Err != nil`).

---

## How AuditRecord is stored and how to review audit data

**How AuditRecord is stored**

AuditRecord is **not** stored in the database. There is no table for it.

When code calls `c.LogAuditRec(auditRec)` (or `LogAuditRecWithLevel`), the app calls `App.Srv().Audit.LogRecord(level, *rec)`. The audit engine (`server/channels/audit/audit.go`) converts the record into mlog fields (event_name, status, actor, event, meta, error) and calls `a.logger.Log(level, "", flds...)`. That logger is an mlog instance whose targets are configured at server startup from **Config > Experimental > Audit** (`ExperimentalAuditSettings`):

- **File target:** If `FileEnabled` is true, a file target is added (e.g. `FileName` under the log root). AuditRecord entries are written as JSON lines to that file. Rotation and retention are controlled by `FileMaxSizeMB`, `FileMaxAgeDays`, `FileMaxBackups`, and `FileMaxQueueSize`.
- **Advanced logging:** If `AdvancedLoggingJSON` (or the config source) defines additional targets, those can send the same audit log stream to syslog, a remote server, or other mlog-supported outputs.

So **AuditRecord is “stored” only as log output** — in the audit log file and/or whatever external targets (syslog, SIEM, etc.) are configured. The server does not persist AuditRecord to any database or queryable store.

**How users can review a list of audit data**

**Legacy audits (listable in product):** The APIs that return audit data to the client use the **Audits** table only (legacy `model.Audit` rows from `LogAudit` / `LogAuditWithUserId`):

- **GET /api/v4/audits** — System admins (or users with `read_audits`). Returns paginated rows from `Audits` for all users (`App.GetAuditsPage(rctx, "", page, perPage)`). Query params: `page`, `per_page`.
- **GET /api/v4/users/:user_id/audits** — Same permission; returns audits for that user only (`App.GetAuditsPage(rctx, userId, page, perPage)`).

Each returned item has: `id`, `create_at`, `user_id`, `action`, `extra_info`, `ip_address`, `session_id`. This is the data that can be shown in the System Console or any UI that calls these APIs. It does **not** include the structured AuditRecord fields (event_name, parameters, prior_state, resulting_state, object_type, etc.).

**AuditRecord (structured) — no list API:** There is no REST API or UI in the server that returns a list of AuditRecords. To review AuditRecord content, users (or admins) must:

- Read the **audit log file** on the server (path from `ExperimentalAuditSettings.FileName` when file audit is enabled), or
- Use whatever **external system** ingests the audit stream (e.g. syslog, log aggregator, SIEM). Those systems can search, filter, and display the JSON audit lines.

So in practice: **listing “audit” in the product = legacy Audits table via the two GET APIs above.** Reviewing the **full AuditRecord** (event name, parameters, prior/result state, etc.) is done outside the product via the audit log file or external log/audit tools.

---

## Example: Create User

In `api4/user.go`, `createUser`:

1. Builds an audit record with event `AuditEventCreateUser` and initial status fail:  
   `auditRec := c.MakeAuditRecord(model.AuditEventCreateUser, model.AuditStatusFail)`  
   `defer c.LogAuditRec(auditRec)` so it is logged when the handler returns.

2. Adds request parameters (invite_id, redirect, and the new user payload via Auditable):  
   `model.AddEventParameterToAuditRec(auditRec, "invite_id", inviteId)`  
   `model.AddEventParameterToAuditRec(auditRec, "redirect", redirect)`  
   `model.AddEventParameterAuditableToAuditRec(auditRec, "user", &user)`  

3. Optionally adds meta (e.g. token type, admin):  
   `auditRec.AddMeta("token_type", token.Type)` or `auditRec.AddMeta("admin", true)`.

4. After a successful create:  
   `auditRec.Success()`  
   `auditRec.AddEventResultState(ruser)`  
   `auditRec.AddEventObjectType("user")`  

5. If the handler returns with `c.Err` set, `LogAuditRec` marks the record as failed and attaches the error code and description, and the record is still emitted.

So one audit entry for user creation includes: who (actor), what (createUser), which user (parameters + result state), success/fail, and optional meta (token type, admin). Legacy `LogAudit("attempt")` / `LogAudit("success")` may also be used elsewhere for the DB audit table.

**Complete AuditRecord example (CreateUser, success, admin path)**

Below is a full JSON-shaped example of the `AuditRecord` as emitted for a successful user creation by an admin. The request is `POST /api/v4/users` with body `{"username":"newuser","email":"newuser@example.com",...}` and no token/invite (admin flow). The `user` parameter comes from `User.Auditable()` (no password); `resulting_state` is the created user’s `Auditable()` snapshot. `prior_state` is left empty for create.

```json
{
  "event_name": "createUser",
  "status": "success",
  "actor": {
    "user_id": "admin_user_id_abc123",
    "session_id": "session_id_xyz789",
    "client": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Mattermost/5.0.0",
    "ip_address": "192.168.1.100",
    "x_forwarded_for": ""
  },
  "event": {
    "parameters": {
      "invite_id": "",
      "redirect": "",
      "user": {
        "id": "",
        "create_at": 0,
        "update_at": 0,
        "delete_at": 0,
        "username": "newuser",
        "auth_service": "",
        "email": "newuser@example.com",
        "email_verified": false,
        "position": "",
        "roles": "system_user",
        "allow_marketing": false,
        "props": {},
        "notify_props": {},
        "last_password_update": 0,
        "last_picture_update": 0,
        "failed_attempts": 0,
        "locale": "en",
        "timezone": {},
        "mfa_active": false,
        "remote_id": "",
        "last_activity_at": 0,
        "is_bot": false,
        "bot_description": "",
        "bot_last_icon_update": 0,
        "terms_of_service_id": "",
        "terms_of_service_create_at": 0,
        "disable_welcome_email": false
      }
    },
    "prior_state": null,
    "resulting_state": {
      "id": "newly_created_user_id_123",
      "create_at": 1640000000000,
      "update_at": 1640000000000,
      "delete_at": 0,
      "username": "newuser",
      "auth_service": "",
      "email": "newuser@example.com",
      "email_verified": false,
      "position": "",
      "roles": "system_user",
      "allow_marketing": false,
      "props": {},
      "notify_props": {},
      "last_password_update": 1640000000000,
      "last_picture_update": 0,
      "failed_attempts": 0,
      "locale": "en",
      "timezone": {},
      "mfa_active": false,
      "remote_id": "",
      "last_activity_at": 0,
      "is_bot": false,
      "bot_description": "",
      "bot_last_icon_update": 0,
      "terms_of_service_id": "",
      "terms_of_service_create_at": 0,
      "disable_welcome_email": false
    },
    "object_type": "user"
  },
  "meta": {
    "api_path": "/api/v4/users",
    "cluster_id": "cluster_abc",
    "admin": true
  },
  "error": {
    "description": "",
    "status_code": 0
  }
}
```

**CreateUser failure example**

When creation fails (e.g. duplicate username), the handler sets `c.Err` and returns. `LogAuditRec` runs in defer, sees `c.Err`, calls `rec.Fail()`, `rec.AddErrorCode(c.Err.StatusCode)`, `rec.AddErrorDesc(c.Err.Error())`. No result state or object type is set. Example:

```json
{
  "event_name": "createUser",
  "status": "fail",
  "actor": {
    "user_id": "admin_user_id_abc123",
    "session_id": "session_id_xyz789",
    "client": "Mozilla/5.0 ...",
    "ip_address": "192.168.1.100",
    "x_forwarded_for": ""
  },
  "event": {
    "parameters": {
      "invite_id": "",
      "redirect": "",
      "user": {
        "username": "newuser",
        "email": "newuser@example.com",
        "roles": "system_user"
      }
    },
    "prior_state": null,
    "resulting_state": null,
    "object_type": ""
  },
  "meta": {
    "api_path": "/api/v4/users",
    "cluster_id": "cluster_abc"
  },
  "error": {
    "description": "A user with that username already exists.",
    "status_code": 400
  }
}
```

Note: `User.Auditable()` never includes password or auth_data; the exact keys in `parameters.user` and `resulting_state` match the fields returned by `User.Auditable()` in `server/public/model/user.go`.

---

## Example: LogAudit (legacy DB audit row)

The legacy audit writes a row to the `Audits` table via `c.LogAudit(extraInfo)` or `c.LogAuditWithUserId(userId, extraInfo)`. Each call produces one `model.Audit`; the store sets `Id` and `CreateAt` before INSERT.

**Traced example: createIncomingHook**

Handler: `createIncomingHook` in `server/channels/api4/webhook.go`. Route: `POST /api/v4/hooks/incoming`. It uses both the structured `AuditRecord` (with `LogAuditRec`) and the legacy `LogAudit` for the DB.

Flow:

1. Handler builds an audit record and calls `c.LogAudit("attempt")` at the start.
2. If permission checks fail it may call `c.LogAudit("fail - bad channel permissions")` or `c.LogAudit("fail - inappropriate permissions")` and return.
3. On success it calls `c.LogAudit("success")` before responding.

So for a single successful request, two rows are written to `Audits`: one with ExtraInfo `"attempt"` and one with `"success"`.

**Where each field comes from**

- **UserId:** From `c.AppContext.Session().UserId` in `LogAudit`; from the `userId` argument in `LogAuditWithUserId` (and if session user is set, ExtraInfo gets `" session_user=" + session.UserId` appended).
- **Action:** From `c.AppContext.Path()` — the request path (e.g. `/api/v4/hooks/incoming`).
- **ExtraInfo:** The string passed to `LogAudit(extraInfo)` or `LogAuditWithUserId(userId, extraInfo)` (e.g. `"attempt"`, `"success"`, `"fail - bad channel permissions"`).
- **IpAddress:** From `c.AppContext.IPAddress()`.
- **SessionId:** From `c.AppContext.Session().Id`.
- **Id:** Set in `AuditStore.Save()` with `model.NewId()` (26-char string).
- **CreateAt:** Set in `AuditStore.Save()` with `model.GetMillis()` (Unix ms).

**Concrete Audit row examples (createIncomingHook, success path)**

First row — when `c.LogAudit("attempt")` runs:

- **Id:** `"a1b2c3d4e5f6g7h8i9j0k1l2m3n4"` (example; from `model.NewId()`)
- **CreateAt:** `1640000000123` (example; from `model.GetMillis()`)
- **UserId:** `"user_id_creator_abc123"` (session user creating the webhook)
- **Action:** `"/api/v4/hooks/incoming"`
- **ExtraInfo:** `"attempt"`
- **IpAddress:** `"192.168.1.100"`
- **SessionId:** `"session_id_xyz789"`

Second row — when `c.LogAudit("success")` runs a few ms later:

- **Id:** `"o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9"`
- **CreateAt:** `1640000000156`
- **UserId:** `"user_id_creator_abc123"`
- **Action:** `"/api/v4/hooks/incoming"`
- **ExtraInfo:** `"success"`
- **IpAddress:** `"192.168.1.100"`
- **SessionId:** `"session_id_xyz789"`

If the handler had failed with bad channel permissions, only one row would be written (from `c.LogAudit("fail - bad channel permissions")`) with the same **UserId**, **Action**, **IpAddress**, **SessionId**, and **ExtraInfo** `"fail - bad channel permissions"`.

**LogAuditWithUserId example**

In `server/channels/web/oauth.go`, after a successful OAuth login the code calls `c.LogAuditWithUserId(user.Id, "authenticated")`. That builds an Audit with **UserId** = the logged-in user’s id and **ExtraInfo** = `"authenticated session_user=<session_user_id>"` (if the session user is set). So the DB row records the user who was authenticated and, in ExtraInfo, the session that performed the action.

---

## Audit Levels (mlog)

- **audit-api (LevelAPI):** REST API access. Default for `LogAuditRec`.
- **audit-content:** Content-generating operations (e.g. posts, reactions).
- **audit-permissions:** Permission checks; used when the context has a permission error.
- **audit-cli:** CLI operations (legacy; mostly unused).

---

## All Audit Events

Events are defined as constants in `server/public/model/audit_events.go`. Below they are grouped by area (no table; plain lists).

**Access Control & Security**  
applyIPFilters, assignAccessPolicy, createAccessControlPolicy, deleteAccessControlPolicy, unassignAccessPolicy, updateActiveStatus, setActiveStatus.

**Audit & Certificates**  
addAuditLogCertificate, getAudits, getUserAudits, removeAuditLogCertificate.

**Bots**  
assignBot, convertBotToUser, convertUserToBot, createBot, patchBot, updateBotActive.

**Branding**  
deleteBrandImage, uploadBrandImage.

**Channel Bookmarks**  
createChannelBookmark, deleteChannelBookmark, updateChannelBookmark, updateChannelBookmarkSortOrder, listChannelBookmarksForChannel.

**Channel Categories**  
createCategoryForTeamForUser, deleteCategoryForTeamForUser, updateCategoriesForTeamForUser, updateCategoryForTeamForUser, updateCategoryOrderForTeamForUser.

**Channels**  
addChannelMember, convertGroupMessageToChannel, createChannel, createDirectChannel, createGroupChannel, deleteChannel, getPinnedPosts, localAddChannelMember, localCreateChannel, localDeleteChannel, localMoveChannel, localPatchChannel, localRemoveChannelMember, localRestoreChannel, localUpdateChannelPrivacy, moveChannel, patchChannel, patchChannelModerations, removeChannelMember, restoreChannel, updateChannel, updateChannelMemberNotifyProps, updateChannelMemberAutotranslation, updateChannelMemberRoles, updateChannelMemberSchemeRoles, updateChannelPrivacy, updateChannelScheme.

**Commands**  
createCommand, deleteCommand, executeCommand, localCreateCommand, moveCommand, regenCommandToken, updateCommand.

**Compliance**  
createComplianceReport, downloadComplianceReport, getComplianceReport, getComplianceReports.

**Configuration**  
configReload, getConfig, localGetClientConfig, localGetConfig, localPatchConfig, localUpdateConfig, migrateConfig, patchConfig, updateConfig.

**Custom Profile Attributes**  
createCPAField, deleteCPAField, patchCPAField, patchCPAValues.

**Data Retention Policies**  
addChannelsToPolicy, addTeamsToPolicy, createPolicy, deletePolicy, patchPolicy, removeChannelsFromPolicy, removeTeamsFromPolicy.

**Emojis**  
createEmoji, deleteEmoji.

**Exports**  
bulkExport, deleteExport, generatePresignURLExport, scheduleExport.

**Files**  
getFile, getFileLink, uploadFileMultipart, uploadFileMultipartLegacy, uploadFileSimple, getFileThumbnail, getFileInfosForPost, getFileInfo, getFilePreview, searchFiles.

**Groups**  
addGroupMembers, addUserToGroupSyncables, createGroup, deleteGroup, deleteGroupMembers, linkGroupSyncable, patchGroup, patchGroupSyncable, restoreGroup, unlinkGroupSyncable.

**Imports**  
bulkImport, deleteImport, slackImport.

**Jobs**  
cancelJob, createJob, jobServer, updateJobStatus.

**LDAP**  
addLdapPrivateCertificate, addLdapPublicCertificate, idMigrateLdap, linkLdapGroup, removeLdapPrivateCertificate, removeLdapPublicCertificate, syncLdap, unlinkLdapGroup.

**Licensing**  
addLicense, localAddLicense, localRemoveLicense, removeLicense, requestTrialLicense.

**OAuth**  
authorizeOAuthApp, authorizeOAuthPage, completeOAuth, createOAuthApp, createOutgoingOauthConnection, deauthorizeOAuthApp, deleteOAuthApp, deleteOutgoingOAuthConnection, getAccessToken, loginWithOAuth, mobileLoginWithOAuth, regenerateOAuthAppSecret, registerOAuthClient, signupWithOAuth, updateOAuthApp, updateOutgoingOAuthConnection, validateOutgoingOAuthConnectionCredentials.

**Plugins**  
disablePlugin, enablePlugin, getFirstAdminVisitMarketplaceStatus, installMarketplacePlugin, installPluginFromURL, removePlugin, setFirstAdminVisitMarketplaceStatus, uploadPlugin.

**Posts**  
createEphemeralPost, createPost, deletePost, getEditHistoryForPost, getFlaggedPosts, getPostsForChannel, getPostsForChannelAroundLastUnread, getPost, getPostThread, getPostsByIds, getThreadForUser, localDeletePost, moveThread, notificationAck, patchPost, restorePostVersion, saveIsPinnedPost, searchPosts, updatePost, revealPost, burnPost, websocketPost.

**Recaps**  
createRecap, getRecap, getRecaps, markRecapAsRead, regenerateRecap, deleteRecap.

**Preferences**  
deletePreferences, updatePreferences.

**Remote Clusters**  
createRemoteCluster, deleteRemoteCluster, generateRemoteClusterInvite, inviteRemoteClusterToChannel, patchRemoteCluster, remoteClusterAcceptInvite, remoteClusterAcceptMessage, remoteUploadProfileImage, uninviteRemoteClusterToChannel, uploadRemoteData.

**Roles**  
patchRole.

**SAML**  
addSamlIdpCertificate, addSamlPrivateCertificate, addSamlPublicCertificate, completeSaml, removeSamlIdpCertificate, removeSamlPrivateCertificate, removeSamlPublicCertificate.

**Scheduled Posts**  
createSchedulePost, deleteScheduledPost, updateScheduledPost.

**Schemes**  
createScheme, deleteScheme, patchScheme.

**Search Indexes**  
purgeBleveIndexes, purgeElasticsearchIndexes.

**Server Administration**  
clearServerBusy, completeOnboarding, databaseRecycle, downloadLogs, generateSupportPacket, getAppliedSchemaMigrations, getLogs, getOnboarding, invalidateCaches, localCheckIntegrity, queryLogs, restartServer, setServerBusy, updateViewedProductNotices, upgradeToEnterprise.

**Teams**  
addTeamMember, addTeamMembers, addUserToTeamFromInvite, createTeam, deleteTeam, importTeam, invalidateAllEmailInvites, inviteGuestsToChannels, inviteUsersToTeam, localCreateTeam, localDeleteTeam, localInviteUsersToTeam, patchTeam, regenerateTeamInviteId, removeTeamIcon, removeTeamMember, restoreTeam, setTeamIcon, updateTeam, updateTeamMemberRoles, updateTeamMemberSchemeRoles, updateTeamPrivacy, updateTeamScheme.

**Terms of Service**  
createTermsOfService, saveUserTermsOfService.

**Threads**  
followThreadByUser, setUnreadThreadByPostId, unfollowThreadByUser, updateReadStateAllThreadsByUser, updateReadStateThreadByUser.

**Uploads**  
createUpload, uploadData.

**Users**  
attachDeviceId, createUser, createUserAccessToken, deleteUser, demoteUserToGuest, disableUserAccessToken, enableUserAccessToken, extendSessionExpiry, localDeleteUser, localPermanentDeleteAllUsers, login, loginWithDesktopToken, logout, migrateAuthToLdap, migrateAuthToSaml, patchUser, promoteGuestToUser, resetPassword, resetPasswordFailedAttempts, revokeAllSessionsAllUsers, revokeAllSessionsForUser, revokeSession, revokeUserAccessToken, sendPasswordReset, sendVerificationEmail, setDefaultProfileImage, setProfileImage, switchAccountType, updatePassword, updateUser, updateUserActive, updateUserAuth, updateUserMfa, updateUserRoles, verifyUserEmail, verifyUserEmailWithoutToken.

**Webhooks**  
createIncomingHook, createOutgoingHook, deleteIncomingHook, deleteOutgoingHook, getIncomingHook, getOutgoingHook, localCreateIncomingHook, regenOutgoingHookToken, updateIncomingHook, updateOutgoingHook.

**Content Flagging**  
flagPost, getFlaggedPost, permanentlyRemoveFlaggedPost, keepFlaggedPost, updateContentFlaggingConfig, setFlaggedPostReviewer.

---

## Key Files

- **Event constants:** `server/public/model/audit_events.go`
- **Record and helpers:** `server/public/model/audit_record.go`, `server/public/model/auditconv.go`
- **Legacy model and DB:** `server/public/model/audit.go`, `server/channels/store/sqlstore/audit_store.go`
- **Context helpers:** `server/channels/web/context.go` (MakeAuditRecord, LogAuditRec, LogAudit, LogAuditWithUserId)
- **App audit:** `server/channels/app/audit.go` (GetAudits, GetAuditsPage, LogAuditRecWithLevel, MakeAuditRecord for CLI, audit config, certificate)
- **Audit engine:** `server/channels/audit/audit.go`
- **Audit API:** `server/channels/api4/audit_logging.go` (certificate), `server/channels/api4/system.go` (getAudits), `server/channels/api4/user.go` (getUserAudits)
- **Schema:** `server/channels/db/migrations/postgres/000024_create_audits.up.sql`
