# Post Block (Frontend)

This document explains what a **post block** is in the Mattermost frontend, how the channel timeline is stored in memory, and all contexts where blocks are used (storage, updates from API/WebSocket, and UI).

**Key paths:** `webapp/platform/types/src/posts.ts`, `webapp/channels/src/packages/mattermost-redux/src/reducers/entities/posts.ts`, `webapp/channels/src/packages/mattermost-redux/src/selectors/entities/posts.ts`, `webapp/channels/src/components/post_view/post_list/index.tsx`.

---

## 1. What is a post block?

A **post block** (type `PostOrderBlock`) is a chunk of the channel timeline held in memory: an ordered list of post IDs plus two optional flags that describe where that chunk sits in the overall timeline.

**Type definition** (`webapp/platform/types/src/posts.ts`):

```ts
export type PostOrderBlock = {
    order: string[];   // Post IDs, newest first
    recent?: boolean;  // This block is the "most recent" (bottom of channel)
    oldest?: boolean;  // This block is the "oldest loaded" (top of channel)
};
```

- **`order`** — Array of post IDs in **newest-first** order (same as the API). This is the slice of the channel timeline that this block represents.
- **`recent`** — When `true`, this block is the **most recent** segment: it includes the latest posts and there are no newer posts loaded. The UI uses this to know “we are at the bottom” (e.g. show/hide “Load newer messages”, scroll position).
- **`oldest`** — When `true`, this block is the **oldest loaded** segment: there are no older posts in memory. The UI uses this to know “we are at the top” (e.g. “Load older messages”, end of scroll).

The channel timeline in memory is **not** a single flat list of post IDs. It is an **array of blocks** per channel. Each block usually corresponds to one API response (one “page” of posts). When two fetches overlap, the client merges blocks so the in-memory store keeps a deduplicated, sorted view of the timeline.

---

## 2. How post blocks are stored in memory

The client keeps a map: **channel id → array of post blocks**. So for each channel we have a list of blocks; the full timeline for that channel is that list of blocks.

Within one channel, blocks are kept ordered by recency (newest block first). After merging, adjacent blocks do not overlap: each post id appears in at most one block. The block with `recent: true` holds the latest posts; the block with `oldest: true` holds the oldest loaded posts. A single block can have both `recent` and `oldest` (e.g. when only one page of posts is loaded).

A channel may have no blocks yet, or an empty array, or blocks whose `order` is empty. The “recent” block is still kept even when empty so the UI can show “at latest” and the client can attach new posts to it.

So: **post block** = one element in the channel’s array of blocks; the full timeline for a channel = that array.

---

## 3. Use cases and contexts

### 3.1 Storing paginated API results

Each fetch of channel posts returns one ordered list of post IDs (and a map of post id → post). The client turns that into one **block** (or merges it into existing blocks) in memory:

- **Initial load / latest** — When the client fetches the latest page (e.g. `getPosts(channelId, page, perPage)`), it adds one new block with `order = posts.order`, `recent = (page === 0)`, `oldest` from the API’s `prev_post_id` (no older page).
- **Unread** — When loading unread posts, the client does the same: one block (or two if “start from newest” is used) with `recent` and `oldest` derived from the API’s `next_post_id` and `prev_post_id`. Multiple blocks are merged when they overlap.
- **Sync after reconnect** — When syncing with `getPostsSince(channelId, since)`, new posts are **merged into the existing recent block** (prepended by `create_at`), not added as a new block.
- **Scroll up (older)** — When loading older posts (e.g. `getPostsBefore`), the client adds a new block with `order = [beforePostId, ...posts.order]` and `oldest` from the API. Overlap with the block below is merged so there are no duplicate or redundant blocks.
- **Scroll down (newer)** — When loading newer posts (e.g. `getPostsAfter`), the client adds a new block with `order = [...posts.order, afterPostId]` and `recent` from the API. Overlap with the block above is merged.
- **Permalink / focused post** — When loading around a specific post (thread + before + after), the client builds one combined `order` and stores it as one block centered on the focused post, with `recent` and `oldest` from the combined response.

