#!/usr/bin/env bash

gstash-search() {
  # Fuzzy-search across the *contents* of every stash (not just titles).
  # Select a matching line to preview surrounding diff; Ctrl-A applies the stash.
  local stash_count
  stash_count=$(git stash list | wc -l)
  if [ "$stash_count" -eq 0 ]; then
    echo "No stashes found."
    return 1
  fi

  local script_dir preview_helper
  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  # preview_helper="$script_dir/gstash-preview-test.sh"
  preview_helper="gstash-preview"
  git stash list --format='%gd' | \
    while read -r stash; do
      git stash show -p "$stash" --color=always | nl -ba | sed "s/^/${stash}:/"
    done | \
    fzf --ansi --delimiter=':' --nth=2.. \
      --header 'Type to fuzzy-search stash contents; Enter opens full diff; Ctrl-A applies stash' \
      --preview "bash \"$preview_helper\" {1} {2}" \
      --bind 'enter:execute(git stash show -p {1} --color=always | ${PAGER:-less -R})' \
      --bind 'ctrl-a:execute(git stash apply {1})+abort'
}

alias gss='gstash-search'



