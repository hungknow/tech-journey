# Heartbeat

This document describes how the heartbeat feature works: how `HEARTBEAT.md` is parsed, how the heartbeat service monitors and runs tasks, how the agent knows what tools are available, where to see which tools are called, and how results are delivered. The implementation lives in `pkg/heartbeat/service.go`, the agent entrypoint in `pkg/agent/loop.go` (`ProcessHeartbeat`), and wiring in `cmd/picoclaw/main.go`.

---

## Overview

The heartbeat service runs periodic checks on a configurable interval. Each run reads the workspace file `HEARTBEAT.md`, builds a prompt from its contents, and invokes the agent with that prompt. The agent runs without session history (each heartbeat is independent). Depending on the agent's response and tool results, the service may send a message to the user on the last active channel or do nothing (e.g. when the response is `HEARTBEAT_OK` or when the handler returns a silent or async result).

---

## How HEARTBEAT.md is parsed

**Location and role**

- The heartbeat service looks for a single file: `HEARTBEAT.md` at the workspace root (e.g. `workspace/HEARTBEAT.md`).
- The file is not parsed as structured data. Its raw contents are read as UTF-8 and used as the user-task section of the heartbeat prompt.

**Reading and prompt building**

- **Read:** The service calls `buildPrompt()` which:
  - Resolves the path as `filepath.Join(workspace, "HEARTBEAT.md")`.
  - Reads the entire file with `os.ReadFile`.
- **Missing file:** If the file does not exist, the service creates a default template via `createDefaultHeartbeatTemplate()` and returns an empty prompt. An empty prompt causes the current heartbeat run to do nothing (no handler call).
- **Read error:** If the file exists but cannot be read, the error is logged to `heartbeat.log` and an empty prompt is returned; again no handler is invoked.
- **Empty content:** If the file is empty (zero length), the prompt is considered empty and the run is skipped.

**Prompt shape**

- The prompt is not "parsed" into fields or sections. The file content is embedded as-is into a fixed template.
- Template used in `buildPrompt()`:
  - A heading: `# Heartbeat Check`
  - A line: `Current time: <YYYY-MM-DD HH:MM:SS>` (server local time).
  - Instructions: the agent is described as a proactive assistant performing a scheduled heartbeat check; it should review the tasks below, run any needed actions using available tools, and if nothing needs attention respond only with `HEARTBEAT_OK`.
  - The full contents of `HEARTBEAT.md` are appended after that (no trimming or parsing).
- So "parsing" here means: read file → if missing create default and skip run; if error log and skip; otherwise embed content into this template and pass the resulting string as the single user message to the agent.

**Default template**

- When `HEARTBEAT.md` is missing, `createDefaultHeartbeatTemplate()` writes a default file at the same path.
- The default includes a title, example tasks (e.g. check unread messages, calendar, device status), and instructions: run all tasks, use spawn for long work, respond with `HEARTBEAT_OK` only when everything is done and nothing needs attention. It also contains a line like "Add your heartbeat tasks below this line:" so users know where to add their own items.
- After creating the template, the current run still gets an empty prompt (so no handler call that time).

**Migration**

- Workspace migration (`pkg/migrate/workspace.go`) treats `HEARTBEAT.md` as a migrateable file: it can be copied from a source workspace to a destination like other workspace config files.

---

## How the service monitors and runs the task

**Service lifecycle**

- The heartbeat service is created at gateway startup with workspace path, interval in minutes, and an enabled flag.
- Configuration comes from `config.Heartbeat` (`HeartbeatConfig`): `enabled` and `interval` (minutes). Defaults are enabled and 30 minutes. Minimum interval is 5 minutes; if a value below 5 (and not 0) is given, it is clamped to 5. Zero interval is treated as the default (30).
- The service is started with `Start()`. If already running or disabled, `Start()` returns without error. When enabled, it starts a goroutine that runs the ticker loop.
- The loop (`runLoop`) uses a `time.Ticker` with the configured interval. The first run happens after a 1-second delay; thereafter it runs on every tick. The loop exits when `Stop()` closes the stop channel.

