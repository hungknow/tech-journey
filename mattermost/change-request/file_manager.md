# Mattermost File Manager: Flows, APIs, and Data Models

This document describes all file-related flows (upload, fetch, file management), server APIs, and data models on both server and frontend. It also explains how large files are uploaded, how files are processed after upload, and how they are stored.

---

## 1. Overview of File Flows

**Upload:** Files can be uploaded in two ways. The primary flow used by the web app is a single POST to `/api/v4/files` with either multipart form data (channel_id, client_ids, files) or a simple body (file in body, channel_id and filename in query). For large files or resumable uploads, the server supports a resumable flow: create an upload session with POST `/api/v4/uploads`, then send file data in chunks with POST `/api/v4/uploads/{upload_id}` until complete.

**Fetch:** Files are fetched by file ID. The server exposes: get file content (with optional download), thumbnail, preview, file metadata (info), and a public link (when enabled). File metadata for a post is returned by GET posts/{post_id}/files/info. File search is available per team or across all teams.

**File management:** Files are associated with a channel and optionally a post. Metadata is stored in the database (FileInfo); the binary is stored in the configured file backend (local filesystem or S3). There is no dedicated “file management” API (e.g. list/delete file by id); file lifecycle is tied to posts and channel context (e.g. attach to post, delete with post, search).

---

## 2. Server API

All routes below are relative to the API root (e.g. `/api/v4`). Session is required unless noted.

**Upload (standard – used by web app)**

- **POST /files**  
  Upload one or more files.  
  **Request:** Either `multipart/form-data` with `channel_id`, optional `client_ids`, and `files` (one or more files), or simple POST with file in body and query params `channel_id`, `filename`. Optional query `bookmark=true` for channel bookmark uploads.  
  **Response:** 201, JSON `FileUploadResponse` (`file_infos`, `client_ids`).

**Resumable upload (large files)**

- **POST /uploads**  
  Create an upload session.  
  **Request:** JSON body `UploadSession`: `type` ("attachment" or "import"), `channel_id` (for attachment), `filename`, `file_size`.  
  **Response:** 201, JSON `UploadSession` (includes `id`, `file_offset`, etc.).

- **GET /uploads/{upload_id}**  
  Get upload session status (e.g. current `file_offset` for resume).  
  **Response:** 200, JSON `UploadSession`.

- **POST /uploads/{upload_id}**  
  Upload a chunk of file data.  
  **Request:** Either raw body (binary) or `multipart/form-data` with one part as file data. Content length must not exceed remaining bytes (`file_size - file_offset`).  
  **Response:** 204 if upload incomplete; 200 with JSON `FileInfo` when upload is complete and file is processed.

**Fetch file**

- **GET /files/{file_id}**  
  Get file content (stream).  
  **Query:** `download=1` to force download; `as_content_reviewer=1` and `flagged_post_id` for content reviewer; session or trust requester.  
  **Response:** 200, file stream with appropriate Content-Type/Content-Disposition.

- **GET /files/{file_id}/thumbnail**  
  Get image thumbnail (120×100 JPEG).  
  **Response:** 200, image stream or 400 if no thumbnail.

- **GET /files/{file_id}/preview**  
  Get image preview (resized, e.g. max 1920px).  
  **Response:** 200, image stream or 400 if no preview.

- **GET /files/{file_id}/info**  
  Get file metadata only.  
  **Response:** 200, JSON `FileInfo` (no Path/ThumbnailPath/PreviewPath/Content).

- **GET /files/{file_id}/link**  
  Get a public link (if enabled).  
  **Response:** 200, JSON `{ "link": "<url>" }`.

**Public file (no auth)**

- **GET /files/{file_id}/public?h={hash}**  
  Get file by public link. Hash is generated server-side from file id and salt.  
  **Response:** 200, file stream, or 4xx if disabled/invalid.

**File metadata by post**

- **GET /posts/{post_id}/files/info**  
  Get file infos for a post.  
  **Query:** `include_deleted=true` to include deleted (admin).  
  **Response:** 200, JSON array of `FileInfo`.

**Search**

- **POST /teams/{team_id}/files/search**  
  Search files in a team.  
  **Request:** JSON `SearchParameter` (e.g. `terms`, `is_or_search`, `page`, `per_page`, `time_zone_offset`, `include_deleted_channels`).  
  **Response:** 200, JSON `FileInfoSearchResults` (file list + matches).

