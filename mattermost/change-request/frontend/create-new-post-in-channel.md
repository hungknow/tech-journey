# Create New Post in Channel

This document describes how the frontend creates a new post in a channel: the UI entry points, data flow from draft to API, which API is called, and what Redux state and side effects are updated. The description is based on the current web app and server code.

**Abbreviations:** **CRT** = Collapsed Reply Threads; **RHS** = Right-Hand Side (thread/reply panel).

---

## Use cases and API

**Entry point:** The user types in the center-channel post text box (or the RHS reply box) and submits via Enter, Ctrl+Enter, or the Send button. For the **center channel**, the create-post UI is `AdvancedCreatePost`, which renders `AdvancedTextEditor` with `location={Locations.CENTER}` and `rootId=''`. For **replies**, the same `AdvancedTextEditor` is used with a non-empty `rootId`; the API and Redux flow are the same, except the post has `root_id` set and draft is keyed by thread (comment draft).

**Single API for creating a post:**

- **Create post (channel or reply).**
    - Function: `Client4.createPost(post)` (called from `mattermost-redux` `createPost` thunk).
    - API: **POST** `/api/v4/posts` with JSON body: the post object (required: `channel_id`, `message`; typically also `user_id`, `root_id` when replying, `create_at`, `update_at`, `pending_post_id`, `file_ids`, `metadata`, `props`, etc.).
    - Server handler: `createPost` in `server/channels/api4/post.go`; app layer `CreatePostAsUser` in `server/channels/app/post.go`.
    - Response: the created `Post` (with real `id`, timestamps, etc.).

**Other code paths before the API (still end at the same API for the actual post):**

- **Scheduled post.** If the user schedules the message, `submitPost` in `create_comment.tsx` builds a scheduled post and calls `createSchedulePostFromDraft` instead of `PostActions.createPost`. That uses a different API (scheduled posts), not covered here.
- **Slash command.** If the message starts with `/`, `onSubmit` calls `submitCommand`; the command may then call `submitPost` (same create-post API) if the command asks to send a message.
- **Emoji reaction.** If the message matches the reaction pattern (e.g. `:emoji:`) and the user is replying, `onSubmit` may call `submitReaction` instead of creating a new post.

---

## 1. API for creating a post

**Endpoint:** **POST** `/api/v4/posts` (handler: `createPost`, `api4/post.go`).

**Request body (JSON):** A single post object. Key fields the frontend sends:

- `channel_id` (required), `message` (required).
- `user_id`, `create_at`, `update_at`, `pending_post_id` (client-generated for optimistic UI).
- `root_id` — empty for channel root posts; set for replies.
- `file_ids` — array of file IDs if the post has attachments.
- `metadata` (e.g. priority), `props` (e.g. `mentionHighlightDisabled`, `disable_group_highlight`).
- `type` — e.g. burn-on-read type when that feature is enabled.

**Response:** The created `Post` as returned by the server (with real `id`, server timestamps, etc.). For burn-on-read posts, the server may return revealed content to the author in this response.

**Notes:** The server runs permission checks (`createPostChecks`), optional “message will be posted” hooks, and then `CreatePostAsUser`. The frontend does **not** refetch the channel post list after create; it relies on optimistic updates and the API response to update the store.

---

## 2. Data flow on the frontend

**High-level flow:**

