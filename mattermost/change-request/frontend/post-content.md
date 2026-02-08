# Post body: content structure and related items

This document describes how post content is structured in Mattermost (server and frontend), what a post can contain (rich text, files, images, reactions, etc.), and how to fetch post-related data via the API.

---

## What a post contains

A post in Mattermost is not only the visible message text. It can include:

**Core fields (always on the post):**
- **message** — The main text of the post (Markdown-supported). This is the “rich text” body. Stored and returned as a string; the frontend renders it via `PostMarkdown` (which uses the markdown component and supports mentions, links, images in text, etc.).
- **message_source** — Optional. When the server rewrites image URLs (e.g. image proxy), this holds the original message as submitted; the frontend uses it to populate edit boxes.
- **type** — Post type (e.g. `''`, `system_add_remove`, `reminder`, `burn_on_read`, etc.). Affects how the body is rendered (e.g. system messages, reminder text).
- **props** — Arbitrary key-value data. Used for integrations: **attachments** (incoming webhook / app message attachments), **app_bindings**, and other plugin/App Framework data.
- **file_ids** — List of file IDs attached to the post. Legacy **filenames** is deprecated.
- **root_id**, **original_id** — Thread and edit lineage.

**Related content (in metadata):**

The server attaches a **metadata** object to the post when preparing it for the client. That object holds:

- **metadata.files** — List of `FileInfo` for attachments (name, size, mime_type, dimensions, etc.). Populated from `file_ids` when the post is prepared for the client.
- **metadata.embeds** — List of `PostEmbed` describing embedded content: **image** (plain image URL in message), **opengraph** (link preview), **message_attachment** (from props.attachments), **permalink** (link to another post), **link**, **boards**.
- **metadata.images** — Map from image URL to dimensions (width, height, format, frameCount). Used for images in the message, in embeds, and in OpenGraph. Does not include file-attachment images (those are in `metadata.files`).
- **metadata.reactions** — List of `Reaction` (user_id, emoji_name, etc.) for this post.
- **metadata.emojis** — Custom emojis used in the post or in its reactions.
- **metadata.priority** — Optional post priority (e.g. urgent) and related flags.
- **metadata.acknowledgements** — User acknowledgements for the post.
- **metadata.translations** — Optional translations keyed by language code.
- **metadata.expire_at** — For burn-on-read posts.
- **metadata.recipients** — For certain post types.

So in practice:
- **Rich text** = `post.message` (and optionally `post.message_source` for editing).
- **List of files** = `post.metadata.files` (and `post.file_ids` as IDs).
- **Images** = inline/linked images come from `metadata.embeds` (type `image`) and `metadata.images` (dimensions); attached images are in `metadata.files`.
- **Reactions** = `post.metadata.reactions`.
- **Other related items** = embeds (OpenGraph, permalinks, message attachments), emojis, priority, acknowledgements, translations, etc., all in `metadata`.

---

## Rich text and supported Markdown

The post **message** is stored as plain text. Rich text is achieved by (1) Markdown parsing and (2) Mattermost-specific autolinking and mentions. The frontend renders it in `PostMessageView` → `PostMarkdown` → `Markdown`, which calls `formatText`. That pipeline uses the **marked** library for Markdown and then applies token-based formatting (mentions, hashtags, etc.).

**Markdown engine:** The app uses **marked** with:
- **GFM** (GitHub Flavored Markdown) enabled: fenced code blocks, strikethrough, autolinking, task lists, etc.
- **Tables** enabled.
- **Sanitization** enabled for safe HTML output.
- Optional **inline LaTeX** when server config has `EnableLatex` and `EnableInlineLatex` set to true (code blocks with language `tex` or `latex` are rendered as LaTeX).

**Standard Markdown supported in the message:**

- **Bold:** `**text**` or `__text__`
- **Italic:** `*text*` or `_text_`
- **Strikethrough:** `~~text~~`
- **Inline code:** `` `code` ``
- **Fenced code blocks:** ` ``` ` on its own line, optional language (e.g. ` ```javascript `), then code, then ` ``` `. Multiline selection in the editor gets wrapped with ` ```\n ` and ` \n``` `.
- **Links:** `[link text](url)` (toolbar also inserts this form)
- **Images:** `![alt text](image_url)` — rendered inline; image URLs can be proxied via server config; dimensions come from `metadata.images`.
- **Headings:** ATX-style (e.g. `### Heading`). The formatting toolbar uses `### ` for the “heading” action.
- **Block quote:** `> quoted line`
- **Unordered lists:** `- item` or `* item` (toolbar uses `- `)
- **Ordered lists:** `1. item`, `2. item`, …
- **Tables:** GFM table syntax (e.g. `| col1 | col2 |` with header separator)
- **Line breaks:** Newlines are preserved; in the HTML path, `<p>` tags and newlines are handled so that line breaks and code blocks display correctly.

