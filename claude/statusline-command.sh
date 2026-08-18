#!/bin/bash
# Claude Code statusline
# Shows: model, repo + branch, effort, context window used, 5h and 7d rate limit usage + reset timer

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

CYAN=$'\033[36m'
RESET=$'\033[0m'

branch=""
if [ -n "$cwd" ]; then
  branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
fi

repo_branch=""
if [ -n "$repo_name" ] && [ -n "$branch" ]; then
  repo_branch="${repo_name}:${CYAN}${branch}${RESET}"
elif [ -n "$repo_name" ]; then
  repo_branch="$repo_name"
elif [ -n "$branch" ]; then
  repo_branch="${CYAN}${branch}${RESET}"
fi

five_raw=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_raw=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_resets_raw=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_resets_raw=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

now=$(date +%s)

# rate_limits is account-wide (not per-session) but only arrives after the
# first API response of a session, so cache the last known values on disk
# and use them at startup until fresh data replaces them.
CACHE_FILE="$HOME/.cache/claude-statusline-ratelimits.json"
cached_five="" cached_five_resets="" cached_week="" cached_week_resets=""
if [ -f "$CACHE_FILE" ]; then
  cached_five=$(jq -r '.five // empty' "$CACHE_FILE" 2>/dev/null)
  cached_five_resets=$(jq -r '.five_resets_at // empty' "$CACHE_FILE" 2>/dev/null)
  cached_week=$(jq -r '.week // empty' "$CACHE_FILE" 2>/dev/null)
  cached_week_resets=$(jq -r '.week_resets_at // empty' "$CACHE_FILE" 2>/dev/null)
fi

five="" five_resets_at="" five_stale=0
if [ -n "$five_raw" ]; then
  five="$five_raw"
  five_resets_at="$five_resets_raw"
elif [ -n "$cached_five" ] && [ -n "$cached_five_resets" ] && [ "$cached_five_resets" -gt "$now" ]; then
  five="$cached_five"
  five_resets_at="$cached_five_resets"
  five_stale=1
fi

week="" week_resets_at="" week_stale=0
if [ -n "$week_raw" ]; then
  week="$week_raw"
  week_resets_at="$week_resets_raw"
elif [ -n "$cached_week" ] && [ -n "$cached_week_resets" ] && [ "$cached_week_resets" -gt "$now" ]; then
  week="$cached_week"
  week_resets_at="$cached_week_resets"
  week_stale=1
fi

if [ -n "$five_raw" ] || [ -n "$week_raw" ]; then
  mkdir -p "$(dirname "$CACHE_FILE")" 2>/dev/null
  jq -n \
    --arg five "${five_raw:-$cached_five}" \
    --arg five_resets_at "${five_resets_raw:-$cached_five_resets}" \
    --arg week "${week_raw:-$cached_week}" \
    --arg week_resets_at "${week_resets_raw:-$cached_week_resets}" \
    '{five: ($five|tonumber?), five_resets_at: ($five_resets_at|tonumber?), week: ($week|tonumber?), week_resets_at: ($week_resets_at|tonumber?)}' \
    > "$CACHE_FILE" 2>/dev/null
fi

format_duration() {
  local secs="$1"
  if [ "$secs" -le 0 ]; then
    echo "0m"
    return
  fi
  local days=$((secs / 86400))
  local hours=$(((secs % 86400) / 3600))
  local mins=$(((secs % 3600) / 60))
  if [ "$days" -gt 0 ]; then
    printf '%dd%dh' "$days" "$hours"
  elif [ "$hours" -gt 0 ]; then
    printf '%dh%dm' "$hours" "$mins"
  else
    printf '%dm' "$mins"
  fi
}

five_remaining=""
if [ -n "$five_resets_at" ]; then
  five_remaining=$(format_duration $((five_resets_at - now)))
fi

week_remaining=""
if [ -n "$week_resets_at" ]; then
  week_remaining=$(format_duration $((week_resets_at - now)))
fi

GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

color_for() {
  local pct="$1"
  if awk -v p="$pct" 'BEGIN { exit !(p > 90) }'; then
    echo "$RED"
  elif awk -v p="$pct" 'BEGIN { exit !(p > 70) }'; then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

limits=""
if [ -n "$five" ]; then
  five_tilde=""
  [ "$five_stale" -eq 1 ] && five_tilde="~"
  five_part="5h:$(color_for "$five")${five_tilde}$(printf '%.0f' "$five")%${RESET}"
  if [ -n "$five_remaining" ]; then
    five_part="$five_part (resets in ${five_remaining})"
  fi
  limits="$five_part"
fi
if [ -n "$week" ]; then
  week_tilde=""
  [ "$week_stale" -eq 1 ] && week_tilde="~"
  week_part="7d:$(color_for "$week")${week_tilde}$(printf '%.0f' "$week")%${RESET}"
  if [ -n "$week_remaining" ]; then
    week_part="$week_part (resets in ${week_remaining})"
  fi
  if [ -n "$limits" ]; then
    limits="$limits $week_part"
  else
    limits="$week_part"
  fi
fi

extra=""
if [ -n "$effort" ]; then
  extra="effort:$effort"
fi
ctx_part="ctx:$(color_for "$ctx_used")$(printf '%.0f' "$ctx_used")%${RESET}"
if [ -n "$extra" ]; then
  extra="$extra $ctx_part"
else
  extra="$ctx_part"
fi

usage=""
if [ -n "$extra" ] && [ -n "$limits" ]; then
  usage="$extra $limits"
elif [ -n "$extra" ]; then
  usage="$extra"
else
  usage="$limits"
fi

output=""
for part in "$model" "$repo_branch" "$usage"; do
  if [ -n "$part" ]; then
    if [ -n "$output" ]; then
      output="$output | $part"
    else
      output="$part"
    fi
  fi
done

printf '%s\n' "$output"
