# Notifications: Server Storage and Frontend Consumption

This document describes how the Mattermost server stores notification-related data, what kinds of notifications exist, and how the frontend consumes them. It is based on the current server and web app source code.

---

## How the server stores notification data in the database

The server uses several database tables for notification-related state. Notification *content* (e.g. post text, channel name) is not stored as “notifications” per se; it lives in existing entities (posts, channels, users). What is stored is **state** that drives when and to whom notifications are sent, and what has been seen or requested.

**PersistentNotifications (table: `persistentnotifications`)**

The server stores one row per post that has “persistent notifications” enabled (e.g. urgent/important posts that re-notify until someone responds). Each row is keyed by post and holds scheduling/usage state.

- **postid** (VARCHAR(26), primary key): Post that has persistent notifications enabled.
- **createat** (bigint): When the record was created.
- **lastsentat** (bigint): Last time a notification was sent for this post.
- **deleteat** (bigint): Soft-delete timestamp; 0 means active.
- **sentcount** (smallint): How many times a notification has been sent for this post.

Rows are created when a post’s priority is saved with `persistent_notifications` enabled (in `PostPriorityStore.Save`). They are updated by the persistent-notification job (e.g. `UpdateLastActivity`), and soft-deleted when the post is resolved (e.g. reply/ack by a mentioned user), the post is deleted, the channel/team is deleted, or the send count reaches the configured maximum.

**NotifyAdmin (table: `NotifyAdmin`)**

Used when a non-admin user asks to “notify admin” (e.g. to request an upgrade or trial). The server stores one request per user/feature/plan combination.

- **UserId** (varchar(26)): User who requested the notification.
- **CreateAt** (bigint): When the request was created.
- **RequiredPlan** (varchar(26)): e.g. professional, enterprise.
- **RequiredFeature** (varchar(100)): Feature they need (e.g. guest accounts, custom groups).
- **Trial** (boolean): Whether this is a trial notification.
- **SentAt** (nullable bigint): When the notify-admin message was sent to admins; NULL until sent.

The app layer uses this to avoid duplicate requests and to drive jobs that send actual “notify admin” messages (e.g. email or posts). The frontend does not read this table directly; it only calls the “notify admin” API, which writes to it.

**ProductNoticeViewState (table: `productnoticeviewstate`)**

Tracks which in-product notices each user has seen, so the server can filter which notices to return.

- **userid** (VARCHAR(26)): User.
- **noticeid** (VARCHAR(26)): Notice identifier from the product notices definition.
- **viewed** (integer): View count or similar.
- **timestamp** (bigint): When it was viewed.

Product notice *definitions* (title, description, conditions) are not stored in the DB; they are loaded from an external source (e.g. URL). Only per-user view state is stored here.

**PostsPriority (table: `PostsPriority`)**

Stores priority and notification options per post (e.g. urgent, request ack, persistent notifications). This is what drives creation of `persistentnotifications` rows when `persistent_notifications` is true. The frontend does not “consume” this as a notification stream; it reads post priority with the post for display.

Push notifications and real-time “posted” events are **not** stored as notification rows. The server decides at post time (and, for persistent, in a job) whether to send websocket or push, and sends them; there is no separate “notification” table for those.

---

## What kinds of notifications exist and how they are stored or sent

**1. Real-time post notifications (websocket “posted” and desktop)**

When a new post is created, the server sends a **websocket event** `posted` to channel members, with the post and metadata. No notification row is stored; the event is simply broadcast.

The frontend receives the event, updates the post list, and—based on user and channel notification preferences, mute state, and focus—may show a desktop notification with a title (e.g. channel name) and a preview of the post, and optionally play a sound.

**2. Persistent (repeating) notifications**

For posts with priority and “persistent notifications” enabled, the server stores a row in **persistentnotifications**. A scheduled job (`SendPersistentNotifications`) periodically selects eligible rows (e.g. not deleted, last sent at least N minutes ago, sent count below max), loads the post and channel/team/mentions, then:

- For **desktop**: sends a **websocket event** `persistent_notification_triggered` to each mentioned user (who has desktop notifications on and is not DND/OOO). The payload includes post (JSON), channel_type, channel_display_name, channel_name, sender_name, team_id, mentions, and optional image/otherFile flags.
- For **push**: sends push notifications to mentioned users (same as normal push path).

After sending, the server updates **persistentnotifications** (lastsentat, sentcount) and may soft-delete rows that exceed max count or when the post/channel/team is deleted or the post is “resolved” (e.g. a mentioned user replies or acks).

So: the **stored** part is only the scheduling state in **persistentnotifications**; the actual “notification” is delivered via websocket and/or push, not stored as a separate record.

