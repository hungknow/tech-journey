# Post Block (Frontend)

This document explains what a **post block** is in the Mattermost frontend, how the channel timeline is stored in memory, and how blocks are created, merged, and used by the UI.

**Key paths:** `webapp/platform/types/src/posts.ts`, `webapp/channels/src/packages/mattermost-redux/src/reducers/entities/posts.ts`, `webapp/channels/src/packages/mattermost-redux/src/selectors/entities/posts.ts`, `webapp/channels/src/components/post_view/post_list/index.tsx`.

---

## 1. What is a post block, and how is it stored?

A **post block** (type `PostOrderBlock`) is a chunk of the channel timeline held in memory: an ordered list of post IDs plus two optional flags.

**Type definition** (`webapp/platform/types/src/posts.ts`):

```ts
export type PostOrderBlock = {
    order: string[];   // Post IDs, newest first
    recent?: boolean;  // This block is the "most recent" (bottom of channel)
    oldest?: boolean;  // This block is the "oldest loaded" (top of channel)
};
```

- **`order`** — Post IDs in **newest-first** order (same as the API). This is the slice of the channel timeline that this block represents.
- **`recent`** — When `true`, this block is the **most recent** segment (no newer posts loaded). The UI uses it for “at bottom” (e.g. “Load newer messages”, scroll position).
- **`oldest`** — When `true`, this block is the **oldest loaded** segment (no older posts in memory). The UI uses it for “at top” (e.g. “Load older messages”).

The client keeps a **map: channel id → array of post blocks**. So for each channel the full timeline in memory is that array of blocks. Each block usually corresponds to one API response (one "page" of posts). When two fetches overlap, the client merges blocks so the store stays deduplicated and sorted. Blocks are ordered by recency (newest block first). After merging, adjacent blocks do not overlap: each post id appears in at most one block. The block with `recent: true` holds the latest posts; the block with `oldest: true` holds the oldest loaded posts. A single block can have both flags (e.g. when only one page is loaded). A channel may have no blocks yet, or an empty array; the **recent** block is kept even when empty so the UI can show “at latest” and new posts can be attached to it.

---

## 2. When blocks are created and updated (by scenario)

Each scenario below is the single place that describes both the intent and the main behavior. Redux action names are in parentheses for reference.

**Reset / clear**

- **Reset posts in channel** (`RESET_POSTS_IN_CHANNEL`) — The entire channel→blocks map is cleared (e.g. toggling CRT).
- **Leave channel** (`LEAVE_CHANNEL`) — The left channel's entry is removed from the map.
- **Logout** (`LOGOUT_SUCCESS`) — The entire map is cleared.

**Paginated fetches (new block + merge)**

- **Initial load / latest, unread, or permalink** (`RECEIVED_POSTS_IN_CHANNEL`) — One ordered list of post IDs from the API is turned into one block with `order`, `recent`, `oldest` from the API's `next_post_id`/`prev_post_id`. For unread, the client may create one block or two (if "start from newest" is used); overlapping blocks are merged. If the new block has `recent: true`, the client first finds the current recent block and sets its `recent` to false (and skips adding a new block if the new `order` is identical to that block). Then it pushes the new block and runs **mergePostBlocks**. For permalink/focused post, one combined block is built and stored. Called from `getPosts`, `getPostsUnread`, `getPostsAround`.
- **Scroll down (newer)** (`RECEIVED_POSTS_AFTER`) — New block with `order = [...order, afterPostId]` and `recent` from API; append then **mergePostBlocks**. Called from `getPostsAfter`.
- **Scroll up (older)** (`RECEIVED_POSTS_BEFORE`) — New block with `order = [beforePostId, ...order]` and `oldest` from API; append then **mergePostBlocks**. Called from `getPostsBefore`.

**Updates to existing blocks (no new block)**