**Single run (executeHeartbeat)**

- On each tick (and on the initial delay), the service calls `executeHeartbeat()`.
- It checks that the service is still enabled and that the stop channel is set (i.e. not stopped). It then:
  - Builds the prompt from `HEARTBEAT.md` as above. If the prompt is empty, it logs and returns.
  - Resolves the last channel from the workspace state manager: `state.GetLastChannel()`. That value is parsed into platform and user ID (see "Last channel and delivery" below).
  - Calls the configured handler with `(prompt, channel, chatID)`. The handler is set by the application (main) and typically calls the agent's `ProcessHeartbeat`.
- The handler returns a `*tools.ToolResult`. The service then:
  - **Nil result:** Logs and returns; no message sent.
  - **Error result (`IsError`):** Logs the error to `heartbeat.log` and returns; no message sent.
  - **Async result (`Async`):** Logs that an async task was started and returns; no immediate user message (the subagent or async path is responsible for later delivery).
  - **Silent result (`Silent`):** Logs "Heartbeat OK - silent" and returns; no user message.
  - **Otherwise:** If `ForUser` is set, that is sent to the user; else `ForLLM` is sent. Then logs "Heartbeat completed" with the ForLLM text.

**Concurrency and locking**

- The service uses a single `sync.RWMutex` to guard the stop channel, bus, handler, and enabled state. The ticker runs in one goroutine; `executeHeartbeat` and the handler run in that same goroutine, so there is no concurrent execution of two heartbeats. `Start`/`Stop`/`SetBus`/`SetHandler` take the lock as needed.

---

## How the agent knows what tools are available

Heartbeat runs use the **same agent and same tool registry** as normal user messages. There is no separate tool set for heartbeat.

**Agent and registry**

- The gateway creates a single `AgentLoop` at startup (`cmd/picoclaw/main.go`). That agent loop holds a `*tools.ToolRegistry` (`al.tools`) built by `createToolRegistry()` in `pkg/agent/loop.go`. All tools (read_file, write_file, list_dir, edit_file, append_file, exec, web_search, web_fetch, i2c, spi, message, spawn, subagent, cron, etc.) are registered there.
- When the heartbeat handler runs, it calls `agentLoop.ProcessHeartbeat(ctx, prompt, channel, chatID)`. That ends up in `runAgentLoop()` with the same `al.tools` registry. So every tool available to the agent in a normal chat is available during a heartbeat run.

**How the LLM sees tools**

- The system prompt sent to the LLM is built by `ContextBuilder.BuildSystemPrompt()` in `pkg/agent/context.go`. The context builder holds a reference to the same tool registry (`cb.tools`) set via `SetToolsRegistry(toolsRegistry)` when the agent loop is created.
- Inside `getIdentity()`, the context builder calls `cb.buildToolsSection()`. That method calls `cb.tools.GetSummaries()` and formats an "Available Tools" section for the system prompt, including the "CRITICAL: You MUST use tools..." instruction and the list of tool summaries. So the LLM receives the same tool list and descriptions for heartbeat as for any other message.
- When the LLM returns tool calls, the agent loop executes them with `al.tools.ExecuteWithContext(ctx, tc.Name, tc.Arguments, opts.Channel, opts.ChatID, asyncCallback)` in `pkg/agent/loop.go`. So the same registry that was used to build the prompt is used to run the tools.

**Summary**

- Tools available to heartbeat = tools registered on the main agent's registry at startup. The LLM learns about them from the "Available Tools" section in the system prompt, which is built from that registry. No extra configuration is needed for heartbeat to "know" what tools exist.

---

## How to see which tool was called

The current code does **not** write tool names or arguments to `heartbeat.log`. Tool execution is visible only in the **application logger** (the same process log that shows other agent and gateway activity). To see which tools run during a heartbeat (or any run), use the following.