**3. Notify-admin (upgrade / trial request)**

When a user clicks “Notify admin” (e.g. for a feature or trial), the frontend calls `POST /users/notify-admin` with `trial_notification`, `required_plan`, and `required_feature`. The server validates and writes (or finds) a row in **NotifyAdmin**. No real-time “notification” is sent from that request; background jobs (or admin-triggered APIs) use this table to send emails or create posts for admins. So the **stored** data is the request (user, plan, feature, trial, sent_at); the actual “notify admin” message is sent by other processes.

**4. Product (in-product) notices**

Notice **content** is not in the DB; it is fetched from the product notices endpoint (e.g. by team and client version). The server uses **productnoticeviewstate** to know what each user has already seen and filters the list of notices accordingly. When the user dismisses or views a notice, the frontend calls `PUT /notices/view` with the notice IDs, and the server updates **productnoticeviewstate**. So only **view state** is stored; the notices themselves are configuration/data from elsewhere.

**5. Push notifications**

Push is sent by the server when a post is created (or when the persistent job runs) to mobile/app clients. The server builds a **PushNotification** struct (post_id, channel_id, message, badge, etc.) and sends it to the push proxy; it is **not** stored in any notification table. Delivery and display are handled by the client and OS.

---

## How the frontend consumes notifications

**Websocket as the main real-time path**

The frontend subscribes to websocket events. Two events drive desktop (browser) notifications and in-app updates:

- **posted** (and **ephemeral_message**): Handled by `handleNewPostEvent` (debounced). The handler parses the post from the event, dispatches `handleNewPost(post, msg)`, which calls `completePostReceive`. Inside `completePostReceive`, the frontend dispatches `sendDesktopNotification(post, websocketMessageProps)`. So the same “posted” event is used to add the post to the store and to optionally show a desktop notification (title, body, sound, click to open channel/thread). Whether a notification is shown depends on user/channel settings (e.g. desktop notify level, mute, focus), and `sendDesktopNotification` implements that (e.g. `shouldSkipNotification`).
- **persistent_notification_triggered**: Handled by `handlePersistentNotification`. The handler parses the post from the event and dispatches `sendDesktopNotification(post, msg.data)`. So persistent notifications reuse the same desktop notification logic as “posted”; the only difference is the event name and that they are sent on a schedule by the server for mentioned users.

In both cases, the “consumed” data is the websocket payload (post + channel/sender/team metadata). No separate REST call is needed to “fetch” the notification; the server pushes it.

**Non-persistent WebSocket events: context when the server sends them**

Besides `posted`, `ephemeral_message`, and `persistent_notification_triggered` (which drive desktop notifications), the server publishes other one-shot WebSocket events so the frontend stays in sync. Below is the **context** in which each event is sent (when the server publishes it). Events are not stored; they are sent once when the action happens.

**Posts and messages.** `posted` — when a new post or reply is created (or when the persistent-notification job re-sends for mentioned users, as `persistent_notification_triggered`). `ephemeral_message` — when an ephemeral post is created (e.g. slash command response to one user). `post_edited` — when a post is updated (including when acknowledgements change and shared-channel sync is needed). `post_deleted` — when a post is permanently deleted (sent to channel and/or to the acting user). `post_unread` — when the server marks a channel/post as unread for a user (e.g. when they are mentioned or the channel is marked unread). For burn-on-read: `post_revealed` when a user reveals a message, `post_burned` when it is burned, `burn_on_read_all_revealed` when all are revealed.

**Reactions and acknowledgements.** `reaction_added` — when a user adds an emoji reaction to a post. `reaction_removed` — when a reaction is removed. `post_acknowledgement_added` — when a user acknowledges a post (e.g. “read” or “got it”). `post_acknowledgement_removed` — when an acknowledgement is removed.

**Threads.** `thread_updated` — when a thread’s metadata or reply count changes. `thread_follow_changed` — when a user follows or unfollows a thread. `thread_read_changed` — when a user’s read state for a thread changes (e.g. they read replies).

**Channels.** `channel_created` — when a new channel is created. `channel_updated` — when channel props (name, purpose, header, etc.) or shared-channel sync change. `channel_deleted` — when a channel is deleted. `channel_restored` — when a deleted channel is restored. `channel_converted` — when a channel is converted (e.g. public to private). `channel_member_updated` — when a channel member’s props (e.g. notify, roles) change. `channel_scheme_updated` — when the channel’s scheme (permissions) is set or removed. `direct_added` — when a DM is created or the user is added to it. `group_added` — when a user is added to a group channel (GM). `user_added` — when a user is added to a channel. `user_removed` — when a user is removed from a channel (sent to channel and to the removed user). Channel bookmarks: `channel_bookmark_created`, `channel_bookmark_updated`, `channel_bookmark_deleted`, `channel_bookmark_sorted` — when bookmarks are created, updated, deleted, or reordered.

