# Live Claude usage popup

## Problem
User is on a Claude Pro/Max subscription (rolling 5-hour usage blocks) and wants a quick way to check current usage and estimated time remaining before hitting the block limit, to help budget token usage.

## Approach
Wrap [ccusage](https://github.com/ryoppippi/ccusage) (reads Claude Code's local JSONL usage logs, no API calls) in a small refresh loop, surfaced via a tmux popup keybinding — matching the existing pattern in `tmux/tmux.conf` (`y` → claude-dashboard, `D` → lazydocker, `w`/`z`/`f` → sessionizers).

Considered alternatives:
- **Always-visible corner pane** — rejected by user in favor of on-demand popup (costs permanent screen space).
- **ccusage's built-in `--live` flag** — does not exist in the installed version (20.0.19); dropped/renamed upstream. Replaced with a manual clear/run/read-with-timeout loop.

## Implementation
- **`bin/claude-usage`**: self-installs `ccusage` globally via bun if missing, then loops: clear screen → `ccusage blocks --active --offline` → wait up to 3s or until `q` is pressed → repeat.
- **`tmux/tmux.conf`**: add `bind-key u display-popup -E -w 60 -h 24 "~/dotfiles/bin/claude-usage"` near the other popup bindings (~line 120). `prefix+u` was verified unbound (no default tmux binding, no existing config binding).
- Popup closes on `q` (script exits, `-E` closes the popup) or `Esc` (tmux's native popup-close behavior).

`ccusage blocks --active` reports, per current 5-hour block: elapsed/remaining time, input/output tokens, cost-equivalent, burn rate (tokens/min, cost/hour), and a projection at current rate. `Time Remaining` directly answers "how long until I hit the limit."

## Out of scope
- Cost-based (API pay-as-you-go) reporting — not applicable to a subscription plan.
- Fable/Opus-specific weekly limit bar — deferred by user for a later iteration.

## Revision: real quota bars (2026-07-30)
Follow-up requirement: show actual progress toward the session (5h) and weekly (7d) limits, matching `claude /usage`'s real percentages — not a time-elapsed proxy.

Discovery: Claude Code's `statusLine` hook receives a `rate_limits` object on every render (`five_hour`/`seven_day`, each with `used_percentage` and `resets_at` epoch) — this is the same account-level data `/usage` displays, sourced from Anthropic's backend rather than local logs. Schema found embedded in the `claude` binary itself (`strings` on `~/.local/share/claude/versions/*`).

This required activating hook wiring that had been dormant:
- `claude/settings.json` (dotfiles) had a JSON syntax error (missing comma) and was never applied to `~/.claude/settings.json` — so neither the `statusLine` hook nor `claude-status-hook` (used by `claude-dashboard`) were ever active. Fixed the syntax error and merged `hooks`/`statusLine` into the live `~/.claude/settings.json` (backed up first), preserving existing keys.
- `bin/claude-statusline` now caches `.rate_limits` from each invocation's stdin JSON to `~/.cache/claude-usage/rate_limits.json`, whenever present.
- `bin/claude-usage` reads that cache and renders `[####......] NN%` bars plus a `resets in Xh Ym` countdown for both windows, above the existing ccusage token/burn-rate block. Falls back to a "no data yet" message until a session has rendered a statusline at least once.

Popup enlarged to `-w 80 -h 32`, anchored top-right via `-x R -y 0`.
