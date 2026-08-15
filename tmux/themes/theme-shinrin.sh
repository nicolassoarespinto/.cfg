#!/usr/bin/env bash
# Shinrin Theme (森林) - Boreal Pine & Glacial Mist
# A dark, organic spruce and cool forest palette.
# Built for maximum eye relaxation during long coding hours, with crisp frost text
# and distinct copper/lichen highlights.

# Color Palette
bg_dark="#101516"          # Deepest spruce obsidian
bg_surface="#162022"       # Submerged pine shadow / inactive tabs
bg_highlight="#223336"     # Elevated forest slate
bg_muted="#304448"         # Tertiary UI element
fg_primary="#cdd8d5"       # Frost mist (cool, soft white)
fg_muted="#668285"         # Muted spruce fog
fg_dim="#3e5356"           # Inactive divider

# Functional Accents
lichen="#8bb68b"           # Lichen green (session badge / active status)
copper="#d48c68"           # Nordic raw copper (prefix alert / notifications)
glacier="#74aab3"          # Glacial teal (active window accent / time)
dusk_violet="#a292ad"      # Soft twilight purple (dates / secondary info)
frost_red="#cf6565"        # Bell / urgent error

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg_primary},bg=${bg_dark}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session badge
# Idle: Lichen green pill | Prefix Active: Warm Copper alert
tmux set-option -g status-left "#{?client_prefix,#[fg=${bg_dark}]#[bg=${copper}]#[bold] ⚡ #S ,#[fg=${bg_dark}]#[bg=${lichen}]#[bold] ◆ #S }#[fg=${fg_primary}]#[bg=${bg_dark}] "

# Right side: Dusk date & Glacier time
tmux set-option -g status-right "#[fg=${fg_dim}]│ #[fg=${dusk_violet}]%a %m/%d #[fg=${fg_dim}]│ #[fg=${glacier}]#[bold]%H:%M "

# Window styling
# Active window: Glacier accent with elevated slate background
tmux set-window-option -g window-status-current-format "#[fg=${bg_dark}]#[bg=${glacier}]#[bold] #I #[fg=${fg_primary}]#[bg=${bg_highlight}]#[bold] #W "

# Inactive windows: Calm forest surface
tmux set-window-option -g window-status-format "#[fg=${fg_dim}]#[bg=${bg_surface}] #I #[fg=${fg_muted}]#[bg=${bg_surface}]#W "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${copper},bg=${bg_surface},bold"
tmux set-window-option -g window-status-bell-style "fg=${frost_red},bg=${bg_surface},bold,blink"

# Pane borders: Forest slate inactive, Glacial teal active
tmux set-option -g pane-border-style "fg=${bg_highlight}"
tmux set-option -g pane-active-border-style "fg=${glacier}"

# Message & Command styling
tmux set-option -g message-style "fg=${bg_dark},bg=${lichen},bold"
tmux set-option -g message-command-style "fg=${fg_primary},bg=${bg_highlight}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${bg_dark},bg=${glacier},bold"

# Pane content styling
tmux set-window-option -g window-style "fg=${fg_primary},bg=${bg_surface}"
tmux set-window-option -g window-active-style "fg=${fg_primary},bg=${bg_dark}"

# Clock mode
tmux set-option -g clock-mode-colour "${glacier}"
tmux set-option -g clock-mode-style 24
