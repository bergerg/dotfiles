#!/usr/bin/env bash
# Creates Claude Code's per-user memory folder (~/.claude/projects/-Users-<you>/memory)
# and registers it as an Obsidian vault, matching the setup already in use.
set -euo pipefail

encoded=$(printf '%s' "$HOME" | tr '/' '-')
vault="$HOME/.claude/projects/$encoded/memory"
mkdir -p "$vault/.obsidian"

[ -f "$vault/.obsidian/app.json" ] || echo '{}' > "$vault/.obsidian/app.json"
[ -f "$vault/.obsidian/appearance.json" ] || echo '{}' > "$vault/.obsidian/appearance.json"
[ -f "$vault/.obsidian/core-plugins.json" ] || cat > "$vault/.obsidian/core-plugins.json" <<'EOF'
{
  "file-explorer": true,
  "global-search": true,
  "switcher": true,
  "graph": true,
  "backlink": true,
  "canvas": true,
  "outgoing-link": true,
  "tag-pane": true,
  "properties": true,
  "page-preview": true,
  "daily-notes": true,
  "templates": true,
  "note-composer": true,
  "command-palette": true,
  "editor-status": true,
  "bookmarks": true,
  "outline": true,
  "word-count": true,
  "file-recovery": true,
  "bases": true
}
EOF

obsidian_json="$HOME/Library/Application Support/obsidian/obsidian.json"
mkdir -p "$(dirname "$obsidian_json")"
[ -f "$obsidian_json" ] || echo '{"vaults":{}}' > "$obsidian_json"

# skip if this vault path is already registered
if ! jq -e --arg path "$vault" '.vaults[] | select(.path == $path)' "$obsidian_json" >/dev/null 2>&1; then
  id=$(openssl rand -hex 8)
  ts=$(($(date +%s) * 1000))
  tmp=$(mktemp)
  jq --arg id "$id" --arg path "$vault" --argjson ts "$ts" \
    '.vaults[$id] = {"path": $path, "ts": $ts, "open": true}' \
    "$obsidian_json" > "$tmp" && mv "$tmp" "$obsidian_json"
fi

echo "Memory vault ready at: $vault"
echo "Open Obsidian to see it in the vault list."
