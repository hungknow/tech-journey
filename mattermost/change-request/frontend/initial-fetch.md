# Data Fetched on First Run or First Render

This document describes what the Mattermost web app fetches when it first loads or when the user first sees the main app (first render after login). The flow is split into: app bootstrap (Root), config-and-me, post-config, logged-in setup, team load, sidebar load, channel selection, and post list.

For each frontend action, the **Backend** API (HTTP method and path under `/api/v4` unless noted) is included so you can map client calls to server endpoints.

---

## 1. App bootstrap (Root, every load)

When the Root component mounts it calls **loadConfigAndMe** (from `components/root/actions`). That runs first for every load.

**Always (no login required):**

- **Client config** — `getClientConfig()` → **Backend:** `GET /api/v4/config/client?format=old`. Public client-safe config (e.g. feature flags, site URL).
- **License config** — `getLicenseConfig()` (uses `Client4.getClientLicenseOld`) → **Backend:** `GET /api/v4/license/client?format=old`. License flags used by the client.

If the user is not logged in (no Mattermost user ID in the cookie), the flow stops here. No user, team, or channel data is requested.

---

## 2. Config and “me” (when logged in)

When the cookie indicates a logged-in user, **loadConfigAndMe** continues and runs in parallel:

- **Current user** — `getMe()` → **Backend:** `GET /api/v4/users/me`. Fetches the current user profile.
- **My preferences** — `getMyPreferences()` → **Backend:** `GET /api/v4/users/me/preferences`. User preferences (theme, sidebar, notifications, etc.).
- **My teams** — `getMyTeams()` → **Backend:** `GET /api/v4/users/me/teams`. List of teams the user belongs to.
- **My team members** — `getMyTeamMembers()` → **Backend:** `GET /api/v4/users/me/teams/members`. Current user’s membership in each team.

Then it runs (not in the same parallel batch):

- **My team unreads** — `getMyTeamUnreads(collapsedThreads)` → **Backend:** `GET /api/v4/users/me/teams/unread?include_collapsed_threads=true|false`. Unread counts and related data per team.
- **Server limits** — `getServerLimits()` → **Backend:** `GET /api/v4/limits/server`. Product/usage limits.

So on first run when logged in, the app has: config, license, current user, preferences, team list, team memberships, team unreads, and server limits.

---

## 3. After config and me (onConfigLoaded)

After **loadConfigAndMe** finishes successfully, Root runs **onConfigLoaded**:

- **Products** — `initializeProducts()` → loads product/plugin modules and related setup.
- **Plugins** — `initializePlugins()` → initializes the plugin system and registered plugins.
- **Emojis** — `migrateRecentEmojis()` and `loadRecentlyUsedCustomEmojis()` → migrates recent emoji data and loads recently used custom emojis.
- **Landing** — `showLandingPageIfNecessary()` → may show desktop/landing logic (no extra API by itself).

When the “products + plugins” promise resolves, Root sets **shouldMountAppRoutes** to true, so the main app routes (including LoggedIn and team/channel UI) mount.

---

## 4. Redirect when user is at “/”

If the user is at the root path “/” after config and me:

- **redirectToOnboardingOrDefaultTeam** may run. It can call:
  - **First admin setup** — `getFirstAdminSetupComplete()` → **Backend:** `GET /api/v4/system/onboarding/complete`. Whether the first admin has completed setup (for onboarding vs redirect).
  - **Admin profiles** — `getProfiles(0, PROFILE_CHUNK_SIZE, { roles: SYSTEM_ADMIN_ROLE })` → **Backend:** `GET /api/v4/users?page=0&per_page=60&roles=system_admin`. Used to decide if the current user is the first admin and whether to send them to the preparing-workspace flow.
- Otherwise it redirects to the default team (e.g. `/{teamName}/channels/...`).

So the “first run” may include one or two of these before the user lands on a team URL.

---

## 5. LoggedIn component (first time the main app is shown)

When the LoggedIn route mounts (user is logged in and app routes are mounted):

- **WebSocket** — `WebSocketActions.initialize()` → opens the WebSocket connection for real-time events (no REST “fetch” of a data set, but part of first-run setup).
- **Timezone** — `updateTimeZone()` → syncs device timezone with the server (may use existing session or a timezone API).
- **Custom profile attributes** — If the config enables them, `getCustomProfileAttributeFields()` → **Backend:** `GET /api/v4/custom_profile_attributes/fields`. So the client knows which custom profile fields exist.

