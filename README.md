# dotfiles

Cross-platform developer environment managed with [chezmoi](https://chezmoi.io).

**Platforms:** macOS (M-series) · Linux (Ubuntu/Debian) · Windows (WSL2 + PowerShell)
**Stack:** Ghostty / WezTerm · Zsh + Antidote · Starship · Neovim + LazyVim · tmux + TPM · Catppuccin Mocha · JetBrains Mono NF · Atuin · sesh · mise · Obsidian

---

## Quickstart (one command)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kareemschultz
```

## Interactive wizard (recommended for first install)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)
```

The wizard will:
- Detect your platform (macOS / Linux / Windows WSL2)
- Ask your name, email, profile (`personal` / `work` / `server`), and Obsidian vault path
- Install chezmoi, clone this repo, and apply everything
- Run all bootstrap scripts (Homebrew, packages, fonts, TPM, default shell, Obsidian)
- Print a guided post-install checklist

**Server/VM one-shot** (installs + removes all chezmoi traces):
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot kareemschultz
```

---

## What's deployed

| File/Dir | Target | Notes |
|---|---|---|
| `dot_zshrc.tmpl` | `~/.zshrc` | Full Zsh config, OS/profile-aware |
| `dot_zsh_plugins.txt` | `~/.zsh_plugins.txt` | antidote: fzf-tab, autosuggestions, syntax-hl |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | delta pager, name/email from init prompts |
| `dot_gitignore_global` | `~/.gitignore_global` | |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Catppuccin Mocha, full module config |
| `dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | TPM, Catppuccin, vim-nav, sesh binding |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | macOS + Linux only |
| `dot_config/wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` | Windows only |
| `dot_config/powershell/` | `~/Documents/PowerShell/` | Windows PS profile with Starship |
| `dot_config/nvim/` | `~/.config/nvim/` | LazyVim + Catppuccin + plugins (see below) |
| `dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` | Catppuccin Mocha + delta |
| `dot_config/atuin/config.toml` | `~/.config/atuin/config.toml` | Encrypted history sync |
| `dot_config/fastfetch/config.jsonc` | `~/.config/fastfetch/config.jsonc` | Shell greeting |
| `dot_config/sesh/sesh.toml` | `~/.config/sesh/sesh.toml` | tmux session picker |
| `dot_config/gh-dash/config.yml` | `~/.config/gh-dash/config.yml` | GitHub dashboard |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | Node LTS, Bun latest, Python 3.12 |
| `dot_config/obsidian-settings/` | `~/notes/.obsidian/` | Deployed once by setup script |
| `private_dot_ssh/config.tmpl` | `~/.ssh/config` | Excluded on server profile |

---

## Machine profiles

Set once during `chezmoi init`. Stored in `~/.config/chezmoi/chezmoi.toml` (never committed).

| Profile | Description |
|---|---|
| `personal` | Full stack including Obsidian, greeting, SSH config |
| `work` | Same as personal + `includeIf` git email override for `~/work/` |
| `server` | Minimal — no terminal apps, no Obsidian, no SSH config (managed via Ansible) |

---

## Bootstrap scripts

Scripts run automatically on `chezmoi apply`. Ordered by numeric prefix.

| Script | Trigger | What it does |
|---|---|---|
| `00-install-homebrew` | `run_once_before` · macOS only | Installs Homebrew if missing |
| `01-install-packages` | `run_onchange_before` | Installs all packages. Re-runs when `packages.yaml` changes |
| `02-install-fonts` | `run_once_before` · Linux only | Installs JetBrains Mono NF |
| `03-install-tpm` | `run_once_after` | Clones TPM into `~/.tmux/plugins/tpm` |
| `04-set-default-shell` | `run_once_after` | Sets zsh as login shell |
| `05-setup-obsidian` | `run_once_after` | Creates vault dir + deploys `.obsidian` settings |
| `06-bat-themes` | `run_once_after` | Downloads Catppuccin Mocha bat theme |

---

## Neovim plugins (on top of LazyVim)

| Plugin | Purpose | Keys |
|---|---|---|
| `catppuccin/nvim` | Catppuccin Mocha colorscheme | — |
| `harpoon2` | Bookmark + jump to key files | `<leader>ha` add · `Ctrl+e` menu · `Ctrl+1-4` jump |
| `trouble.nvim` | LSP diagnostics panel | `<leader>xx` · `<leader>xX` |
| `octo.nvim` | GitHub PRs + issues in nvim | `<leader>ghi` · `<leader>ghp` |
| `obsidian.nvim` | Edit Obsidian vault in nvim | `<leader>on` `of` `os` `ob` `od` `ot` |
| `flash.nvim` | Jump anywhere in 2-3 chars | `s` in normal mode |
| `snacks.nvim` | Dashboard, notifier, indent | Built-in LazyVim extra |

**LazyVim extras enabled:** TypeScript · Tailwind · JSON · YAML · Docker · Ansible · Biome · ESLint

**Mason auto-installs:** typescript-language-server · tailwindcss-language-server · biome · ansible-language-server · yaml-language-server · dockerfile-language-server · bash-language-server · pyright · black · ruff-lsp · marksman · taplo

---

## Obsidian integration

chezmoi manages Obsidian config at two levels:

**1. App settings** (`~/.config/obsidian-settings/` → deployed to `VAULT/.obsidian/`):
- `app.json` — editor, attachment, trash settings
- `appearance.json` — Catppuccin theme, JetBrains Mono NF
- `community-plugins.json` — plugin list (obsidian-git, templater, dataview, calendar, tasks, etc.)
- `core-plugins.json` — enabled built-in plugins
- `hotkeys.json` — custom keyboard shortcuts

**2. In-editor editing** (`obsidian.nvim`):
- Browse, create, search, link notes from inside Neovim
- Catppuccin-coloured checkboxes, bullets, tags
- Daily notes, backlinks, tag browser
- `<leader>oo` opens the current note in the Obsidian app

**3. Vault git sync** (via `obsidian-git` community plugin):
- `Cmd/Ctrl+Shift+S` → commit and sync
- `Cmd/Ctrl+Shift+G` → pull

---

## tmux key bindings

| Binding | Action |
|---|---|
| `Ctrl+A` | Prefix |
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Ctrl+H/J/K/L` | Navigate panes (also works in Neovim) |
| `Shift+Left/Right` | Previous/next window |
| `Prefix + Ctrl+J` | sesh session picker (fuzzy) |
| `Prefix + r` | Reload config |
| `Prefix + I` | Install TPM plugins |
| `Prefix + U` | Update TPM plugins |

---

## Daily workflow

```bash
chezmoi update              # pull latest from GitHub + apply
chezmoi diff                # preview what would change
chezmoi apply               # apply source state to home
chezmoi edit --apply FILE   # edit a managed file and apply immediately
chezmoi add ~/.newfile      # add a new file to management
chezmoi cd                  # open a shell in the source dir
chezmoi data                # show all template variables
chezmoi doctor              # diagnose issues
```

Shell aliases: `cz` `czd` `cza` `cze` `czu` `czcd`
