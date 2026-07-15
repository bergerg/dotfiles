# dotfiles

Personal system setup / recovery repo.

## Usage

```sh
git clone https://github.com/bergerg/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Installs Homebrew packages/casks from `Brewfile`, copies dotfiles from `home/`
into `$HOME`, copies `config/ghostty/config`, `config/yazi/` and the Claude
Code config, clones the LazyVim starter for neovim, and — if Obsidian got
installed — sets up the Claude Code memory vault
(`scripts/init-memory-vault.sh`). Existing files are backed up with a `.bak`
suffix, not overwritten.

Files are copied, not symlinked — this repo is a one-off recovery script, not
something to edit back into from a machine you don't want to auth with. It
stays the single source of truth.

### Claude Code memory vault

Run automatically by `install.sh` when Obsidian is present; can also be run on
its own:

```sh
./scripts/init-memory-vault.sh
```

Creates `~/.claude/projects/-Users-<you>/memory` (Claude Code's per-user memory
folder) and registers it as an Obsidian vault, matching the setup already in
use on other machines. Memory *content* isn't backed up here on purpose (see
below) — this just recreates the mechanism so a fresh vault is ready to go.

## What's in here

- `Brewfile` — GUI apps (casks) and CLI tools (formulae)
- `home/` — `.zshrc`, `.zprofile`, `.vimrc`
- `config/ghostty/config` — Ghostty terminal theme
- `config/yazi/` — Yazi file manager config, theme, and `neon-arcade` flavor
- `claude/` — Claude Code `CLAUDE.md` and `settings.json`
- `scripts/init-memory-vault.sh` — sets up the Claude Code memory vault in Obsidian

## Not included (on purpose)

- Secrets/tokens — kept in `~/.local_conf.sh`, sourced by `.zshrc` but never committed
- SSH keys, git credentials, gh/docker auth
- App data (Obsidian vault *content*, browser profiles, game saves) — the memory vault's mechanism is set up by `scripts/init-memory-vault.sh`, but its content isn't tracked here
- Anything that's just cache/regenerable state