No other bulk data is fetched here; team/channel data comes in the next steps.

---

## 6. Team controller (first time a team context is shown)

When the TeamController mounts (user has been redirected to a team or navigated to one), it runs once:

- **All teams’ channels** — `fetchAllMyTeamsChannels()` → **Backend:** `GET /api/v4/users/me/channels`. Fetches channels for all of the user’s teams in one go.
- **All my channel members** — `fetchAllMyChannelMembers()` → **Backend:** `GET /api/v4/users/{userId}/channel_members?page=-1` (streaming). The current user’s channel memberships across all teams.

So on first render of the team UI, the app already has channels and channel memberships for every team, not only the current team.

When the URL specifies a team by name, the app resolves the team and may call **joinTeam** (e.g. first time opening that team). Then:

- **Team by name** — `getTeamByName(teamname)` → **Backend:** `GET /api/v4/teams/name/{teamName}`.
- **Add user to team** — `addUserToTeam(team.id, currentUser.id)` → **Backend:** `POST /api/v4/teams/{teamId}/members` (or equivalent) if the user is not already in the team.
- **initializeTeam(team)** — selects the team in Redux; if licensed and LDAP/custom groups are enabled, it may also call:
  - **Groups for user** — `getGroupsByUserIdPaginated(...)` → **Backend:** `GET /api/v4/users/{userId}/groups` (with pagination/filter params).
  - **Groups for channels in team** — `getAllGroupsAssociatedToChannelsInTeam(team.id)` → **Backend:** `GET /api/v4/teams/{teamId}/groups_by_channels?...` (if LDAP groups).
  - **Groups for team** — `getAllGroupsAssociatedToTeam(team.id)` or `getGroups(...)` → **Backend:** `GET /api/v4/teams/{teamId}/groups?...` or `GET /api/v4/groups?...` depending on team type.
- **Channels and members for this team** — `fetchChannelsAndMembers(team.id)` → **Backend:** `GET /api/v4/users/me/teams/{teamId}/channels` and `GET /api/v4/users/me/teams/{teamId}/channels/members`. Current team’s channel list and members (redundant with “all teams” if fetchAllMyTeamsChannels already ran, but joinTeam explicitly loads this team’s data).

When the current team is set, TeamController also runs (when content flagging is enabled):

- **Team content flagging status** — `getTeamContentFlaggingStatus(currentTeamId)` → **Backend:** `GET /api/v4/content_flagging/team/{teamId}/status`.

So “first run” for the team layer is: all channels + all my channel members, then (if navigating to a team by name) team-by-name, optional add to team, initializeTeam (and optional groups), and optionally fetchChannelsAndMembers for that team and content flagging status.

---

## 7. Sidebar and categories

When the Sidebar component mounts or when **teamId** becomes available, it fetches:

- **My categories** — `fetchMyCategories(teamId)` → **Backend:** `GET /api/v4/users/{userId}/teams/{teamId}/channels/categories`. Channel categories and order for the current team (sidebar grouping).

So the first time the sidebar is shown for a team, it loads categories for that team.

---

## 8. DataPrefetch (when sidebar is “loaded” and a channel is selected)

When **sidebarLoaded** becomes true and there is a **currentChannelId**, the DataPrefetch component:

- **Profiles for sidebar** — `loadProfilesForSidebar()` runs `loadProfilesForDM()` and `loadProfilesForGM()`. For GMs with no profiles loaded it calls **Backend:** `POST /api/v4/users/group_channels` (body: array of channel IDs) → returns profiles per group channel. DMs may use `getChannelAndMyMember` and preferences; user list uses **Backend:** `GET /api/v4/users?in_channel=...` or similar. So DMs and GMs in the sidebar get user profiles where needed.
- **Current channel posts** — queues `prefetchChannelPosts(currentChannelId)` → **Backend:** `GET /api/v4/channels/{channelId}/posts?since=...` (via `getPostsSince`) so the current channel’s posts are requested early (may add a short jitter for large public/private channels).
- **Other unread channels** — builds a queue from unread channels (mentions first, then unreads) and prefetches posts (two at a time) → same posts APIs as below (e.g. `GET /api/v4/channels/{channelId}/posts` or unread endpoint).