1. User focuses the center (or RHS) text box. The draft is read from Redux-backed storage via `makeGetDraft(state, channelId, rootId, storageKey)` and merged with local state in `AdvancedTextEditor`.
2. User types; draft is updated in local state and persisted (e.g. via `updateDraft` / storage) so it can be restored when switching channels.
3. User submits (Enter, Send button, etc.). The handler is `handleSubmit` from `useSubmit`, which may show modals (e.g. notify all, status reset, /header, /purpose) or call `doSubmit`.
4. `doSubmit` calls `dispatch(onSubmit(submittingDraft, options, schedulingInfo))` (when not in edit mode and not scheduled).
5. `onSubmit` (in `create_comment.tsx`) optionally handles reactions or slash commands; otherwise it calls `submitPost(channelId, rootId, draft, ...)`.
6. `submitPost` builds a `Post` from the draft (message, channel_id, root_id, user_id, file_ids, metadata, props, etc.), runs `runMessageWillBePostedHooks(post)`, then calls `PostActions.createPost(post, draft.fileInfos, afterSubmit, options)` from `post_actions.ts`.
7. The webapp `post_actions.createPost` adds recent emojis for the message, then dispatches `PostActions.createPost` from mattermost-redux (same signature).
8. **mattermost-redux `createPost`** (in `mattermost-redux/actions/posts.ts`):
    - Builds a `pending_post_id` (e.g. `userId:timestamp`) and a `newPost` (with pending id, create_at, update_at, reply_count if reply).
    - Dispatches **optimistic** actions: `RECEIVED_NEW_POST` with the pending post, and optionally `RECEIVED_FILES_FOR_POST` and `INCREMENT_FILE_COUNT` for attachments.
    - Calls **Client4.createPost** with the new post (create_at set to 0 for server to assign).
    - On success: dispatches `receivedPost(created, crtEnabled)`, `CREATE_POST_SUCCESS`, `INCREMENT_TOTAL_MSG_COUNT`, `DECREMENT_UNREAD_MSG_COUNT`, and again file actions for the real post id.
    - On failure: dispatches `CREATE_POST_FAILURE` and either `removePost` (for certain server errors) or `receivedPost` with failed post (for retry).
9. Back in the webapp, after `PostActions.createPost` returns, `post_actions.createPost` clears the draft (unless `keepDraft`): for root posts it dispatches `storeDraft(channelId, null)`; for replies `storeCommentDraft(rootId, null)`. Then it runs `afterOptimisticSubmit` if provided.
10. In `use_submit.tsx`, after a successful `onSubmit`, the local draft is reset via `handleDraftChange({ message: '', fileInfos: [], ... })`, and for center-channel root posts `scrollPostListToBottom()` is dispatched so the list scrolls to the new post.

**Summary:** Draft → `onSubmit` → `submitPost` → `runMessageWillBePostedHooks` → `PostActions.createPost` (redux) → optimistic `RECEIVED_NEW_POST` → **POST /api/v4/posts** → on success: `receivedPost` + message count updates + draft clear + scroll to bottom.

---

## 3. What data is updated (Redux and side effects)

**Optimistic (before API response):**

- **Posts:** `PostTypes.RECEIVED_NEW_POST` — the new post is added to `state.entities.posts.posts` (and related structures like `postsInChannel`, `postsInThread`, `nextPostsReplies`) with `id = pending_post_id`. So the UI shows the new message immediately.
- **Channels:** `PostTypes.RECEIVED_NEW_POST` in channels reducer — the channel’s `last_post_at` (and for CRT replies, `last_root_post_at`) is updated.
- **Files:** If the post has attachments, `FileTypes.RECEIVED_FILES_FOR_POST` (by pending id) and `ChannelTypes.INCREMENT_FILE_COUNT` for the channel.
- **Request state:** `BATCH_CREATE_POST_INIT` is used to batch the above.

**After successful API response:**

- **Posts:** `receivedPost(created, crtEnabled)` — same post is updated in the store with the real server `id` and server timestamps; ordering and thread state are updated so the pending id is replaced by the real id.
- **Channels:** `ChannelTypes.INCREMENT_TOTAL_MSG_COUNT` — `messageCounts[channelId]` total (and root when CRT) is incremented by 1.
- **Channels (unread):** `ChannelTypes.DECREMENT_UNREAD_MSG_COUNT` — unread message count for that channel (and root when CRT) is decremented (author’s own post is considered “read”).
- **Files:** `FileTypes.RECEIVED_FILES_FOR_POST` with the real `postId` so file-to-post mapping is correct.
- **Request state:** `CREATE_POST_SUCCESS`; batch label `BATCH_CREATE_POST`.

**After failed API response:**

