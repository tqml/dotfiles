#!/bin/bash
# Claude Code statusline
# Shows: model, repo + branch, effort, context window used, 5h and 7d rate limit usage + reset timer

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
repo_owner=$(echo "$input" | jq -r '.workspace.repo.owner // empty')
repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

repo=""
if [ -n "$repo_owner" ] && [ -n "$repo_name" ]; then
  repo="$repo_owner/$repo_name"
elif [ -n "$repo_name" ]; then
  repo="$repo_name"
fi

branch=""
if [ -n "$cwd" ]; then
  branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
fi

repo_branch=""
if [ -n "$repo" ] && [ -n "$branch" ]; then
  repo_branch="$repo ($branch)"
elif [ -n "$repo" ]; then
  repo_branch="$repo"
elif [ -n "$branch" ]; then
  repo_branch="$branch"
fi

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

now=$(date +%s)

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
RESET=$'\033[0m'

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
  five_part="5h:$(color_for "$five")$(printf '%.0f' "$five")%${RESET}"
  if [ -n "$five_remaining" ]; then
    five_part="$five_part (resets in ${five_remaining})"
  fi
  limits="$five_part"
fi
if [ -n "$week" ]; then
  week_part="7d:$(color_for "$week")$(printf '%.0f' "$week")%${RESET}"
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
if [ -n "$ctx_used" ]; then
  if [ -n "$extra" ]; then
    extra="$extra ctx:$(printf '%.0f' "$ctx_used")%"
  else
    extra="ctx:$(printf '%.0f' "$ctx_used")%"
  fi
fi

output=""
for part in "$model" "$repo_branch" "$extra" "$limits"; do
  if [ -n "$part" ]; then
    if [ -n "$output" ]; then
      output="$output | $part"
    else
      output="$part"
    fi
  fi
done

printf '%s\n' "$output"