So on first run, once the sidebar is considered loaded and a channel is selected, the app prefetches profiles for sidebar DMs/GMs and posts for the current channel and then for other unread channels.

---

## 9. Channel selection (click or URL)

When the user opens a channel (by URL or click), **ChannelIdentifierRouter** runs **onChannelByIdentifierEnter**, which resolves the identifier (channel name, id, DM, GM) and then calls **emitChannelClickEvent(channel)**. That:

- **Channel stats** — `getChannelStats(channel.id)` → **Backend:** `GET /api/v4/channels/{channelId}/stats` (or with `?exclude_files_count=true`). Member count, etc., for the channel.
- **Profiles for sidebar** — `loadProfilesForSidebar()` again when switching (same APIs as in section 8).
- **Redux** — `SELECT_CHANNEL` and `SELECT_CHANNEL_WITH_MEMBER` so the UI and Redux know the current channel (no API).
- **App bindings** — If apps are enabled, `fetchAppBindings(channel.id)` → **Backend:** `GET /plugins/com.mattermost.apps/api/v1/bindings?channel_id=...&team_id=...&user_agent=webapp`. App commands/bindings for that channel.

If the channel was not in the store yet (e.g. resolved by name or by ID), the router may have called **getChannelByNameAndTeamName** → **Backend:** `GET /api/v4/teams/name/{teamName}/channels/name/{channelName}`, **getChannelMember** → **Backend:** `GET /api/v4/channels/{channelId}/members/{userId}`, **joinChannel** → **Backend:** `POST /api/v4/channels/members`, **getUser** / **getUserByUsername** → **Backend:** `GET /api/v4/users/{userId}` or `GET /api/v4/users/username/{username}`, **openDirectChannelToUserId** (creates/gets DM), or **fetchChannelsAndMembers(teamId)** (APIs above). So the “first fetch” for a given channel can include channel metadata, membership, and optionally user profile(s) for DMs/GMs.

---

## 10. Post list (first time a channel’s posts are shown)

When the PostList component loads posts for the selected channel it runs **postsOnLoad** (or equivalent), which:

- If there is a **focused post** (e.g. permalink): **loadPostsAround(channelId, focusedPostId)** → **Backend:** `GET /api/v4/channels/{channelId}/posts?before=...` and/or `?after=...` (via `getPostsBefore` / `getPostsAfter`). Posts around that id.
- Else if **first load** and not already prefetching: **loadUnreads(channelId)** → **Backend:** `GET /api/v4/users/me/channels/{channelId}/posts/unread?limit_after=...&limit_before=...&...`. Unread-related posts.
- Else if there is a **latestPostTimeStamp** (e.g. after reconnect): **syncPostsInChannel(channelId, since)** → **Backend:** `GET /api/v4/channels/{channelId}/posts?since=...`.
- Otherwise: **loadLatestPosts(channelId)** → **Backend:** `GET /api/v4/channels/{channelId}/posts?page=0&per_page=...`. Latest chunk of posts (`getPosts`).

After loading, it calls **markChannelAsRead(channelId)** → **Backend:** `POST /api/v4/channels/members/me/view` with body `{ channel_id, collapsed_threads_supported: true }` (updates last viewed and read state).

So on first render of a channel’s thread view, the app fetches either unread posts or the latest posts (or around a permalink), then marks the channel as read.

---

## Summary order (logged-in first run)

Rough order of what gets fetched:

1. **Config and license** (always).
2. **Me, preferences, my teams, my team members** (parallel).
3. **My team unreads, server limits** (after that).
4. **Products, plugins, recent emojis** (onConfigLoaded); then app routes mount.
5. **Optional:** first-admin check and admin profiles if at “/”.
6. **WebSocket, timezone, custom profile attributes** (LoggedIn).
7. **All teams’ channels and all my channel members** (TeamController).
8. **Optional:** team by name, add to team, initializeTeam (and groups), fetchChannelsAndMembers for that team, team content flagging.
9. **My categories** for current team (Sidebar).
10. **Profiles for sidebar** (DMs/GMs) and **prefetch current channel + unread channels’ posts** (DataPrefetch).
11. **Channel stats, app bindings** when a channel is selected; **posts** (latest or unread or around permalink) and **markChannelAsRead** when the post list loads.

This is the set of data the frontend fetches on the first run or first render for a logged-in user.