So: **every place that fetches a contiguous slice of the channel timeline** either creates a new block or updates the recent block; then the client merges overlapping blocks so the in-memory timeline stays deduplicated and sorted.

### 3.2 New post (WebSocket or create)

When a new post arrives (e.g. via WebSocket or after the user creates a post), the client adds it to the **recent block** of that channel (prepended to `order`). If that channel has no blocks in memory yet (channel not loaded), the new post is not added to the channel’s block list.

When a single post is received that replaces a previously pending post (e.g. server confirmation after create), the client only updates the recent block: it replaces the pending post id with the real post id in `order`.

So: the **recent** block is the only one that gets new posts at the “newest” end.

### 3.3 Delete / remove

When a post is deleted (or removed, e.g. current user deletes), the client removes that post id (and reply ids when applicable) from every block’s `order`. Then it drops empty blocks **except** the one marked `recent`, so the “latest” block always exists even when empty (e.g. empty channel or all posts deleted).

So: blocks can become empty; only the recent block is kept when empty.

### 3.4 Choosing which block the UI shows

The post list does not render all blocks at once. It picks **one** block (one “chunk”) and renders that block’s `order` as the list of post IDs. Which block is chosen depends on the route and unread state:

- **Permalink / focused post** — The UI uses the block that contains the focused post id in its `order`.
- **Unread (first load)** — The UI uses the block that contains the unread boundary (or the recent/oldest block if all read or all unread). When the user’s last-viewed time falls inside a block’s time range, that block is used.
- **Default (latest)** — The UI uses the block with `recent: true` (the “bottom” of the channel).

From that chosen block the UI reads:

- `chunk.order` → post IDs to render (newest first).
- `chunk.recent` → at latest post: no newer messages loaded; at bottom.
- `chunk.oldest` → at oldest post: no older messages loaded; at top.

So: **all main use cases** (permalink, unread, latest) are “pick one block, then use its `order` and flags”.

### 3.5 Other uses of blocks

- **Oldest post time in channel** — The client can compute the oldest post time by iterating over all blocks for the channel and taking the minimum `create_at` among the last post in each block’s `order`.
- **Block around a timestamp** — To find the block that contains a given time (e.g. for unread), the client finds the block whose time range (first and last post `create_at`) contains that timestamp.
- **Whether a chunk includes unreads** — Given a block and the user’s last-viewed time, the client can tell whether that block contains posts older than that time (i.e. unreads).
- **Post IDs “at the bottom”** — Code that only needs “posts at the bottom” (e.g. status/away, drafts) reads the recent block’s `order`.
- **Full post objects for current channel** — The client can resolve post IDs from the recent block’s `order` and map them to full post objects from the in-memory post map.

So: **post block** is the unit of “which slice of the timeline we have” and “where we are (recent/oldest)”; the client either returns one block for the UI or aggregates over all blocks for a channel when needed.

---

## 4. How blocks are merged and cleaned (in-memory maintenance)

When new data is written into the channel’s block list, the client maintains consistency with a few helpers:

- **mergePostBlocks(blocks, posts)** — Sorts blocks by recency (by first post `create_at`), merges **adjacent overlapping** blocks (same or contiguous posts), dedupes and re-sorts each merged block’s `order` by `create_at`. Preserves `recent` and `oldest` when merging. Used whenever a new block is added (initial load, before, after, unread, permalink) so the channel never keeps redundant overlapping blocks.
- **removeNonRecentEmptyPostBlocks(blocks)** — Removes blocks with `order.length === 0` **unless** the block has `recent: true`. Ensures the “recent” block is always kept even when empty (e.g. empty channel or all posts deleted).
- **mergePostOrder(left, right, posts)** — Used inside merge: concatenates two id arrays, dedupes, and sorts by `create_at` (newest first). Used to combine two blocks into one.

