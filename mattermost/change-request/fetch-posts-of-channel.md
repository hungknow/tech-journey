# Fetch Posts of Channel

This document describes how the frontend fetches the latest posts for a specific channel: which API is used, how thread (reply) posts are handled, and how pagination works when the user scrolls. The description is based on the current web app and server code.

**Abbreviations:** **CRT** = Collapsed Reply Threads — replies are shown in a thread view (not inline in the channel); the channel shows root posts + thread metadata; when CRT is on, unread and mentions use root-post counts (`msg_count_root`, `mention_count_root`, `messageCount.root`).

## Use cases and API

**Entry point:** `PostList` calls `postsOnLoad(channelId)` (in `post_list.tsx`). That function picks one of the actions below: first it checks for a focused/permalink post, then first-load unreads, then sync after reconnect, then falls back to loading the latest posts. Scroll (older/newer) and other actions run later, when the user scrolls or opens a thread.

**Main post-loading (used by `postsOnLoad`), in priority order:**

1. **Permalink / focused post.** (checked first)
    - Function: `loadPostsAround(channelId, focusedPostId)` — three calls in parallel: `getPostThread(postId)`, `getPostsAfter`, `getPostsBefore`.
    - API: `GET /api/v4/posts/{post_id}/thread` plus `GET /api/v4/channels/{channel_id}/posts?after=...` and `?before=...`. Results merged so the list is centered on that post.

2. **First load with unreads.**
    - Function: `loadUnreads` → `getPostsUnread`.
    - API: `GET /api/v4/users/{user_id}/channels/{channel_id}/posts/unread?limit_after=30&limit_before=30`.
    - May also call `getPosts` when "start from newest".

3. **Sync after reconnect.**
    - Function: `syncPostsInChannel` → `getPostsSince(since)`.
    - API: `GET /api/v4/channels/{channel_id}/posts?since={timestamp}`.

4. **Open channel (latest).** (default fallback)
    - Function: `loadLatestPosts` → `getPosts(channelId, 0, 30)`.
    - API: `GET /api/v4/channels/{channel_id}/posts?page=0&per_page=30`.
    - Optional query: `skipFetchThreads`, `collapsedThreads`, `collapsedThreadsExtended`.

**Other actions (scroll, permalink, thread, etc.):**

- **Scroll up (older).**
    - Function: `loadOlderPosts` → `getPostsBefore(channelId, oldestPostId, …)`.
    - API: `GET /api/v4/channels/{channel_id}/posts?before={postId}&page=0&per_page=30`.

- **Scroll down (newer).**
    - Function: `loadNewerPosts` → `getPostsAfter(channelId, newestPostId, …)`.
    - API: `GET /api/v4/channels/{channel_id}/posts?after={postId}&page=0&per_page=30`.

- **Permalink / focused post.**
    - Function: `loadPostsAround` — runs three calls in parallel: `getPostThread(postId)`, `getPostsAfter`, `getPostsBefore`.
    - API: `GET /api/v4/posts/{post_id}/thread` plus channel posts with `after` / `before`. Results merged so the list is centered on that post.

- **Thread viewer (replies).**
    - Function: `getPostThread(postId)`.
    - API: `GET /api/v4/posts/{post_id}/thread`. Optional query: `skipFetchThreads`, `collapsedThreads`, `collapsedThreadsExtended`.

- **Load specific posts by ID.**
    - Function: `getPostsByIds(ids)`.
    - API: `POST /api/v4/posts/ids` (body: JSON array of post IDs). For specific posts, not the channel timeline.

**Notes:** Thread behaviour: channel list uses `skipFetchThreads` and `collapsedThreads` on the channel posts endpoint; thread viewer uses the thread endpoint. Key paths: `webapp/channels/src/actions/views/channel.ts`; Redux/Client: `mattermost-redux/actions/posts.ts`, `client4.ts`. Server: `getPostsForChannel` in `api4/post.go`.

---

## 1. API for channel posts

**Endpoint:** `GET /api/v4/channels/{channel_id}/posts` (handler: `getPostsForChannel`, `api4/post.go`).

**Query params:**

- `page`, `per_page` — Default pagination (no `since`/`before`/`after`).
- `since` — Unix ms; posts modified after (sync). Mutually exclusive with before/after/page.
- `before` — Post ID → page of **older** posts.
- `after` — Post ID → page of **newer** posts.
- `skipFetchThreads` — If true, no reply posts; only roots (and thread metadata when collapsed).
- `collapsedThreads` — Only root posts + thread metadata (reply count, last reply, etc.).
- `collapsedThreadsExtended` — Extended thread metadata.
- `include_deleted` — Include deleted (system admin).

