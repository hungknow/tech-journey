# Fetch Posts of Channel — Change Request

This document describes how the frontend fetches the latest posts for a specific channel: which API is used, how thread (reply) posts are handled, and how pagination works when the user scrolls. The description is based on the current web app and server code.

## Summary

| Scenario | API / params | Frontend entry |
|----------|--------------|----------------|
| Open channel, show latest | `GET .../channels/{id}/posts` `page=0`, `per_page=30` | `loadLatestPosts` → `PostActions.getPosts` |
| Scroll up (older) | `GET .../channels/{id}/posts` `before={oldestVisibleId}`, `per_page=30` | `loadOlderPosts` → `loadPosts(BEFORE_ID)` → `getPostsBefore` |
| Scroll down (newer) | `GET .../channels/{id}/posts` `after={newestVisibleId}`, `per_page=30` | `loadNewerPosts` → `loadPosts(AFTER_ID)` → `getPostsAfter` |
| Sync after reconnect | `GET .../channels/{id}/posts` `since={timestamp}` | `syncPostsInChannel` → `getPostsSince` |
| Permalink / focused post | `getPostThread(postId)` + `getPostsAfter` + `getPostsBefore` | `loadPostsAround` → `getPostsAround` (3 parallel calls) |
| Open thread (replies) | `GET .../posts/{post_id}/thread` | Thread viewer / `getPostThread` |

Thread behaviour: channel list uses `skipFetchThreads` and `collapsedThreads` on the channel posts endpoint; thread viewer uses the thread endpoint.

### Frontend → Backend

- **loadLatestPosts** → `GET /api/v4/channels/{channel_id}/posts?page=0&per_page=30`
- **loadUnreads** → `GET /api/v4/users/{user_id}/channels/{channel_id}/posts/unread?limit_after=30&limit_before=30`
- **syncPostsInChannel** → `GET .../posts?since={timestamp}`
- **Scroll up** → **getPostsBefore** → `GET .../posts?before={postId}&page=0&per_page=30`
- **Scroll down** → **getPostsAfter** → `GET .../posts?after={postId}&page=0&per_page=30`
- **loadPostsAround** → 3 calls: `getPostThread(postId)`, `getPostsAfter`, `getPostsBefore`
- **Thread viewer** → `GET /api/v4/posts/{post_id}/thread`

Key paths: `webapp/channels/src/actions/views/channel.ts`; Redux/Client: `mattermost-redux/actions/posts.ts`, `client4.ts`. Server: `getPostsForChannel` in `api4/post.go`.

---

## 1. API for channel posts

**Endpoint:** `GET /api/v4/channels/{channel_id}/posts` (handler: `getPostsForChannel`, `api4/post.go`).

**Query params:**

| Parameter | Description |
|-----------|-------------|
| `page`, `per_page` | Default pagination (no `since`/`before`/`after`). |
| `since` | Unix ms; posts modified after (sync). Mutually exclusive with before/after/page. |
| `before` | Post ID → page of **older** posts. |
| `after` | Post ID → page of **newer** posts. |
| `skipFetchThreads` | If true, no reply posts; only roots (and thread metadata when collapsed). |
| `collapsedThreads` | Only root posts + thread metadata (reply count, last reply, etc.). |
| `collapsedThreadsExtended` | Extended thread metadata. |
| `include_deleted` | Include deleted (system admin). |

**Response (PostList):**  
- `order`: list of post IDs, newest first  
- `posts`: map of id → post  
- `next_post_id`: string, for pagination (empty if no more newer)  
- `prev_post_id`: string, for pagination (empty if no more older)  
- `first_inaccessible_post_time`: timestamp if earliest post is not visible to the user  

---

## 2. How the frontend fetches “latest” posts

Entry: `PostList` → `postsOnLoad(channelId)` (in `post_list.tsx` / `post_list/index.tsx`).

**Which call:**

1. **Permalink / focused post** → `loadPostsAround(channelId, focusedPostId)`: 3 parallel calls — `getPostThread(postId)` (focused post + thread), `getPostsAfter`, `getPostsBefore`; merged so list is centered on that post.
2. **First load with unreads** → `loadUnreads(channelId)` → unread endpoint; may also call `getPosts(channelId, 0, …)` when “start from newest”.
3. **Re-sync (e.g. reconnect)** → `syncPostsInChannel(channelId, latestPostTimeStamp)` → `getPostsSince(since)`.
4. **Default** → `loadLatestPosts(channelId)` → `getPosts(channelId, 0, 30)` → `GET .../posts?page=0&per_page=30`.

Typical “open channel” = **GET** `.../posts` with `page=0`, `per_page=30`.

---

## 3. Threads (replies)

**Channel list:** Root posts (no `root_id`); replies have `root_id`. Order is by root. Replies either inline (Collapsed Threads off) or collapsed (only root + metadata).

**API:**  
- `skipFetchThreads = false`: server includes reply posts.  
- `skipFetchThreads = true`: only roots (and metadata); replies loaded when user opens thread.  
- `collapsedThreads = true`: only roots + thread metadata; full replies when thread opens.

**Thread viewer:** `GET /api/v4/posts/{post_id}/thread` via `Client4.getPostThread`. Returns PostList for that thread (root + replies). Not the channel-posts endpoint.

**loadPostsAround:** Always calls thread API with focused post ID. Backend returns: single post (no thread), root+replies (root), or full thread (when focused post is a reply). Frontend merges with before/after channel posts and centers.

---

## 4. Pagination on scroll

**Trigger:** Virtualized list (`post_list_virtualized.tsx`). Near top → `loadOlderPosts()`; near bottom → `loadNewerPosts()`. Threshold ~1000px.

**Calls:**  
- Older: `getPostsBefore(channelId, oldestVisiblePostId, …)` → `GET .../posts?before={postId}&page=0&per_page=30`.  
- Newer: `getPostsAfter(channelId, newestVisiblePostId, …)` → `GET .../posts?after={postId}&page=0&per_page=30`.

**Sizes:** User scroll = 30/request; auto-load up to 200.  
**Boundaries:** `atOldestPost` / `atLatestPost` from `prev_post_id === ''` / `next_post_id === ''`; then no more requests.  
**Limit:** `MAX_EXTRA_PAGES_LOADED` (30) caps extra pages per session.

---

## 5. Frontend file tree and flow

### 5.1 File tree

```
webapp/channels/src/
├── actions/views/channel.ts           # loadLatestPosts, loadPosts, loadUnreads, loadPostsAround, syncPostsInChannel
├── actions/websocket_actions.ts       # syncPostsInChannel on reconnect
├── components/channel_view/channel_view.tsx
├── components/data_prefetch/          # prefetchChannelPosts (current + unread)
├── components/post_view/
│   ├── post_view.tsx, post_list/      # postsOnLoad, getPostsBefore/After
│   └── post_list_virtualized/         # onScroll → loadOlder/Newer
└── packages/mattermost-redux/src/
    ├── actions/posts.ts              # getPosts, getPostsBefore/After, getPostsSince, getPostsAround, getPostsUnread
    ├── selectors/entities/posts.ts
    ├── reducers/entities/posts.ts
    └── utils/post_list.ts

webapp/platform/client/src/client4.ts  # HTTP: getPosts, getPostsBefore/After, getPostsSince, getPostThread
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
