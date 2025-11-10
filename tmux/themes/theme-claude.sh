#!/usr/bin/env bash
# Claude's Twilight Theme - A deep ocean twilight palette for focused work
# Colors inspired by the quiet hours between sunset and night

# Color palette - Deep ocean twilight with warm accents
deep_indigo="#1a1d2e"        # Background - deep blue-gray
midnight_blue="#252836"      # Secondary background
ocean_blue="#414561"         # Tertiary background
slate="#6c7086"              # Muted text
pearl="#e0def4"              # Primary text - soft warm white
amber="#f6c177"              # Warm accent - like distant city lights
rose_gold="#ea9a97"          # Secondary accent
lavender="#c4a7e7"           # Highlight - soft purple
seafoam="#9ccfd8"            # Info color - calm cyan
pine="#56949f"               # Borders - muted teal

# Status bar styling - elegant and unobtrusive
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${pearl},bg=${deep_indigo}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session name with warm amber glow (changes to rose gold on prefix)
tmux set-option -g status-left "#{?client_prefix,#[fg=${deep_indigo}],#[fg=${deep_indigo},bg=${amber}]} ◆ #S #[fg=${pearl},bg=${deep_indigo}] "

# Right side: Minimalist time display with subtle separator
tmux set-option -g status-right "#[fg=${slate}]│ #[fg=${lavender}]%a %m/%d #[fg=${slate}]│ #[fg=${seafoam}]%H:%M "

# Window styling - clear hierarchy
# Current window: lavender background with pearl text
tmux set-window-option -g window-status-current-format "#[fg=${pearl},bg=${ocean_blue},bold] #I #[fg=${amber}]❯#[fg=${pearl}] #W "

# Inactive windows: subtle and calm
tmux set-window-option -g window-status-format "#[fg=${slate},bg=${midnight_blue}] #I #[fg=${slate}]│ #W "

# Activity indicators
tmux set-window-option -g window-status-activity-style "fg=${rose_gold},bold"
tmux set-window-option -g window-status-bell-style "fg=${amber},bold,blink"

# Pane borders - subtle pine for inactive, warm lavender for active
tmux set-option -g pane-border-style "fg=${pine}"
tmux set-option -g pane-active-border-style "fg=${lavender}"

# Message styling - gentle on the eyes
tmux set-option -g message-style "fg=${pearl},bg=${ocean_blue}"
tmux set-option -g message-command-style "fg=${amber},bg=${ocean_blue}"

# Copy mode - inverted colors for clear distinction
tmux set-option -g mode-style "fg=${deep_indigo},bg=${seafoam}"

# Pane content - slightly lighter background for depth
tmux set-window-option -g window-style "fg=${pearl},bg=${midnight_blue}"
tmux set-window-option -g window-active-style "fg=${pearl},bg=${deep_indigo}"

# Clock mode (prefix + t) - matching theme
tmux set-option -g clock-mode-colour "${seafoam}"
tmux set-option -g clock-mode-style 24
