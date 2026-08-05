# Yazi config improvements

## Goal
Bring yazi in line with the rest of the dotfiles (kanagawa theme used by tmux/nvim), remove dead config, and add a small set of high-value plugins/keymaps using tools already installed (`csv-peek`, `fzf`, `zoxide`).

## Changes

### 1. Theme (`yazi/theme.toml`)
- `dark = "kanagawa"` (was `catppuccin-mocha`), using the already-vendored `yazi/flavors/kanagawa.yazi`.
- `light = "gruvbox"` unchanged.

### 2. Previewers (`yazi/yazi.toml`)
- Remove the commented-out duckdb blocks under `[plugin]` (`prepend_previewers` / `prepend_preloaders`) — duckdb isn't installed and isn't in scope.
- Add a shell-based previewer for `*.csv` / `*.tsv` that pipes through `csv-peek` (already in `tools/csv-peek`, installed as a `uv tool`) to render a quick formatted table in the preview pane.

### 3. Plugins
- Install `yazi-rs/plugins:full-border` via `ya pkg add` — adds clean unicode borders around the three panes. Purely cosmetic, no config beyond enabling it in `init.lua`.

### 4. Keymap (`yazi/keymap.toml`, new file)
Light-touch — only additive bindings via `prepend_keymap`, everything else stays default:
- `<C-f>`: fuzzy-find a file in the current directory via `fzf` and jump to it (shell-out, no plugin needed — standard yazi recipe).
- `<C-g>`: fuzzy-jump to a `zoxide`-tracked directory (shell-out).

### 5. `init.lua` (new file)
- Required to enable `full-border` plugin (`require("full-border"):setup()`).

## Out of scope
- No duckdb previewer (not installed).
- No broader keymap overhaul — defaults stay intact except the two new bindings.
- No changes to `flavors/` beyond using the existing kanagawa flavor already vendored.
