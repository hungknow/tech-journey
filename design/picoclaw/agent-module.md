# Agent Module Specification

This document describes the `pkg/agent` module: its data flow, call order, and the purpose of each primary function. Use it as a specification when reimplementing this module or building similar modules.

---

## Overview

The agent module implements the core AI loop: it consumes user messages, builds context (system prompt, history, memory, skills), calls the LLM, executes tools, and optionally summarizes conversation. It is the central orchestrator between the message bus, the LLM provider, the tool registry, session storage, and persistent memory.

**Main types:**

- **AgentLoop** — The main loop: consumes inbound messages, runs the LLM iteration with tools, persists session state, and publishes outbound responses.
- **ContextBuilder** — Builds the system prompt and the full message list (system + history + current user message) for each request.
- **MemoryStore** — Reads and writes long-term memory (MEMORY.md) and daily notes (memory/YYYYMM/YYYYMMDD.md). Used only by ContextBuilder for prompt context.

**Files:**

- **loop.go** — AgentLoop, process options, tool registry creation, Run/processMessage/runAgentLoop/runLLMIteration, summarization, and helpers.
- **context.go** — ContextBuilder: identity, bootstrap files, skills summary, memory context, BuildSystemPrompt, BuildMessages.
- **memory.go** — MemoryStore: long-term and daily-note paths, read/write/append, GetMemoryContext.

---

## Data Flow

### Call order (text diagram)

**Entry from bus (normal run):**

```
Run(ctx)
  └─ ConsumeInbound(ctx)  →  msg
  └─ processMessage(ctx, msg)
        ├─ [channel == "system"]  →  processSystemMessage(ctx, msg)
        │     →  return (no LLM, no outbound)
        └─ [else]  →  runAgentLoop(ctx, opts)
  └─ [response && !messageToolSent]  →  PublishOutbound(response)
```

**Entry from CLI / direct / heartbeat:**

```
ProcessDirect(ctx, content, sessionKey)
  OR   ProcessHeartbeat(ctx, content, channel, chatID)
  └─ builds msg or opts
  └─ processMessage(ctx, msg)  OR  runAgentLoop(ctx, opts)
        →  same core path below
```

**Core path (one user message → one reply):**

```
runAgentLoop(ctx, opts)
  ├─ RecordLastChannel(...)           [if external channel]
  ├─ updateToolContexts(channel, chatID)
  ├─ history, summary = GetHistory(opts.SessionKey), GetSummary(opts.SessionKey)
  │     [unless NoHistory]
  ├─ messages = BuildMessages(history, summary, UserMessage, ...)
  │     └─ BuildSystemPrompt()
  │           →  getIdentity + LoadBootstrapFiles + skills + GetMemoryContext
  ├─ AddMessage(sessionKey, "user", UserMessage)
  ├─ runLLMIteration(ctx, messages, opts)
  │     └─ loop:
  │           ├─ provider.Chat(ctx, messages, toolDefs)  →  response
  │           ├─ [no tool calls]  →  finalContent = response.Content; break
  │           └─ [has tool calls]  →  append assistant msg; for each:
  │                 ExecuteWithContext(...); append tool msg; repeat
  ├─ [finalContent empty]  →  finalContent = DefaultResponse
  ├─ AddMessage(sessionKey, "assistant", finalContent); Save(sessionKey)
  ├─ [EnableSummary]  →  maybeSummarize(sessionKey)
  │     [async: summarizeSession → summarizeBatch]
  ├─ [SendResponse]  →  PublishOutbound(finalContent)
  └─ return finalContent
```

### Data flow (text diagram)

```
INPUTS
  bus.InboundMessage (Channel, ChatID, Content, SessionKey)   ──┐
  ctx (cancellation)                                          │
  processOptions (SessionKey, Channel, ChatID, UserMessage,   │
                  EnableSummary, SendResponse, NoHistory)    │
                                                              ▼
  runAgentLoop ──► updateToolContexts ──► BuildMessages ──► runLLMIteration
       │                  │                    │                    │
       │                  │                    │   system + history + user
       │                  │                    │   (BuildSystemPrompt ←
       │                  │                    │    GetMemoryContext, skills, bootstrap)
       │                  │                    │                    │
       │                  │                    │                    ├─ provider.Chat(messages, toolDefs)
       │                  │                    │                    ├─ tool results → append to messages
       │                  │                    │                    └─ loop until no tool calls
       │                  │                    │
       │                  │                    └──► sessions.AddMessage / AddFullMessage / Save
       │                  └──► message, spawn, subagent tools get (channel, chatID)
       └──► RecordLastChannel; maybeSummarize (async); optional PublishOutbound

OUTPUTS
  OutboundMessage (Channel, ChatID, Content)  →  bus
      [from Run or runAgentLoop or message tool]
  return string (final reply)  →  caller
  state (last channel/chatID); session files (history, summary)
```

