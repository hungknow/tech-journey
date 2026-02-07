# Fetch Posts of Channel — Change Request

This document describes how the frontend fetches the latest posts for a specific channel: which API is used, how thread (reply) posts are handled, and how pagination works when the user scrolls. The description is based on the current web app and server code.

## Summary

| Scenario | API / params | Frontend entry |
|----------|--------------|----------------|
| Open channel, show latest | `GET .../channels/{id}/posts` `page=0`, `per_page=30` | `loadLatestPosts` → `PostActions.getPosts` |
| Scroll up (older) | `GET .../channels/{id}/posts` `before={oldestVisibleId}`, `per_page=30` | `loadOlderPosts` → `loadPosts(BEFORE_ID)` → `getPostsBefore` |
| Scroll down (newer) | `GET .../channels/{id}/posts` `after={newestVisibleId}`, `per_page=30` | `loadNewerPosts` → `loadPosts(AFTER_ID)` → `getPostsAfter` |
| Sync after reconnect | `GET .../channels/{id}/posts` `since={timestamp}` | `syncPostsInChannel` → `getPostsSince` |
| Permalink / focused post | `getPostsAfter` + `getPostsBefore` for that post | `loadPostsAround` → `getPostsAround` |
| Open thread (replies) | `GET .../posts/{post_id}/thread` | Thread viewer / `getPostThread` |

Thread behaviour in the channel list is controlled by `skipFetchThreads` and `collapsedThreads` on the **channel** posts endpoint; the thread viewer uses the **thread** endpoint for that post’s replies.

---

## 1. API for channel posts

### Endpoint

All channel post listing is done through a single HTTP endpoint:

- **Method:** `GET`
- **Path:** `/api/v4/channels/{channel_id}/posts`

Defined in the server at `server/channels/api4/api.go` as `PostsForChannel` (route: `api/v4/channels/{channel_id}/posts`). The handler is `getPostsForChannel` in `server/channels/api4/post.go`.

### Query parameters

The server branches on these query parameters (see `getPostsForChannel`):

| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | integer | Page index (default `0`). Used when no `since`/`before`/`after`. |
| `per_page` | integer | Posts per page (default `60`). |
| `since` | integer | Unix time in milliseconds. Return posts modified after this time (mutually exclusive with `before`/`after`/`page`/`per_page`). |
| `before` | string | Post ID. Return the page of posts that came **before** this post (older). |
| `after` | string | Post ID. Return the page of posts that came **after** this post (newer). |
| `skipFetchThreads` | boolean | If `true`, do not fetch reply posts for threads; only root posts (and thread metadata when collapsed threads is on). |
| `collapsedThreads` | boolean | When `true`, only root posts are returned, with thread metadata (reply count, last reply at, etc.). |
| `collapsedThreadsExtended` | boolean | Extended thread metadata when collapsed threads is enabled. |
| `include_deleted` | boolean | Include deleted posts (requires system admin). |

- **Initial load (latest page):** no `since`/`before`/`after` → uses `page` and `per_page` (e.g. `page=0`, `per_page=30`).
- **Older posts (scroll up):** `before={oldestVisiblePostId}`.
- **Newer posts (scroll down):** `after={newestVisiblePostId}`.
- **Sync new messages:** `since={timestamp}`.

The frontend builds these in `webapp/platform/client/src/client4.ts` (e.g. `getPosts`, `getPostsBefore`, `getPostsAfter`, `getPostsSince`).

### Response shape

Response is a **PostList** (see `webapp/platform/types/src/posts.ts` and server model):

- `order`: array of post IDs, **newest first** (chronological order for the channel view).
- `posts`: map of post ID → post object.
- `next_post_id`: ID of the next (newer) post, or `''` if at latest.
- `prev_post_id`: ID of the previous (older) post, or `''` if at oldest.
- `first_inaccessible_post_time`: used for “inaccessible” (e.g. plan limit) posts.

The client uses `next_post_id` and `prev_post_id` to know whether more can be loaded and to drive pagination.

---

## 2. How the frontend fetches “latest” posts

### Entry point