- **POST /files/search**  
  Search files across all teams. Same request/response shape.

---

## 3. Server Data Models

**FileInfo (model.FileInfo)**  
Core metadata for one file. Stored in DB; path fields and content not sent to client.

- **Id** – unique file id  
- **CreatorId** – user id (or "nouser", or bookmark constant)  
- **PostId** – optional; set when attached to a post  
- **ChannelId** – channel (denormalized from post/origin)  
- **CreateAt, UpdateAt, DeleteAt** – timestamps  
- **Path** – backend path to file (not in JSON to client)  
- **ThumbnailPath, PreviewPath** – backend paths (not in JSON to client)  
- **Name, Extension, Size, MimeType**  
- **Width, Height** – for images  
- **HasPreviewImage** – whether preview image exists  
- **MiniPreview** – small inline preview bytes (optional)  
- **Content** – extracted text for search (not in JSON to client)  
- **RemoteId** – for shared channels  
- **Archived** – e.g. content made inaccessible

**UploadSession (model.UploadSession)**  
Used only for resumable uploads.

- **Id** – upload session id  
- **Type** – "attachment" or "import"  
- **CreateAt, UserId, ChannelId** (for attachment), **Filename**  
- **Path** – backend path where data is written  
- **FileSize** – total size; **FileOffset** – bytes received so far  
- **RemoteId, ReqFileId** – for shared channels

**FileUploadResponse (model.FileUploadResponse)**  
Returned by standard upload API.

- **FileInfos** – slice of created `FileInfo`  
- **ClientIds** – client-provided ids, aligned with FileInfos

**Storage path structure (backend)**  
Backend (local or S3) uses a path prefix under the configured root:

- **Standard upload (UploadFileX):**  
  `{YYYYMMDD}/teams/{teamId}/channels/{channelId}/users/{userId}/{fileInfoId}/{filename}`  
  For bookmarks: `bookmark/teams/.../channels/.../{fileInfoId}/{filename}`  
  Images add same-dir files: `{nameWithoutExt}_preview.{ext}`, `{nameWithoutExt}_thumb.{ext}`.

- **Resumable upload (CreateUploadSession):**  
  Attachment: `{YYYYMMDD}/teams/noteam/channels/{channelId}/users/{userId}/{uploadSessionId}/{filename}`  
  Import: `{ImportSettings.Directory}/{uploadSessionId}_{filename}` (incomplete: same + `.tmp`).

---

## 4. Frontend Data Model

**FileInfo (webapp/platform/types/src/files.ts)**  
Matches server FileInfo for the fields exposed to the client (snake_case in JSON).

- **id, user_id, channel_id, create_at, update_at, delete_at**  
- **name, extension, size, mime_type**  
- **width, height, has_preview_image**  
- **clientId** – added on client after upload to match file to UI (not from server)  
- **post_id** – when attached to a post  
- **mini_preview** – optional  
- **archived, link** – optional

**File list by post**  
Redux keeps `fileIdsByPostId` and `files` (id → FileInfo). File infos for a post come from GET `/posts/{post_id}/files/info` and are normalized into these structures.

**URLs (mattermost-redux)**  
- File content: `Client4.getFileRoute(fileId)` → `/api/v4/files/{file_id}`  
- Download: same + `?download=1`  
- Thumbnail: `.../files/{file_id}/thumbnail`  
- Preview: `.../files/{file_id}/preview`  
- File info: `.../files/{file_id}/info`  
- Public link: `.../files/{file_id}/link`

---

## 5. How Upload Works

**Standard upload (web app)**  
- User selects files; frontend uses `uploadFile` in `file_actions.ts`.  
- **POST /files** with FormData: `channel_id`, `client_ids` (one per file), `files` (file, name).  
- Server: `uploadFileStream` → if multipart, `uploadFileMultipart`; else `uploadFileSimple`. Both end up calling `App.UploadFileX` with channel, filename, and reader.  
- **UploadFileX:** Validates size vs `FileSettings.MaxFileSize`, builds FileInfo and path, optionally preprocesses image (dimensions, orientation, preview/thumb paths), streams to backend via `WriteFile`, runs plugin hook `FileWillBeUploaded`, then for images runs postprocess (write thumbnail and preview), saves FileInfo to DB, and optionally kicks off content extraction.  
- Response: `FileUploadResponse` with `file_infos` and `client_ids`; frontend maps them and updates Redux (e.g. RECEIVED_UPLOAD_FILES, UPLOAD_FILES_SUCCESS).

