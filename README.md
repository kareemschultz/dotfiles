# 🎯 Karetech Dotfiles

**Professional, cross-platform development environment for Karetech**

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/kareemschultz/dotfiles)
[![Shell](https://img.shields.io/badge/shell-ZSH%20%7C%20Bash-green)](https://github.com/kareemschultz/dotfiles)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Beautiful, productive, and consistent development environment that works seamlessly across **Windows, macOS, and Linux** using modern tools and best practices.

## ✨ Features

### 🚀 **One-Click Installation**
```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### 🎨 **Modern Terminal Experience**
- **Oh My Posh** with custom Gruvbox-themed `jandedobbeleer` prompt
- **Nerd Fonts** (CaskaydiaCove) with full icon support
- **True color** terminal with consistent theming
- **Cross-platform** compatibility (Windows/macOS/Linux)

### 🛠️ **Enhanced Shell (ZSH + Bash)**
- **Oh-My-Zsh** with curated plugins:
  - `zsh-autosuggestions` - Smart command suggestions
  - `zsh-syntax-highlighting` - Real-time syntax highlighting
  - `git`, `docker`, `kubectl`, `node`, `python` plugins
- **Modern Unix tools** integration:
  - `exa` → Enhanced `ls` with git integration & icons
  - `bat` → Syntax-highlighted `cat` with themes
  - `fd` → Fast `find` replacement
  - `ripgrep` → Lightning-fast `grep` alternative
  - `fzf` → Fuzzy finder for everything
  - `zoxide` → Smart `cd` with frecency algorithm
  - `delta` → Beautiful git diffs

### 📺 **Tmux Powerhouse**
- **Custom key bindings** (Prefix: `Ctrl+a`)
- **TPM (Tmux Plugin Manager)** with essential plugins:
  - `tmux-resurrect` - Save/restore sessions
  - `tmux-continuum` - Auto-save sessions  
  - `tmux-yank` - Copy to system clipboard
  - `vim-tmux-navigator` - Seamless navigation
  - `tmux-cpu` & `tmux-battery` - System monitoring
- **Gruvbox color scheme** with custom status bar
- **Vi-mode** key bindings

### 🔧 **Development Tools**
- **Git configuration** with 30+ useful aliases
- **VS Code settings** with Gruvbox theme and optimizations
- **Cross-platform SSH** configuration
- **Global gitignore** for common files
- **Delta integration** for beautiful diffs

### 📋 **Profile Management**
- **Auto-detection** based on hostname:
  - `work` - Corporate environment settings
  - `development` - Full development toolset
  - `personal` - Home machine configuration
- **Environment-specific** configurations
- **Encrypted secrets** management with age

## 🚀 Quick Start

### One-Line Installation
```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### Manual Installation
```bash
# Install chezmoi
sh -c "$(curl -fsLS chezmoi.io/get)"

# Initialize with Karetech dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

## 📚 Usage

### Essential Commands
```bash
# Update dotfiles
chezmoi update

# Edit configuration
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Check status
chezmoi status
```

### Git Aliases
```bash
gs          # git status
ga          # git add
gaa         # git add .
gc          # git commit
gcm         # git commit -m
gp          # git push
gpl         # git pull
gd          # git diff
glog        # git log --oneline --graph --decorate --all
```

### Tmux Key Bindings
```bash
Ctrl+a |    # Split horizontally
Ctrl+a -    # Split vertically
Ctrl+a h/j/k/l  # Navigate panes
Ctrl+a r    # Reload config
Alt+Arrows  # Navigate without prefix
```

### Modern Tools
```bash
ls          # exa with icons
cat file    # bat with syntax highlighting
find name   # fd for fast search
grep text   # ripgrep for fast grep
cd dir      # zoxide for smart cd
```

### Useful Functions
```bash
mkcd newdir     # Create and cd into directory
extract file    # Extract any archive format
serve 8080      # Quick HTTP server
weather         # Current weather
myip           # Show IP addresses
sysinfo        # System information
gclone repo    # Git clone and cd
newproject name # Create new project with git init
```

## 🎨 Customization

### Terminal Setup
1. Install a **Nerd Font** compatible terminal
2. Set font to **"CaskaydiaCove Nerd Font"**
3. Enable **true color** support
4. Set color scheme to **Gruvbox Dark**

### VS Code Extensions (Recommended)
```bash
code --install-extension jdinhlife.gruvbox
code --install-extension PKief.material-icon-theme
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-eslint
```

### Local Customizations
Create local override files:
- `~/.zshrc.local` - ZSH customizations
- `~/.bashrc.local` - Bash customizations
- `~/.tmux.conf.local` - Tmux customizations

## 🔧 Platform Support

### macOS
- **Homebrew** integration
- **macOS-specific** aliases and functions
- **Native font** installation

### Linux
- **Multi-distro** support (Ubuntu, Fedora, Arch)
- **Package manager** detection
- **XDG** compliance

### Windows
- **WSL2** optimized
- **PowerShell** integration
- **Windows-specific** aliases

## 📁 Repository Structure

```
dotfiles/
├── .chezmoi.toml.tmpl          # Chezmoi configuration
├── .chezmoiignore              # Ignored files
├── install.sh                  # One-click installer
├── dot_zshrc.tmpl             # ZSH configuration
├── dot_bashrc.tmpl            # Bash configuration
├── dot_tmux.conf.tmpl         # Tmux configuration
├── dot_gitconfig.tmpl         # Git configuration
├── dot_gitignore_global.tmpl  # Global gitignore
├── dot_config/                # Config files
│   ├── oh-my-posh/
│   │   └── jandedobbeleer.omp.json
│   └── Code/User/
│       ├── settings.json.tmpl
│       └── extensions.json.tmpl
└── scripts/                   # Helper scripts
    └── setup-tmux-plugins.sh
```

## 🔐 Security

- **Age encryption** for sensitive files
- **GPG signing** support for commits
- **SSH key** management
- **No secrets** in plain text

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) - ZSH framework
- [Oh My Posh](https://ohmyposh.dev/) - Cross-platform prompt engine
- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Gruvbox](https://github.com/morhetz/gruvbox) - Color scheme
- [Nerd Fonts](https://www.nerdfonts.com/) - Iconic font aggregator

## 📞 Support

- 📧 Email: kareemschultz46@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/kareemschultz/dotfiles/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/kareemschultz/dotfiles/discussions)

---

**Made with ❤️ by Kareem Schultz for Karetech**
