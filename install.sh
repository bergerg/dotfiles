#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Installing Homebrew packages"
brew bundle --file=Brewfile

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

cat <<'EOF'

Done. Notes:
- Docker Desktop was installed via Brewfile. If your org blocks Docker Desktop,
  use Colima instead: brew install colima docker && colima start
- Any existing dotfiles that were in the way got backed up with a .bak suffix.
EOF