**Teams.** `added_to_team` — when a user is added to a team (invite, signup, or LDAP sync). `leave_team` — when a user leaves a team (sent to team and to that user). `update_team`, `delete_team`, `restore_team`, `update_team_scheme` — when team props or scheme are updated, or the team is deleted or restored. `memberrole_updated` — when a team member’s role (e.g. admin) changes.

**Users and presence.** `new_user` — when a new user account is created (broadcast to all). `user_updated` — when a user’s profile or props are updated (may be sent to all, to admins only, or to the user only depending on the change). `user_role_updated` — when a user’s system role changes. `status_change` — when a user’s status (online, away, DND, etc.) changes. `user_activation_status_change` — when a user is activated or deactivated. `guests_deactivated` — when guest accounts are deactivated (e.g. after license change). `typing` — when a user is typing in a channel (sent by server on behalf of the client that sent the typing request).

**Preferences and sidebar.** `preference_changed` — when a single preference is changed (e.g. expand/collapse slash command). `preferences_changed` — when the user’s preferences are updated (e.g. sidebar categories or other prefs). `preferences_deleted` — when preferences are deleted. `sidebar_category_created`, `sidebar_category_updated`, `sidebar_category_deleted`, `sidebar_category_order_updated` — when the user’s sidebar categories are created, updated, deleted, or reordered.

**Drafts and scheduled posts.** `draft_created`, `draft_updated`, `draft_deleted` — when a draft is created, updated, or removed for a channel (typically for the owning user/connection). Scheduled post events (`scheduled_post_created`, `scheduled_post_updated`, `scheduled_post_deleted`) — when a scheduled post is created, updated, or cancelled.

**System, config, and plugins.** `hello` — when the client first connects; server sends connection/session info. `config_changed` — when server config is updated (e.g. by sysadmin). `license_changed` — when the server license is updated. `role_updated` — when a system or channel role is updated. `emoji_added` — when a custom emoji is added. `plugin_enabled`, `plugin_disabled` — when a plugin is enabled or disabled. `plugin_statuses_changed` — when plugin health status changes (e.g. for sysadmin UI). `open_dialog` — when the server asks the client to open a dialog (e.g. from an integration action). `multiple_channels_viewed` — when the server records that the user viewed multiple channels (e.g. for “channel viewed” tracking).

**Groups (LDAP/sync).** Events like `received_group`, `received_group_associated_to_team`, `received_group_not_associated_to_team`, `received_group_associated_to_channel`, `received_group_not_associated_to_channel`, `group_member_deleted`, `group_member_add` — when LDAP or sync changes group membership or association with teams/channels.

**Cloud and other.** `cloud_subscription_changed`, `first_admin_visit_marketplace_status_received`, `hosted_customer_signup_progress_updated` — when cloud subscription, marketplace visit, or signup state changes. Custom profile attributes: `custom_profile_attributes_field_created`, `custom_profile_attributes_field_updated`, `custom_profile_attributes_field_deleted`, `custom_profile_attributes_values_updated` — when CPA fields or values change. `recap_updated` — when a recap is updated for a user. `post_translation_updated` — when a post’s translation is updated. `content_flagging_report_value_updated` — when a content-flagging report value changes. `presence` — presence updates. `posted_notify_ack` — server ack for posted/push notification flow.

The only event that is “persistent” (re-sent on a schedule) is `persistent_notification_triggered`; all others above are published once when the corresponding action happens.

**Desktop notification behavior (shared for “posted” and “persistent_notification_triggered”)**

`sendDesktopNotification` (in `notification_actions.tsx`) uses Redux state (channel, user, member, preferences) and the event payload to decide whether to show a notification. It computes title (e.g. channel name or “Direct Message”), body (e.g. sender and message preview), and whether to play a sound (from user/channel notify props). It can run plugin hooks to modify or suppress the notification, then calls `notifyMe(...)` to show the browser/OS notification and optionally play a sound. So the frontend “consumes” the notification by rendering it via the OS/browser API and by having already received the post in the websocket payload (and thus in the store).

**Notify-admin**

The frontend does not “receive” notify-admin as a push or websocket notification. It **sends** a request: when the user clicks “Notify admin”, the client calls `Client4.notifyAdmin(request)` (POST with trial_notification, required_plan, required_feature). The server writes to **NotifyAdmin** and returns. The frontend then shows local UI (e.g. “Admin notified!”). Admins are notified by separate flows (e.g. email or posts) that read from the **NotifyAdmin** table; the web app does not subscribe to a special “notify admin” event for that.