**Logger category "agent"**

- In `pkg/agent/loop.go`, when the LLM returns tool calls, the loop logs:
  - `logger.InfoCF("agent", "LLM requested tool calls", ...)` with `tools` (list of tool names) and `count`.
  - For each tool: `logger.InfoCF("agent", "Tool call: %s(%s)", tc.Name, argsPreview, ...)` with `tool` and `iteration`. The message string is literally `Tool call: <name>(<args preview>)` with arguments truncated to 200 characters.
- So in your application log output, search for log category or component **"agent"** and messages **"LLM requested tool calls"** and **"Tool call: ..."** to see which tools the LLM requested and the name/args of each call. During a heartbeat run, these lines correspond to heartbeat-driven tool invocations.

**Logger category "tool"**

- In `pkg/tools/registry.go`, `ExecuteWithContext()` logs for every tool execution:
  - **"Tool execution started"** with `tool` (name) and `args` (full arguments map).
  - Then one of: **"Tool not found"** (error), **"Tool execution failed"** (with `tool`, `duration`, `error`), **"Tool started (async)"** (with `tool`, `duration`), or **"Tool execution completed"** (with `tool`, `duration_ms`, `result_length`).
- So in your application log output, search for log category or component **"tool"** and messages **"Tool execution started"** and **"Tool execution completed"** (or **"Tool started (async)"** / **"Tool execution failed"**) to see exactly which tool ran and its outcome. Again, when these occur during a heartbeat run, they are the heartbeat's tool calls.

**Correlating with heartbeat**

- Heartbeat runs are logged by the heartbeat service with category **"heartbeat"** (e.g. "Executing heartbeat", "Async heartbeat task started") and to `workspace/heartbeat.log` (e.g. "Heartbeat OK - silent", "Heartbeat completed", errors). By time: when you see "Executing heartbeat" (or a heartbeat.log entry), the next "agent" / "tool" log lines until the handler returns are for that heartbeat run. So you can correlate: heartbeat start → "LLM requested tool calls" / "Tool call: X(...)" → "Tool execution started" / "Tool execution completed" for X.

**Summary**

- To study which tools are called during heartbeat: use the application logger (stdout/stderr or your log sink), filter or search for category **"agent"** (tool request and per-call "Tool call: name(args)") and **"tool"** ("Tool execution started", "Tool execution completed", etc.). `heartbeat.log` does not currently contain tool names; it only contains high-level heartbeat outcomes and errors.

---

## Agent-side processing (ProcessHeartbeat)

- The handler registered in main calls `AgentLoop.ProcessHeartbeat(ctx, prompt, channel, chatID)`.
- `ProcessHeartbeat` runs the same core loop as normal messages (`runAgentLoop`) but with fixed options:
  - **SessionKey:** `"heartbeat"` so heartbeat uses a dedicated session key.
  - **NoHistory:** `true` — no session history or summary is loaded; each run is stateless with respect to past heartbeats.
  - **EnableSummary:** `false`.
  - **SendResponse:** `false` — the loop does not send the final assistant reply to the bus; the heartbeat service decides what to send based on the returned string and tool results.
- The last channel is still recorded when `ProcessHeartbeat` is invoked (if channel/chatID are non-empty and not internal), so subsequent heartbeats can use the same "last channel" for delivery.
- The agent can use tools (including spawn). If the spawn tool returns an async result, the handler in main returns that to the heartbeat service, which then does not send any message; the subagent delivers results later via the normal system/channel flow.

**Response handling in main**

- If `ProcessHeartbeat` returns an error, the handler returns `tools.ErrorResult(...)`; the service logs the error and does not send.
- If the returned string is exactly `HEARTBEAT_OK`, the handler returns `tools.SilentResult("Heartbeat OK")`; the service sends nothing to the user.
- Otherwise the handler returns `tools.SilentResult(response)` so the service does not send that text to the user (the design relies on subagent or tool-driven messages for user-visible output when needed).

---

## Last channel and delivery