When the channel view shows the post list, loading is triggered from `PostList` in `webapp/channels/src/components/post_view/post_list/post_list.tsx`. The logic is in `postsOnLoad(channelId)` (and is also coordinated by the container in `webapp/channels/src/components/post_view/post_list/index.tsx`).

### Which API call is used

`postsOnLoad` chooses the request based on state:

1. **Permalink / focused post**  
   If there is a `focusedPostId` (e.g. opening a channel from a permalink):  
   `loadPostsAround(channelId, focusedPostId)`  
   - Redux: `actions/views/channel.ts` → `PostActions.getPostsAround()`.  
   - Client: two parallel calls: `getPostsAfter` and `getPostsBefore` for that post (each with `per_page = POST_CHUNK_SIZE/2`), so the list is centered on that post.

2. **First load with unreads**  
   If it’s the first load and there are unreads (and no prefetch in progress):  
   `loadUnreads(channelId)`  
   - Uses **unread** endpoint: `GET /api/v4/users/{user_id}/channels/{channel_id}/posts/unread` with `limit_before` and `limit_after`.  
   - Then may additionally call `getPosts(channelId, 0, POST_CHUNK_SIZE/2)` when “start from newest” is preferred.

3. **Re-sync (e.g. after reconnect)**  
   If there is a `latestPostTimeStamp` (e.g. last time we had posts):  
   `syncPostsInChannel(channelId, latestPostTimeStamp, false)`  
   - Client: `getPostsSince(channelId, since)` → `GET .../posts?since={since}`.

4. **Default: latest page**  
   Otherwise:  
   `loadLatestPosts(channelId)`  
   - Redux: `actions/views/channel.ts` → `PostActions.getPosts(channelId, 0, POST_CHUNK_SIZE/2)`.  
   - Client: `getPosts(channelId, 0, perPage)` → **GET** `/api/v4/channels/{channel_id}/posts?page=0&per_page=30` (no `before`/`after`/`since`).

So for the typical “open channel and show latest posts” case, the frontend uses **GET `/api/v4/channels/{channel_id}/posts`** with `page=0` and `per_page=30` (half of `POST_CHUNK_SIZE` which is 60). Thread behaviour is controlled by `skipFetchThreads` and `collapsedThreads` (see below).

---

## 3. When a post is a thread (replies)

### Channel list: root posts vs reply posts

- **Root posts** are channel messages with no `root_id`.
- **Thread replies** are posts with `root_id` set to the root post’s ID.

The **channel** post list is ordered by **root** post order. Reply posts are either:

- Shown **inline** in the channel (when Collapsed Threads is off), or  
- **Collapsed** (when Collapsed Threads is on): only the root is shown, with metadata (reply count, last reply at, participants, etc.).

### API behaviour (`skipFetchThreads`, `collapsedThreads`)

- **`skipFetchThreads = false` (default)**  
  Server fetches and includes reply posts for the root posts in the requested window. The returned `posts` map and `order` can contain both root and reply posts; the store and UI then group replies under the root (e.g. `receivedPostsInChannel` and post list utils).

- **`skipFetchThreads = true`**  
  Server does not load reply posts for the channel request. Only root posts (and, when applicable, thread metadata) are returned. Replies are loaded later when the user opens the thread (see below).

- **`collapsedThreads = true`**  
  Server returns only **root** posts and joins with thread metadata (e.g. `ThreadReplyCount`, `LastReplyAt`, `ThreadParticipants`, `IsFollowing`). The store still uses `receivedPostsInChannel`; the UI shows the root with a “thread” affordance and loads full replies when the user opens the thread.

So: “what happens if a post is a thread” in the **channel** list is:

- Either replies are included in the same channel-posts response (when `skipFetchThreads = false`), or  
- Only the root is in the channel list and replies are fetched when the user opens the thread.

### Opening a single thread (thread viewer)

When the user opens a thread (e.g. thread viewer / RHS), the frontend loads that thread’s replies with a **different** API:

- **Endpoint:** `GET /api/v4/posts/{post_id}/thread`
- **Client:** `Client4.getPostThread(postId, ...)` / `getPaginatedPostThread(postId, options)` in `webapp/platform/client/src/client4.ts`.