**Product notices**

The frontend **fetches** notices via `Client4.getInProductNotices(teamId, client, clientVersion)` (GET). The server returns a list of notices that apply to that team/client/version and that the user has not yet fully “viewed” according to **productnoticeviewstate**. When the user views or dismisses a notice, the frontend calls `Client4.updateNoticesAsViewed(noticeIds)` (PUT). So consumption is: fetch list from API, show in UI (e.g. modal), then mark viewed via API so the server can update **productnoticeviewstate** and filter future responses.

**Push notifications**

Mobile and desktop apps receive push payloads from the push proxy (triggered by the server). The web app does not “consume” push in the same way; it only consumes websocket “posted” and “persistent_notification_triggered” for in-session desktop notifications. Push is consumed by the native/client layer and the OS.

---

## Event flow: server to frontend

**Real-time post (“posted”).** On the server, when a user creates a post, `handlePostEvents` runs and calls `SendNotifications`, which builds the payload (post, channel type and names, sender name, team id, mentions, etc.) and publishes a WebSocket event `posted` to the channel’s connections. On the frontend, the client receives the event and runs `handleNewPostEvent` (debounced), which calls `handleNewPost` and then `completePostReceive`. Inside `completePostReceive`, the post is added to the store via `receivedNewPost` and `sendDesktopNotification` is called with the event data. `sendDesktopNotification` checks whether to show a notification (e.g. channel muted, user focus, notify level); if not skipped, it calls `notifyMe` with title and body and optionally plays a sound, and the browser or OS shows the desktop notification.

**Persistent notification.** A scheduled job `SendPersistentNotifications` runs periodically. It reads eligible rows from the `persistentnotifications` table, loads the corresponding posts and channel/team/mentions, and for each mentioned user who has desktop notifications on and is not DND or OOO, publishes a WebSocket event `persistent_notification_triggered` with the post and metadata. The job then updates the table (e.g. `UpdateLastActivity` for lastsentat and sentcount). On the frontend, the client handles `persistent_notification_triggered` with `handlePersistentNotification`, which calls `sendDesktopNotification` with the event payload; from there the flow is the same as for a real-time post (optional desktop notification and sound).

**Notify-admin.** The user clicks “Notify admin” in the UI. The frontend calls `Client4.notifyAdmin` with the request body (trial_notification, required_plan, required_feature). The server receives `POST /users/notify-admin`, runs `handleNotifyAdmin`, and saves the request via `NotifyAdminStore.Save` into the `NotifyAdmin` table, then returns 200. The frontend shows feedback like “Admin notified!” or “Already notified”. The actual notification to admins (e.g. email or posts) is done later by a separate job or API that reads from `NotifyAdmin`.

**Product notices.** When the app loads or the user switches team, the frontend calls `Client4.getInProductNotices` with team id, client type, and version. The server loads the notice definitions (e.g. from URL or config), filters them using `ProductNoticeViewState` so the user only gets notices they haven’t fully viewed, and returns the list. The frontend shows the notices (e.g. in a modal). When the user views or dismisses a notice, the frontend calls `Client4.updateNoticesAsViewed` with the notice id(s). The server updates `ProductNoticeViewState` and returns 200. Subsequent calls to `getInProductNotices` will exclude or treat those notices as viewed.

**Push (mobile/native).** When a post is created (or when the persistent notification job runs), the server may call `sendPushNotification` and send a payload (post_id, channel_id, message, badge, etc.) to the push proxy over HTTPS. The push proxy delivers to the platform service (e.g. APNS, FCM). The device receives the push and the OS shows the notification; the user can tap to open the app. The web app does not receive push in this way; it only uses the WebSocket events `posted` and `persistent_notification_triggered` for in-session desktop notifications.

---

## Summary

- **Stored in DB**: (1) **persistentnotifications** – which posts have repeating notifications and how often they’ve been sent; (2) **NotifyAdmin** – who asked to notify admin for which plan/feature and whether it was sent; (3) **productnoticeviewstate** – which product notices each user has viewed; (4) **PostsPriority** – post priority and options that can create **persistentnotifications** rows.
- **Not stored as notifications**: Real-time “posted” events, push payloads, and the content of product notices (only view state is stored).
- **Frontend consumption**: Real-time and persistent desktop notifications are **consumed via websocket** (“posted” and “persistent_notification_triggered”) and rendered with `sendDesktopNotification`. Notify-admin is **sent** via REST and only state/feedback is shown in the UI. Product notices are **fetched** via REST and **marked viewed** via REST; the server uses the view state to filter what to return next.
