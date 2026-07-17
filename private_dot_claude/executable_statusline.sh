#!/usr/bin/env bash
# Claude Code status line — colorized, icon-rich.
# Reads the status JSON on stdin and prints a single ' · '-separated line.

input=$(cat)

# ---- ANSI colors (256-color) ----
RESET=$'\033[0m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
c_repo=$'\033[38;5;110m'    # soft blue
c_wt=$'\033[38;5;140m'      # purple
c_pr=$'\033[38;5;114m'      # green
c_branch=$'\033[38;5;180m'  # tan
c_dir=$'\033[38;5;109m'     # teal
c_model=$'\033[38;5;175m'   # pink
c_ok=$'\033[38;5;114m'      # green
c_warn=$'\033[38;5;179m'    # amber
c_crit=$'\033[38;5;203m'    # red
c_style=$'\033[38;5;146m'   # lavender
c_vim=$'\033[38;5;244m'     # grey
SEP=$'\033[38;5;240m · '"$RESET"

# ---- extract fields ----
repo=$(echo "$input"  | jq -r '.workspace.repo | if . then .owner + "/" + .name else empty end')
wt=$(echo "$input"    | jq -r '.worktree.name // empty')
pr=$(echo "$input"    | jq -r '.pr | if . then (.number | tostring) + " (" + (.review_state // "open") + ")" else empty end')
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input"   | jq -r '.workspace.current_dir // .cwd // empty')
ctx=$(echo "$input"   | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input"  | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input"  | jq -r '.rate_limits.seven_day.used_percentage // empty')
style=$(echo "$input" | jq -r '.output_style.name // empty')
vim=$(echo "$input"   | jq -r '.vim.mode // empty')
cost=$(echo "$input"  | jq -r '.cost.total_cost_usd // empty')
tin=$(echo "$input"   | jq -r '.context_window.total_input_tokens // empty')
tout=$(echo "$input"  | jq -r '.context_window.total_output_tokens // empty')
cwrite=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // empty')
cread=$(echo "$input"  | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')

# compact token count: 12345 -> 12.3k, 1200000 -> 1.2M
fmt_tok() {
  awk -v n="$1" 'BEGIN{
    if (n>=1e6) printf "%.1fM", n/1e6;
    else if (n>=1e3) printf "%.1fk", n/1e3;
    else printf "%d", n;
  }'
}

# git branch (fall back gracefully outside a repo)
branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  # dirty flag
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
    branch="${branch}*"
  fi
fi

# pick a color for a 0-100 percentage: green < 60 < amber < 85 < red
pct_color() {
  local p=${1%.*}
  if   [ "$p" -ge 85 ]; then printf '%s' "$c_crit"
  elif [ "$p" -ge 60 ]; then printf '%s' "$c_warn"
  else                       printf '%s' "$c_ok"; fi
}

# ---- build segments ----
parts=()
[ -n "$repo" ]   && parts+=("${c_repo} ${repo}${RESET}")
[ -n "$wt" ]     && parts+=("${c_wt}⑂ ${wt}${RESET}")
[ -n "$branch" ] && parts+=("${c_branch} ${branch}${RESET}")
[ -n "$pr" ]     && parts+=("${c_pr} PR #${pr}${RESET}")
parts+=("${c_model}✦ ${model}${RESET}")

if [ -n "$ctx" ]; then
  parts+=("$(pct_color "$ctx")$(printf ' ctx %.0f%%' "$ctx")${RESET}")
fi

limits=""
if [ -n "$five" ]; then
  limits="$(pct_color "$five")$(printf '5h %.0f%%' "$five")${RESET}"
fi
if [ -n "$week" ]; then
  wk="$(pct_color "$week")$(printf '7d %.0f%%' "$week")${RESET}"
  if [ -n "$limits" ]; then limits="$limits ${DIM}|${RESET} $wk"; else limits="$wk"; fi
fi
[ -n "$limits" ] && parts+=("${DIM}󰄉${RESET} $limits")

[ -n "$cost" ] && parts+=("${c_ok}$(printf '$%.4f' "$cost")${RESET}")
if [ -n "$tin" ] || [ -n "$tout" ]; then
  parts+=("${DIM}⇅${RESET} ${c_dir}$(fmt_tok "${tin:-0}")↓ $(fmt_tok "${tout:-0}")↑${RESET}")
fi
if [ -n "$cwrite" ] || [ -n "$cread" ]; then
  parts+=("${DIM}⚡${RESET} ${c_vim}$(fmt_tok "${cwrite:-0}")w $(fmt_tok "${cread:-0}")r${RESET}")
fi

[ -n "$style" ] && [ "$style" != "default" ] && parts+=("${c_style}◆ ${style}${RESET}")
[ -n "$vim" ] && parts+=("${c_vim}${vim}${RESET}")

# ---- join ----
out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then out="$p"; else out="$out$SEP$p"; fi
done
printf '%b\n' "$out"