- **New post** (`RECEIVED_NEW_POST`) — WebSocket or create: add post id to the **recent** block (prepend). If CRT is enabled and the post is a reply, state is unchanged. If the channel has no blocks, do nothing. If there is no recent block, create one `{ order: [], recent: true }` and add the post. If the post has `pending_post_id` and it differs from `post.id`, remove the pending id and re-sort the block by **comparePosts** (pending/failed posts first, then by `create_at`). So only the recent block receives new posts at the “newest” end.
- **Single post (e.g. server confirmation)** (`RECEIVED_POST`) — When a post replaces a pending one (`pending_post_id` set): if CRT is enabled and the post is a reply, or there is no `pending_post_id`, state is unchanged. Otherwise find the recent block and replace that entry in place. No new block, no re-sort.
- **Sync after reconnect** (`RECEIVED_POSTS_SINCE`) — New posts since a timestamp are **merged into the recent block** only. The client iterates the API `order` in **reverse** (newest first) and prepends each id with `unshift` only if the post is in the post map, its `create_at` is strictly greater than the current oldest in the recent block, and it is not already in the block. If no ids were added, the block list is left unchanged. The recent block is then re-sorted by **comparePosts**. No new block and no **mergePostBlocks**.

**Remove post ids**

- **Post deleted** (`POST_DELETED`) — Remove the deleted post id from every block's `order`; unless the post is burn-on-read, also remove any reply whose `root_id` is the deleted post. Blocks are not split—only the id(s) are filtered out. Then drop empty blocks **except** the one marked `recent`. For burn-on-read, only the deleted post id is removed.
- **Post removed** (`POST_REMOVED`) — Hard remove: same as deleted (remove post id and, for non–burn-on-read, replies with that `root_id`; for burn-on-read only the post id). Same cleanup (keep recent block when empty).

**Helpers**

- **mergePostBlocks(blocks, posts)** — (1) Remove empty blocks except recent. (2) Sort blocks by first post's `create_at` (newest first). (3) Merge adjacent overlapping blocks: if the last post in block `a` is older than or equal to the first post in block `b` (`aEndsAt <= bStartsAt`), combine into one with **mergePostOrder**, set `recent = a.recent || b.recent`, `oldest = a.oldest || b.oldest`, remove the second block and re-check; else advance. (4) Return original array if no structural change. Used after RECEIVED_POSTS_IN_CHANNEL, RECEIVED_POSTS_AFTER, RECEIVED_POSTS_BEFORE.
- **removeNonRecentEmptyPostBlocks(blocks)** — Drop any block with `order.length === 0` unless it has `recent: true`.
- **mergePostOrder(left, right, posts)** — Concatenate ids, dedupe, sort by `create_at` newest first; used inside merge.

---

## 3. How the merge algorithm works (detail)

When a new block is added, the client runs **mergePostBlocks**:

1. **Clean empty blocks** — Run **removeNonRecentEmptyPostBlocks**: drop blocks with empty `order` except the one with `recent: true`.
2. **Early return** — If no blocks remain, return the original `blocks` unchanged.
3. **Sort** — Blocks sorted by the **first** post's `create_at` in each block (newest first), so the list is in timeline order.
4. **Merge adjacent overlapping** — Walk adjacent pairs `(a, b)`. Overlap when last post in `a` (oldest in block) has `create_at <=` first post in `b` (newest in block). When overlapping: combine with **mergePostOrder**, set `recent = a.recent || b.recent`, `oldest = a.oldest || b.oldest`, remove `b`, re-check same index. Otherwise advance.
5. **mergePostOrder** — Copy `left`, add ids from `right` not in `left`, dedupe; if no new ids return `left`, else sort by `create_at` descending and return.
6. **Return** — If result has same length as original and no merge happened, return original `blocks`; else return the new list.

**Received posts in channel** (`recent: true`): if the new `order` is identical to the current recent block (same length, first id, last id), the client does not push a new block or run merge, so duplicate “latest page” responses do not create extra blocks.

---

## 4. How the UI uses blocks

**Choosing which chunk to display**

