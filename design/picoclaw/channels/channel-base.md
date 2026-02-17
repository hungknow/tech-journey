# Channel Module — Core Structure

This document describes the channel module's core design: the main interface, how messages are sent to
external platforms, and how messages from platforms are received and routed. It is platform-agnostic
and does not refer to any specific messaging service.

---

## 1. Core Interface

The channel abstraction is defined by a single interface that every channel implementation must
satisfy:

```go
package channels

import (
	"context"
	"github.com/sipeed/picoclaw/pkg/bus"
)

// Channel is the core interface for all channel implementations.
// Implementations connect the application to external messaging platforms.
type Channel interface {
	// Name returns the channel identifier (e.g. used in config and bus routing).
	Name() string

	// Start begins listening for incoming events and/or establishing connection.
	// It should return when the channel is ready; long-running I/O runs in goroutines.
	Start(ctx context.Context) error

	// Stop shuts down the channel and releases resources.
	Stop(ctx context.Context) error

	// Send delivers an outbound message to the platform for the given chat/conversation.
	Send(ctx context.Context, msg bus.OutboundMessage) error

	// IsRunning reports whether the channel is currently active.
	IsRunning() bool

	// IsAllowed returns whether the given sender is allowed to interact (e.g. allowlist).
	IsAllowed(senderID string) bool
}
```

Implementations typically embed a shared **base** that provides common behavior (name, allowlist,
bus access, and the standard way to push received messages into the bus).

---

## 2. Base Implementation

The module provides a **base type** that concrete channels embed. It holds:

- **Name** — channel identifier
- **Config** — opaque config for the implementation
- **Message bus** — reference to the central `MessageBus`
- **Allowlist** — optional list of allowed sender IDs
- **Running flag** — whether the channel is active

The base implements `Name()`, `IsRunning()`, and `IsAllowed(senderID)`. It also exposes a single
entry point for **inbound** handling:

```go
// HandleMessage normalizes a received platform event and publishes it to the bus.
// Implementations call this after parsing platform-specific events.
// If the sender is not allowed, the message is dropped.
func (c *BaseChannel) HandleMessage(senderID, chatID, content string, media []string, metadata map[string]string)
```

So:

- **Outbound**: each channel implements `Send(ctx, msg bus.OutboundMessage)` and uses the platform
  SDK/API to post the message.
- **Inbound**: the platform-specific code parses events, then calls `HandleMessage(...)`; the base
  checks allowlist and publishes a normalized `bus.InboundMessage` to the bus.

---

## 3. Message Types (Bus)

Messages are normalized into two bus types (defined in `pkg/bus`):

**Inbound (platform → application):**

```go
type InboundMessage struct {
	Channel    string            // channel name (e.g. "telegram", "slack")
	SenderID   string            // platform user/conversation identifier
	ChatID     string            // conversation/thread identifier for replies
	Content    string            // text content
	Media      []string          // optional local file paths (e.g. downloaded attachments)
	SessionKey string            // "channel:chatID" for session/conversation grouping
	Metadata   map[string]string // platform-specific fields (e.g. message_ts, thread_ts)
}
```

**Outbound (application → platform):**

```go
type OutboundMessage struct {
	Channel string // target channel name (used for routing)
	ChatID  string // conversation/thread to send to (platform-specific format)
	Content string // text to send
}
```

---

## 4. Sending Messages to the Platform (Outbound)

**Flow:**

1. Some component (e.g. the agent loop) produces a reply and pushes it onto the bus as an
   **outbound** message with `Channel` set to the target channel name and `ChatID` set to the
   conversation/thread on that platform.
2. A **dispatcher** (channel manager) subscribes to the outbound bus. For each `OutboundMessage`:
   - It looks up the channel by `msg.Channel` in a registry (`map[string]Channel`).
   - It calls `channel.Send(ctx, msg)`.
3. Each channel's `Send` implementation:
   - Optionally checks `IsRunning()`.
   - Interprets `msg.ChatID` and `msg.Content` in a **platform-specific** way (e.g. channel+thread,
     chat ID, etc.).
   - Uses the platform's API/SDK to post the message (and optionally edit placeholders, add
     reactions, etc.).

So: **routing to the correct channel is done by the dispatcher using `msg.Channel`; delivery to the
right conversation/thread is done inside each channel using `msg.ChatID`.**

---

## 5. Receiving Messages from the Platform (Inbound)

**Flow:**

1. **Start:** When the channel is started, it connects to the platform (long polling, webhooks,
   socket mode, etc.) and runs an event loop in a goroutine.
2. **Platform events:** The implementation receives raw events (new message, mention, etc.) and
   parses them into:
   - `senderID` — who sent it (platform user ID or compound `id|username`)
   - `chatID` — where to reply (conversation/thread ID; format is platform-specific)
   - `content` — text (and optionally transcribed voice or file references)
   - `media` — optional slice of local file paths (e.g. downloaded attachments)
   - `metadata` — optional platform-specific key-value (e.g. message timestamp, thread ID)
3. **Allowlist:** Before handing off to the base, the implementation (or the base) checks
   `IsAllowed(senderID)`. If not allowed, the message is dropped.
4. **Publish to bus:** The implementation calls `HandleMessage(senderID, chatID, content, media,
   metadata)`. The base:
   - Builds `SessionKey` as `"channelName:chatID"`.
   - Constructs `bus.InboundMessage` with `Channel` set to the channel name.
   - Calls `bus.PublishInbound(msg)` so downstream consumers (e.g. agent loop) receive a single
     normalized shape.

So: **the correct "channel" for inbound is fixed per implementation (each channel has one name and
publishes with that name).** Session/conversation is identified by `SessionKey` / `ChatID` for
routing and context.

---

## 6. Summary Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Message Bus (pkg/bus)                            │
│  Inbound channel ◀── PublishInbound(InboundMessage)  (from channels)     │
│  Outbound channel ──► SubscribeOutbound() → OutboundMessage (to dispatch) │
└─────────────────────────────────────────────────────────────────────────┘
         ▲                                              │
         │ HandleMessage(...)                            │ msg.Channel → lookup
         │ → PublishInbound                              │ → channel.Send(ctx, msg)
         │                                               ▼
┌────────┴────────┐  platform events            ┌───────────────────────────┐
│ Channel impl    │  (polling/webhook/socket)   │ Channel Manager           │
│ • Start/Stop    │ ──► parse ──► allowlist ──► │ • dispatchOutbound()      │
│ • Send(msg)     │ ◀── API/SDK send ◀──────────│ • channels[msg.Channel]   │
│ • IsAllowed     │                             │ • GetChannel / Register   │
└─────────────────┘                             └───────────────────────────┘
```

- **Outbound:** Producer → `PublishOutbound(OutboundMessage)` → Manager subscribes →
  `channels[msg.Channel].Send(ctx, msg)` → platform API.
- **Inbound:** Platform event → channel parses → `HandleMessage(...)` → base does allowlist and
  `PublishInbound(InboundMessage)` → bus → correct logical channel and session via `Channel` +
  `SessionKey`/`ChatID`.

This is the core structure of the channel module independent of any specific platform.
