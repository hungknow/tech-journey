# Mention in Post — Frontend and Backend Implementation

This document describes how user and group mentions in post messages are implemented.

Mentions are stored as plain text in the post message (e.g. `@username` or `@groupname`).

The server parses them for notifications and permissions.

The client parses them again for display and for resolving usernames/groups.

---

## Server

### Create Post API

**Endpoint:** `POST /api/v4/posts`

**Request:** JSON body is a `Post` object.

The client sends the post with the message as plain text; mentions are not sent as a separate structure.

Required: `channel_id`, `message`.

**Request payload (relevant fields):**

- `channel_id` (string, required) — Target channel ID.
- `message` (string, required) — Raw message body. Mentions are literal text, e.g. `Hello @user1 and @groupname`, or `@channel`, `@all`, `@here`.
- `root_id` (string, optional) — For replies, the root post ID.
- `file_ids` (array, optional) — Attached file IDs.
- `pending_post_id` (string, optional) — Client-generated ID for optimistic updates.
- `metadata` (object, optional) — Can include `priority`; mention data is not part of it.
- `props` (object, optional) — Can be set by server (e.g. `channel_mentions`, `mentionHighlightDisabled`).

**Response:** `201 Created`. Body is the created `Post`.

It includes the same `message` as stored.

`metadata` (embeds, emojis, files, reactions, etc.) has no separate “mentions” array.

`props` may contain `channel_mentions`, `mentionHighlightDisabled`, `disable_group_highlight`.

The server does not return a list of mentioned user IDs or usernames.

The client derives that by parsing `message` and resolving via the store or separate APIs (e.g. get users by usernames).

**Flow:**

```
Client sends post { channel_id, message: "...@alice..." }
    |
    v
POST /api/v4/posts
    |
    v
Server: getExplicitMentions(post)  -->  MentionResults (user IDs, group IDs, @here/@all/@channel)
    |
    +---> Notifications, IncrementMentionCount
    +---> FillInPostProps (channel_mentions, mentionHighlightDisabled, etc.)
    |
    v
Save post; return Post to client
```

### How mentions are stored in the database

Mentions are **not** stored as structured data.

There is no “mentions” table and no post-level list of mentioned user/group IDs.

The system only persists the following.

**1. The message text (and attachment text)**

- **`posts` table:** The actual mention text lives only in `posts.message` (VARCHAR(65535)), e.g. `Hello @alice and @developers`.
- There is no column like `mentioned_user_ids`.
- Attachment text (pretext, text, field values) that can contain mentions is stored inside `posts.props` (JSON).
- So mention content is in the post row: `message` and optionally inside `props` for attachments.

**2. Post-level props (optional)**

- **`posts.props`:** The server may write mention-related keys when saving a post.
- `channel_mentions` — map of mentioned channel names to display info for ~channel links.
- `mentionHighlightDisabled` — when the post has @channel/@all/@here and the author is not allowed.
- `disable_group_highlight` — when the post has a group mention but the author lacks permission.
- These affect rendering and permissions; they do **not** store “who was mentioned” as a list of IDs.

**3. Aggregate mention counts**

- **`channelmembers`:** Per (channel, user): `mentioncount`, `mentioncountroot`, `urgentmentioncount` — unread mention counts.
- Updated when new posts are created and the server parses mentions (e.g. `IncrementMentionCount`).
- Counts only; no “post X mentioned user Y” rows.
- **`threadmemberships`:** Per (thread root post, user): `unreadmentions` — unread mention count in that thread.
- Again a single number per membership, not a list of mention records.

**Summary:**

The database does not store a normalized “PostMentions” table.

Who was mentioned is determined by **parsing the post’s `message` (and attachment text in `props`) at runtime**.

The DB stores only the message text, optional mention-related props, and aggregate counts.

To know “who was mentioned in this post,” the server or client must parse the message text each time.

**Database (file-tree style):**

```
posts
  message          ← only place mention text is stored (e.g. "Hello @alice")
  props            ← optional: channel_mentions, mentionHighlightDisabled, disable_group_highlight
  (no mention_ids / mentions table)

channelmembers
  mentioncount     ← unread mention count per (channel, user)
  mentioncountroot
  urgentmentioncount

threadmemberships
  unreadmentions   ← unread mention count per (thread, user)
```

### How the server uses mentions (parsing and behavior)

- **Parsing:** The server parses mentions from the message (and from attachment pretext/text/fields).
- It uses `getMentionsEnabledFields(post)` to get the text to scan, then a standard mention parser.
- **Mention types:**
  - User mentions `@username` (and `@username:remotename`), matched against a “mention keywords” map (usernames, mention keys, optionally first name).
  - Group mentions `@groupname` for groups allowed in the channel.
  - Channel-wide: `@channel`, `@all`, `@here`, resolved per user from notify settings and channel membership.
- **Result:** Parsing produces `MentionResults`: maps user ID → mention type, group ID → mention type; flags for `HereMentioned`, `AllMentioned`, `ChannelMentioned`; and “other potential mentions” for strings that looked like mentions but did not match.
- **Use:** These results drive notifications.
- They drive updates to `channelmembers.mentioncount` / `threadmemberships.unreadmentions`.
- They drive permission checks (`PermissionUseChannelMentions`, `PermissionUseGroupMentions`).
- The server also fills post props before saving.
- **Code:** `server/channels/app/notification.go` (`getExplicitMentions`, `getMentionsEnabledFields`); `mention_keywords.go`; `mention_results.go`; `post.go` (e.g. `FillInPostProps`).
- Count updates: channel and thread stores (e.g. `IncrementMentionCount`).

