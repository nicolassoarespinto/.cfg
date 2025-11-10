#!/usr/bin/env bash
# Reset tmux theme to defaults without restarting server

# Status bar options
tmux set-option -gu status-style
tmux set-option -gu status-left
tmux set-option -gu status-right
tmux set-option -gu status-left-length
tmux set-option -gu status-right-length
tmux set-option -gu status-interval

# Pane options
tmux set-option -gu pane-active-border-style
tmux set-option -gu pane-border-style

# Message options
tmux set-option -gu message-style

# Window options
tmux set-window-option -gu window-status-current-format
tmux set-window-option -gu window-status-format
tmux set-window-option -gu window-status-activity-style
tmux set-window-option -gu window-status-bell-style
tmux set-window-option -gu window-style

echo "✓ Tmux theme reset to defaults"