**Response (PostList):**  
- `order`: list of post IDs, newest first  
- `posts`: map of id → post  
- `next_post_id`: string, for pagination (empty if no more newer)  
- `prev_post_id`: string, for pagination (empty if no more older)  
- `first_inaccessible_post_time`: timestamp if earliest post is not visible to the user  

---

## 2. How the frontend fetches “latest” posts

**Entry:** `PostList` → `postsOnLoad(channelId)` (in `post_list.tsx` / `post_list/index.tsx`).

**Which call (order matches `postsOnLoad` logic):**

1. **Permalink / focused post** → `loadPostsAround(channelId, focusedPostId)`: 3 parallel calls — `getPostThread(postId)` → `GET .../posts/{id}/thread`, `getPostsAfter` → `GET .../channels/{id}/posts?after=...`, `getPostsBefore` → `GET .../channels/{id}/posts?before=...`; merged so list is centered on that post.
2. **First load with unreads** → `loadUnreads(channelId)` → `getPostsUnread` → **API:** `GET /api/v4/users/{user_id}/channels/{channel_id}/posts/unread?limit_after=30&limit_before=30`; may also call `getPosts(channelId, 0, …)` when “start from newest”.
3. **Re-sync (e.g. reconnect)** → `syncPostsInChannel(channelId, latestPostTimeStamp)` → `getPostsSince(since)` → **API:** `GET /api/v4/channels/{channel_id}/posts?since={timestamp}`.
4. **Default** → `loadLatestPosts(channelId)` → `getPosts(channelId, 0, 30)` → **API:** `GET /api/v4/channels/{channel_id}/posts?page=0&per_page=30`.

Typical “open channel” = **GET** `.../posts` with `page=0`, `per_page=30`.

### 2.1 Load unreads vs load latest

- **First open** (no posts in channel yet): the app calls **load unreads** → `GET .../users/{user_id}/channels/{channel_id}/posts/unread?limit_after=30&limit_before=30`. The server uses the user’s membership (`last_viewed_at`, `msg_count`) to return a window around the unread position. Whether the UI then shows that unread window or the newest posts is controlled by the “Scroll position when viewing an unread channel” setting (start from unread vs start from newest).
- **Later opens** (channel already has posts in Redux): the app uses **load latest** or **sync** → `GET .../channels/{id}/posts?page=0&per_page=30` (or `since=...`).

**How “unread” is determined** (for sidebar and behaviour):  
- **`myMembers`** = `state.entities.channels.myMembers` — a map **channelId → your membership** in that channel. Each value is a `ChannelMembership`: your read position and mention counts for that channel (see types in `webapp/platform/types/src/channels.ts`).
- **Per channel you have:** `msg_count` / `msg_count_root` = number of posts (or root posts) you’ve “read” (count at last view); `mention_count` / `mention_count_root` = unread @mentions for you. Channel totals live in `state.entities.channels.messageCounts[channelId]` as `total` and `root`.
- **Formulas:** unread messages = `messageCount.total − member.msg_count` (or `root − msg_count_root` when CRT is on); unread mentions = `member.mention_count` (or `mention_count_root`). **Show as unread** = `mention_count > 0` OR (channel not muted AND unread message count > 0). See `calculateUnreadCount` in `mattermost-redux/utils/channel_utils.ts`.
- **Example (no CRT):** Channel has 100 posts (`messageCount.total = 100`), you’ve read up to 93 (`member.msg_count = 93`), 2 unread @mentions (`member.mention_count = 2`). Unread messages = 100 − 93 = **7**; sidebar shows unread (mentions 2 > 0 and 7 unread).

---

## 3. Threads (replies)

**Channel list:** Root posts (no `root_id`); replies have `root_id`. Order is by root. Replies either inline (Collapsed Threads off) or collapsed (only root + metadata).

**API:**  
- `skipFetchThreads = false`: server includes reply posts.  
- `skipFetchThreads = true`: only roots (and metadata); replies loaded when user opens thread.  
- `collapsedThreads = true`: only roots + thread metadata; full replies when thread opens.

**Thread viewer:** `Client4.getPostThread(postId)` → **API:** `GET /api/v4/posts/{post_id}/thread`. Returns PostList for that thread (root + replies). Not the channel-posts endpoint.

