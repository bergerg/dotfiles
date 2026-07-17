#!/usr/bin/env bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
dir=$(echo "$input" | jq -r '.workspace.current_dir')
branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
ctx_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

out="$model | ${dir/#$HOME/~}"
[ -n "$branch" ] && out="$out | $branch"
[ -n "$ctx_remaining" ] && out="$out | ctx:$(printf '%.0f' "$ctx_remaining")% left"

limits=""
[ -n "$five" ] && limits="5h:$(printf '%.0f' "$five")%"
[ -n "$week" ] && limits="$limits${limits:+ }7d:$(printf '%.0f' "$week")%"
[ -n "$limits" ] && out="$out | $limits"

echo "$out"