**Resumable upload (large files)**  
- Client first **POST /uploads** with `UploadSession` (type, channel_id, filename, file_size). Server creates session, sets Path, stores session (FileOffset = 0).  
- Client then **POST /uploads/{upload_id}** one or more times with body = next chunk. Server uses `UploadData`: same-session lock, LimitedReader to (FileSize - FileOffset), then either `WriteFile` (first chunk) or `AppendFile` (resume). First chunk must be at least 5MB unless file is smaller than that.  
- After each chunk, server updates session’s FileOffset in DB. When FileOffset == FileSize: reads file, builds FileInfo, runs plugin hook, generates thumbnail/preview for images, saves FileInfo, optionally runs content extraction (async), deletes upload session, returns FileInfo.  
- So: large file is split into chunks by the client; server appends to one path per session; file is processed only after the full file is received.

---

## 6. How Files Are Processed After Upload

Processing happens on the server after the file is fully written (standard upload after stream write; resumable after last chunk).

**Images (non-SVG)**  
- **Preprocess (during stream):** Decode config for dimensions, check max resolution, set PreviewPath/ThumbnailPath, detect orientation (EXIF), handle animated GIF (no preview, decode once).  
- **Postprocess (after write):** Decode image, apply orientation, then generate and write: thumbnail (120×100), preview (max 1920px), and optionally mini preview. All written to the same path prefix as the main file.  
- SVG: dimensions parsed if possible; no thumbnail/preview generation.

**Plugins**  
- Hook `FileWillBeUploaded` is run with file reader and a writer. Plugins can transform or reject the upload. If they write content, it is written to a temp path then moved to the final path (so plugin can modify the stored file).

**Content extraction**  
- If `FileSettings.ExtractContent` is true, after FileInfo is saved the server runs `ExtractContentFromFileInfo` asynchronously (in a goroutine). It uses a document extractor (e.g. for PDF, Office) to get text, truncates to 1MB, and stores it in `FileInfo.Content` in the DB. Used for search. Images are skipped. Content is not returned to the client in the normal FileInfo JSON.

---

## 7. How Files Are Stored

**Backend**  
- Configured by `FileSettings.DriverName`: `"local"` or `"amazons3"`.  
- **Local:** `FileSettings.Directory`; all paths (above) are relative to this directory.  
- **S3:** Same logical path structure; bucket and prefix from config (e.g. AmazonS3Bucket, AmazonS3PathPrefix).  
- Interface: `filestore.FileBackend`: Reader, ReadFile, FileExists, FileSize, WriteFile, AppendFile, MoveFile, RemoveFile, ListDirectory, etc. Resumable upload uses WriteFile for first chunk and AppendFile for subsequent chunks.

**Database**  
- **FileInfo:** One row per file (id, path, creator, channel, post_id, name, size, mime_type, dimensions, preview/thumbnail paths, etc.). Path/content fields used only server-side.  
- **UploadSession:** One row per resumable session; deleted when upload completes.

**Path summary**  
- Standard: `{date}/teams/{team}/channels/{channel}/users/{user}/{fileId}/{filename}` (and same dir for _preview and _thumb).  
- Resumable attachment: `{date}/teams/noteam/channels/{channel}/users/{user}/{uploadSessionId}/{filename}` (no FileInfo id until completion).  
- Files are identified by **file_id** (FileInfo.Id) in the API; path is an implementation detail of the backend.

---

## 8. Summary

- **Server API:** Upload via POST /files (multipart or simple) or resumable POST /uploads + POST /uploads/{id}. Fetch via GET /files/{id}, /thumbnail, /preview, /info, /link; GET /posts/{id}/files/info; POST .../files/search.  
- **Server models:** FileInfo (metadata + backend paths), UploadSession (resumable), FileUploadResponse.  
- **Frontend model:** FileInfo (same fields as exposed by API) plus clientId; files and fileIdsByPostId in Redux.  
- **Large files:** Resumable flow with upload session and chunked POST to /uploads/{id}; file is processed only after the full file is received.  
- **After upload:** Images get thumbnail/preview and orientation fix; plugins can transform or reject; optional async content extraction for search.  
- **Storage:** Local or S3 via FileBackend; path layout by date/team/channel/user/id; metadata in DB, content in backend.
