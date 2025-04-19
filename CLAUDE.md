# Dotfiles Repository Guide

## Repository Structure
- `/nvim/` - Neovim configuration (primary component)
  - `/init.lua` - Entry point that loads custom configurations
  - `/lua/custom/` - Core configuration modules
  - `/lua/custom/lazy/` - Plugin specifications organized by functionality
  - `/plugin/` - Global plugin configurations
- `/.tmux.conf` - Tmux configuration file (terminal multiplexer)

## Package Management
- Neovim: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- LSP: Uses Mason for language server installation and management
- Plugin specs are modular files in `lua/custom/lazy/` that return table configurations

## Configuration Architecture
- Neovim: Modular design with clear separation of concerns:
  - `set.lua` - Global Vim options and settings
  - `remap.lua` - Key mappings and custom functions
  - `lazy_init.lua` - Package manager initialization
  - `style.lua` - Theme and visual customizations
  - `completion.lua` - Completion engine configuration
- Tmux: Single configuration file with screen-like key bindings
  - Uses C-a as the prefix key (instead of default C-b)
  - Configured with vim-like navigation (h,j,k,l for pane movement)

## Development Workflow
- Install plugins: Neovim will auto-install on first run
- Update plugins: `:Lazy update` inside Neovim
- Code formatting: Uses `stylua` for Lua (installed via Mason)
- Testing changes: Source current file with `:so %`
- Reload tmux config: `tmux source-file ~/.tmux.conf` or prefix+r

## Code Style Guidelines
- Indentation: 4 spaces
- Naming: Use descriptive, lowercase names with underscores
- Configuration: Use table-based configs with meaningful structure
- Error handling: Use pcall for potentially failing operations
- Comments: Document non-obvious functionality

## Tools and Integrations
- LSP support for multiple languages (Lua, Python, Bash)
- Completion: nvim-cmp with multiple sources, including Copilot
- Terminal integration via various terminal plugins
- Markdown support with dedicated plugins
- Tmux for terminal session management and multiplexing

## Adding New Configurations
- Follow the modular pattern - create dedicated files for related functionality
- For new plugins, add them to `lua/custom/lazy/` with appropriate dependencies
- Maintain existing organization and structure