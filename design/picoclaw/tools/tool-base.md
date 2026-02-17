# Tool Management: Core Logic

The `pkg/tools` package provides a small library to define, register, and run tools that an LLM can call. It does not describe any specific tool; it defines the interfaces, result model, registry, and the loop that connects tools to the LLM.

## Tool contract

Every tool implements the **Tool** interface: it has a name, a description, and a JSON-schema-style parameter map. Execution is a single method that takes a context and an arguments map and returns a **ToolResult**. The name is the unique key used by the registry and by the LLM to refer to the tool.

Two optional extensions exist. **ContextualTool** adds `SetContext(channel, chatID)`. The registry calls this before execution when channel and chat ID are provided, so tools that need to know the current conversation (e.g. to send a message) can use that. **AsyncTool** adds `SetCallback(cb)`. The registry can inject a completion callback before execution; the tool may return immediately and invoke the callback later. This supports long-running or background work without blocking the agent loop.

Tools are described for the LLM via **ToolToSchema**: it turns a Tool into a single `type: "function"` object with `name`, `description`, and `parameters`. The registry uses this to build the full list of definitions passed to the provider.

```go
package tools

import "context"

// Tool is the interface that all tools must implement.
// Name is the unique key used by the registry and by the LLM (e.g. "read_file", "message").
// Parameters returns a JSON Schema object for the LLM; see sample below.
type Tool interface {
	Name() string
	Description() string
	Parameters() map[string]interface{}
	Execute(ctx context.Context, args map[string]interface{}) *ToolResult
}

// ContextualTool is optional. Implement it when the tool needs the current
// channel and chat ID (e.g. to send a message to the right conversation).
// The registry calls SetContext before Execute when channel/chatID are provided.
type ContextualTool interface {
	Tool
	SetContext(channel, chatID string)
}

// AsyncCallback is invoked by an async tool when its background work completes.
// Purpose: let the agent loop react to completion without blocking (e.g. inject a follow-up message).
type AsyncCallback func(ctx context.Context, result *ToolResult)

// AsyncTool is optional. Implement it for long-running or background work.
// The tool returns AsyncResult(...) immediately; when done, it calls the callback set by SetCallback.
type AsyncTool interface {
	Tool
	SetCallback(cb AsyncCallback)
}

// ToolToSchema converts a tool into the OpenAI-style schema sent to the LLM.
// Sample output: {"type":"function","function":{"name":"read_file","description":"...","parameters":{...}}}
func ToolToSchema(tool Tool) map[string]interface{}
```

Sample **Parameters()** return (JSON Schema for one string argument):

```go
map[string]interface{}{
	"type": "object",
	"properties": map[string]interface{}{
		"path": map[string]interface{}{
			"type":        "string",
			"description": "Path to the file to read",
		},
	},
	"required": []string{"path"},
}
```

## Result model

**ToolResult** is the only return type from tool execution. It separates three concerns: what the model sees, what the user sees, and how the system should treat the outcome.

**ForLLM** is always set and is the text that gets sent back to the LLM as the tool result (e.g. in the "tool" message). **ForUser** is optional; when non-empty and not suppressed, it can be shown directly to the user. **Silent** suppresses user-facing output even if ForUser is set; useful for internal or background actions. **IsError** marks the result as a failure so the agent can handle it as an error. **Async** indicates that the tool has started work in the background and will complete via callback later. **Err** is an optional underlying error for logging and is not exposed in JSON.

Helpers construct common shapes: **NewToolResult** (basic ForLLM-only), **SilentResult** (ForLLM, no user message), **AsyncResult** (ForLLM, Async=true), **ErrorResult** (ForLLM + IsError), **UserResult** (same content for both LLM and user). **WithError** attaches an error to any result for chaining.

```go
// ToolResult is the only return type from tool execution.
// Purpose: separate what the LLM sees (ForLLM), what the user sees (ForUser), and outcome flags.
type ToolResult struct {
	ForLLM  string `json:"for_llm"`            // Required. Content sent to LLM as tool result.
	ForUser string `json:"for_user,omitempty"`  // Optional. Shown to user unless Silent is true.
	Silent  bool   `json:"silent"`              // If true, no user message is sent (ForUser ignored).
	IsError bool   `json:"is_error"`           // If true, treat as failure (e.g. for retry or apology).
	Async   bool   `json:"async"`               // If true, tool will complete later via callback.
	Err     error  `json:"-"`                   // Underlying error for logging; not serialized to JSON.
}

// Constructor helpers (all return *ToolResult):
func NewToolResult(forLLM string) *ToolResult       // e.g. NewToolResult("File saved")
func SilentResult(forLLM string) *ToolResult        // LLM-only; no user message
func AsyncResult(forLLM string) *ToolResult         // e.g. AsyncResult("Task started, will report back")
func ErrorResult(message string) *ToolResult       // ForLLM = message, IsError = true
func UserResult(content string) *ToolResult        // Same content for both LLM and user
func (tr *ToolResult) WithError(err error) *ToolResult  // Chain: ErrorResult("failed").WithError(err)
```

