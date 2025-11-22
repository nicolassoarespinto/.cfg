# Bash-compatible zoxide-fzf integration
# This creates a function to interactively select and cd to a directory from zoxide history

function zoxide_fzf() {
    # Check if zoxide is installed
    if ! command -v zoxide >/dev/null 2>&1; then
        echo "Error: zoxide is not installed" >&2
        return 1
    fi

    # Check if fzf is installed
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: fzf is not installed" >&2
        return 1
    fi

    local selection
    selection=$(zoxide query --list | fzf --height 40% --reverse --border)

    # If user selected a directory, cd to it
    if [[ -n "$selection" ]]; then
        cd "$selection" || return 1
    fi
}

# Create a shorter alias for convenience
alias zf='zoxide_fzf'