That call returns a **PostList** for that thread (root + replies), possibly paginated. It is **not** the channel posts endpoint; it’s the dedicated thread endpoint. Redux uses this in thread-related actions (e.g. `getPostThread` in mattermost-redux) and the result is merged into the store so the thread viewer can show replies.

---

## 4. Pagination when the user scrolls

### Scroll → load more

The scrollable list is implemented with a virtualized list in `webapp/channels/src/components/post_view/post_list_virtualized/post_list_virtualized.tsx`. In `onScroll`:

- **Scroll “backward” (up, toward older messages):**  
  When `scrollOffset < HEIGHT_TRIGGER_FOR_MORE_POSTS` (1000px from top) and not already at oldest:  
  `loadOlderPosts()`.

- **Scroll “forward” (down, toward newer messages):**  
  When offset from bottom is within the same threshold and not at latest:  
  `loadNewerPosts()`.

So pagination is **triggered by scroll position** (near top or near bottom), not by a “page number” in the URL.

### What gets called

- **Load older (scroll up):**  
  `PostList.getPostsBefore()` → `callLoadPosts(channelId, oldestVisiblePostId, PostRequestTypes.BEFORE_ID, perPage)`.  
  Redux: `loadPosts({ channelId, postId, type: BEFORE_ID, perPage })` in `actions/views/channel.ts` → `PostActions.getPostsBefore(channelId, postId, page, perPage)`.  
  Client: **GET** `/api/v4/channels/{channel_id}/posts?before={postId}&page=0&per_page={perPage}`.

- **Load newer (scroll down):**  
  `PostList.getPostsAfter()` → `callLoadPosts(channelId, latestVisiblePostId, PostRequestTypes.AFTER_ID, perPage)`.  
  Redux: `loadPosts({ channelId, postId, type: AFTER_ID, perPage })` → `PostActions.getPostsAfter(channelId, postId, page, perPage)`.  
  Client: **GET** `/api/v4/channels/{channel_id}/posts?after={postId}&page=0&per_page={perPage}`.

### Page sizes

- **User scroll (manual):** `USER_SCROLL_POSTS_PER_PAGE = POST_CHUNK_SIZE / 2` → **30** posts per request (`post_list.tsx`).
- **Auto-load (e.g. “Load more” or programmatic scroll):** `AUTO_LOAD_POSTS_PER_PAGE = 200` (capped by server limit).

So when the user scrolls, each “page” is 30 posts (before or after the current edge post).

### “At oldest” / “At latest”

- `atOldestPost` is derived from the last response’s `prev_post_id === ''`.
- `atLatestPost` is derived from `next_post_id === ''`.

When those are true, the virtualized list does not call `loadOlderPosts` / `loadNewerPosts` again, so scrolling stops triggering new requests.

### Safety / limits

- A guard (`MAX_EXTRA_PAGES_LOADED`, 30) limits how many extra pages can be loaded in one session to avoid runaway loading (e.g. channels full of hidden messages). After that, a manual “Load more” style path can still be used.

---

## 5. Frontend file tree, components, and hooks

This section lists the main frontend paths involved in fetching and displaying channel posts, how the components fit together, and where React hooks are used in this flow.

### 5.1 File tree (relevant paths)

All paths below are under the repository root. Only files that participate in “fetch posts of channel” are listed.