So: **post block** is the unit that gets merged, cleaned, and kept or dropped when updating the in-memory timeline.

---

## 5. All logic: how blocks are created and updated (from source)

The following list is taken from the code that updates the channel→blocks map. Each item is one code path: when it runs, and exactly what it does to blocks.

**Reset / clear**

- **Reset posts in channel** — The entire map is cleared (all channels lose their blocks). Triggered when the app needs to reload the channel list (e.g. toggling CRT or similar). Source: `postsInChannel` case `RESET_POSTS_IN_CHANNEL`: `return {}`.

- **Leave channel** — The entry for the left channel is removed from the map. Other channels unchanged. Source: `postsInChannel` case `LEAVE_CHANNEL`: delete `state[channelId]`.

- **Logout** — The entire map is cleared. Source: `postsInChannel` case `LOGOUT_SUCCESS`: `return {}`.

**Create or add blocks**

- **Received posts in channel** — Used for initial load, unread load, or permalink (one combined block). Input: `channelId`, `order` (post ids, newest first), `recent`, `oldest`. If `order` is empty and the channel already has blocks, state is unchanged. Otherwise: (1) If `recent` is true, find the current recent block and set its `recent` to false (and skip if the new order is identical to that block). (2) Push a new block `{ order, recent, oldest }`. (3) Run `mergePostBlocks` on the channel’s new list. Source: `postsInChannel` case `RECEIVED_POSTS_IN_CHANNEL`. Called from: `getPosts`, `getPostsUnread`, `getPostsAround`.

- **Received posts after** — Used when loading newer posts (scroll down). Input: `channelId`, `order`, `afterPostId`, `recent`. If `order` is empty, state unchanged. Otherwise: build one new block with `order = [...order, afterPostId]`, `recent` from input, no `oldest`. Append it to the channel’s blocks and run `mergePostBlocks`. Source: `postsInChannel` case `RECEIVED_POSTS_AFTER`. Called from: `getPostsAfter`.

- **Received posts before** — Used when loading older posts (scroll up). Input: `channelId`, `order`, `beforePostId`, `oldest`. If `order` is empty, state unchanged. Otherwise: build one new block with `order = [beforePostId, ...order]`, `recent: false`, `oldest` from input. Append it to the channel’s blocks and run `mergePostBlocks`. Source: `postsInChannel` case `RECEIVED_POSTS_BEFORE`. Called from: `getPostsBefore`.

**Update existing blocks (no new block)**

- **Received new post** — A single new post (e.g. WebSocket or create). Input: post with `channel_id`. If CRT is enabled and the post is a reply, state unchanged. If the channel has no blocks yet, state unchanged (don’t add to blocks until the channel has been loaded). Otherwise: find the recent block (or create one with `order: []`, `recent: true` if missing). (1) If the post id is not already in that block’s `order`, prepend it (`unshift`). (2) If the post has `pending_post_id` and it differs from `post.id`, remove `pending_post_id` from the block’s `order` and re-sort by `comparePosts`. Return updated blocks for that channel. Source: `postsInChannel` case `RECEIVED_NEW_POST`. Called from: WebSocket `posted`/`ephemeral_message`, `createPost` success path, etc.

- **Received post** — A single post that may replace a pending one. Input: post with `channel_id`, `pending_post_id`. If CRT enabled and reply, or no `pending_post_id`, state unchanged. If the channel has no recent block, state unchanged. Otherwise: find the recent block; if `pending_post_id` is in its `order`, replace that entry with `post.id`. Return updated blocks for that channel. Source: `postsInChannel` case `RECEIVED_POST`. Called from: `createPost` when server returns the created post.