---

## Frontend

### Sending a post with mentions

When the user types a message with `@username` or `@groupname`, the client sends the same plain-text `message` to `POST /api/v4/posts`.

No client-side preprocessing of mentions is required; the server accepts the raw message and parses mentions itself.

The Redux action `createPost` (in `webapp/channels/src/packages/mattermost-redux/src/actions/posts.ts`) builds the post object and calls `Client4.createPost(post)`.

The platform client (`webapp/platform/client/src/client4.ts`) sends `POST` to `/api/v4/posts` with `body: JSON.stringify(post)`.

### Displaying mentions in a post

Rendering goes: message text → markdown/formatting → HTML with `data-mention` spans → React components.

**Display flow (graph text):**

```
post.message (plain text)
    |
    v
Markdown.format()  -->  Renderer.text()  -->  TextFormatting.doFormatText()
    |
    v
autolinkAtMentions()  -->  replace @x with <span data-mention="x">@x</span>
    |
    v
messageHtmlToComponent(html)
    |
    v
<span data-mention="x">  -->  AtMention(mentionName="x")
    |
    v
getUserOrGroupFromMentionName(x)  -->  usersByUsername / groupsByName (Redux)
    |
    +---> user  -->  ProfilePopover
    +---> group -->  UserGroupPopover
    +---> missing + fetchMissingUsers  -->  load users/groups then re-render
```

1. **Message source:** The post body (e.g. `PostMessageView` → `PostMarkdown` → `Markdown`) receives `post.message` (plain text).

2. **Markdown and text formatting:** The message goes through the markdown formatter (`webapp/channels/src/utils/markdown/index.ts`) with a custom `Renderer`.

   For each text segment the renderer calls `TextFormatting.doFormatText()` (`webapp/channels/src/utils/text_formatting.tsx`).

   When `atMentions` is true (default for post body), `doFormatText` calls `autolinkAtMentions()`.

3. **Autolinking mentions to HTML:** `autolinkAtMentions()` uses `Constants.SPECIAL_MENTIONS_REGEX` for `@channel`, `@all`, `@here` and `Constants.MENTIONS_REGEX` for other mentions (e.g. `@username` or `username:remotename`).

   It replaces each match with a token that is later substituted with `<span data-mention="${username}">@${username}</span>`.

   The rest of the pipeline (emoticons, search highlight, etc.) runs and tokens are replaced to produce the final HTML.

4. **HTML → React:** The HTML is passed to `messageHtmlToComponent()` (`webapp/channels/src/utils/message_html_to_component.tsx`).

   A processing instruction finds elements with the `data-mention` attribute and renders an `AtMention` component with `mentionName` = the attribute value.

   Plus options like `mentionHighlight`, `disableGroupHighlight`, `channelId`, `fetchMissingUsers`.

5. **AtMention component:** `AtMention` (`webapp/channels/src/components/at_mention/at_mention.tsx`) resolves `mentionName` with `getUserOrGroupFromMentionName(mentionName, usersByUsername, groupsByName, disableGroupHighlight)` (in `webapp/channels/src/utils/post_utils.ts`).

   It looks up the name in `usersByUsername` (Redux) and `groupsByName` (Redux) if group highlights are enabled.

   If a user is found it renders a `ProfilePopover` (with optional highlight for current user).

   If a group, it renders `UserGroupPopover`.

   If neither and `fetchMissingUsers` is true, it can trigger loading the mentioned user(s).

6. **Loading missing mention users:** When posts contain `@...` strings and the client does not have those users or groups in the store, it can call `getNeededAtMentionedUsernamesAndGroups()` (in `webapp/channels/src/packages/mattermost-redux/src/actions/posts.ts`).

   That scans post messages (and attachment pretext/text/fields) with a regex, compares to `getUsersByUsername` and `getAllGroupsByName`, and returns the set of usernames/group names still missing.

   The app can then request those users/groups so that when the message is rendered, `AtMention` can resolve the name and show the correct profile or group popover.

**File tree (main paths):**

```
webapp/channels/src/
  packages/mattermost-redux/src/actions/posts.ts
    createPost()
    getNeededAtMentionedUsernamesAndGroups()
  utils/
    text_formatting.tsx          # autolinkAtMentions(), doFormatText()
    message_html_to_component.tsx # data-mention -> AtMention
    post_utils.ts                # getUserOrGroupFromMentionName()
  utils/markdown/
    index.ts                     # format() -> Renderer
    renderer.tsx                 # text() -> doFormatText()
  components/at_mention/
    at_mention.tsx               # ProfilePopover / UserGroupPopover
```

### Summary

- **Backend API:** `POST /api/v4/posts` with at least `channel_id` and `message`.
  Mentions are plain text in `message`.
  Response is the full post; no separate mentions array.
- **Backend / database:** Mentions are not stored as a list of user/group IDs.
  They exist only in `posts.message` (and attachment text in `posts.props`).
  The DB also stores aggregate counts (`channelmembers.mentioncount`, `threadmemberships.unreadmentions`) and optional post props (`channel_mentions`, `mentionHighlightDisabled`, etc.).
- **Frontend send:** The client sends the post with `message` as typed.
  No extra mention structure is sent.
- **Frontend display:** The client converts `post.message` to HTML via markdown + `autolinkAtMentions()` → `<span data-mention="...">@...</span>`.
  `messageHtmlToComponent()` turns those spans into `AtMention` components.
  They resolve the name from Redux (or trigger loading missing users) and render the link and popover.