- The service needs a target channel to send user-facing heartbeat results. It uses the "last channel" stored in the workspace state.
- The state manager (`state.Manager`) keeps `LastChannel` in `workspace/state/state.json`. The agent loop records it on each user message (only for non-internal channels) as `"platform:chatID"` (e.g. `telegram:123456`).
- In `executeHeartbeat`, the service gets `lastChannel` from `state.GetLastChannel()` and parses it with `parseLastChannel(lastChannel)`:
  - Split on the first `":"` into platform and user ID. If the format is wrong or either part is empty, the service treats it as invalid and does not send.
  - If the platform is internal (`constants.IsInternalChannel`: e.g. `cli`, `system`, `subagent`), the service does not send and logs that it is skipping an internal channel.
- When the service decides to send a message (non-silent, non-async, non-error result with `ForUser` or `ForLLM`), it calls `sendResponse(response)`, which:
  - Gets the message bus from the service (set by `SetBus`). If the bus is nil, it logs and returns.
  - Gets the last channel again from state and parses it. If missing or invalid or internal, it does not send.
  - Publishes `bus.OutboundMessage{ Channel: platform, ChatID: userID, Content: response }` so the channel adapter can deliver to the user.

---

## Logging

- All heartbeat-specific logging goes to `workspace/heartbeat.log` via `logInfo` / `logError` (timestamp, level, message). The service also uses the global logger with category `"heartbeat"` for start/stop, interval, and debug/async messages.
- Errors (e.g. handler error, read error, invalid channel format) are written to `heartbeat.log` so operators can inspect failures without relying only on process logs.
- Tool names and arguments are **not** written to `heartbeat.log`; see "How to see which tool was called" above for where they appear (application logger, categories "agent" and "tool").

---

## Features summary

- **Single file:** One file, `HEARTBEAT.md`, at the workspace root; no structured parsing, only full-file content embedded in a fixed prompt template.
- **Default template:** Auto-creation of `HEARTBEAT.md` with instructions and placeholder when the file is missing.
- **Configurable interval:** Interval in minutes (min 5, default 30), enabled/disabled via config or env (`PICOCLAW_HEARTBEAT_ENABLED`, `PICOCLAW_HEARTBEAT_INTERVAL`).
- **Stateless agent runs:** Each heartbeat uses `ProcessHeartbeat` with no history, so tasks do not depend on previous heartbeat conversations.
- **Same tools as normal chats:** The agent uses the same tool registry and system prompt "Available Tools" section for heartbeat as for user messages; no separate tool configuration.
- **Tool call visibility:** Which tools run is visible in the application logger under categories "agent" (LLM-requested tool calls and "Tool call: name(args)") and "tool" (Tool execution started/completed/async/failed); correlate by time with heartbeat log lines.
- **Result handling:** Support for silent, error, and async tool results so the service can avoid sending when the agent says `HEARTBEAT_OK`, when tools are silent, or when a subagent will report later.
- **Delivery to last channel:** User-visible results are sent only to the last active external channel (platform + chat ID), derived from workspace state; internal channels are never used for delivery.
- **Structured shutdown:** `Stop()` closes the stop channel so the ticker loop exits and no new heartbeat runs after shutdown.

---

## Configuration reference

- **heartbeat.enabled** (bool): Turn the heartbeat service on or off. Default: true.
- **heartbeat.interval** (int): Interval in minutes between runs. Minimum 5 when non-zero; 0 means 30. Default: 30.
- Environment: `PICOCLAW_HEARTBEAT_ENABLED`, `PICOCLAW_HEARTBEAT_INTERVAL` override the config file.

Files and paths:

- **HEARTBEAT.md:** `workspace/HEARTBEAT.md` (created with default template if missing).
- **heartbeat.log:** `workspace/heartbeat.log` (append-only, one line per log entry; high-level outcomes and errors only, no tool names).
- **Last channel state:** `workspace/state/state.json` (shared with the agent for last-channel tracking).