- **Received posts since** — Sync after reconnect (new posts since a timestamp). Input: `channelId`, `order` (from API). If `order` is empty and the channel already has blocks, state unchanged. If the channel has no recent block, state unchanged. Otherwise: take the recent block; get the oldest `create_at` in that block. For each id in `order` (iterating reverse): if the post exists in the post map, is newer than that oldest time, and is not already in the block, prepend it to the recent block’s `order`. Then re-sort the recent block by `comparePosts`. No new block is created; no `mergePostBlocks`. Source: `postsInChannel` case `RECEIVED_POSTS_SINCE`. Called from: `getPostsSince`.

**Remove post ids from blocks**

- **Post deleted** — Soft delete: post is marked deleted but may still be shown. Input: post with `channel_id`, `id`. For each block in the channel: remove from `order` the post id if it is the deleted post or (for non–burn-on-read) a reply to the deleted post; for burn-on-read, only remove the deleted post id. Then run `removeNonRecentEmptyPostBlocks` on the channel’s blocks. Source: `postsInChannel` case `POST_DELETED`. Called from: delete post flow (e.g. WebSocket `post_deleted`, or local delete).

- **Post removed** — Hard remove: post and its replies are removed from the store. Input: post with `channel_id`, `id`. For each block: filter `order` to remove the post id and (for non–burn-on-read) any reply whose `root_id` is this post; for burn-on-read, only remove the post id. Then run `removeNonRecentEmptyPostBlocks`. Source: `postsInChannel` case `POST_REMOVED`. Called from: current user deletes post, or burn-on-read burn.

**Helpers (used by the paths above)**

- **removeNonRecentEmptyPostBlocks(blocks)** — Returns blocks unchanged except: drop any block with `order.length === 0` unless that block has `recent: true`. So the recent block is always kept even when empty.

- **mergePostBlocks(blocks, posts)** — (1) Run `removeNonRecentEmptyPostBlocks` on input. (2) If no blocks remain, return original `blocks`. (3) Sort blocks by the first post’s `create_at` (newest first). (4) Merge adjacent overlapping blocks: for each pair (a, b), if the last post in `a` is older than or equal to the first post in `b` (by `create_at`), merge them into one block with `order = mergePostOrder(a.order, b.order, posts)`, set `recent = a.recent || b.recent`, `oldest = a.oldest || b.oldest`, remove the second block and re-check the same index; otherwise move to the next index. (5) If the result has the same length as the original and no merge happened, return original `blocks`; else return the new list. Used after RECEIVED_POSTS_IN_CHANNEL, RECEIVED_POSTS_AFTER, RECEIVED_POSTS_BEFORE.

- **mergePostOrder(left, right, posts)** — Concatenate `left` and `right` without duplicates (by id), then sort by `posts[id].create_at` newest first. If no new ids were added, return `left`; otherwise return the sorted array. Used inside `mergePostBlocks` to combine two blocks’ `order` arrays.

---

## 6. Summary (what is a post block used for?)

- **Storage** — One block is one (possibly merged) page of the channel timeline; per channel we store an array of blocks in memory.
- **Pagination** — Each “get posts” (latest, before, after, unread, around) adds or updates blocks; the flags `recent` and `oldest` come from API pagination (`next_post_id` / `prev_post_id`).
- **New posts** — Only the block with `recent: true` receives new posts (WebSocket or create).
- **Deletes** — Post ids are removed from every block’s `order`; empty blocks are removed except the recent block.
- **UI “which chunk”** — The UI picks one block (recent, around post, or around unread time), renders that block’s `order`, and uses `recent` / `oldest` for “at top” / “at bottom”.
- **Maintenance** — Merging keeps blocks non-overlapping; cleanup keeps the recent block even when empty.

In short: a **post block** is the frontend’s representation of a contiguous, ordered slice of the channel timeline and whether that slice is at the latest messages (`recent`), at the oldest loaded messages (`oldest`), or in between. All channel post fetches and the post list UI are built on this in-memory abstraction.
