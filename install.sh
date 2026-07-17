#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
REPO="$(pwd)"

# Symlink REPO/$1 to $2, backing up any existing non-symlink target.
link() {
  local src="$REPO/$1" dest="$2"
  [ -e "$dest" ] && [ ! -L "$dest" ] && mv "$dest" "$dest.bak"
  ln -sfn "$src" "$dest"
}

echo "==> Container runtime"
echo "Choose a container runtime:"
echo "  1) Docker Desktop"
echo "  2) Colima (lightweight, no GUI)"
echo "  3) None - I'll install it myself"
read -rp "Choice [1-3]: " runtime_choice
case "$runtime_choice" in
  1) runtime_pkg='cask "docker-desktop"' ;;
  2) runtime_pkg=$'brew "colima"\nbrew "docker"' ;;
  3) runtime_pkg='' ;;
  *) echo "Invalid choice, skipping container runtime."; runtime_pkg='' ;;
esac

echo "==> Installing Homebrew packages"
cat Brewfile <(echo "$runtime_pkg") | brew bundle --file=-

if [ "$runtime_choice" = "2" ]; then
  colima start
fi

echo "==> Linking dotfiles"
for f in home/.*; do
  name=$(basename "$f")
  [ "$name" = "." ] || [ "$name" = ".." ] && continue
  link "$f" "$HOME/$name"
done

echo "==> Linking Ghostty config"
mkdir -p ~/.config/ghostty
link config/ghostty/config ~/.config/ghostty/config

echo "==> Linking Yazi config"
mkdir -p ~/.config/yazi
link config/yazi/yazi.toml ~/.config/yazi/yazi.toml
link config/yazi/theme.toml ~/.config/yazi/theme.toml
link config/yazi/flavors ~/.config/yazi/flavors

echo "==> Linking Claude Code config"
mkdir -p ~/.claude
link claude/CLAUDE.md ~/.claude/CLAUDE.md
link claude/settings.json ~/.claude/settings.json
link claude/statusline-command.sh ~/.claude/statusline-command.sh

echo "==> Neovim config (LazyVim starter)"
if [ ! -d ~/.config/nvim ]; then
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi

echo "==> Claude Code memory vault"
if [ -d "/Applications/Obsidian.app" ]; then
  ./scripts/init-memory-vault.sh
else
  echo "Obsidian not found, skipping memory vault setup"
fi

cat <<'EOF'

Done. Notes:
- Any existing dotfiles that were in the way got backed up with a .bak suffix.
EOF
