# LLM Prompts in picoclaw

This document lists every LLM prompt used in the codebase: the literal or templated text sent to the model, the function that builds or uses it, and the context where it is used.

---

## Messages sent to the LLM

This section describes the **message list** actually passed to the LLM in each scenario: who builds each part and what the combined input looks like. The sections below give the full content of each prompt; here we only summarize the structure and responsibility.

### Normal chat (user message)

**Built by:** `ContextBuilder.BuildMessages()` in `pkg/agent/context.go`, called from `runAgentLoop()` in `pkg/agent/loop.go` with `history` and `summary` from the session, and the current user message.

**Message list:** `[ system, ...history, user ]`

- **System:** Full main agent system prompt from `BuildSystemPrompt()` (identity, Available Tools, bootstrap files, skills, memory, optional Current Session, optional Summary of Previous Conversation).
- **History:** Previous turns from `sessions.GetHistory(sessionKey)` — alternating user/assistant (and possibly tool) messages.
- **User:** The current user message for this turn.

After the first LLM call, if tool calls are present in the response, the loop appends an assistant message (with tool calls) and a tool result message for each call, then calls the LLM again with this updated message list. With each iteration, the list always starts with the same full system prompt—covering identity, tools, bootstrap, skills, memory, etc.—followed by history, user input, assistant/tool messages.

This system prompt is resent on every LLM request: only new assistant and tool messages are appended, the system message itself is unchanged. If multiple tool calls occur, the LLM is called multiple times per turn (e.g., 6 calls means 6 identical copies of the system prompt sent).

As a result, the system prompt dominates repeated token usage since it is never shortened or omitted between tool iterations.

**Tool definitions:** From `ToolRegistry.ToProviderDefs()`, passed to the provider together with the message list.

### Heartbeat run

**Built by:** Same `BuildMessages()`, but with **no history** (`NoHistory: true`) and the **user** slot set to the heartbeat prompt from `buildPrompt()` in `pkg/heartbeat/service.go`.

**Message list:** `[ system, user ]`

- **System:** Same full main agent system prompt from `BuildSystemPrompt()` (so the model still sees identity, Available Tools, bootstrap, skills, memory, etc.).
- **User:** Single message = output of `buildPrompt()` (Heartbeat Check heading, current time, instructions, raw contents of `HEARTBEAT.md`).

No conversation history; tool definitions are the same as normal chat.

### Conversation summarization (`summarizeBatch`)

**Built by:** `summarizeBatch()` in `pkg/agent/loop.go` — builds a single user message string and calls `provider.Chat()` with no system message and no tools.

**Message list:** `[ user ]`

- **User:** One message containing the summarization instruction, optional "Existing context: …", and "CONVERSATION:" plus the batch of messages as text.

No system message, no tool definitions. Used only to get a summary string; the response is not part of a conversation.

### Merge summaries (`summarizeSession`)

**Built by:** Inline in `summarizeSession()` in `pkg/agent/loop.go` — builds one user message and calls `provider.Chat()` with no system message and no tools.

**Message list:** `[ user ]`

- **User:** One message: "Merge these two conversation summaries into one cohesive summary:\n\n1: <s1>\n\n2: <s2>".

No system message, no tool definitions. Used only to merge two summary strings into one.

### Subagent (async spawn)

**Built by:** `runTask()` in `pkg/tools/subagent.go` — builds a fixed system string and uses the task as the user message, then calls `RunToolLoop()`.

**Message list:** `[ system, user ]`

- **System:** Short subagent system prompt ("You are a subagent. Complete the given task independently…"). It does **not** include the main agent’s "Available Tools" text block or the skills section; the subagent does not use `BuildSystemPrompt()`.
- **User:** The task string from the spawn tool arguments.

Tool definitions are passed to the provider from the same registry (`ToProviderDefs()`), so the model can call tools, but the system message does not list tool names/descriptions or skills.

### Sync subagent (SubagentTool)

**Built by:** `SubagentTool.Execute()` in `pkg/tools/subagent.go` — builds a fixed system string and the task as user message, then calls `RunToolLoop()`.

**Message list:** `[ system, user ]`

- **System:** Short sync subagent prompt ("You are a subagent. Complete the given task independently and provide a clear, concise result."). It does **not** include the tool section or skills section (same as async subagent).
- **User:** The task string from the tool arguments.

Same tool registry as the main agent; tools are available via API definitions only, not via text in the system prompt.

---

## Main agent system prompt

### Function