### Data items (short reference)

- **InboundMessage**: Channel, ChatID, Content, SessionKey (and SenderID, Media, Metadata).
  System channel = subagent result, no LLM.
- **processOptions**: SessionKey, Channel, ChatID, UserMessage, DefaultResponse, EnableSummary,
  SendResponse, NoHistory.
- **messages**: system (from BuildSystemPrompt) + history + current user; then in runLLMIteration,
  assistant + tool messages appended.
- **Session**: GetHistory / GetSummary (read); AddMessage, AddFullMessage, SetSummary,
  TruncateHistory, Save (write).
- **ToolResult**: ForLLM → into messages; ForUser → optional PublishOutbound (or message tool).
- **OutboundMessage**: Channel, ChatID, Content. Published by Run (if message tool did not send),
  runAgentLoop (if SendResponse), or tools.

---

## Purpose and Order of Function Calls

This section merges call order with the purpose of each function. Functions are listed in the
order they appear in the call flow. Indented items are helpers called by the function above
them; the description explains how the helper serves that caller. Each line prefixes the
**file name** so you can see where the function lives.

### File tree (reference)

```
pkg/agent/
├── loop.go      # AgentLoop: NewAgentLoop, Run, processMessage, processSystemMessage,
│                #   runAgentLoop, updateToolContexts, runLLMIteration, maybeSummarize,
│                #   estimateTokens, summarizeSession, summarizeBatch;
│                #   ProcessDirect, ProcessDirectWithChannel, ProcessHeartbeat;
│                #   GetStartupInfo, RecordLastChannel, RecordLastChatID, RegisterTool, Stop
├── context.go   # ContextBuilder: NewContextBuilder, SetToolsRegistry, BuildMessages,
│                #   BuildSystemPrompt, getIdentity, buildToolsSection, LoadBootstrapFiles,
│                #   AddToolResult, AddAssistantMessage, GetSkillsInfo
└── memory.go    # MemoryStore: NewMemoryStore, GetMemoryContext, ReadLongTerm,
                 #   GetRecentDailyNotes, ReadToday, AppendToday, getTodayFile, WriteLongTerm
```

### Functions (call order; indented = called by above)

- **loop.go** **NewAgentLoop** — Run at startup. Prepares the agent: registers all tools (files,
  exec, web, hardware, message, spawn, subagent), sets up subagents with their own tools,
  session storage, and state. Creates the context builder and gives it the tool registry.
  Produces a fully wired AgentLoop ready to process messages.
  - **context.go** **NewContextBuilder** — Creates the object that
    will build system prompts and message lists; binds workspace, skills, and memory.
  - **context.go** **SetToolsRegistry** — Connects the tool registry to the context builder
    so the system prompt can include an "available tools" section.
  - **memory.go** **NewMemoryStore** — Used by NewContextBuilder. Creates a store that
    knows where long-term memory and daily notes live and ensures the memory directory
    exists.

- **loop.go** **Run** — Keeps the agent alive: listens for messages on the bus and, for each one, runs the
  full process and sends the reply back unless a tool (e.g. the message tool) already sent this
  round. Stops when the context is cancelled.
  - **loop.go** **processMessage** — Decides how to handle the
    message: system-channel messages go to processSystemMessage; all others are turned into a
    "run options" bundle and passed to runAgentLoop so one full turn can be executed.
  - **loop.go** **processSystemMessage** — When the message is on the system channel, interprets and logs subagent results; does not call the LLM or send to the user.
    User-facing output from subagents is expected via the message tool.

