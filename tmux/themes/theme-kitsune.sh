#!/usr/bin/env bash
# Kitsune Theme (狐火) - Charred Ink & Autumn Ochre
# A warm, smoky Japanese hearth aesthetic merging the depth of Kanagawa Dragon
# with the rich earthy comfort of roasted chestnuts and amber tea.

# Color Palette
bg_dark="#141312"          # Charred bamboo ink (deep warm black)
bg_surface="#1e1c19"       # Smoked timber surface
bg_highlight="#2c2824"     # Elevated dark clay
bg_muted="#3d3731"         # Tertiary border
fg_primary="#dfd7cb"       # Washi paper ivory (warm, easy on eyes)
fg_muted="#7a7065"         # Driftwood gray
fg_dim="#4e463d"           # Inactive divider

# Functional Accents
persimmon="#e08238"        # Ripe persimmon / fox amber (session badge)
vermilion="#cf4f45"        # Shrine torii vermilion (prefix trigger)
matcha="#8e9d67"           # Muted matcha green (clock / safe status)
sand="#c7a462"             # Golden sand (active window highlight)
smoke_blue="#6d838a"       # Autumn smoke blue (calendar / system)

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg_primary},bg=${bg_dark}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session badge
# Idle: Persimmon amber | Prefix Active: Fiery Vermilion
tmux set-option -g status-left "#{?client_prefix,#[fg=${bg_dark}]#[bg=${vermilion}]#[bold] ⚡ #S ,#[fg=${bg_dark}]#[bg=${persimmon}]#[bold] ◆ #S }#[fg=${fg_primary}]#[bg=${bg_dark}] "

# Right side: Smoke blue date & Matcha time
tmux set-option -g status-right "#[fg=${fg_dim}]│ #[fg=${smoke_blue}]%a %m/%d #[fg=${fg_dim}]│ #[fg=${matcha}]#[bold]%H:%M "

# Window styling
# Active window: Sand/Ochre pill with elevated clay background
tmux set-window-option -g window-status-current-format "#[fg=${bg_dark}]#[bg=${sand}]#[bold] #I #[fg=${fg_primary}]#[bg=${bg_highlight}]#[bold] #W "

# Inactive windows: Smoked timber surface
tmux set-window-option -g window-status-format "#[fg=${fg_dim}]#[bg=${bg_surface}] #I #[fg=${fg_muted}]#[bg=${bg_surface}]#W "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${persimmon},bg=${bg_surface},bold"
tmux set-window-option -g window-status-bell-style "fg=${vermilion},bg=${bg_surface},bold,blink"

# Pane borders: Dark clay inactive, Persimmon active
tmux set-option -g pane-border-style "fg=${bg_highlight}"
tmux set-option -g pane-active-border-style "fg=${persimmon}"

# Message & Command styling
tmux set-option -g message-style "fg=${bg_dark},bg=${sand},bold"
tmux set-window-option -g message-command-style "fg=${fg_primary},bg=${bg_highlight}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${bg_dark},bg=${sand},bold"

# Pane content styling
tmux set-window-option -g window-style "fg=${fg_primary},bg=${bg_surface}"
tmux set-window-option -g window-active-style "fg=${fg_primary},bg=${bg_dark}"

# Clock mode
tmux set-option -g clock-mode-colour "${persimmon}"
tmux set-option -g clock-mode-style 24
