#!/usr/bin/env bash
# Kurogane Theme (黒鉄) - Cast Iron & Ember
# A deep, matte dark palette inspired by Japanese cast iron and smoldering hearth ember.
# Low eye-strain with crisp bone typography and instant-clarity functional accents.

# Color Palette
bg_dark="#121316"          # Deepest cast iron / matte black
bg_surface="#1a1c22"       # Pane background / inactive tabs
bg_highlight="#262933"     # Secondary elevated container
bg_muted="#343844"         # Tertiary UI element
fg_primary="#d8d6cd"       # Bone / raw silk foreground (high legibility)
fg_muted="#636879"         # Gunmetal slate (subtle secondary text)
fg_dim="#484d5c"           # Dim divider / inactive text

# Functional Accents
ember="#e57c58"            # Active ember / prefix trigger (warm, noticeable)
ochre="#dca561"            # Warm brass / session badge
moss="#78997a"             # Weathered patina green (clean, calm)
steel_blue="#688094"       # Muted steel blue (widgets / dates)
clay="#c25d53"             # Warning / alert red

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg_primary},bg=${bg_dark}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session badge
# Idle: Warm Ochre pill | Prefix Active: Glowing Ember with lightning cue
tmux set-option -g status-left "#{?client_prefix,#[fg=${bg_dark}]#[bg=${ember}]#[bold] ⚡ #S ,#[fg=${bg_dark}]#[bg=${ochre}]#[bold] ◆ #S }#[fg=${fg_primary}]#[bg=${bg_dark}] "

# Right side: Clean date & moss time
tmux set-option -g status-right "#[fg=${fg_dim}]│ #[fg=${steel_blue}]%a %m/%d #[fg=${fg_dim}]│ #[fg=${moss}]#[bold]%H:%M "

# Window styling
# Active window: Ember number pill with elevated slate background
tmux set-window-option -g window-status-current-format "#[fg=${bg_dark}]#[bg=${ember}]#[bold] #I #[fg=${fg_primary}]#[bg=${bg_highlight}]#[bold] #W "

# Inactive windows: Calm surface background with muted numbering
tmux set-window-option -g window-status-format "#[fg=${fg_dim}]#[bg=${bg_surface}] #I #[fg=${fg_muted}]#[bg=${bg_surface}]#W "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${ochre},bg=${bg_surface},bold"
tmux set-window-option -g window-status-bell-style "fg=${clay},bg=${bg_surface},bold,blink"

# Pane borders: Subtle gunmetal for inactive, glowing ember for active
tmux set-option -g pane-border-style "fg=${bg_highlight}"
tmux set-option -g pane-active-border-style "fg=${ember}"

# Message & Command styling
tmux set-option -g message-style "fg=${bg_dark},bg=${ochre},bold"
tmux set-option -g message-command-style "fg=${fg_primary},bg=${bg_highlight}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${bg_dark},bg=${ember},bold"

# Pane content styling - subtle background depth for active pane
tmux set-window-option -g window-style "fg=${fg_primary},bg=${bg_surface}"
tmux set-window-option -g window-active-style "fg=${fg_primary},bg=${bg_dark}"

# Clock mode
tmux set-option -g clock-mode-colour "${ember}"
tmux set-option -g clock-mode-style 24
