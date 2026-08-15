# Yazi cd-on-exit integration (official recipe: https://yazi-rs.github.io/docs/quick-start#shell-wrapper)
# `yy` opens yazi, then changes the shell's cwd to wherever yazi was left in when it closes.

function yy() {
    if ! command -v yazi >/dev/null 2>&1; then
        echo "Error: yazi is not installed" >&2
        return 1
    fi

    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$tmp"

    local cwd
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd" || true
    fi
    rm -f -- "$tmp"
}
