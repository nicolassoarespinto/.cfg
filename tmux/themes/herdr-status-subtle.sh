#!/usr/bin/env bash
# Session-scoped status bar override for the "herdr" tmux session.
#
# Herdr already draws its own UI chrome, so the normal kanagawa status bar
# (session name in green, window list, clock) is pure redundancy there.
# This dims it down to a single barely-visible "tmux" marker instead of
# turning it off outright, so there's still a visual cue you're inside
# tmux (vs. herdr run standalone) without competing with herdr's own UI.
#
# Uses session-scoped `set-option`/`set-window-option` (no -g), so it only
# overrides the global kanagawa theme (theme-kanagawa.sh) for whichever
# session is currently attached when this runs. `--off` unsets those
# overrides (`-u`) so the session falls back to the normal global styling.
#
# Invoked from the client-session-changed hook in tmux.conf.

# Kanagawa ink tones, matching theme-kanagawa.sh's own palette so this
# blends with the rest of the theme instead of introducing new colors.
sumi_ink_1='#1e1f28'   # pane background (theme-kanagawa.sh window-style bg)
sumi_ink_6='#54546D'   # muted grey-purple (theme-kanagawa.sh dark_purple)

if [[ "$1" == "--off" ]]; then
    tmux set-option -u status-style
    tmux set-option -u status-left
    tmux set-option -u status-left-style
    tmux set-option -u status-right
    tmux set-window-option -u window-status-current-format
    tmux set-window-option -u window-status-current-style
    tmux set-window-option -u window-status-format
    tmux set-option status on
else
    tmux set-option status on
    tmux set-option status-style "bg=${sumi_ink_1},fg=${sumi_ink_6}"
    tmux set-option status-left " tmux "
    tmux set-option status-left-style "fg=${sumi_ink_6},bg=${sumi_ink_1}"
    tmux set-option status-right ""
    tmux set-window-option window-status-current-format ""
    tmux set-window-option window-status-current-style "fg=${sumi_ink_6},bg=${sumi_ink_1}"
    tmux set-window-option window-status-format ""
fi
