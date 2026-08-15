#!/usr/bin/env bash
# Subtle Kurogane Theme (黒鉄・幽玄) - Minimalist & Low-Contrast
# Designed for maximum focus and zero visual noise.
# No heavy background blocks — clean typography, understated separators,
# and precise functional color accents when you need them.

# Color Palette
bg_dark="#121316"          # Deep cast iron base
bg_surface="#1a1c22"       # Subtle pane background
fg_primary="#d8d6cd"       # Bone ivory (active text)
fg_muted="#636879"         # Gunmetal slate (inactive text)
fg_dim="#3a3e4c"           # Delicate divider gray

# Subtle Accents
ember="#e57c58"            # Active ember / prefix cue
ochre="#dca561"            # Warm ochre brass
moss="#78997a"             # Muted sage green
steel="#688094"            # Soft steel blue
clay="#c25d53"             # Gentle alert red

# Status bar styling - seamless and unobtrusive
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${fg_muted},bg=${bg_dark}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session name
# Idle: Warm Ochre diamond | Prefix: Glowing Ember lightning cue
tmux set-option -g status-left "#{?client_prefix,#[fg=${ember}]#[bold] ⚡ #S #[fg=${fg_dim}]│ ,#[fg=${ochre}]#[bold] ◆ #S #[fg=${fg_dim}]│ }"

# Right side: Minimal date & sage clock
tmux set-option -g status-right "#[fg=${steel}]%a %m/%d #[fg=${fg_dim}]│ #[fg=${moss}]%H:%M "

# Window styling - typographic distinction without heavy block boxes
# Active window: Ember number + crisp bone white name
tmux set-window-option -g window-status-current-format "#[fg=${ember}]#[bold]#I #[fg=${fg_primary}]#[bold]#W #[fg=${fg_dim}]│ "

# Inactive windows: Dimmed number + muted slate name
tmux set-window-option -g window-status-format "#[fg=${fg_dim}]#I #[fg=${fg_muted}]#W #[fg=${fg_dim}]│ "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${ochre},bold"
tmux set-window-option -g window-status-bell-style "fg=${clay},bold,blink"

# Pane borders: Deep charcoal inactive, Ember active
tmux set-option -g pane-border-style "fg=${fg_dim}"
tmux set-option -g pane-active-border-style "fg=${ember}"

# Message & Command styling - understated
tmux set-option -g message-style "fg=${fg_primary},bg=${bg_surface},bold"
tmux set-option -g message-command-style "fg=${fg_primary},bg=${bg_surface}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${bg_dark},bg=${ember},bold"

# Pane content styling - seamless background
tmux set-window-option -g window-style "fg=${fg_primary},bg=${bg_dark}"
tmux set-window-option -g window-active-style "fg=${fg_primary},bg=${bg_dark}"

# Clock mode
tmux set-option -g clock-mode-colour "${ember}"
tmux set-option -g clock-mode-style 24