```
webapp/
├── channels/src/
│   ├── actions/
│   │   ├── views/
│   │   │   └── channel.ts              # loadLatestPosts, loadPosts, loadUnreads, loadPostsAround, syncPostsInChannel
│   │   └── websocket_actions.ts         # calls syncPostsInChannel on reconnect
│   ├── components/
│   │   ├── channel_view/
│   │   │   └── channel_view.tsx         # Renders deferred PostView (center channel)
│   │   ├── data_prefetch/
│   │   │   ├── data_prefetch.tsx        # Prefetches channel posts (current + unread channels)
│   │   │   ├── index.ts                 # connect() + mapState/mapDispatch
│   │   │   └── actions.ts               # prefetchChannelPosts wiring
│   │   ├── post_view/
│   │   │   ├── index.ts                 # connect(withRouter(PostView)); mapState for channelLoading, lastViewedAt
│   │   │   ├── post_view.tsx            # Wraps PostList; loading state, unread chunk
│   │   │   ├── post_list/
│   │   │   │   ├── index.tsx            # connect(PostList): selectors + load* actions
│   │   │   │   └── post_list.tsx        # postsOnLoad(), getPostsBefore/After, passes actions to VirtPostList
│   │   │   └── post_list_virtualized/
│   │   │       ├── post_list_virtualized.tsx   # Virtual list; onScroll → loadOlderPosts/loadNewerPosts
│   │   │       └── latest_post_reader.tsx      # Screen-reader latest post (uses hooks)
│   │   └── sidebar/
│   │       └── sidebar.tsx              # Renders <DataPrefetch />
│   └── packages/mattermost-redux/src/
│       ├── actions/
│       │   └── posts.ts                 # getPosts, getPostsBefore, getPostsAfter, getPostsSince, getPostsAround, getPostsUnread
│       ├── selectors/entities/
│       │   └── posts.ts                 # getRecentPostsChunkInChannel, makeGetPostsChunkAroundPost, getUnreadPostsChunk, getPost, etc.
│       ├── reducers/entities/
│       │   └── posts.ts                 # postsInChannel, order; receivedPostsInChannel, receivedPostsBefore/After/Since
│       └── utils/
│           └── post_list.ts            # makePreparePostIdsForPostList, date lines, new message separator
│   └── utils/
│       ├── constants.tsx               # POST_CHUNK_SIZE, PostListRowListIds
│       └── post_utils.ts               # getLatestPostId, getOldestPostId; usePostAriaLabel (hook)
webapp/platform/
├── client/src/
│   └── client4.ts                      # getPosts, getPostsBefore, getPostsAfter, getPostsSince, getPostThread (HTTP)
└── types/src/
    └── posts.ts                        # PostList, Post types
```

**Server (reference):**

```
server/channels/
├── api4/
│   ├── api.go                          # BaseRoutes.PostsForChannel = .../channels/{channel_id}/posts
│   └── post.go                         # getPostsForChannel handler (since/before/after/page/per_page)
└── app/
    └── post.go                         # GetPostsPage, GetPostsBeforePost, GetPostsAfterPost, GetPostsSince
```

### 5.2 Component hierarchy and hook-up

Rendering and data flow for the center-channel post list:

1. **ChannelView** (`components/channel_view/channel_view.tsx`)  
   - Renders the center channel. Uses a **deferred** `PostView` (lazy) so the heavy post list loads after first paint.  
   - Passes `channelId`, `focusedPostId` (from route `postid`), etc. into `PostView`.

2. **PostView** (`components/post_view/post_view.tsx`)  
   - **Class component.** Controls loading vs. content: shows `LoadingScreen` when `channelLoading` or `loaderForChangeOfPostsChunk`, otherwise renders `PostList`.  
   - Manages `unreadChunkTimeStamp` and `shouldStartFromBottomWhenUnread`; passes them and `changeUnreadChunkTimeStamp`, `toggleShouldStartFromBottomWhenUnread` into `PostList`.  
   - Wired to Redux via `post_view/index.ts`: `connect(makeMapStateToProps)(PostView)` for `channelLoading`, `lastViewedAt`, `unreadScrollPosition`.

