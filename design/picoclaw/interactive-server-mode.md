# Interactive Mode and Server Mode: Template for New Applications

This document describes how PicoClaw supports both **interactive mode** (local CLI, one-shot or read-eval-print loop) and **server mode** (long-running gateway with channels). Use it as a reference so other agents can generate new applications with the same dual-mode design.

---

## Overview

**Interactive mode** means the process is driven by local input: either a single message (one-shot) or a loop reading from stdin. The process exits after the one-shot response or when the user leaves the loop (e.g. Ctrl+C or "exit").

**Server mode** means the process runs indefinitely, receives input from external channels (e.g. Telegram, Discord, Slack), processes messages through the same core logic as interactive mode, and sends responses back through those channels. Shutdown is via signal (e.g. Ctrl+C).

Both modes reuse the same **agent core**: one component that can "process a user message" and optionally "run a loop that consumes from a message bus." The difference is how input is fed and how output is delivered.

---

## Command Structure

Use a single binary with a top-level command switch. Two main entry points:

- **Interactive / one-shot**: e.g. `app agent [flags] [-m "message"]`
  - With `-m` / `--message`: one-shot. Process the given message, print the response, exit.
  - Without `-m`: interactive. Enter a read-eval-print loop (read line, process, print, repeat until exit).

- **Server**: e.g. `app gateway [flags]`
  - Start the message bus, the agent loop (consuming from the bus), and all channel adapters (which push to the bus and consume outbound replies). Run until interrupt.

Other commands (onboard, status, migrate, etc.) are independent; the template focus here is the agent vs gateway split.

---

## Shared Core: Agent Loop and Message Bus

**Message bus** (inbound + outbound):

- **Inbound**: producers (CLI in interactive mode, or channel adapters in server mode) push user messages. Each message carries at least: channel, sender id, chat id, content, and a session key (e.g. `"channel:chatID"` for per-chat history).
- **Outbound**: the agent pushes replies (channel, chat id, content). In interactive mode the CLI is the only consumer and just prints. In server mode a dispatcher goroutine reads outbound and calls the appropriate channel’s `Send`.

Define two structs (or equivalents): **InboundMessage** (Channel, SenderID, ChatID, Content, SessionKey, optional Media/Metadata) and **OutboundMessage** (Channel, ChatID, Content). The bus has:
- `PublishInbound(msg)` and `ConsumeInbound(ctx)` (blocking until message or ctx done).
- `PublishOutbound(msg)` and `SubscribeOutbound(ctx)` (same idea for replies).

**Agent loop** holds: config, message bus, LLM provider, session store, tool registry, and any context builder. It exposes:

- **ProcessDirect(ctx, content, sessionKey)**  
  Process one user message and return the reply string. Used by interactive mode (one-shot and loop). Internally it can build an InboundMessage with channel `"cli"` and chat id `"direct"` and call the same processing path as the bus.

- **ProcessDirectWithChannel(ctx, content, sessionKey, channel, chatID)**  
  Same as ProcessDirect but with explicit channel and chat id (for tools that need to send replies to a specific channel/chat).

- **ProcessHeartbeat(ctx, content, channel, chatID)** (optional)  
  Process a standalone prompt without session history (e.g. scheduled or health-check tasks). No history load, no summarization; response can be discarded or used internally.

- **Run(ctx)**  
  Loop: `ConsumeInbound(ctx)` → process message → if non-empty response and not already sent by a tool, `PublishOutbound(...)`. Run until context is cancelled. Used only in server mode.

- **processMessage(ctx, msg)** (internal)  
  Single place that takes an InboundMessage, optionally routes system messages (e.g. subagent completion), and otherwise runs the full agent logic (context build, LLM, tools, session save, optional summarization). ProcessDirect / ProcessDirectWithChannel and Run both go through this (or an equivalent) so behavior is identical.

Session key format should be consistent: e.g. `"cli:default"` for default CLI session, and `"<channel>:<chatID>"` for channel chats so history is per-chat.