**loadPostsAround:** Always calls thread API with focused post ID. Backend returns: single post (no thread), root+replies (root), or full thread (when focused post is a reply). Frontend merges with before/after channel posts and centers.

---

## 4. Pagination on scroll

**Trigger:** Virtualized list (`post_list_virtualized.tsx`). Near top → `loadOlderPosts()`; near bottom → `loadNewerPosts()`. Threshold ~1000px.

**Calls:**  
- Older: `getPostsBefore(channelId, oldestVisiblePostId, …)` → **API:** `GET /api/v4/channels/{channel_id}/posts?before={postId}&page=0&per_page=30`.  
- Newer: `getPostsAfter(channelId, newestVisiblePostId, …)` → **API:** `GET /api/v4/channels/{channel_id}/posts?after={postId}&page=0&per_page=30`.

**Sizes:** User scroll = 30/request; auto-load up to 200.  
**Boundaries:** `atOldestPost` / `atLatestPost` from `prev_post_id === ''` / `next_post_id === ''`; then no more requests.  
**Limit:** `MAX_EXTRA_PAGES_LOADED` (30) caps extra pages per session.

---

## 5. Frontend file tree and flow

### 5.1 File tree

```
webapp/channels/src/
├── actions/views/channel.ts           # loadLatestPosts→getPosts, loadUnreads→getPostsUnread, loadPostsAround→(3 APIs), syncPostsInChannel→getPostsSince
├── actions/websocket_actions.ts       # syncPostsInChannel on reconnect
├── components/channel_view/channel_view.tsx
├── components/data_prefetch/          # prefetchChannelPosts (current + unread)
├── components/post_view/
│   ├── post_view.tsx, post_list/      # postsOnLoad, getPostsBefore/After
│   └── post_list_virtualized/         # onScroll → loadOlder/Newer
└── packages/mattermost-redux/src/
    ├── actions/posts.ts              # Defines functions that call the various post-related API endpoints, including:
    │                                 #   - getPosts:               GET /channels/{id}/posts
    │                                 #   - getPostsBefore:         GET /channels/{id}/posts?before={postId}
    │                                 #   - getPostsAfter:          GET /channels/{id}/posts?after={postId}
    │                                 #   - getPostsSince:          GET /channels/{id}/posts?since={timestamp}
    │                                 #   - getPostsAround:         Runs thread+before+after calls and merges them
    │                                 #   - getPostsUnread:         GET /users/{user_id}/channels/{channel_id}/posts/unread
    ├── selectors/entities/posts.ts    # Selectors to extract post data from the Redux store.
    ├── reducers/entities/posts.ts     # Redux reducers for managing post state.
    └── utils/post_list.ts             # Post list utilities, sorting, merging, etc.

webapp/platform/client/src/client4.ts  # Contains low-level HTTP functions for all post-related endpoints used above:
```

**Server:** `server/channels/api4/api.go` (route), `post.go` (`getPostsForChannel`); `app/post.go` (GetPostsPage, GetPostsBeforePost, GetPostsAfterPost, GetPostsSince).

### 5.2 Component flow

**Hierarchy (top → bottom):**

```
ChannelView
    └── PostView (deferred; handles loading vs content, passes unread state)
            └── PostList (Redux connect)
                    └── PostListVirtualized (virtualized list, scroll handlers)
```

**Responsibilities:**

- **ChannelView** — Container; mounts PostView (deferred).
- **PostView** — Shows a loading state (e.g. spinner/skeleton) while posts are fetched, then the post list once ready. Passes unread-related data (e.g. last read position) down to PostList so it can show the “New messages” divider and choose between `loadUnreads` and `loadLatestPosts` on first load.
- **PostList** — On load: `postsOnLoad` runs one of `loadPostsAround`, `loadUnreads`, `syncPostsInChannel`, or `loadLatestPosts`. Passes `getPostsBefore` / `getPostsAfter` to the virtualized list.
- **PostListVirtualized** — Renders posts; `onScroll` calls `loadOlderPosts` (near top) or `loadNewerPosts` (near bottom).
- **DataPrefetch** (Sidebar) — Prefetches posts for current channel and unread channels; separate from the main post list.

### 5.3 Hooks

Post loading and scroll pagination are in **class components** + Redux `connect()`.  
Hooks in this path: **LatestPostReader** (`useSelector`, `useMemo`, `usePostAriaLabel`) for accessibility only. Other post_view children use hooks for reactions/attachments/etc., not for fetching.
