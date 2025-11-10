#!/usr/bin/env bash
# Gruvbox Theme for tmux - Perfect match for Neovim Gruvbox
# Retro groove color scheme with warm, earthy tones

# Gruvbox Dark color palette
bg0="#282828"          # Main background
bg1="#3c3836"          # Secondary background
bg2="#504945"          # Tertiary background
bg3="#665c54"          # Darkest gray
bg4="#7c6f64"          # Light gray

fg0="#fbf1c7"          # Brightest foreground
fg1="#ebdbb2"          # Main foreground
fg2="#d5c4a1"          # Muted foreground
fg4="#a89984"          # Dimmed gray

# Gruvbox accent colors
red="#cc241d"          # Dark red
bright_red="#fb4934"   # Bright red
green="#98971a"        # Dark green
bright_green="#b8bb26" # Bright green
yellow="#d79921"       # Dark yellow
bright_yellow="#fabd2f" # Bright yellow
blue="#458588"         # Dark blue
bright_blue="#83a598"  # Bright blue
purple="#b16286"       # Dark purple
bright_purple="#d3869b" # Bright purple
aqua="#689d6a"         # Dark aqua
bright_aqua="#8ec07c"  # Bright aqua
orange="#d65d0e"       # Dark orange
bright_orange="#fe8019" # Bright orange

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg1},bg=${bg1}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session name with yellow/orange accent (changes to red on prefix)
tmux set-option -g status-left "#{?client_prefix,#[fg=${bright_red}],#[fg=${bg0},bg=${bright_yellow},bold]} #S #[fg=${fg1},bg=${bg1}] "

# Right side: Date and time with aqua accent
tmux set-option -g status-right "#[fg=${fg4}]#[fg=${bright_aqua}]%a %m/%d #[fg=${fg4}]│ #[fg=${bright_blue}]%H:%M "

# Window styling
# Current window: bright green accent with bold text
tmux set-window-option -g window-status-current-format "#[fg=${bg0},bg=${bright_green},bold] #I #[fg=${fg0},bg=${bg2},bold] #W "

# Inactive windows: muted with gray
tmux set-window-option -g window-status-format "#[fg=${fg4},bg=${bg1}] #I #[fg=${fg2}]#W "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${bright_orange},bg=${bg1},bold"
tmux set-window-option -g window-status-bell-style "fg=${bright_red},bg=${bg1},bold"

# Pane borders - aqua for inactive, bright orange for active (warm Gruvbox accent)
tmux set-option -g pane-border-style "fg=${bg3}"
tmux set-option -g pane-active-border-style "fg=${bright_orange}"

# Message styling - yellow background like Gruvbox search highlight
tmux set-option -g message-style "fg=${bg0},bg=${bright_yellow},bold"
tmux set-option -g message-command-style "fg=${bg0},bg=${bright_aqua}"

# Copy mode - blue background matching Gruvbox visual mode
tmux set-option -g mode-style "fg=${bg0},bg=${bright_blue},bold"

# Window content styling - subtle background difference
tmux set-window-option -g window-style "fg=${fg1},bg=${bg0}"
tmux set-window-option -g window-active-style "fg=${fg0},bg=${bg0}"

# Clock mode - matching Gruvbox aqua
tmux set-option -g clock-mode-colour "${bright_aqua}"
tmux set-option -g clock-mode-style 24