So the message supports classic Markdown plus GFM (tables, strikethrough, fenced code, etc.) and optional LaTeX in code blocks.

**Mattermost-specific “rich text” (beyond plain Markdown):**

- **@mentions:** `@username` and group mentions (e.g. `@all`, `@channel`) are detected and turned into links/spans with `data-mention` (and optional highlighting for the current user). Handled in `formatText` via `atMentions` and related options.
- **Channel mentions:** `~channelname` is linked to the channel using `channelNamesMap` and team context.
- **Hashtags:** Words matching the hashtag pattern (configurable minimum length, default 3) are autolinked to search. Handled by `autolinkHashtags`.
- **Autolinked URLs:** URLs with schemes allowed by server config (e.g. `https://`) are turned into clickable links. Controlled by `getAutolinkedUrlSchemes` and a URL filter in the markdown options.
- **Autolinked emails:** Email addresses in the text are linked.
- **Emoticons and emoji:** Text emoticons (e.g. `:D`, `:)`) can be rendered as emoji when `emoticons` and `renderEmoticonsAsEmoji` are enabled. Custom emoji syntax `:shortcode:` (e.g. `:smile:`, `:sheep:`) is replaced with the corresponding emoji image or character. Unicode emoji in the message are also handled. Emoji data comes from the emoji map and post metadata.
- **Search highlighting:** When viewing search results, the search term or phrase can be highlighted in the message via `searchTerm` / `searchMatches` / `searchPatterns` in the formatting options.
- **Unsafe links:** If the post has `props.unsafe_links`, links can be treated as unsafe and opened with appropriate warnings.

Formatting can be disabled per render: if `enableFormatting` is false (or the markdown option is disabled), the message is shown as plain text with no Markdown or mention parsing. System and reminder post types often bypass the standard Markdown path and use dedicated renderers (e.g. `renderSystemMessage`, `renderReminderSystemBotMessage`).

**Editor toolbar (formatting bar):** The desktop UI offers quick-insert for: bold, italic, strikethrough, link, inline code, code block (multiline), heading (`### `), block quote, unordered list (`- `), ordered list (`1. `). These map to the same Markdown syntax above; the implementation lives in `apply_markdown.ts` (e.g. `applyBoldMarkdown`, `applyCodeMarkdown`, `applyLinkMarkdown`) and the formatting bar / key handlers in the advanced text editor.

**Relevant code:** `webapp/channels/src/utils/text_formatting.tsx` (`formatText`, `doFormatText`, `TextFormattingOptions`), `webapp/channels/src/utils/markdown/index.ts` (marked with GFM and tables), `webapp/channels/src/utils/markdown/renderer.tsx` (code blocks, images, etc.), `webapp/channels/src/utils/markdown/apply_markdown.ts` (toolbar markdown modes), `webapp/channels/src/components/help/messaging.tsx` (user-facing formatting examples).

---

## Server model (reference)

**Post** (`server/public/model/post.go`):
- Message, MessageSource, Type, Props, Hashtags, FileIds, Filenames (deprecated)
- Metadata *PostMetadata

**PostMetadata** (`server/public/model/post_metadata.go`):
- Embeds, Emojis, Files, Images, Reactions, Priority, Acknowledgements, Translations, ExpireAt, Recipients

**PostEmbed** (`server/public/model/post_embed.go`):
- Type: image | link | message_attachment | opengraph | permalink | boards
- URL, Data (e.g. OpenGraph or permalink preview data)

**FileInfo** (`server/public/model/file_info.go`):
- Id, CreatorId, PostId, ChannelId, CreateAt, UpdateAt, DeleteAt, Name, Extension, Size, MimeType, Width, Height, HasPreviewImage, etc.

**Reaction** (`server/public/model/reaction.go`):
- UserId, PostId, EmojiName, CreateAt, UpdateAt, DeleteAt, ChannelId

When the API returns a post (e.g. get post, get post thread, get posts for channel), the server calls **PreparePostForClient** or **PreparePostForClientWithEmbedsAndImages**. The latter fills metadata with files, reactions, emojis, embeds, and image dimensions so the client gets a fully populated post.

---

## How metadata is stored (server model and database)

**Metadata is not stored on the post in the database.** In the server’s Go model, `Post.Metadata` is documented as “Transient data populated before sending a post to the client.” The **posts** table has no `metadata` column. When the store loads a post, it only fills the persisted columns (id, channelid, createat, message, type, props, fileids, hasreactions, etc.). The `Metadata` field is left nil and is filled later in the app layer when preparing the response.

**Where the underlying data lives:**

