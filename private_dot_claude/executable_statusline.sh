#!/usr/bin/env zsh

# Claude Code status line script
# Displays: directory, git branch/status, context %, daily/weekly cost

USAGE_FILE="$HOME/.claude/usage-log.jsonl"

# Read JSON input from stdin
input=$(cat)

# --- Directory ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
display_dir="${cwd/#$HOME/~}"

# --- Git info ---
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if ! git -C "$cwd" diff --quiet 2>/dev/null || \
       ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        git_dirty="✗"
    else
        git_dirty="✓"
    fi
    git_info=" $(printf '\033[36m')($branch $git_dirty)$(printf '\033[0m')"
fi

# --- Context window ---
ctx_info=""
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [[ -n "$used_pct" ]]; then
    if (( $(echo "$used_pct > 80" | bc -l) )); then
        ctx_color='\033[31m'
    elif (( $(echo "$used_pct > 50" | bc -l) )); then
        ctx_color='\033[33m'
    else
        ctx_color='\033[32m'
    fi
    ctx_info=" $(printf "$ctx_color")ctx:${used_pct}%$(printf '\033[0m')"
fi

# --- Track session cost ---
session_id=$(echo "$input" | jq -r '.session_id // empty')
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
now=$(date +%s)
today=$(date +%Y-%m-%d)

# Record current session cost (one line per session, updated in place)
if [[ -n "$session_id" && -n "$session_cost" ]]; then
    # Remove old entry for this session, append updated one
    if [[ -f "$USAGE_FILE" ]]; then
        tmp=$(grep -v "\"sid\":\"$session_id\"" "$USAGE_FILE" 2>/dev/null || true)
        echo "$tmp" > "$USAGE_FILE"
    fi
    echo "{\"sid\":\"$session_id\",\"cost\":$session_cost,\"ts\":$now,\"date\":\"$today\"}" >> "$USAGE_FILE"
fi

# --- Calculate daily/weekly totals ---
daily_cost=0
weekly_cost=0
if [[ -f "$USAGE_FILE" ]]; then
    week_ago=$(date -v-7d +%s 2>/dev/null || date -d '7 days ago' +%s 2>/dev/null)
    day_start=$(date -j -f '%Y-%m-%d' "$today" +%s 2>/dev/null || date -d "$today" +%s 2>/dev/null)

    # Deduplicate by session (take latest entry per session)
    # Then sum costs for today and this week
    while IFS= read -r line; do
        ts=$(echo "$line" | jq -r '.ts // 0')
        cost=$(echo "$line" | jq -r '.cost // 0')
        line_date=$(echo "$line" | jq -r '.date // ""')

        if [[ "$line_date" == "$today" ]]; then
            daily_cost=$(echo "$daily_cost + $cost" | bc -l)
        fi
        if (( ts >= week_ago )); then
            weekly_cost=$(echo "$weekly_cost + $cost" | bc -l)
        fi
    done < "$USAGE_FILE"
fi

# Format costs
fmt_daily=$(printf '$%.2f' "$daily_cost")
fmt_weekly=$(printf '$%.2f' "$weekly_cost")
cost_info=" $(printf '\033[33m')d:${fmt_daily} w:${fmt_weekly}$(printf '\033[0m')"

# --- Assemble ---
echo "$(printf '\033[32m')${display_dir}$(printf '\033[0m')${git_info}${ctx_info}${cost_info}"