- **Posts:** Either the post is removed (`removePost` for specific server errors like deleted root or town square read-only or plugin dismiss) or the same post is updated with `failed: true` so the user can retry.
- **Request state:** `CREATE_POST_FAILURE`; batch label `BATCH_CREATE_POST_FAILED`.

**Draft and UI:**

- Draft for the channel (or comment draft for the thread) is cleared in storage via `storeDraft(channelId, null)` or `storeCommentDraft(rootId, null)` after a successful create (unless `keepDraft`).
- Local draft state in `AdvancedTextEditor` is reset to empty in `use_submit` after success.
- For a new root post in the center channel, `scrollPostListToBottom()` is dispatched, which emits `POST_LIST_SCROLL_TO_BOTTOM` so the virtualized post list scrolls to the bottom.

**Other:**

- Recent emojis used in the message are updated via `addRecentEmojisForMessage` before the create-post thunk.
- If the server returns a burn-on-read post with revealed content, the client stores that post as returned; no extra API call is needed for the author’s view.

---

## 4. Threads (replies) and CRT

Creating a **reply** uses the same **POST /api/v4/posts** endpoint; the only difference is `root_id` is set on the post. The frontend:

- Uses the same `AdvancedTextEditor` with `rootId` set to the thread root post id.
- Draft is keyed by `rootId` (comment draft storage key).
- When building the post in `submitPost`, `root_id` is set from the draft’s context; in redux `createPost`, `reply_count` for the root is set to `getPostRepliesCount(state, post.root_id) + 1` for the optimistic post.
- Reducers that handle `RECEIVED_NEW_POST` update both channel-level and thread-level state (e.g. `postsInThread`, `nextPostsReplies`), and channel `last_post_at` / `last_root_post_at` as appropriate when CRT is enabled.

---

## 5. Frontend file tree and flow

### 5.1 File tree

```
webapp/channels/src/
├── components/
│   ├── channel_view/channel_view.tsx              # Renders AdvancedCreatePost in center when channel is not archived / no missing role
│   ├── advanced_create_post/advanced_create_post.tsx   # Center channel: AdvancedTextEditor with currentChannelId, rootId=''
│   └── advanced_text_editor/
│       ├── advanced_text_editor.tsx                # Draft from makeGetDraft(channelId, rootId); useSubmit → handleSubmit; connects to Textbox, Footer, SendButton
│       ├── use_submit.tsx                          # doSubmit → onSubmit(submittingDraft, options); on success: handleDraftChange(empty), scrollPostListToBottom (if root)
│       ├── use_key_handler.tsx                     # Enter / Ctrl+Enter → handleSubmit(updatedDraft)
│       ├── footer.tsx                              # Send button and schedule; calls handleSubmit
│       └── send_button/send_button.tsx            # Triggers handleSubmit(schedulingInfo)
├── actions/
│   ├── post_actions.ts                            # createPost: addRecentEmojisForMessage → PostActions.createPost → storeDraft/storeCommentDraft, afterOptimisticSubmit
│   └── views/
│       ├── create_comment.tsx                     # submitPost (build Post from draft, runMessageWillBePostedHooks, PostActions.createPost); onSubmit (reaction/slash/submitPost)
│       └── channel.ts                             # scrollPostListToBottom → EventEmitter POST_LIST_SCROLL_TO_BOTTOM
├── selectors/drafts.ts                            # makeGetDraft(channelId, rootId, storageKey) from storage
└── packages/mattermost-redux/src/
    ├── actions/posts.ts                           # createPost: optimistic RECEIVED_NEW_POST, Client4.createPost, then receivedPost + INCREMENT_TOTAL_MSG_COUNT + DECREMENT_UNREAD_MSG_COUNT
    ├── reducers/entities/posts.ts                 # RECEIVED_NEW_POST: handlePostReceived; nextPostsReplies
    ├── reducers/entities/channels.ts              # RECEIVED_NEW_POST: last_post_at, last_root_post_at; DECREMENT_UNREAD_MSG_COUNT
    ├── reducers/entities/channels/message_counts.ts  # INCREMENT_TOTAL_MSG_COUNT
    └── reducers/entities/threads/                 # RECEIVED_NEW_POST handling for CRT

webapp/platform/client/src/client4.ts               # createPost: POST getPostsRoute() (i.e. POST /api/v4/posts), body JSON post
```