The post list picks **one** block and renders that block's `order` as the list of post IDs:

- **Permalink / focused post** — Use the block whose `order` contains the focused post id.
- **Unread (first load)** — Use the block that contains the unread boundary (or recent/oldest block if all read or all unread), but only when unread chunk timestamp is set and not "start from bottom when unread"; otherwise use the recent block. When the user's last-viewed time falls inside a block's time range, that block is used.
- **Default (latest)** — Use the block with `recent: true`.

From the chosen chunk the UI uses: `chunk.order` (post IDs to render, newest first), `chunk.recent` (at latest post), `chunk.oldest` (at oldest loaded post).

**Other reads**

- **Recent block** — First block with `recent === true` for the channel.
- **Oldest block** — First block with `oldest === true`.
- **Post IDs at bottom** — The recent block's `order` (does not include older posts from other blocks).
- **Full post objects for current channel** — Resolve post IDs from the recent block's `order` and map them to full post objects from the in-memory post map.
- **Oldest post time in channel** — For each block with non-empty `order`, take the last id (oldest in block) and its `create_at`; return the minimum of those times (or 0 if none).
- **Block around a timestamp** — First block whose first post has `create_at >= timeStamp` and last post has `create_at <= timeStamp` (used for unread).
- **Block for unread view** — (1) If recent chunk has empty `order`, use it. (2) If recent chunk's oldest post has `create_at <= timeStamp`, use recent. (3) If an oldest chunk exists and its oldest post has `create_at >= timeStamp`, use oldest. (4) Else use block around `timeStamp` if found. (5) Else use recent chunk.
- **Block containing a post id** — First block whose `order` contains that id (permalink).
- **Chunk includes unreads** — True when the chunk has non-empty `order` and the oldest post in the chunk (last in `order`) has `create_at <= timeStamp` (i.e. the chunk contains posts at or older than that time).

---

## 5. How the UI knows there is more data (server ↔ client)

The UI does not ask the server on every scroll. It uses the block flags `recent` and `oldest`, which were set when data was last fetched from the server's pagination cursors.

**Server** — Each post list response has `next_post_id` and `prev_post_id` (or empty string if none). Set in `server/channels/app/post.go` (`GetNextPostIdFromPostList`, `GetPrevPostIdFromPostList`, `AddCursorIdsForPostList`).

**Client** — When storing posts, the client sets: `recent` when `next_post_id === ''`, `oldest` when `prev_post_id === ''`. Done in `receivedPostsInChannel`, `receivedPostsBefore`, `receivedPostsAfter` in `mattermost-redux/src/actions/posts.ts`.

**UI** — The post list derives `atLatestPost = Boolean(chunk.recent)` and `atOldestPost = Boolean(chunk.oldest)` (`post_list/index.tsx`). If `!atOldestPost` it can show “Load older messages”; if `!atLatestPost` it can show “Load newer messages”. Scroll handlers in `post_list.tsx` and `post_list_virtualized.tsx` use these props to trigger loading.

---

## 6. Summary

- **Storage** — Per channel: array of blocks in memory; one block = one (possibly merged) contiguous slice of the timeline.
- **Pagination** — Each “get posts” (latest, before, after, unread, around) adds or updates blocks; `recent` and `oldest` come from API `next_post_id` / `prev_post_id`.
- **New posts** — Only the block with `recent: true` receives new posts (WebSocket or create).
- **Deletes/removes** — Post ids are removed from every block's `order`; empty blocks are dropped except the recent block.
- **UI** — Picks one block (recent, around post, or around unread time), renders its `order`, and uses `recent` / `oldest` for “at top” / “at bottom”.
- **Maintenance** — Merging keeps blocks non-overlapping; cleanup keeps the recent block even when empty.

In short: a **post block** is the frontend's representation of a contiguous, ordered slice of the channel timeline and whether that slice is at the latest messages (`recent`), at the oldest loaded messages (`oldest`), or in between.