3. **PostList** (container: `post_list/index.tsx`; UI: `post_list/post_list.tsx`)  
   - **Container** (`index.tsx`): `connect(makeMapStateToProps, mapDispatchToProps)(PostList)`.  
   - **mapStateToProps:** Uses `getRecentPostsChunkInChannel`, `makeGetPostsChunkAroundPost`, `getUnreadPostsChunk`, `getPost`, `isPostsChunkIncludingUnreadsPosts`, `getLimitedViews`, and `makePreparePostIdsForPostList` to compute `postListIds`, `formattedPostIds`, `atLatestPost`, `atOldestPost`, `latestPostTimeStamp`, `isFirstLoad`, etc.  
   - **mapDispatchToProps:** Binds `loadUnreads`, `loadPosts`, `loadLatestPosts`, `loadPostsAround`, `syncPostsInChannel`, `markChannelAsRead`, `updateNewMessagesAtInChannel`.  
   - **Class component** (`post_list.tsx`): In `componentDidMount` / when channel or focus changes, calls `postsOnLoad(channelId)` which dispatches one of `loadPostsAround`, `loadUnreads`, `syncPostsInChannel`, or `loadLatestPosts`. Exposes `getPostsBefore`, `getPostsAfter`, `canLoadMorePosts` as the `actions` object passed to the virtualized list. Renders `VirtPostList` (post_list_virtualized) with `postListIds`, `formattedPostIds`, and these actions.

4. **PostListVirtualized** (`post_list_virtualized/post_list_virtualized.tsx`)  
   - **Class component.** Renders the virtualized list of rows. In `onScroll`, when near top/bottom and not at boundaries, calls `loadOlderPosts()` or `loadNewerPosts()` (which are the `getPostsBefore` / `getPostsAfter` from PostList). Renders each row via `PostListRow`; injects “Load older” / “Load newer” triggers and loaders. Also renders `LatestPostReader` and `ScrollToBottomArrows`.

5. **PostListRow** (`post_view/post_list_row/post_list_row.tsx`)  
   - Renders a single row: date separator, new message line, channel intro, combined activity, or a single post. “Load older” / “Load newer” triggers call the `loadOlderPosts` / `loadNewerPosts` props (from VirtPostList → from PostList).

6. **DataPrefetch** (`components/data_prefetch/data_prefetch.tsx`)  
   - **Class component.** Rendered by `Sidebar`. On current channel or unread-queue changes, calls `prefetchChannelPosts(channelId)` which dispatches `syncPostsInChannel` or `loadUnreads` (with prefetch flag). Ensures the current channel’s posts (and unread channels) are requested; the actual post list still runs `postsOnLoad` when PostList mounts.

**Flow summary:**  
`ChannelView` → deferred `PostView` → `PostList` (connected) → `PostListVirtualized` → scroll triggers `loadOlderPosts` / `loadNewerPosts` → `loadPosts` in `channel.ts` → Redux `getPostsBefore` / `getPostsAfter` → `Client4.getPostsBefore` / `getPostsAfter`. Initial load is either `loadLatestPosts`, `loadUnreads`, `loadPostsAround`, or `syncPostsInChannel` from `postsOnLoad`.

### 5.3 Hooks used in this flow

The main **post-loading and scroll-pagination** logic lives in **class components** (PostView, PostList, PostListVirtualized, DataPrefetch). Redux is connected via `connect()`, not `useSelector`/`useDispatch` in those components.

Hooks appear in **child UI** used by the post list:

| Location | Hook(s) | Role in “fetch posts” flow |
|----------|---------|----------------------------|
| `post_list_virtualized/latest_post_reader.tsx` | `useSelector`, `useMemo`, `usePostAriaLabel` | Renders screen-reader text for the latest post in the list. Reads `postIds` and uses `getPost(state, latestPostId)`; does not trigger fetches. |
| `utils/post_utils.ts` | `usePostAriaLabel(post)` | Custom hook that returns an aria-label for a post (used by LatestPostReader and `post_aria_label_div.tsx`). |

Other components under `post_view/` (e.g. `add_reaction_button`, `post_reaction`, `post_attachment_container`, `post_flag_icon`, `post_header_custom_status`, `channel_intro_message/add_members_button`) use `useSelector`, `useDispatch`, `useCallback`, `useEffect`, or `useMemo` for their own behavior (reactions, attachments, status, etc.). They do not initiate or control channel post fetching; they only render a single post or UI chrome once posts are already in the store.

So for **this change request** (fetching and paginating channel posts), the only hook usage that is directly in the “post list path” is in **LatestPostReader** (`useSelector`, `useMemo`, `usePostAriaLabel`) for accessibility. All load/sync/pagination decisions are in class components and Redux `connect()`.