- **metadata.files** — Not stored on the post. File attachments are stored in the **fileinfo** table (id, creatorid, postid, channelid, createat, updateat, deleteat, name, extension, size, mimetype, width, height, haspreviewimage, etc.). The post only stores **file_ids** (in `posts.fileids`). When preparing the post for the client, the app calls `getFileMetadataForPost`, which loads `FileInfo` rows by the post’s `FileIds` and assigns the result to `post.Metadata.Files`.

- **metadata.reactions** — Not stored on the post. Reactions are in the **reactions** table (userid, postid, emojiname, createat, updateat, deleteat, channelid). The post has a boolean **hasreactions** on the posts table for quick filtering. The app loads reactions via `GetReactionsForPost(post.Id)` and assigns them to `post.Metadata.Reactions` inside `getEmojisAndReactionsForPost`, which is called from `PreparePostForClient`.

- **metadata.emojis** — Custom emojis used in the message or in reactions. They come from the **emoji** table. The app derives the set from the post message and reaction emoji names and attaches it to `post.Metadata.Emojis`.

- **metadata.embeds** and **metadata.images** — Not stored on the post. Built at response time from the post’s **message** and optional **linkmetadata** (and other caches). The app parses URLs from the message, fetches or uses cached OpenGraph/image/permalink data, and fills `post.Metadata.Embeds` and `post.Metadata.Images` in `getEmbedsAndImages`, which is called from `PreparePostForClientWithEmbedsAndImages`.

- **metadata.priority** — Stored in **postspriority** (postid, channelid, priority, requestedack, persistentnotifications). The app loads it with `GetPriorityForPost(post.Id)` when `IncludePriority` is set and assigns it to `post.Metadata.Priority`.

- **metadata.acknowledgements** — Stored in **postacknowledgements** (postid, userid, acknowledgedat, optional remoteid/channelid). The app loads it with `GetAcknowledgementsForPost(post.Id)` and assigns it to `post.Metadata.Acknowledgements`.

- **metadata.translations** — Cached in the **translations** table (objectId, objectType, dstLang, state, etc.). Populated for post lists in `populatePostListTranslations` (and similarly for single-post flows when applicable).

- **metadata.expire_at** — For burn-on-read posts, this can come from **temporaryposts** (postid, type, expireat) or the reveal flow; it is set when preparing the post for the client.

So in summary: the **posts** table holds only the core post row (including `fileids` and `hasreactions`). All other metadata is either in separate tables (fileinfo, reactions, emoji, postspriority, postacknowledgements, linkmetadata, translations, temporaryposts) or computed from the message. The app layer (e.g. `post_metadata.go`: `PreparePostForClient`, `PreparePostForClientWithEmbedsAndImages`, `getFileMetadataForPost`, `getEmojisAndReactionsForPost`, `getEmbedsAndImages`) assembles these into `Post.Metadata` right before sending the API response. Nothing in the database is named “post metadata” as a single blob; it’s a view built from multiple sources.

---

## Mapping from server data to frontend model

The API returns JSON. The server serializes the Go structs using `encoding/json` and the struct tags (e.g. `json:"create_at"`). So the response uses **snake_case** keys. The frontend TypeScript types in `webapp/platform/types/src/posts.ts` (and related types for `FileInfo`, `Reaction`, etc.) use the same **snake_case** property names. There is no separate “mapping” layer: the client parses the JSON and types it as `Post`; the shape matches.

**Concrete mapping:**

- **Post:** Server fields like `Id`, `CreateAt`, `Message`, `FileIds`, `Metadata` are serialized as `id`, `create_at`, `message`, `file_ids`, `metadata`. The frontend `Post` type uses `id`, `create_at`, `message`, `file_ids`, `metadata`. Same for other post fields (`user_id`, `channel_id`, `root_id`, `reply_count`, `last_reply_at`, `participants`, `is_following`, `message_source`, etc.).

- **PostMetadata:** Server `Embeds`, `Emojis`, `Files`, `Images`, `Reactions`, `Priority`, `Acknowledgements`, `Translations`, `ExpireAt`, `Recipients` become `embeds`, `emojis`, `files`, `images`, `reactions`, `priority`, `acknowledgements`, `translations`, `expire_at`, `recipients` in JSON. The frontend `PostMetadata` type uses those same keys.

- **FileInfo:** Server uses `CreatorId` with tag `json:"user_id"`, so the client sees `user_id`. Fields like `Path`, `ThumbnailPath`, `PreviewPath`, `Content` have `json:"-"` and are **omitted** from the API response; the frontend type does not include them. The frontend `FileInfo` type (`webapp/platform/types/src/files.ts`) has `user_id`, `post_id`, `channel_id`, `create_at`, `name`, `mime_type`, `size`, etc., matching the JSON that is actually sent.

- **Reaction:** Server fields `UserId`, `PostId`, `EmojiName`, `CreateAt`, etc. are serialized as `user_id`, `post_id`, `emoji_name`, `create_at`. Frontend `Reaction` type uses the same names.