## Registry

The **ToolRegistry** holds tools by name in a concurrent map. You **Register** a tool by its name; later registrations overwrite. **Get** looks up by name. **Execute** and **ExecuteWithContext** run a tool: they resolve the tool by name, then optionally set context (for ContextualTool) and callback (for AsyncTool), then call **Execute** and return the **ToolResult**. If the tool is not found, the registry returns an ErrorResult instead of panicking. The registry also logs tool start, completion, async start, and errors with timing.

The registry exposes definitions for the LLM in two ways: **GetDefinitions** returns a slice of schema maps (as from ToolToSchema), and **ToProviderDefs** returns the provider-specific struct format used when calling the LLM API. **List** and **Count** expose registered names and how many tools there are; **GetSummaries** returns short "name - description" lines for humans.

```go
// ToolRegistry holds tools by name (concurrent-safe). Create with NewToolRegistry().
type ToolRegistry struct { ... }

func NewToolRegistry() *ToolRegistry

// Register adds or replaces a tool by its Name(). Purpose: plug in tools at startup or dynamically.
func (r *ToolRegistry) Register(tool Tool)

// Get looks up a tool by name. Second return is false if not found.
func (r *ToolRegistry) Get(name string) (Tool, bool)

// Execute runs a tool by name with the given args. No channel/chatID or async callback.
func (r *ToolRegistry) Execute(ctx context.Context, name string, args map[string]interface{}) *ToolResult

// ExecuteWithContext runs a tool and injects context (ContextualTool) and optional AsyncCallback (AsyncTool).
// Use this from the agent loop when channel/chatID are known; pass nil for asyncCallback in the standard loop.
func (r *ToolRegistry) ExecuteWithContext(ctx context.Context, name string, args map[string]interface{}, channel, chatID string, asyncCallback AsyncCallback) *ToolResult

// Definition export for the LLM:
func (r *ToolRegistry) GetDefinitions() []map[string]interface{}   // Raw schema maps
func (r *ToolRegistry) ToProviderDefs() []providers.ToolDefinition // Provider API format

// Introspection:
func (r *ToolRegistry) List() []string           // All registered tool names
func (r *ToolRegistry) Count() int                // Number of tools
func (r *ToolRegistry) GetSummaries() []string    // e.g. "- `read_file` - Read file contents"
```

## How the LLM invokes a specific tool

This section describes the flow from tool definitions sent to the LLM to execution of a concrete tool and back.

### What the LLM receives

Example (JSON) of the data passed to the provider on each request — i.e. the result of **ToProviderDefs()** for a registry with one tool, e.g. `read_file`:

```json
[
  {
    "type": "function",
    "function": {
      "name": "read_file",
      "description": "Read the contents of a file at the given path.",
      "parameters": {
        "type": "object",
        "properties": {
          "path": {
            "type": "string",
            "description": "Path to the file to read"
          }
        },
        "required": ["path"]
      }
    }
  }
]
```

On each request, the loop passes this list to the provider. Each element has **type** `"function"` and a **function** object with **name** (same as the tool’s `Name()`), **description**, and **parameters** (JSON Schema). The LLM only sees these schemas; it does not see Go code or the registry.

### What the LLM returns when it wants to call a tool

Example (JSON) of the **LLMResponse** when the model decides to call a tool — i.e. the return value of `Chat()` with tool calls:

```json
{
  "content": "I'll read that file for you.",
  "tool_calls": [
    {
      "id": "call_abc123",
      "type": "function",
      "function": {
        "name": "read_file",
        "arguments": "{\"path\": \"/tmp/foo\"}"
      }
    }
  ],
  "finish_reason": "tool_calls"
}
```

