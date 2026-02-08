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

### 4.1 How a new block is merged into existing blocks

Whenever a **new block** is added to a channel (e.g. when posts are received in channel, after, or before), the client appends it to the channel's block list and then runs the merge logic (**mergePostBlocks(blocks, posts)**). The following describes the exact sequence of steps and behaviours.

**1. Clean empty blocks (before merge)**  
The function first runs **removeNonRecentEmptyPostBlocks** on the current list: any block with `order.length === 0` is removed **except** when that block has `recent: true`. So the "recent" block is always kept even if empty; all other empty blocks are dropped. This ensures the merge step never has to handle overlapping logic for blocks that no longer contain any posts.

**2. Early return when no blocks remain**  
If, after that cleanup, the list is empty (e.g. channel with no posts or experimental case), the function returns the **original** `blocks` argument unchanged (reference identity). No sort or merge is performed.

**3. Sort blocks by recency**  
Blocks are sorted so the **most recent** block is first. Ordering is by the **first** post's `create_at` in each block (because `order` is newest-first, the first element is the newest). Comparison is `bStartsAt - aStartsAt`, so newer `create_at` comes first. After this step, the newly added block sits in the position implied by its newest post, and all blocks are in timeline order (newest block first, oldest block last).

**4. Merge adjacent overlapping blocks**  
The code walks adjacent pairs `(a, b)` where `a` is at index `i` and `b` at `i + 1`.

- **Overlap condition:** Two adjacent blocks are merged when the **last** post in `a` (oldest in that block) is **older than or equal to** the **first** post in `b` (newest in that block), by `create_at`. That is, `aEndsAt <= bStartsAt` means they overlap or touch in time, so they are combined into one contiguous block.
- **When they overlap:**  
  - The two blocks are combined into one: `order = mergePostOrder(a.order, b.order, posts)` (see below).  
  - The merged block keeps **recent** and **oldest** from both: `recent = a.recent || b.recent`, `oldest = a.oldest || b.oldest`.  
  - The second block (`b`) is removed from the list (`splice(i + 1, 1)`).  
  - The index `i` is **not** incremented, so the same (merged) block is compared again with the next block; this repeats until it no longer overlaps with its successor.
- **When they do not overlap:** The index is incremented (`i += 1`) and the next pair is considered.

So a new block can merge with an existing block below it (in timeline order), and that merged block can in turn merge with the next, until no more adjacent pairs overlap.

**5. Combining two blocks' post IDs (mergePostOrder)**  
When two blocks are merged, their `order` arrays are combined with **mergePostOrder(left, right, posts)**:

- Start from a copy of `left`. Add every id from `right` that is not already in `left` (dedupe by id).
- If no new ids were added (`result.length === left.length`), return `left` unchanged (reference identity).
- Otherwise, sort the combined array by `posts[id].create_at` in **descending** order (newest first) and return it. So the merged block's `order` remains newest-first and deduplicated.

**6. Return value (reference identity)**  
If, after all merges, the resulting list has the **same length** as the original `blocks` argument, the function returns the **original** `blocks` (no new array). Otherwise it returns the new list. So callers can rely on reference equality when no structural change occurred (no empty blocks removed and no adjacent merges).

**Summary:** A new block is merged by (1) dropping non-recent empty blocks, (2) sorting all blocks by newest post first, (3) repeatedly merging adjacent blocks whose time ranges overlap or touch (`aEndsAt <= bStartsAt`), combining their `order` with dedupe and newest-first sort and preserving `recent`/`oldest`, and (4) returning the original array when no changes were made.

### 4.2 Received posts in channel

When the new block has `recent: true`, the client first finds the current recent block. If the new `order` is **identical** to that block (same length, same first id, same last id), it does not push a new block or run merge. Duplicate "latest page" responses therefore do not create extra blocks.

### 4.3 Received new post

If the channel has blocks but none has `recent: true`, the client **creates** a new block `{ order: [], recent: true }`, adds the new post id to it, then either pushes that block or replaces the block at the recent index. The recent block is thus created on demand when the first new post arrives after load.

If the post has `pending_post_id` and the real `post.id` differs, the client removes `pending_post_id` from the recent block's `order`, adds `post.id` if not already present, then **re-sorts** that block's `order` with `comparePosts` (pending/failed posts first, then by `create_at`) so the confirmed post is in the right position.

### 4.4 Received post (single post, e.g. server confirmation)

When a single post is received that replaces a previously pending post (`pending_post_id` set): the client finds the recent block and replaces that entry in place (`order[index] = post.id`). No new block is created and no re-sort is run.

### 4.5 Received posts since

When the client receives posts since a timestamp (e.g. after reconnect): for each post id in the API `order`, it adds the post to the **recent block** only if the post exists in the post map, its `create_at` is **strictly greater than** the current oldest post's `create_at` in the recent block, and it is not already in the block. It iterates the API `order` in **reverse** (newest first) and prepends with `unshift`. No new block is created and merge is not run. If no ids were added, the block list is left unchanged.

### 4.6 Post deleted

For each block in the channel, the client removes from `order` the deleted post id and (unless the deleted post is burn-on-read) any reply whose `root_id` is the deleted post. Then it runs the same cleanup as in merge: drop empty blocks except the one marked `recent`. The recent block is always kept even when empty.

### 4.7 Post removed

Same as post deleted but for hard remove: the client removes from each block's `order` the post id and (for non–burn-on-read) any reply with `root_id` equal to that post; for burn-on-read only the post id is removed. Then it drops empty blocks except the recent block.

### 4.8 Reading blocks: recent, oldest, around time, unread, around post

- **Recent block** — The first block with `recent === true` for the channel (post IDs at the bottom of the channel).
- **Oldest block** — The first block with `oldest === true` for the channel.
- **Post IDs at bottom** — The recent block's `order`; does not include older posts from other blocks.
- **Oldest post time in channel** — For each block with non-empty `order`, take the last id (oldest in block) and its `create_at`; return the minimum of those times, or 0 if none.
- **Block around a timestamp** — The first block whose time range contains the timestamp: first post in block `create_at >= timeStamp` and last post in block `create_at <= timeStamp`.
- **Block for unread view** — (1) If the recent chunk has empty `order`, use it. (2) If the recent chunk's oldest post has `create_at <= timeStamp`, all read at bottom → use recent chunk. (3) If an oldest chunk exists and its oldest post has `create_at >= timeStamp`, all unread → use oldest chunk. (4) Otherwise use the block around `timeStamp` if found. (5) Else use the recent chunk.
- **Block containing a post id** — The first block whose `order` contains that post id (used for permalink/focused post).
- **Chunk includes unreads** — True when the chunk has non-empty `order` and the oldest post in the chunk (last in `order`) has `create_at <= timeStamp` (the chunk contains posts at or older than that time).

### 4.9 Choosing the chunk to display in the post list

The post list picks one chunk to render: if there is a **focused post id** (permalink), it uses the block that contains that post. Else if **unread chunk timestamp** is set and not "start from bottom when unread", it uses the block for the unread view. Otherwise it uses the recent block. From the chosen chunk it uses `chunk.order` as the list of post IDs to render, `chunk.recent` for "at latest post", and `chunk.oldest` for "at oldest loaded post".

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