- **PostEmbed / PostImage / PostPriority / PostAcknowledgement / PostTranslation:** Same idea: server json tags use snake_case (e.g. `frame_count`, `requested_ack`, `persistent_notifications`, `acknowledged_at`), and the frontend types mirror that.

So the mapping from server to frontend is: **same JSON shape and key names**. The frontend does not transform the response; it expects the API contract and types it accordingly. The only “differences” are (1) server-only fields that are omitted via `json:"-"` (e.g. file paths, internal IDs) and (2) optional/omitempty fields that may be absent in JSON and are optional in the frontend types.

---

## Frontend rendering

- **Message text:** `PostMessageView` → `PostMarkdown` with `post.message`. System/reminder types are rendered by system message helpers instead of raw markdown.
- **Embeds (images, OpenGraph, attachments, permalinks):** `MessageWithAdditionalContent` wraps the message in `PostBodyAdditionalContent`, which reads `metadata.embeds`, picks the first embed (or app bindings from props), and renders:
  - **image** → `PostImage` (uses `metadata.images[embed.url]` for dimensions).
  - **message_attachment** → `MessageAttachmentList` from `post.props.attachments` and `metadata.images`.
  - **opengraph** → `PostAttachmentOpenGraph` or YouTube component.
  - **permalink** → `PostMessagePreview` (embed.data has post_id, etc.).
- **File attachments:** Rendered below the message in `PostComponent` via `FileAttachmentListContainer`, which uses either `post.metadata.files` or Redux file state keyed by `post.file_ids` (see `makeGetFilesForPost` / `getFilesForPost`).
- **Reactions:** Rendered in the post footer from `post.metadata.reactions` (or Redux reactions state).

So: rich text from `message`; files from `metadata.files` / `file_ids`; images from `metadata.embeds` + `metadata.images`; reactions from `metadata.reactions`; other related UI from the rest of `metadata` and `props`.

---

## APIs to fetch post and related items

Base path: **`/api/v4`** (e.g. `GET https://your-server/api/v4/...`). All listed endpoints require an authenticated session (session-based or token in header).

**Get a single post (includes metadata: files, reactions, embeds, images, etc.):**
- **GET** `/api/v4/posts/{post_id}`
- Query: `include_deleted=true` (optional, needs manage system); `retain_content=true` (optional).
- Response: One `Post` with `metadata` populated (files, reactions, emojis, embeds, images, priority, acknowledgements when applicable). This is the main way to get “post content” and related items in one call.

**Get file infos for a post (when you only need attachments):**
- **GET** `/api/v4/posts/{post_id}/files/info`
- Query: `include_deleted=true` (optional, needs manage system).
- Response: Array of `FileInfo`. Useful if you already have the post but need to refresh or fetch file list separately.

**Get reactions for a post:**
- **GET** `/api/v4/posts/{post_id}/reactions`
- Response: Array of `Reaction`. Also included in the post’s `metadata.reactions` when you GET the post.

**Get post thread (root + replies, all with metadata):**
- **GET** `/api/v4/posts/{post_id}/thread`
- Query: `skipFetchThreads`, `collapsedThreads`, `collapsedThreadsExtended`, `direction`, `perPage`, etc.
- Response: `PostList` (posts + order). Each post is prepared for client with metadata.

**Get multiple posts by IDs:**
- **POST** `/api/v4/posts/ids`
- Body: JSON array of post IDs (e.g. `["id1","id2"]`). Max 1000 IDs.
- Response: `PostList`. Posts are prepared for client with metadata.

**Get post info (channel/team context for permalinks, etc.):**
- **GET** `/api/v4/posts/{post_id}/info`
- Response: Channel and team info, join status, etc. (not the full post body again).

**Get edit history for a post:**
- **GET** `/api/v4/posts/{post_id}/edit_history`
- Response: Edit history entries. Useful for “content over time” but not for current body structure.

**Channel posts (for timeline):**
- **GET** `/api/v4/channels/{channel_id}/posts` — page of posts (with query params for pagination and thread options).
- **GET** `/api/v4/channels/{channel_id}/posts/unread` — around last unread.
- **GET** `/api/v4/channels/{channel_id}/posts/before/{post_id}` and `.../after/{post_id}` — pagination.

All of these that return posts run them through **PreparePostForClient** or **PreparePostForClientWithEmbedsAndImages**, so you get `message`, `message_source`, `props`, `file_ids`, and a populated `metadata` (files, reactions, embeds, images, emojis, priority, acknowledgements, etc.) in a single response. For most use cases, **GET /api/v4/posts/{post_id}** is enough to obtain the full post body and all related items (rich text, list of files, images, reactions, and other metadata).