The provider parses the model’s output and populates **tool_calls**; each entry is a single tool invocation. In our code, `Arguments` is already a key-value map (e.g. `{"path": "/tmp/foo"}`), not the raw JSON string. Each tool call has:

- **id** — Provider-generated (e.g. `call_abc123`); used to attach the tool result message later.
- **name** — Tool name from the definitions (e.g. `read_file`); the loop uses this to select the tool in the registry.
- **arguments** — Map of argument names to values, conforming to the tool’s parameters schema; the loop passes it to `Execute` without re-validating.

If **tool_calls** is empty, the loop treats the turn as finished and uses **content** as the final answer.

### How the loop dispatches to a specific tool

Example (JSON) of **one element** of `response.ToolCalls` that the loop consumes — name and arguments are what get passed into the registry:

```json
{
  "id": "call_abc123",
  "name": "read_file",
  "arguments": {
    "path": "/tmp/foo"
  }
}
```

For each such item, the loop takes **name** and **arguments** and calls `ToolRegistry.ExecuteWithContext(ctx, name, arguments, channel, chatID, nil)`. The tool that runs is determined only by **name**: the registry’s `Get(name)` resolves the tool, then the registry sets context/callback if the tool implements `ContextualTool` or `AsyncTool`, and calls `Execute(ctx, arguments)`. There is no separate “tool call router”; the registry map from name to tool is the only dispatch logic.

### How the result is fed back to the LLM

Example (JSON) of the **tool result message** appended to the conversation after running a tool (equivalent to `providers.Message` with role `"tool"`):

```json
{
  "role": "tool",
  "content": "Hello from /tmp/foo\n",
  "tool_call_id": "call_abc123"
}
```

The loop sets **role** to `"tool"`, **content** from `ToolResult.ForLLM` (or the tool’s error string if `ForLLM` is empty), and **tool_call_id** to the same **id** as the corresponding tool call. This message is appended to the message list; the next LLM call sees the assistant message (with tool calls) and these tool messages (each tied by **tool_call_id**). The model can then call more tools or respond with final text. So the flow is: LLM requests a tool by **name** with **arguments**; the loop runs the tool and sends back a tool message with the same call **id** and the result in **content**.

## Tool loop

The **RunToolLoop** function is the core loop that alternates between the LLM and tool execution. It takes a config (provider, model, **ToolRegistry**, max iterations, LLM options), the current message list, and channel/chatID for context.

Each iteration: build tool definitions from the registry (**ToProviderDefs**), call the LLM with the current messages and those definitions. If the LLM response has no tool calls, the loop finishes and returns the final text content. Otherwise, the loop appends an assistant message that includes the tool calls, then for each tool call it runs **ExecuteWithContext** on the registry with the tool name, parsed arguments, channel, chatID, and (in this loop) no async callback. Each **ToolResult.ForLLM** (or the underlying error string if ForLLM is empty) is appended as a tool result message with the corresponding tool call ID. The loop then continues with the updated message list so the next LLM call sees the tool results. Iteration stops when the LLM responds without tool calls or when max iterations is reached.

So the flow is: registry owns tool set and schema; the loop pulls definitions from the registry, gets tool calls from the LLM, runs them through the registry with context, and feeds results back into the message history. Individual tools are not referenced by the loop—only the registry and the ToolResult contract are.

```go
// ToolLoopConfig configures one run of the LLM + tool loop.
// Purpose: pass provider, model, tool set, and iteration limit so RunToolLoop can be reused (e.g. main agent vs subagent).
type ToolLoopConfig struct {
	Provider      providers.LLMProvider  // LLM to call
	Model         string                 // e.g. "gpt-4o"
	Tools         *ToolRegistry          // Tool set; can be nil (no tools)
	MaxIterations int                    // Cap iterations to avoid infinite loops
	LLMOptions    map[string]any         // e.g. map[string]any{"max_tokens": 4096, "temperature": 0.7}
}

// ToolLoopResult is the outcome when the loop exits (no more tool calls or max iterations).
type ToolLoopResult struct {
	Content    string // Final assistant text when the LLM stopped with no tool calls
	Iterations int    // Number of LLM rounds executed
}

// RunToolLoop runs the core agent loop: LLM call -> if tool calls then execute via registry -> append tool results -> repeat.
// messages: conversation so far (including system/user); channel/chatID passed to ExecuteWithContext for contextual tools.
func RunToolLoop(ctx context.Context, config ToolLoopConfig, messages []providers.Message, channel, chatID string) (*ToolLoopResult, error)
```
