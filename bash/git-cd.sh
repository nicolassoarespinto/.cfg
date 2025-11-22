#!/usr/bin/env bash

# git-cd: Interactive worktree selector using fzf
# This is a shell function wrapper that allows changing the current directory
# The actual selection logic is in bin/git-cd

git-cd() {
  # Check if the git-cd script exists
  local git_cd_script="$HOME/dotfiles/bin/git-cd"

  if [ ! -x "$git_cd_script" ]; then
    echo "Error: git-cd script not found at $git_cd_script" >&2
    return 1
  fi

  # Run the script and capture the selected path
  # The script outputs informational messages to stderr and the path to stdout
  local selected_path
  selected_path=$("$git_cd_script")
  local exit_code=$?

  # If script exited with error, it already printed the error message to stderr
  if [ $exit_code -ne 0 ]; then
    return $exit_code
  fi

  # Check if we got a valid path back (user didn't cancel)
  if [ -n "$selected_path" ] && [ -d "$selected_path" ]; then
    cd "$selected_path" || return 1
  fi

  # Return success (including when user cancelled)
  return 0
}

# Create an alias for convenience
alias gcd='git-cd'
