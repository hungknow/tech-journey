# Posts Model in Redux

This document describes how posts are stored in memory in the Redux store (data structure and update behavior) and how backend APIs and WebSocket events change that model.

**Key paths:** `webapp/channels/src/packages/mattermost-redux/src/reducers/entities/posts.ts`, `actions/posts.ts`, `webapp/platform/types/src/posts.ts`.

---

## 1. Data structure: how posts are stored in memory

The posts slice lives under `state.entities.posts`. All post-related state is normalized: each post object exists once and is referenced by id elsewhere.

- **posts**
  - Map of post id → post. Every post entity lives here once.

- **postsReplies**
  - Reply count per root post (and for the root post itself).

- **postsInChannel**
  - Per channel, an array of “blocks.” Each block has an ordered list of post ids (newest first) and flags like `recent` and `oldest`. This is the channel timeline order; blocks are merged when they overlap.

- **postsInThread**
  - Per root post id, an array of reply post ids (order not guaranteed).

- **pendingPostIds**
  - Ids of posts currently being sent (e.g. optimistically created).

- **postEditHistory**
  - List of post versions for the edit-history UI.

- **currentFocusedPostId**
  - Post id for the permalink / focused post view.

- **reactions**
  - Per post, a map of reaction key (e.g. userId-emojiName) to reaction.

- **openGraph**
  - Per post, link preview metadata by URL.

- **messagesHistory**
  - Recent message text and index for “previous message” navigation.

- **acknowledgements**
  - Per post, which users acknowledged and when.

- **limitedViews**
  - For cloud message limits: per channel or thread, the time of the first inaccessible post.

Posts are stored once in `posts` and referenced by id from `postsInChannel` and `postsInThread`. Channel order is maintained as blocks that can be merged when they overlap.

---

## 2. How the store is updated (merge, delete, remove)

**Merge one post**
  - One post is added or updated in `posts` using an update rule: if the stored post is newer (by `update_at`), it is kept; if same `update_at` and same CRT/metadata, skip; otherwise overwrite. Permalink embeds with nested posts are merged recursively (with a depth limit). Deleted posts (`delete_at > 0`) update the stored post to deleted state. If the incoming post has a `pending_post_id` different from its id, the pending post is removed from `posts` and the real id is used. For replies, the root’s `participants` and `reply_count` may be updated.
  - Channel order (`postsInChannel`) is updated only when this merge is replacing a pending post id in the recent block. So merging one existing fetched post updates only `posts`, not the channel list.

**Merge many posts**
  - Many posts are merged into `posts` (and into postsReplies, reactions, openGraph, acknowledgements). Optionally, channel order is updated by adding or merging a block for a channel (e.g. a new “page” of ids), or thread order by adding reply ids to `postsInThread[rootId]`. Blocks are deduped and sorted by `create_at` (newest first).

**Soft delete**
  - The post stays in `posts` but is marked deleted (message cleared, etc.; burn-on-read posts are removed entirely). Its id and reply ids are removed from `postsInChannel` and `postsInThread`, and permalink embeds pointing to it are cleaned. Used when showing “Message deleted.”

**Hard remove**
  - The post and its replies are removed from `posts`, and their ids are removed from `postsInChannel` and `postsInThread`. Used when the current user deletes or when a failed pending post is discarded.

**Other updates**
  - Pinned flag and last update time can be updated for a post. Focused (permalink) post id can be set. Edit history list can be set. Reactions and acknowledgements can be added or removed per post. Burn-on-read metadata (e.g. expire_at, recipients) can be updated. Channel order can be cleared (e.g. when toggling CRT), then the list is reloaded by refetching. Leaving a channel or team clears that channel’s posts from the store; logout clears the whole posts slice; following a thread updates the root post’s `is_following` in the store.

---

## 3. Backend API → changes in the model

Which backend API leads to which changes in the Redux posts model. Base URL is `/api/v4`.

**GET /api/v4/posts/{post_id}**
  - **Trigger:** `getPost(postId)`.
  - **Model change:** Merge the single post into `posts`. No change to channel or thread order.

**POST /api/v4/posts** (create post)
  - **Trigger:** `createPost(post, files)`.
  - **Model change:** A pending post is first added to `posts` and to the channel’s recent block (and pendingPostIds). After the API returns, that entry is replaced by the created post in `posts` and channel order. On failure, the pending post is either removed (hard remove) or kept as failed in `posts`.

**PUT /api/v4/posts/{post_id}/patch** (edit post)
  - **Trigger:** `editPost(post)`.
  - **Model change:** The post in `posts` is updated with the API response (same id).

**DELETE /api/v4/posts/{post_id}**
  - **Trigger:** `deletePost(post)`.
  - **Model change:** Soft delete is applied immediately (post marked deleted, id removed from channel/thread order). The API call runs in the background.

**POST /api/v4/posts/{post_id}/pin** / **POST /api/v4/posts/{post_id}/unpin**
  - **Trigger:** `pinPost(postId)` / `unpinPost(postId)`.
  - **Model change:** The post’s pinned flag and last update time are updated in `posts`; channel pinned count is updated elsewhere.