`BuildSystemPrompt()` in `pkg/agent/context.go`. It is built from: `getIdentity()`, `LoadBootstrapFiles()`, a skills block (via `BuildSkillsSummary()`), and `GetMemoryContext()` from the memory store. The tools section comes from `buildToolsSection()` (which calls `cb.tools.GetSummaries()`).

### Context

Used for every normal chat turn and for heartbeat runs. `ContextBuilder.BuildMessages()` calls `BuildSystemPrompt()` to form the system message. That message list is then passed to `runLLMIteration()` in the agent loop, which calls the LLM provider’s `Chat()` with it. For heartbeat, the same agent (and same context builder) is used; the only difference is the user message (the heartbeat prompt from `buildPrompt()`). Optionally, `BuildMessages()` appends "Current Session" (channel/chatID) and "Summary of Previous Conversation" when those are provided.

### Full prompt (template)

**Short placeholder template (what parts are available):**  
Parts are joined by `\n\n---\n\n`. Part 1 is always present; Parts 2–4 and the suffix are included only when applicable.

```
[Part 1 – always]  <now>  <runtime>  <workspacePath>  <toolsSection>  + Important Rules
---
[Part 2 – optional]  Bootstrap: for each existing file (AGENTS.md, SOUL.md, USER.md, IDENTITY.md) → ## <filename> + <contents>
---
[Part 3 – optional]  Skills: # Skills + <skills> XML block (one <skill> per skill)
---
[Part 4 – optional]  Memory: # Memory + ## Long-term Memory + ## Recent Daily Notes
---
[Optional suffix]  ## Current Session (<channel>, <chatID>)  and/or  ## Summary of Previous Conversation (<summary>)
```

The system prompt is the concatenation of the following parts, joined by `\n\n---\n\n`. Below, each part is shown with **example full content** as filled by the code (from the actual implementations).

**Part 1 – Identity (from `getIdentity()`):**

Time uses format `2006-01-02 15:04 (Monday)`. Runtime is `GOOS GOARCH, Go version`. Workspace is the absolute path. The tools section is built by `buildToolsSection()` from `ToolRegistry.GetSummaries()`: each tool is one line `` - `name` - description ``.

Example with all built-in tools registered:

```
# picoclaw 🦞

You are picoclaw, a helpful AI assistant.

## Current Time
2026-02-17 14:30 (Monday)

## Runtime
darwin arm64, Go 1.22.0

## Workspace
Your workspace is at: <workspacePath>/picoclaw
- Memory: <workspacePath>/picoclaw/memory/MEMORY.md
- Daily Notes: <workspacePath>/picoclaw/memory/YYYYMM/YYYYMMDD.md
- Skills: <workspacePath>/picoclaw/skills/{skill-name}/SKILL.md

## Available Tools <toolsSection>

**CRITICAL**: You MUST use tools to perform actions. Do NOT pretend to execute commands or schedule tasks.

You have access to the following tools:

- `read_file` - Read the contents of a file
- `write_file` - Write content to a file
- `list_dir` - List files and directories in a path
- `edit_file` - Edit a file by replacing old_text with new_text. The old_text must exist exactly in the file.
- `append_file` - Append content to the end of a file
- `message` - Send a message to user on a chat channel. Use this when you want to communicate something.
- `exec` - Execute a shell command and return its output. Use with caution.
- `cron` - Schedule reminders, tasks, or system commands. IMPORTANT: When user asks to be reminded or scheduled, you MUST call this tool. Use 'at_seconds' for one-time reminders (e.g., 'remind me in 10 minutes' → at_seconds=600). Use 'every_seconds' ONLY for recurring tasks (e.g., 'every 2 hours' → every_seconds=7200). Use 'cron_expr' for complex recurring schedules. Use 'command' to execute shell commands directly.
- `spawn` - Spawn a subagent to handle a task in the background. Use this for complex or time-consuming tasks that can run independently. The subagent will complete the task and report back when done.
- `subagent` - Execute a subagent task synchronously and return the result. Use this for delegating specific tasks to an independent agent instance. Returns execution summary to user and full details to LLM.
- `web_search` - Search the web for current information. Returns titles, URLs, and snippets from search results.
- `web_fetch` - Fetch a URL and extract readable content (HTML to text). Use this to get weather info, news, articles, or any web content.
- `i2c` - Interact with I2C bus devices for reading sensors and controlling peripherals. Actions: detect (list buses), scan (find devices on a bus), read (read bytes from device), write (send bytes to device). Linux only.
- `spi` - Interact with SPI bus devices for high-speed peripheral communication. Actions: list (find SPI devices), transfer (full-duplex send/receive), read (receive bytes). Linux only.

## Important Rules

1. **ALWAYS use tools** - When you need to perform an action (schedule reminders, send messages, execute commands, etc.), you MUST call the appropriate tool. Do NOT just say you'll do it or pretend to do it.

2. **Be helpful and accurate** - When using tools, briefly explain what you're doing.

3. **Memory** - When remembering something, write to <workspacePath>/picoclaw/memory/MEMORY.md
```