---

## Interactive Mode Implementation

- Parse flags: e.g. `-m`/`--message`, `-s`/`--session` (session key), `--debug`.
- Load config and create provider and message bus. Build the agent loop (same constructor as for server mode). Optionally print startup info (tools count, skills, etc.).
- If `message != ""` (one-shot):
  - Call `agentLoop.ProcessDirect(ctx, message, sessionKey)`.
  - Print the returned string to stdout and exit.
- Else (interactive loop):
  - Print a short line like "Interactive mode (Ctrl+C to exit)".
  - Use a readline (or simple bufio.Scanner) loop:
    - Read a line; trim; skip empty; treat "exit"/"quit" as exit.
    - Call `agentLoop.ProcessDirect(ctx, line, sessionKey)` and print the response.
  - On EOF or interrupt, exit gracefully.

No bus consumer loop is started in interactive mode; the only consumer of the agent’s work is the local code that called ProcessDirect and prints the result.

---

## Server Mode (Gateway) Implementation

- Parse flags (e.g. `--debug`). Load config, create provider and message bus, build the same agent loop.
- Optionally create and start extra services that feed the agent via the bus or ProcessHeartbeat (e.g. cron, heartbeat). Register any extra tools (e.g. cron tool) with the agent loop.
- Create a **channel manager** that:
  - Holds a map of channel name → channel implementation.
  - Each channel implements: Start(ctx), Stop(ctx), Send(ctx, OutboundMessage), and a way to push incoming user messages to the bus (e.g. HandleMessage(senderID, chatID, content, ...) that builds InboundMessage and calls bus.PublishInbound).
- Start an **outbound dispatcher** goroutine: loop with `bus.SubscribeOutbound(ctx)`; for each message, look up the channel by name and call `channel.Send(ctx, msg)`. Skip or log unknown/internal channels.
- Start each channel (each may start its own listeners or webhooks).
- Start the agent loop in a goroutine: `go agentLoop.Run(ctx)`.
- Block on shutdown signal (e.g. os.Interrupt). On signal: cancel context, stop channels, stop outbound dispatcher, stop agent loop (e.g. set a "running" flag and cancel context so Run exits), then stop any cron/heartbeat services.

Result: channels push user messages to the bus; the agent loop is the single consumer of inbound and processes each message; it pushes replies to the outbound bus; the dispatcher sends those to the right channel. No HTTP server is strictly required for this pattern; each channel can use its own transport (Telegram Bot API, Discord, Slack, webhooks, etc.). If the app has a single "gateway" host/port, it can be used for webhooks or a small HTTP API; the core pattern is still bus + Run + channels.

---

## Session and Channel Identity

- **Session key**: Uniquely identifies the conversation for history and summarization. Use a stable format like `"channel:chatID"` (e.g. `telegram:12345`, `cli:default`). In interactive mode you can default to `cli:default` or allow `-s` to override.
- **Channel and ChatID in messages**: So that tools (e.g. "message" or "send") can send replies to the right place, every InboundMessage should set Channel and ChatID. In ProcessDirect for CLI, use channel `"cli"` and chat id `"direct"` (or the session key). In server mode, channels set these when they call PublishInbound (e.g. channel name and the platform’s chat/conversation id).
- **Internal channels**: If you have channels that should not receive user-visible outbound (e.g. "system", "cli" when in server mode), mark them as internal and in the outbound dispatcher skip publishing to them or do not register them as external channels.

---

## One-Shot vs Interactive vs Server: Summary

- **One-shot**: `app agent -m "Hello"` → one ProcessDirect, print, exit.
- **Interactive**: `app agent` → loop: read line → ProcessDirect → print, until exit.
- **Server**: `app gateway` → agentLoop.Run(ctx) + channel manager (inbound from channels → bus, outbound from bus → channel.Send), plus optional cron/heartbeat; run until signal.

