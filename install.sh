#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

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

echo "==> Copying dotfiles"
for f in home/.*; do
  name=$(basename "$f")
  [ "$name" = "." ] || [ "$name" = ".." ] && continue
  target="$HOME/$name"
  [ -e "$target" ] && mv "$target" "$target.bak"
  cp "$(pwd)/$f" "$target"
done

echo "==> Copying Ghostty config"
mkdir -p ~/.config/ghostty
[ -e ~/.config/ghostty/config ] && mv ~/.config/ghostty/config ~/.config/ghostty/config.bak
cp "$(pwd)/config/ghostty/config" ~/.config/ghostty/config

echo "==> Copying Yazi config"
mkdir -p ~/.config/yazi
[ -e ~/.config/yazi/yazi.toml ] && mv ~/.config/yazi/yazi.toml ~/.config/yazi/yazi.toml.bak
[ -e ~/.config/yazi/theme.toml ] && mv ~/.config/yazi/theme.toml ~/.config/yazi/theme.toml.bak
cp "$(pwd)/config/yazi/yazi.toml" ~/.config/yazi/yazi.toml
cp "$(pwd)/config/yazi/theme.toml" ~/.config/yazi/theme.toml
[ -e ~/.config/yazi/flavors ] && mv ~/.config/yazi/flavors ~/.config/yazi/flavors.bak
cp -R "$(pwd)/config/yazi/flavors" ~/.config/yazi/flavors

echo "==> Copying Claude Code config"
mkdir -p ~/.claude
[ -e ~/.claude/CLAUDE.md ] && mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak
[ -e ~/.claude/settings.json ] && mv ~/.claude/settings.json ~/.claude/settings.json.bak
cp "$(pwd)/claude/CLAUDE.md" ~/.claude/CLAUDE.md
cp "$(pwd)/claude/settings.json" ~/.claude/settings.json

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