**GET /api/v4/channels/{channel_id}/posts** (with page, since, before, or after)
  - **Trigger:** `getPosts`, `getPostsSince`, `getPostsBefore`, `getPostsAfter` (and `getPostsAround` uses before + after + thread).
  - **Model change:** All returned posts are merged into `posts`. Channel order is updated: a new block is added (or merged) for that channel with the returned order (newest first).

**GET /api/v4/users/{user_id}/channels/{channel_id}/posts/unread**
  - **Trigger:** `getPostsUnread`.
  - **Model change:** Same as channel posts: merge into `posts` and update `postsInChannel` for that channel. If “start from newest” is used, a second fetch merges more posts the same way.

**GET /api/v4/posts/{post_id}/thread**
  - **Trigger:** `getPostThread`, `getNewestPostThread`, and from `getPostsAround` (with getPostsAfter/getPostsBefore).
  - **Model change:** All returned posts are merged into `posts`. Reply ids are added to `postsInThread[rootId]`. Thread fetches can also be triggered when a new reply arrives via WebSocket and the root post is missing.

**POST /api/v4/posts/ids** (body: array of post ids)
  - **Trigger:** `getPostsByIds(ids)`.
  - **Model change:** Returned posts are merged into `posts` only. No change to channel or thread order.

**GET /api/v4/posts/{post_id}/edit_history**
  - **Trigger:** `getPostEditHistory(postId)`.
  - **Model change:** `postEditHistory` is set to the list of post versions.

**POST /api/v4/reactions** (add) / **DELETE /api/v4/users/{user_id}/posts/{post_id}/reactions/{emoji_name}** (remove)
  - **Trigger:** `addReaction(postId, emojiName)` / `removeReaction(postId, emojiName)`.
  - **Model change:** One reaction is added or removed for that post in `reactions`.

**POST /api/v4/users/{user_id}/posts/{post_id}/ack** / **DELETE .../ack**
  - **Trigger:** `acknowledgePost(postId)` / `unacknowledgePost(postId)`.
  - **Model change:** One acknowledgement is added or removed for that post in `acknowledgements`.

**GET /api/v4/posts/{post_id}/reveal** (burn-on-read reveal)
  - **Trigger:** Reveal burn-on-read flow (client fetches revealed content).
  - **Model change:** Post metadata (e.g. expire_at) and optionally content are updated in `posts` for that post.

**DELETE /api/v4/posts/{post_id}/burn** (burn-on-read burn now)
  - **Trigger:** Burn-on-read “burn now” flow; after API returns, client updates state.
  - **Model change:** Post is hard-removed from `posts` and from channel/thread order.

---

## 4. WebSocket events → changes in the model

Which WebSocket event leads to which changes in the Redux posts model.

**posted** / **ephemeral_message**
  - **Handler:** `handleNewPostEvent` → `handleNewPost` → `completePostReceive`.
  - **Model change:** New post is merged into `posts` and added to the channel’s recent block and to `postsInThread` if it’s a reply; it can be added to pendingPostIds. If the post is a reply and the root is missing, a thread fetch may run and merge the root and replies. Batched new posts merge multiple posts the same way, then may trigger thread fetches.

**post_edited**
  - **Handler:** `handlePostEditEvent`.
  - **Model change:** The post in `posts` is updated with the payload (same id).

**post_deleted**
  - **Handler:** `handlePostDeleteEvent`.
  - **Model change:** Soft delete: post marked deleted in `posts`, id and reply ids removed from channel and thread order. If CRT is on and a reply was deleted, the thread may be refetched and the root post updated in `posts`.

**burn_on_read_post_revealed**
  - **Handler:** `handleBurnOnReadPostRevealed`.
  - **Model change:** For the author: recipients list in post metadata is updated. For the recipient: post in `posts` is updated with revealed content and expire_at.

**burn_on_read_post_burned**
  - **Handler:** `handlePostExpired` (via websocket_actions).
  - **Model change:** Post is hard-removed from `posts` and from channel/thread order.

**burn_on_read_all_revealed**
  - **Handler:** `handleBurnOnReadAllRevealed`.
  - **Model change:** Sender’s expire time is set in that post’s metadata in `posts`.

**Note:** The frontend does not wait for the server to send a WebSocket event to update the store after a user action. For example, delete updates the model immediately (soft delete) and then calls the delete API in the background; create adds a pending post to the store first, then replaces it with the server post on success.

---

## 5. Reducer helpers (how blocks and order are maintained)

- **mergePostBlocks**
  - Sorts blocks by recency, merges overlapping adjacent blocks, dedupes and sorts by `create_at`.

- **mergePostOrder**
  - Concatenates two id arrays without duplicates and sorts by `create_at` (newest first).

- **removeNonRecentEmptyPostBlocks**
  - Drops empty blocks except the one marked recent.

- **removePostsAndEmbedsForChannels**
  - Removes all posts in the given channels and any permalink embeds pointing into them (used on leave channel/team).
