#!/usr/bin/env bash
# Minimal Nord-inspired theme - self-contained

# Color definitions
gray_light="#D8DEE9"
gray_medium="#ABB2BF"
gray_dark="#3B4252"
green_soft="#A3BE8C"
blue_muted="#81A1C1"
cyan_soft="#88C0D0"

# Status bar position and length
tmux set-option -g status-position bottom
tmux set-option -g status-left-length 100

# Status bar styling
tmux set-option -g status-style "fg=${gray_light},bg=default"

# Left side: session name
tmux set-option -g status-left "#[fg=${green_soft},bold] #S #[fg=${gray_light},nobold] | "

# Right side: cpu and memory (requires tmux plugins)
tmux set-option -g status-right " #{cpu}   #{mem} "

# Window status format
tmux set-window-option -g window-status-current-format "#[fg=${cyan_soft},bold]  #[underscore]#I:#W"
tmux set-window-option -g window-status-format " #I:#W"

# Message styling
tmux set-option -g message-style "fg=${gray_light},bg=default"

# Copy mode styling
tmux set-option -g mode-style "fg=${gray_dark},bg=${blue_muted}"

# Pane border styling
tmux set-option -g pane-border-style "fg=${gray_dark}"
tmux set-option -g pane-active-border-style "fg=${green_soft}"