**Server:** `server/channels/api4/post.go` (`createPost`), `server/channels/app/post.go` (`CreatePostAsUser`).

### 5.2 Component flow

**Hierarchy (center channel):**

```
ChannelView
    └── AdvancedCreatePost (currentChannelId from Redux)
            └── AdvancedTextEditor (location=CENTER, rootId='', channelId=currentChannelId)
                    ├── Draft: from makeGetDraft(state, channelId, rootId) + local state
                    ├── useSubmit → handleSubmit → doSubmit → onSubmit → submitPost → PostActions.createPost
                    ├── Textbox (value = draft.message, onChange → handleDraftChange)
                    ├── Footer → SendButton / schedule → handleSubmit
                    └── useKeyHandler → Enter → handleSubmit
```

**Responsibilities:**

- **ChannelView** — Decides whether to show the create post area (e.g. archived channel, no shared team, or normal). Renders `AdvancedCreatePost` in the center.
- **AdvancedCreatePost** — Connects current channel id and renders `AdvancedTextEditor` for the center channel (`rootId=''`).
- **AdvancedTextEditor** — Holds draft (from store + local state), handles submit (useSubmit), key handlers, and file uploads; passes `handleSubmit` to Footer/SendButton and to the key handler so Enter or Send triggers the same flow.
- **use_submit** — Validates (empty draft, uploads in progress, server error, root deleted), optionally shows modals (notify all, status, /header, /purpose), then calls `onSubmit`. After success, clears draft and dispatches `scrollPostListToBottom()` for root posts.
- **create_comment.submitPost** — Builds `Post` from draft, runs message-will-be-posted hooks, then dispatches `PostActions.createPost`.
- **post_actions.createPost** — Adds recent emojis, calls redux `PostActions.createPost`, then clears draft (unless keepDraft) and runs afterOptimisticSubmit.
- **mattermost-redux createPost** — Optimistic RECEIVED_NEW_POST, calls Client4.createPost, then on success updates store with real post and message/unread counts; on failure updates or removes the post.

### 5.3 Hooks and draft storage

- Draft is stored in Redux-backed storage (e.g. `state.storage.storage`) under keys like `draft_{channelId}` (channel) or `comment_draft_{rootId}` (reply). `makeGetDraft` reads it; `updateDraft` / `removeDraft` (or `storeDraft` / `storeCommentDraft` after submit) write it.
- `useSubmit` and `use_key_handler` are hooks used inside `AdvancedTextEditor`; they receive the current draft and callbacks so that submit goes through a single path: `onSubmit` → `submitPost` → `PostActions.createPost`.

---

## 6. Other items

**Slash commands and reactions:** If the user sends a message that is a slash command, `onSubmit` calls `submitCommand`; the command handler may in turn call `submitPost` for the same draft, so the same create-post API and Redux flow apply. If the message is detected as an emoji reaction (e.g. `:smile:` on the latest post in the thread), `submitReaction` is used instead and no new post is created.

**Scheduled posts:** When the user schedules a message, `submitPost` builds a scheduled post and calls `createSchedulePostFromDraft`, which uses the scheduled-post API and does not call the normal create-post API or the optimistic post flow described above.

**Edit mode:** The same `AdvancedTextEditor` is used for editing an existing post. In that case `useSubmit`’s `doSubmit` calls `editPost(submittingDraft)` instead of `onSubmit`; the API is PATCH/PUT for the existing post, not POST.

**Permissions and hooks:** Before sending, the app checks channel permission (e.g. CREATE_POST) and runs `runMessageWillBePostedHooks`. If a hook returns an error, the create flow stops and no API call is made. Props like `mentionHighlightDisabled` or `disable_group_highlight` are set when the user lacks channel or group mention permission.

**Optimistic UI:** The list updates immediately with the pending post; when the server responds, the same post is updated in place with the real id and timestamps. If the request fails, the post is either removed or marked failed so the user can retry.