Same agent loop and processMessage logic for all three; only the source of input (stdin vs bus) and the consumer of output (stdout vs outbound bus and then channels) differ. Document this so that agents generating new code can replicate the pattern without using a table: interactive and server mode are two ways to wire the same core.

---

## Template File Tree

Use this layout when creating a new application. Replace `yourapp` and `yourmodule` with your project and Go module names.

```
yourapp/
├── cmd/
│   └── yourapp/
│       └── main.go          # Entry: command switch, agentCmd, gatewayCmd, interactiveMode
├── pkg/
│   ├── bus/
│   │   ├── types.go        # InboundMessage, OutboundMessage
│   │   └── bus.go          # MessageBus, PublishInbound/ConsumeInbound, PublishOutbound/SubscribeOutbound
│   ├── agent/
│   │   └── loop.go         # AgentLoop, NewAgentLoop, ProcessDirect, ProcessDirectWithChannel, Run, processMessage
│   ├── channels/
│   │   ├── channel.go      # Channel interface, BaseChannel, HandleMessage
│   │   └── manager.go      # Manager, StartAll, StopAll, dispatchOutbound
│   └── config/
│       └── config.go       # Config struct, LoadConfig (optional; can start with a minimal struct in main)
├── go.mod
└── README.md
```

Optional as you grow: `pkg/session`, `pkg/tools`, `pkg/providers`, and per-channel packages (e.g. `pkg/channels/telegram`).

---

## Template Code (Go)

The following is minimal template code in Go. Replace `yourmodule` with your module path (e.g. `github.com/you/yourapp`). The agent core is stubbed (echo-style) so you can plug in your real LLM, session store, and tools.

**go.mod**

```go
module yourmodule

go 1.21
```

**pkg/bus/types.go**

```go
package bus

type InboundMessage struct {
	Channel    string
	SenderID   string
	ChatID     string
	Content    string
	SessionKey string
	Media      []string
	Metadata   map[string]string
}

type OutboundMessage struct {
	Channel string
	ChatID  string
	Content string
}
```

**pkg/bus/bus.go**

```go
package bus

import "context"

type MessageBus struct {
	inbound  chan InboundMessage
	outbound chan OutboundMessage
}

func NewMessageBus() *MessageBus {
	return &MessageBus{
		inbound:  make(chan InboundMessage, 100),
		outbound: make(chan OutboundMessage, 100),
	}
}

func (mb *MessageBus) PublishInbound(msg InboundMessage) {
	mb.inbound <- msg
}

func (mb *MessageBus) ConsumeInbound(ctx context.Context) (InboundMessage, bool) {
	select {
	case msg := <-mb.inbound:
		return msg, true
	case <-ctx.Done():
		return InboundMessage{}, false
	}
}

func (mb *MessageBus) PublishOutbound(msg OutboundMessage) {
	mb.outbound <- msg
}

func (mb *MessageBus) SubscribeOutbound(ctx context.Context) (OutboundMessage, bool) {
	select {
	case msg := <-mb.outbound:
		return msg, true
	case <-ctx.Done():
		return OutboundMessage{}, false
	}
}
```

**pkg/agent/loop.go**

