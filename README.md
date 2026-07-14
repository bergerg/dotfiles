# dotfiles

Personal system setup / recovery repo.

## Usage

```sh
git clone https://github.com/bergerg/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Installs Homebrew packages/casks from `Brewfile`, symlinks dotfiles from `home/`
into `$HOME`, links `config/ghostty/config` and the Claude Code config, and
clones the LazyVim starter for neovim.

## What's in here

- `Brewfile` — GUI apps (casks) and CLI tools (formulae)
- `home/` — `.zshrc`, `.zprofile`, `.vimrc`
- `config/ghostty/config` — Ghostty terminal theme
- `claude/` — Claude Code `CLAUDE.md` and `settings.json`

## Not included (on purpose)

- Secrets/tokens — kept in `~/.local_conf.sh`, sourced by `.zshrc` but never committed
- SSH keys, git credentials, gh/docker auth
- App data (Obsidian vaults, browser profiles, game saves)
- Anything that's just cache/regenerable state
