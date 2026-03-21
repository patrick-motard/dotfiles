# -*- mode: sh; -*-
# vim: set ft=zsh:
#
# cmd-history-logger.zsh
#
# Logs every shell command to a structured JSONL file with timestamp, cwd,
# exit code, and optionally the command output (via tmux pipe-pane).
#
# Log location: ~/.local/share/cmd-history/history.jsonl
#
# Output capture is opt-in to avoid ~50ms latency on every prompt render.
# Toggle it on/off per session:
#   cmd-capture-on   - enable output capture (requires tmux)
#   cmd-capture-off  - disable output capture

CMD_HISTORY_LOG="${HOME}/.local/share/cmd-history/history.jsonl"
CMD_HISTORY_CAPTURE=0
_cmd_ts=""
_cmd_cwd=""
_cmd_str=""
_cmd_capture_file="/tmp/cmd-capture-${$}"

[[ -d "${CMD_HISTORY_LOG:h}" ]] || mkdir -p "${CMD_HISTORY_LOG:h}"

function _cmd_history_preexec() {
  _cmd_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  _cmd_cwd=$PWD
  _cmd_str=$1

  if [[ $CMD_HISTORY_CAPTURE -eq 1 ]] && [[ -n "$TMUX" ]]; then
    : > "$_cmd_capture_file"
    tmux pipe-pane "cat >> ${_cmd_capture_file}"
  fi
}

function _cmd_history_precmd() {
  local exit_code=$?

  [[ -z "$_cmd_str" ]] && return
  [[ -z "$_cmd_ts" ]] && return

  local output=""

  if [[ $CMD_HISTORY_CAPTURE -eq 1 ]] && [[ -n "$TMUX" ]]; then
    tmux pipe-pane
    sleep 0.05
    if [[ -f "$_cmd_capture_file" ]]; then
      # Strip ANSI escape codes, carriage returns, and prompt lines
      output=$(
        perl -pe 's/\x1b\[[0-9;]*[mGKHFJA-Z]//g;
                  s/\x1b\][^\x07]*\x07//g;
                  s/\r//g' "$_cmd_capture_file" \
          | grep -v '❯' \
          | grep -v '^$' \
          | tr '\n' '\034'
      )
      # Remove trailing separator
      output="${output%$'\034'}"
    fi
  fi

  # Build JSON with python3 for correct escaping
  python3 - "$_cmd_ts" "$_cmd_cwd" "$_cmd_str" "$exit_code" "$output" \
    "$CMD_HISTORY_LOG" <<'PYEOF'
import sys, json

ts, cwd, cmd, exit_code_str, output_raw, log_file = sys.argv[1:]

# Convert our \034 separator back to \n in output
output = output_raw.replace(chr(0x1c), "\n").strip()

entry = {
    "ts":        ts,
    "cwd":       cwd,
    "cmd":       cmd,
    "exit_code": int(exit_code_str) if exit_code_str.lstrip('-').isdigit() else 0,
    "output":    output,
}

with open(log_file, "a") as f:
    f.write(json.dumps(entry) + "\n")
PYEOF

  _cmd_str=""
  _cmd_ts=""
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _cmd_history_preexec
add-zsh-hook precmd  _cmd_history_precmd

alias cmd-capture-on='export CMD_HISTORY_CAPTURE=1; echo "output capture enabled"'
alias cmd-capture-off='export CMD_HISTORY_CAPTURE=0; echo "output capture disabled"'