**Part 2 – Bootstrap files (from `LoadBootstrapFiles()`):**  
For each of `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md` present under the workspace, a block is appended. Example when `IDENTITY.md` exists:

```
## IDENTITY.md

I prefer to be called Alex. Keep responses concise.
```

**Part 3 – Skills (from `BuildSkillsSummary()`):**  
If any skills exist, the block is XML from `SkillsLoader.BuildSkillsSummary()`: `<skills>` with one `<skill>` per skill; each has `<name>`, `<description>`, `<location>` (path to SKILL.md), and `<source>` (`workspace`, `global`, or `builtin`). Example with two skills:

```
# Skills

The following skills extend your capabilities. To use a skill, read its SKILL.md file using the read_file tool.

<skills>
  <skill>
    <name>my-skill</name>
    <description>Custom workspace skill for project helpers.</description>
    <location><workspacePath>/picoclaw/skills/my-skill/SKILL.md</location>
    <source>workspace</source>
  </skill>
  <skill>
    <name>calendar</name>
    <description>Read and create calendar events.</description>
    <location><workspacePath>/picoclaw/skills/calendar/SKILL.md</location>
    <source>builtin</source>
  </skill>
</skills>
```

**Part 4 – Memory (from `cb.memory.GetMemoryContext()`):**  
Included only when there is long-term memory or recent daily notes. Long-term is raw contents of `memory/MEMORY.md`. Recent daily notes are the last 3 days’ files from `memory/YYYYMM/YYYYMMDD.md`, joined with `---`. Example:

```
# Memory

## Long-term Memory

User's name is Alex. Prefers dark mode. Has a cat named Nala.

---

## Recent Daily Notes

# 2026-02-17

Checked mailbox. No urgent items.

---

# 2026-02-16

Meeting with team at 3pm. Reminder set.
```

**Optional suffix in `BuildMessages()`:**  
When `channel` and `chatID` are non-empty:

```
## Current Session
Channel: telegram <channel>
Chat ID: 123456789 <chatID>
```

When a conversation summary exists (from previous summarization):

```
## Summary of Previous Conversation

User asked about setting a reminder. Assistant used the cron tool to schedule it. User confirmed.
```

So the **full** system prompt at send time is: the four parts above (identity + bootstrap + skills + memory), optionally followed by Current Session and Summary of Previous Conversation.

---

## Conversation summarization prompt

### Function

`summarizeBatch()` in `pkg/agent/loop.go`.

### Context

When a session’s history exceeds the configured threshold, `maybeSummarize()` triggers `summarizeSession()`. `summarizeSession()` takes the older part of the history (all but the last 4 messages), optionally splits it into two batches, and calls `summarizeBatch()` for each. The result is stored as the session summary and the history is truncated. This prompt is the only user message sent for that LLM call (no system message from the main agent; it’s a dedicated summarization call).

### Full prompt

The prompt is built in code as: a fixed instruction line, then optionally "Existing context: " + existingSummary, then "CONVERSATION:" and one line per message in the batch (`role: content`). Example with existing summary and a short conversation:

```
Provide a concise summary of this conversation segment, preserving core context and key points.
Existing context: User previously asked about the weather.

CONVERSATION:
user: Can you set a reminder for my meeting at 3pm tomorrow?
assistant: I'll schedule that for you.
user: Thanks!
assistant: Done. I've set a reminder for 3pm tomorrow using the cron tool.
```

---

## Merge summaries prompt

### Function

Inline in `summarizeSession()` in `pkg/agent/loop.go`, built with `fmt.Sprintf` and sent as a single user message to `provider.Chat()`.

### Context

When the history to summarize is long (>10 messages), it is split into two halves. Each half is summarized with `summarizeBatch()`. This merge prompt is then used in a separate LLM call to combine the two summaries into one. The response becomes the final summary for the session.

### Full prompt (template)

The prompt is built with `fmt.Sprintf("Merge these two conversation summaries into one cohesive summary:\n\n1: %s\n\n2: %s", s1, s2)` where `s1` and `s2` are the strings returned by `summarizeBatch()` for the first and second half. Example with real-looking summaries:

```
Merge these two conversation summaries into one cohesive summary:

1: <s1> User asked about setting reminders. Assistant explained the cron tool and set a one-time reminder for 3pm. User confirmed.

2: <s2> User requested a recurring daily reminder at 9am. Assistant used cron with every_seconds=86400 and command. User thanked.
```

The LLM response becomes the final session summary.

---

## Subagent system prompt

### Function

`runTask()` in `pkg/tools/subagent.go`. The literal system prompt is assigned to `systemPrompt`; the user message is `task.Task`.

### Context

When the user (or main agent) invokes the spawn/subagent tool, `SubagentManager.runTask()` runs. It builds a two-message list (system + user), then calls `RunToolLoop()` with the same tool registry and provider. The subagent therefore sees this short system prompt and the task text, and can use tools until completion. The result is sent back to the main agent via the system channel.

### Full prompt (system message)

```
You are a subagent. Complete the given task independently and report the result.
You have access to tools - use them as needed to complete your task.
After completing the task, provide a clear summary of what was done.
```

**User message:** The task string passed to the subagent (from the tool arguments).

**Tool section and skills section:** No. The subagent system prompt is only the short text above. It does **not** include the main agent’s "Available Tools" block (the CRITICAL instruction and the list of tool names/descriptions) or the "# Skills" block. The subagent can still use tools because `RunToolLoop()` passes `ToolRegistry.ToProviderDefs()` to the provider, so the model receives tool definitions in the API call and can invoke them; the system message itself does not list tools or skills.

---

## Sync subagent system prompt (SubagentTool)

### Function

`Execute()` of `SubagentTool` in `pkg/tools/subagent.go`. The system message is a literal string; the user message is `task` from the tool arguments.

### Context

When the user (or main agent) calls the synchronous subagent tool (not the async spawn tool), this prompt is used. `SubagentTool.Execute()` builds a two-message list and calls `RunToolLoop()` with the same registry and provider. The run is blocking; the result is returned in the tool result to the main agent.

### Full prompt (system message)

```
You are a subagent. Complete the given task independently and provide a clear, concise result.
```

**User message:** The task string from the tool’s `task` argument.

**Tool section and skills section:** No. Same as the async subagent: the system prompt is only the one line above; no "Available Tools" text and no skills section. Tools are available via the API tool definitions from the same registry.

---

## Heartbeat prompt (user message)

### Function

`buildPrompt()` in `pkg/heartbeat/service.go`.

### Context

The heartbeat service runs on a timer. On each run, it reads the `HEARTBEAT.md` file from the workspace.

If the file is missing, the service creates the default template by calling `createDefaultHeartbeatTemplate()` and returns an empty prompt. This causes the current heartbeat run to do nothing.

If `HEARTBEAT.md` exists and is non-empty, the service constructs the heartbeat prompt using its contents and passes this prompt to the configured handler. The handler (in `cmd/picoclaw/main.go`) then calls the agent’s `ProcessHeartbeat(ctx, prompt, channel, chatID)` method.

When processing a heartbeat, the agent uses the **same** system prompt as in normal chat (built from `BuildSystemPrompt()`). The only difference is that, for heartbeat runs, the user message passed to the LLM is this heartbeat prompt, whereas in normal operation it is a user chat message.

### Full prompt (template)

The prompt is built with `fmt.Sprintf(...)` using the current time in format `2006-01-02 15:04:05` and the raw contents of `HEARTBEAT.md`. Example with real time and example file content:

```
# Heartbeat Check

Current time: 2026-02-17 14:30:00

You are a proactive AI assistant. This is a scheduled heartbeat check.
Review the following tasks and execute any necessary actions using available skills.
If there is nothing that requires attention, respond ONLY with: HEARTBEAT_OK

# Heartbeat Check List

This file contains tasks for the heartbeat service to check periodically.

## Examples

- Check for unread messages
- Review upcoming calendar events
- Check device status (e.g., MaixCam)

## Instructions

- Execute ALL tasks listed below. Do NOT skip any task.
- For simple tasks (e.g., report current time), respond directly.
- For complex tasks that may take time, use the spawn tool to create a subagent.
- The spawn tool is async - subagent results will be sent to the user automatically.
- After spawning a subagent, CONTINUE to process remaining tasks.
- Only respond with HEARTBEAT_OK when ALL tasks are done AND nothing needs attention.

---

Add your heartbeat tasks below this line:

- Report current time
- Check if there are any reminders due in the next hour
```

So the **full** LLM input for a heartbeat run is: the main agent system prompt (see **Main agent system prompt** above) as the system message, and the above string as the single user message.
