#!/usr/bin/env bash
# Kanagawa Theme for tmux - Single file version
# Inspired by the colors of the famous painting "The Great Wave off Kanagawa"

# Kanagawa Wave theme colors (default)
fuji_white='#dcd7ba'
sumi_ink_0='#16161d'
sumi_ink_1='#1e1f28'
sumi_ink_2='#1a1a22'
sumi_ink_3='#363646'
sumi_ink_4='#2a2a37'
sumi_ink_5='#363646'
sumi_ink_6='#54546D'
wave_aqua='#6a9589'
ronin_yellow='#ff9e3b'
spring_violet_1='#938aa9'
autumn_orange='#dca561'
wave_red='#e46876'
sakura_pink='#d27e99'

# Set theme colors
white=$fuji_white
gray=$sumi_ink_4
dark_gray=$sumi_ink_3
light_purple=$sumi_ink_5
dark_purple=$sumi_ink_6
cyan=$wave_aqua
green=$spring_violet_1
orange=$autumn_orange
red=$wave_red
pink=$sakura_pink
yellow=$ronin_yellow

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

# Left side: show session name (green bg, no bg change when prefix is pressed)
tmux set-option -g status-left "#{?client_prefix,#[fg=${dark_gray}],#[fg=${dark_gray},bg=${green}]} #S "

# Right side: show date and time
tmux set-option -g status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p "

# Window styling
tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
tmux set-window-option -g window-status-format "#[fg=${white},bg=${gray}] #I #W "

# Window style
tmux set-window-option -g window-style "fg=${white},bg=${sumi_ink_1}"
tmux set-window-option -g window-status-activity-style "bold"
tmux set-window-option -g window-status-bell-style "bold"
