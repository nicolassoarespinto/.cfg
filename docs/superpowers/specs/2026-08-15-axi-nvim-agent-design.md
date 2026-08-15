# nvim-agent as an AXI tool

## Purpose

Redesign `bin/nvim-agent` in place so agents can interact with a running
Neovim server (`nvim --listen SOCKET`) as a proper AXI tool: structured
token-efficient output, definitive errors, zero-friction discovery — not
just a thin shell wrapper around `--remote-expr`/`--remote-send`.

## Scope

In scope:
- Redesigning `nvim-agent`'s command surface, output, discovery, and errors.
- Reusing `herdr-nvim-server`'s socket-naming convention for discovery.
- A `state` command exposing buffers, cursor, and diagnostics as one
  aggregate read, per AXI §4.
- Automated tests driving a real headless `nvim --listen` instance.

Out of scope (explicit follow-up):
- AXI §7 session-start hook integration (ambient context at session boot).
- Buffer editing / applying patches directly into open buffers.
- Scanning for arbitrary live sockets outside the HerdR workspace convention.

## Transport

Undecided by design, decided by prototype: implementation starts by
spiking the `state` and `lua` commands two ways —

1. Shelling to `nvim --remote-expr` / `--remote-send` (today's approach,
   bash + jq, zero extra dependencies).
2. Direct msgpack-RPC via `pynvim` (`nvim_list_bufs`, `nvim_win_get_cursor`,
   `nvim_exec_lua`, no shell-escaping of Lua-in-JSON-in-string).

Whichever is less code and more reliable for `state` wins, and decides the
implementation language for the whole tool (bash+jq vs Python). The command
surface below is identical either way.

## Discovery

Resolution order, matching `herdr-nvim-server`:

1. `--server SOCKET` flag (explicit override)
2. `NVIM_AGENT_SERVER` env var
3. `HERDR_PLUS_WORKSPACE_ID` / `HERDR_WORKSPACE_ID` env var → socket
   `${XDG_RUNTIME_DIR:-/tmp}/nvim-agent-<workspace>.sock`
4. cwd → `git rev-parse --show-toplevel` → HerdR workspace lookup (same
   fallback `herdr-nvim-server` uses) → same socket path pattern

If no socket resolves, or the resolved socket isn't live, fail with a
structured error suggesting `herdr-nvim-server` as the fix — never a
silent no-op.

## Command surface

- `nvim-agent` (no args) — home view: bin path, one-line description,
  current `state` summary, contextual next-step suggestions. Content
  first (AXI §8), not a usage dump.
- `nvim-agent state [--full-diagnostics] [--fields ...]` — aggregate read:
  current buffer (name, filetype, modified), cursor (line, col), open
  buffer list (bufnr, name, modified — 3-4 fields, not full listing),
  diagnostics (counts by severity + up to 3 messages with file:line,
  truncated with a `--full-diagnostics` escape hatch per AXI §3).
- `nvim-agent quickfix [--title TITLE] [--no-open] FILE[:LINE]...` —
  unchanged behavior, restyled output/errors; flags free to adjust if AXI
  conventions call for it (confirmed nothing else in the repo depends on
  the current invocation shape).
- `nvim-agent codediff [CODEDIFF-ARGS...]` — unchanged behavior, restyled
  output/errors.
- `nvim-agent lua LUA-CHUNK` — unchanged behavior, restyled output/errors.
- Global flags: `--server SOCKET`, `--help`/`-h` (per-command, concise,
  AXI §10), `--version`/`-v`/`-V` (fast path, must not pay for loading the
  full command graph — relevant mainly if the pynvim/Python path wins).

## Output & errors

- TOON on stdout for all structured output (AXI §1).
- Definitive empty states ("0 open buffers", not blank) (AXI §5).
- Errors go to stdout in the same TOON-ish structured shape, with an
  actionable `help` line; dependency errors (nvim RPC failures) are
  translated, never leaked raw (AXI §6).
- Exit codes: 0 success/no-op, 1 error, 2 usage error.
- Unknown flags/commands rejected loudly (exit 2) with the command's
  valid flags listed inline — never silently ignored (AXI §6).
- Contextual suggestions after list/mutation output, parameterized
  placeholders for dynamic values (AXI §9).

## Testing

Automated, script-driven (no human in the loop for this round):
a test script launches a real headless `nvim --listen SOCKET` instance,
drives every subcommand (`state`, `quickfix`, `codediff`, `lua`, error
paths: bad flag, dead socket, missing required arg), and asserts on the
actual stdout/exit code. This replaces manual smoke-testing for this
implementation pass.

## Deferred

- SessionStart hook (Claude Code / Codex) surfacing `state` automatically
  at session boot, plus an installable Skill as the lower-overhead
  secondary discovery path (AXI §7). Follow-up spec once the core CLI is
  proven useful on-demand.