- **loop.go** **runAgentLoop** — Runs one full turn for a request: load or skip history, build the message
  list, call the LLM (with tools) until a final answer, persist the turn, optionally
  summarize and optionally send the reply. The single place where "one user message → one
  agent turn" is completed.
  - **loop.go** **updateToolContexts** — At the start of each turn, tells the
    message, spawn, and subagent tools the current channel and chat ID so they can target
    the right conversation when they run.
  - **context.go** **BuildMessages** — Produces the exact message
    list for one LLM call: system prompt (including session and summary when relevant),
    conversation history, and the current user message, so each turn sends a consistent
    structure to the model.
    - **context.go** **BuildSystemPrompt** — Assembles the full
      system prompt so BuildMessages has a single system block at the head of the message
      list. Gives the model identity, rules, skills, and memory in one place.
      - **context.go** **getIdentity** — Produces the fixed
        "who you are" block (agent name, time, runtime, workspace, and the tools section)
        so BuildSystemPrompt can place it first in the prompt.
        - **context.go** **buildToolsSection** — Turns the tool
          registry into a text block that describes available tools, so getIdentity can
          tell the model what it can do without hardcoding the list.
      - **context.go** **LoadBootstrapFiles** — Injects
        project-defined files (e.g. AGENTS.md, SOUL.md, USER.md, IDENTITY.md) into the
        prompt so BuildSystemPrompt can include per-workspace behavior without code
        changes.
      - **memory.go** **GetMemoryContext** — Supplies the
        "memory" block (long-term + recent daily notes) so the system prompt includes
        persistent and recent context.
        - **memory.go** **ReadLongTerm** — Supplies the
          long-term memory content so GetMemoryContext can include it in the block and
          the model can reason over persistent facts.
        - **memory.go** **GetRecentDailyNotes** — Supplies the
          last N days of daily notes so GetMemoryContext can give the model a short
          "recent past" window without loading full history.
  - **loop.go** **runLLMIteration** — Does the back-and-forth with the model: sends
    messages and tool definitions, gets a response, and either finishes (no tool calls) or
    runs the requested tools, appends their results as messages, and repeats until the
    model returns a plain answer or the iteration limit is hit.
  - **loop.go** **maybeSummarize** — After saving the turn, decides whether the
    session has grown too long; if so, kicks off background summarization once per session so
    future turns do not overflow the context window.
    - **loop.go** **estimateTokens** — Provides a rough token count for the
      session history so maybeSummarize can decide whether to trigger summarization without
      using a real tokenizer.
    - **loop.go** **summarizeSession** — Shrinks the session history by replacing most of
      it with an LLM-generated summary and keeping only the last few messages (runs in a
      goroutine), so runAgentLoop can keep using a bounded context size.
      - **loop.go** **summarizeBatch** — Asks the LLM to produce a short
        summary of a given slice of conversation (and optionally an existing summary), so
        summarizeSession can build the final summary and then truncate history.

- **loop.go** **ProcessDirect**, **ProcessDirectWithChannel**, **ProcessHeartbeat** — Entry
  points from CLI, direct calls, or heartbeat. They build the appropriate options or
  message and then call processMessage or runAgentLoop so the same core flow is used.

- **loop.go** **GetStartupInfo** — Exposes tool and skill counts for startup or logging.
  - **context.go** **GetSkillsInfo** — Exposes which skills are
    loaded and their names so the app can report the agent's capabilities.

- **context.go** **AddToolResult**, **AddAssistantMessage** — Convenience helpers for code
  that builds message lists by hand (e.g. tests). The main loop does not use them; it
  appends messages itself.

- **memory.go** **ReadToday** — Exposes today's daily note for the prompt or for tools when
  the agent or a tool needs "what happened today."
  - **memory.go** **getTodayFile** — Resolves the
    file path for today's daily note so both can read or write the correct file without
    duplicating path logic.

- **memory.go** **AppendToday** — Appends to today's daily note without overwriting, so the
  agent or tools can add entries (e.g. completed tasks) over the day. Uses getTodayFile
  to target the correct file.

- **memory.go** **WriteLongTerm** — Lets the agent or tools update long-term memory so
  important information persists across sessions. Not called by other agent functions;
  used by tools or external callers.

---

## Dependencies

- **bus** — InboundMessage, OutboundMessage; ConsumeInbound, PublishOutbound.
- **config** — Workspace path, agent defaults (model, max tokens, max tool iterations, restrict), tools config (e.g. Brave/DuckDuckGo).
- **providers** — Message, ToolDefinition, ToolCall, LLMProvider.Chat.
- **tools** — ToolRegistry, Tool, ContextualTool, ToolResult, ExecuteWithContext, ToProviderDefs, GetSummaries; concrete tools (read_file, message, spawn, subagent, etc.).
- **session** — SessionManager: GetHistory, GetSummary, AddMessage, AddFullMessage, SetSummary, TruncateHistory, Save.
- **state** — Manager: SetLastChannel, SetLastChatID.
- **skills** — SkillsLoader: ListSkills, BuildSkillsSummary.
- **logger** — DebugCF, InfoCF, WarnCF, ErrorCF.
- **constants** — IsInternalChannel(channel).
