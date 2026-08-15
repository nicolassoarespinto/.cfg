#!/usr/bin/env bash
# Minimal Kanagawa theme - self-contained, no dependencies

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/colors.sh"

# Simple tmux option getter
get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -n "$option_value" ]; then
    echo "$option_value"
  else
    echo "$default_value"
  fi
}

main() {
  # Get theme (wave/dragon/lotus)
  theme=$(get_tmux_option "@kanagawa-theme" "")
  set_theme "$theme"

  # Status bar styling
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  # Pane border styling
  tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # Message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # Status bar layout
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # Left side: show session name (green bg, changes to yellow when prefix is pressed)
  tmux set-option -g status-left "#{?client_prefix,#[fg=${dark_gray}],#[fg=${dark_gray},bg=${green}]} #S "

  # Right side: show date and time
  tmux set-option -g status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p "

  # Window styling
  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
  tmux set-window-option -g window-status-format "#[fg=${white},bg=${gray}] #I #W "

  # Window style
  tmux set-window-option -g window-style "fg=${white},bg=${dark_gray}"
  tmux set-window-option -g window-status-activity-style "bold"
  tmux set-window-option -g window-status-bell-style "bold"
}

# Run main function
main
