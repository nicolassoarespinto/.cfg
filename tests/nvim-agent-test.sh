#!/usr/bin/env bash
# Drives a real headless `nvim --listen` instance through every nvim-agent
# subcommand and error path, asserting on stdout and exit code. No test
# framework dependency: plain bash + nvim + jq, same as the tool under test.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM_AGENT="$REPO_ROOT/bin/nvim-agent"
SOCKET="${TMPDIR:-/tmp}/nvim-agent-test-$$.sock"
NVIM_PID=""

pass_count=0
fail_count=0

cleanup() {
    [[ -n "$NVIM_PID" ]] && kill "$NVIM_PID" >/dev/null 2>&1
    rm -f "$SOCKET"
}
trap cleanup EXIT

start_server() {
    rm -f "$SOCKET"
    nvim --headless --listen "$SOCKET" >/dev/null 2>&1 &
    NVIM_PID=$!
    for _ in {1..50}; do
        nvim --server "$SOCKET" --remote-expr '1' >/dev/null 2>&1 && return 0
        sleep 0.1
    done
    echo "nvim server never came up" >&2
    exit 1
}

# assert_run DESCRIPTION EXPECTED_EXIT_CODE GREP_PATTERN -- CMD...
assert_run() {
    local desc="$1" expected_code="$2" pattern="$3"
    shift 3
    [[ "${1:-}" == "--" ]] && shift
    local output code
    output=$("$@" 2>&1)
    code=$?
    local ok=true
    if [[ "$code" != "$expected_code" ]]; then
        ok=false
    fi
    if [[ -n "$pattern" ]] && ! grep -q -- "$pattern" <<<"$output"; then
        ok=false
    fi
    if [[ "$ok" == true ]]; then
        pass_count=$((pass_count + 1))
        echo "ok   - $desc"
    else
        fail_count=$((fail_count + 1))
        echo "FAIL - $desc (exit=$code, expected=$expected_code, pattern=[$pattern])"
        echo "       output: $output"
    fi
}

main() {
    export NVIM_AGENT_SERVER="$SOCKET"
    unset HERDR_WORKSPACE_ID HERDR_PLUS_WORKSPACE_ID

    # --version must work with no server running at all.
    assert_run "--version prints bare version" 0 "^[0-9]" -- "$NVIM_AGENT" --version
    assert_run "-v prints bare version" 0 "^[0-9]" -- "$NVIM_AGENT" -v

    # Errors before a server exists: NVIM_AGENT_SERVER already points at the
    # (not yet listening) socket, so this hits the "unavailable" branch, not
    # the "couldn't resolve any socket" branch.
    assert_run "state with dead socket errors (exit 1)" 1 "unavailable" -- "$NVIM_AGENT" state

    start_server

    # Home view / help.
    assert_run "no-args home view shows bin/description" 0 "description: Agent eXperience Interface" -- "$NVIM_AGENT"
    assert_run "--help shows usage" 0 "Usage:" -- "$NVIM_AGENT" --help
    assert_run "state --help shows usage" 0 "nvim-agent state" -- "$NVIM_AGENT" state --help

    # state
    assert_run "state reports buffer_count" 0 "buffer_count:" -- "$NVIM_AGENT" state
    assert_run "state reports zero diagnostics on empty buffer" 0 "total: 0" -- "$NVIM_AGENT" state

    # quickfix
    assert_run "quickfix accepts file:line and reports items" 0 "items: 1" -- "$NVIM_AGENT" quickfix --no-open "$REPO_ROOT/README.md:1"
    assert_run "quickfix with no files errors (exit 2)" 2 "needs at least one file" -- "$NVIM_AGENT" quickfix
    quickfist_json=$(nvim --server "$SOCKET" --remote-expr 'luaeval("vim.json.encode(vim.fn.getqflist())")')
    if grep -q '"lnum":1' <<<"$quickfist_json"; then
        pass_count=$((pass_count + 1)); echo "ok   - quickfix actually populated nvim's qflist"
    else
        fail_count=$((fail_count + 1)); echo "FAIL - quickfix did not populate nvim's qflist: $quickfist_json"
    fi

    # lua
    assert_run "lua queues a chunk" 0 "status: queued" -- "$NVIM_AGENT" lua "vim.g.axi_test_marker = 99"
    sleep 0.2
    marker=$(nvim --server "$SOCKET" --remote-expr 'luaeval("vim.g.axi_test_marker")')
    if [[ "$marker" == "99" ]]; then
        pass_count=$((pass_count + 1)); echo "ok   - lua chunk actually executed in nvim"
    else
        fail_count=$((fail_count + 1)); echo "FAIL - lua chunk did not execute (marker=$marker)"
    fi
    assert_run "lua with no chunk errors (exit 2)" 2 "needs a Lua chunk" -- "$NVIM_AGENT" lua

    # codediff
    assert_run "codediff reports sent" 0 "status: sent" -- "$NVIM_AGENT" codediff main feat/example

    # error paths
    assert_run "unknown command errors (exit 2)" 2 "unknown command: bogus" -- "$NVIM_AGENT" bogus
    assert_run "unknown flag on state errors (exit 2)" 2 "unknown flag --bogus" -- "$NVIM_AGENT" state --bogus
    assert_run "--server override with dead socket errors (exit 1)" 1 "unavailable" -- "$NVIM_AGENT" --server /nonexistent-socket state

    echo
    echo "$pass_count passed, $fail_count failed"
    [[ "$fail_count" -eq 0 ]]
}

main