```go
package agent

import (
	"context"
	"fmt"
	"sync/atomic"

	"yourmodule/pkg/bus"
)

type AgentLoop struct {
	bus     *bus.MessageBus
	running atomic.Bool
}

func NewAgentLoop(bus *bus.MessageBus) *AgentLoop {
	return &AgentLoop{bus: bus}
}

func (al *AgentLoop) ProcessDirect(ctx context.Context, content, sessionKey string) (string, error) {
	return al.ProcessDirectWithChannel(ctx, content, sessionKey, "cli", "direct")
}

func (al *AgentLoop) ProcessDirectWithChannel(ctx context.Context, content, sessionKey, channel, chatID string) (string, error) {
	msg := bus.InboundMessage{
		Channel:    channel,
		SenderID:   "cli",
		ChatID:     chatID,
		Content:    content,
		SessionKey: sessionKey,
	}
	return al.processMessage(ctx, msg)
}

func (al *AgentLoop) Run(ctx context.Context) error {
	al.running.Store(true)
	defer al.running.Store(false)

	for al.running.Load() {
		select {
		case <-ctx.Done():
			return nil
		default:
			msg, ok := al.bus.ConsumeInbound(ctx)
			if !ok {
				continue
			}
			response, err := al.processMessage(ctx, msg)
			if err != nil {
				response = fmt.Sprintf("Error: %v", err)
			}
			if response != "" {
				al.bus.PublishOutbound(bus.OutboundMessage{
					Channel: msg.Channel,
					ChatID:  msg.ChatID,
					Content: response,
				})
			}
		}
	}
	return nil
}

func (al *AgentLoop) Stop() {
	al.running.Store(false)
}

func (al *AgentLoop) processMessage(ctx context.Context, msg bus.InboundMessage) (string, error) {
	// TODO: Replace with real logic: load session, build context, call LLM, run tools, save session.
	// Stub: echo the user message.
	return "Echo: " + msg.Content, nil
}
```

**pkg/channels/channel.go**

```go
package channels

import (
	"context"
	"fmt"

	"yourmodule/pkg/bus"
)

type Channel interface {
	Name() string
	Start(ctx context.Context) error
	Stop(ctx context.Context) error
	Send(ctx context.Context, msg bus.OutboundMessage) error
}

type BaseChannel struct {
	name string
	bus  *bus.MessageBus
}

func NewBaseChannel(name string, bus *bus.MessageBus) *BaseChannel {
	return &BaseChannel{name: name, bus: bus}
}

func (c *BaseChannel) Name() string {
	return c.name
}

func (c *BaseChannel) HandleMessage(senderID, chatID, content string) {
	sessionKey := fmt.Sprintf("%s:%s", c.name, chatID)
	c.bus.PublishInbound(bus.InboundMessage{
		Channel:    c.name,
		SenderID:   senderID,
		ChatID:     chatID,
		Content:    content,
		SessionKey: sessionKey,
	})
}
```

**pkg/channels/manager.go**

```go
package channels

import (
	"context"
	"log"
	"sync"

	"yourmodule/pkg/bus"
)

type Manager struct {
	channels map[string]Channel
	bus      *bus.MessageBus
	ctx      context.Context
	cancel   context.CancelFunc
	mu       sync.RWMutex
}

func NewManager(bus *bus.MessageBus) *Manager {
	return &Manager{
		channels: make(map[string]Channel),
		bus:      bus,
	}
}

func (m *Manager) Register(name string, ch Channel) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.channels[name] = ch
}

func (m *Manager) StartAll(ctx context.Context) error {
	m.mu.Lock()
	m.ctx, m.cancel = context.WithCancel(ctx)
	m.mu.Unlock()

	go m.dispatchOutbound(m.ctx)

	for name, ch := range m.channels {
		if err := ch.Start(m.ctx); err != nil {
			log.Printf("channel %s start: %v", name, err)
		}
	}
	return nil
}

func (m *Manager) StopAll(ctx context.Context) error {
	if m.cancel != nil {
		m.cancel()
	}
	m.mu.RLock()
	defer m.mu.RUnlock()
	for name, ch := range m.channels {
		if err := ch.Stop(ctx); err != nil {
			log.Printf("channel %s stop: %v", name, err)
		}
	}
	return nil
}

func (m *Manager) dispatchOutbound(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		default:
			msg, ok := m.bus.SubscribeOutbound(ctx)
			if !ok {
				continue
			}
			m.mu.RLock()
			ch, exists := m.channels[msg.Channel]
			m.mu.RUnlock()
			if !exists {
				continue
			}
			if err := ch.Send(ctx, msg); err != nil {
				log.Printf("send to %s: %v", msg.Channel, err)
			}
		}
	}
}
```

**cmd/yourapp/main.go**

