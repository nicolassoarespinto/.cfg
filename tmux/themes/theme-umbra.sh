#!/usr/bin/env bash
# Umbra Theme (深淵) - Abyssal Twilight & Amethyst
# A deep, mysterious ocean-trench night palette.
# Takes the gentle twilight calm of the Claude theme and elevates it with deeper
# contrast, cool basalt grays, and luminescent violet-teal highlights.

# Color Palette
bg_dark="#0f1118"          # Pitch abyssal trench (zero glare)
bg_surface="#161a25"       # Submerged basalt shelf
bg_highlight="#222838"     # Elevated midnight slate
bg_muted="#31394e"         # Tertiary UI border
fg_primary="#ced4e2"       # Starlight silver (crisp and serene)
fg_muted="#636e86"         # Oceanic fog
fg_dim="#41495c"           # Subtle divider

# Functional Accents
amethyst="#a78bfa"         # Dusk amethyst / active window highlight
coral="#f47280"            # Phosphor coral / prefix indicator
marine_teal="#5eead4"      # Bioluminescent cyan / clock & session
moon_gold="#fbbf24"        # Warm starlight gold (activity / alerts)
deep_blue="#60a5fa"        # Deep ocean blue (calendar)

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg_primary},bg=${bg_dark}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session badge
# Idle: Marine teal pill | Prefix Active: Glowing Coral
tmux set-option -g status-left "#{?client_prefix,#[fg=${bg_dark}]#[bg=${coral}]#[bold] ⚡ #S ,#[fg=${bg_dark}]#[bg=${marine_teal}]#[bold] ◆ #S }#[fg=${fg_primary}]#[bg=${bg_dark}] "

# Right side: Deep blue date & Amethyst time
tmux set-option -g status-right "#[fg=${fg_dim}]│ #[fg=${deep_blue}]%a %m/%d #[fg=${fg_dim}]│ #[fg=${amethyst}]#[bold]%H:%M "

# Window styling
# Active window: Amethyst pill with midnight slate background
tmux set-window-option -g window-status-current-format "#[fg=${bg_dark}]#[bg=${amethyst}]#[bold] #I #[fg=${fg_primary}]#[bg=${bg_highlight}]#[bold] #W "

# Inactive windows: Submerged basalt shelf
tmux set-window-option -g window-status-format "#[fg=${fg_dim}]#[bg=${bg_surface}] #I #[fg=${fg_muted}]#[bg=${bg_surface}]#W "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${moon_gold},bg=${bg_surface},bold"
tmux set-window-option -g window-status-bell-style "fg=${coral},bg=${bg_surface},bold,blink"

# Pane borders: Midnight slate inactive, Amethyst active
tmux set-option -g pane-border-style "fg=${bg_highlight}"
tmux set-option -g pane-active-border-style "fg=${amethyst}"

# Message & Command styling
tmux set-option -g message-style "fg=${bg_dark},bg=${amethyst},bold"
tmux set-window-option -g message-command-style "fg=${fg_primary},bg=${bg_highlight}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${bg_dark},bg=${marine_teal},bold"

# Pane content styling
tmux set-window-option -g window-style "fg=${fg_primary},bg=${bg_surface}"
tmux set-window-option -g window-active-style "fg=${fg_primary},bg=${bg_dark}"

# Clock mode
tmux set-option -g clock-mode-colour "${marine_teal}"
tmux set-option -g clock-mode-style 24
