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
- Fixing `claude-status-hook` wiring (unrelated, deferred by user to a later task).
- Cost-based (API pay-as-you-go) reporting — not applicable to a subscription plan.