```go
package main

import (
	"bufio"
	"context"
	"fmt"
	"os"
	"os/signal"
	"strings"

	"yourmodule/pkg/agent"
	"yourmodule/pkg/bus"
	"yourmodule/pkg/channels"
)

const appName = "yourapp"

func main() {
	if len(os.Args) < 2 {
		printHelp()
		os.Exit(1)
	}

	cmd := os.Args[1]
	switch cmd {
	case "agent":
		agentCmd()
	case "gateway":
		gatewayCmd()
	default:
		fmt.Printf("Unknown command: %s\n", cmd)
		printHelp()
		os.Exit(1)
	}
}

func printHelp() {
	fmt.Printf("%s - Interactive and server mode template\n\n", appName)
	fmt.Println("Commands:")
	fmt.Println("  agent     Interactive mode (use -m \"msg\" for one-shot)")
	fmt.Println("  gateway   Server mode (channels + bus)")
}

func agentCmd() {
	var message, sessionKey string
	args := os.Args[2:]
	for i := 0; i < len(args); i++ {
		switch args[i] {
		case "-m", "--message":
			if i+1 < len(args) {
				message = args[i+1]
				i++
			}
		case "-s", "--session":
			if i+1 < len(args) {
				sessionKey = args[i+1]
				i++
			}
		}
	}
	if sessionKey == "" {
		sessionKey = "cli:default"
	}

	msgBus := bus.NewMessageBus()
	agentLoop := agent.NewAgentLoop(msgBus)

	if message != "" {
		ctx := context.Background()
		response, err := agentLoop.ProcessDirect(ctx, message, sessionKey)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}
		fmt.Println(response)
		return
	}

	fmt.Printf("%s interactive mode (Ctrl+C or 'exit' to quit)\n\n", appName)
	interactiveMode(agentLoop, sessionKey)
}

func interactiveMode(agentLoop *agent.AgentLoop, sessionKey string) {
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print("You: ")
		if !scanner.Scan() {
			fmt.Println("\nGoodbye!")
			return
		}
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		if line == "exit" || line == "quit" {
			fmt.Println("Goodbye!")
			return
		}

		ctx := context.Background()
		response, err := agentLoop.ProcessDirect(ctx, line, sessionKey)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			continue
		}
		fmt.Printf("\n%s %s\n\n", appName, response)
	}
}

func gatewayCmd() {
	msgBus := bus.NewMessageBus()
	agentLoop := agent.NewAgentLoop(msgBus)

	// Optional: add one or more channels. Example: a no-op channel that only logs.
	// In real code you would register Telegram, Discord, etc.
	chMgr := channels.NewManager(msgBus)
	// chMgr.Register("telegram", telegram.NewChannel(cfg, msgBus))

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	if err := chMgr.StartAll(ctx); err != nil {
		fmt.Fprintf(os.Stderr, "channels start: %v\n", err)
		os.Exit(1)
	}

	go agentLoop.Run(ctx)

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt)
	<-sig

	fmt.Println("\nShutting down...")
	cancel()
	agentLoop.Stop()
	_ = chMgr.StopAll(ctx)
	fmt.Println("Done.")
}
```

**How to use the template**

- Copy the file tree and create the directories and files. Replace `yourmodule` with your Go module path and `yourapp` with your binary name.
- Run: `go mod init yourmodule` (if you create the tree manually), then `go build ./cmd/yourapp` and run `./yourapp agent` or `./yourapp agent -m "hello"` or `./yourapp gateway`.
- Implement real behavior in `pkg/agent/loop.go`: in `processMessage`, load session history, build LLM messages, call your provider, execute tools, save session, and return the final reply. Keep `ProcessDirect`, `ProcessDirectWithChannel`, and `Run` as shown so interactive and server modes stay aligned.
- Add real channels by implementing the `channels.Channel` interface and registering them in `gatewayCmd`; have them call `BaseChannel.HandleMessage` (or equivalent) when they receive a user message so it goes onto the bus.
