#!/usr/bin/env bash
# Kanagawa Dragon Theme (金川 龍) for tmux
# Canonical Neovim Kanagawa Dragon palette with warm charred-earth tones,
# dragon orange/yellow accents, and clean low eye-strain typography.

# Canonical Kanagawa Dragon Palette
dragon_black_0="#0d0c0c"
dragon_black_1="#12120f"
dragon_black_2="#1d1c19"
dragon_black_3="#181616"   # Main background
dragon_black_4="#282727"   # Secondary surface
dragon_black_5="#393836"   # Highlight container
dragon_black_6="#625e5a"   # Dim divider / dark gray

dragon_white="#c5c9c5"     # Main foreground (dragonWhite)
dragon_gray="#a6a69c"      # Muted text (dragonGray)
dragon_gray_dim="#7a8382"  # Inactive numbers

# Dragon Accents
dragon_orange="#b6927b"    # Active tab / border accent
dragon_yellow="#c4b28a"    # Session badge (warm bamboo)
dragon_green="#8a9a7b"     # Clock / status safe
dragon_aqua="#8ea4a2"      # Date widget
dragon_red="#c4746e"       # Prefix trigger / alert
dragon_pink="#a292a3"      # Secondary accent
dragon_blue="#8ba4b0"      # Info / selection

# Status bar styling
tmux set-option -g status-position bottom
tmux set-option -g status-style "fg=${dragon_gray},bg=${dragon_black_3}"
tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

# Left side: Session badge
# Idle: Dragon Yellow diamond | Prefix Active: Dragon Red lightning bolt
tmux set-option -g status-left "#{?client_prefix,#[fg=${dragon_red}]#[bold] ⚡ #S #[fg=${dragon_black_6}]│ ,#[fg=${dragon_yellow}]#[bold] ◆ #S #[fg=${dragon_black_6}]│ }"

# Right side: Dragon Aqua date & Dragon Green clock
tmux set-option -g status-right "#[fg=${dragon_aqua}]%a %m/%d #[fg=${dragon_black_6}]│ #[fg=${dragon_green}]#[bold]%H:%M "

# Window styling - typographic distinction
# Active window: Dragon Orange number + crisp Dragon White name
tmux set-window-option -g window-status-current-format "#[fg=${dragon_orange}]#[bold]#I #[fg=${dragon_white}]#[bold]#W #[fg=${dragon_black_6}]│ "

# Inactive windows: Dimmed number + muted gray name
tmux set-window-option -g window-status-format "#[fg=${dragon_gray_dim}]#I #[fg=${dragon_gray}]#W #[fg=${dragon_black_6}]│ "

# Activity and bell indicators
tmux set-window-option -g window-status-activity-style "fg=${dragon_yellow},bold"
tmux set-window-option -g window-status-bell-style "fg=${dragon_red},bold,blink"

# Pane borders: Smoked charcoal inactive, Dragon Orange active
tmux set-option -g pane-border-style "fg=${dragon_black_5}"
tmux set-option -g pane-active-border-style "fg=${dragon_orange}"

# Message & Command styling
tmux set-option -g message-style "fg=${dragon_white},bg=${dragon_black_4},bold"
tmux set-option -g message-command-style "fg=${dragon_white},bg=${dragon_black_4}"

# Copy / Selection mode
tmux set-option -g mode-style "fg=${dragon_black_0},bg=${dragon_orange},bold"

# Pane content styling - seamless background
tmux set-window-option -g window-style "fg=${dragon_white},bg=${dragon_black_3}"
tmux set-window-option -g window-active-style "fg=${dragon_white},bg=${dragon_black_3}"

# Clock mode
tmux set-option -g clock-mode-colour "${dragon_orange}"
tmux set-option -g clock-mode-style 24
