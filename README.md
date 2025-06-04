# 🎯 Karetech Dotfiles

**Professional, cross-platform development environment for Karetech**

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/kareemschultz/dotfiles)
[![Shell](https://img.shields.io/badge/shell-PowerShell%20%7C%20ZSH%20%7C%20Bash-green)](https://github.com/kareemschultz/dotfiles)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Beautiful, productive, and consistent development environment that works seamlessly across **Windows, macOS, and Linux** using modern tools and best practices.

## 🚀 Quick Start

### **Linux/macOS (One-Click Install):**
```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### **Windows (PowerShell):**
```powershell
# Step 1: Install Chezmoi
winget install twpayne.chezmoi

# Step 2: Restart PowerShell, then apply dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git

# Step 3: Install Oh My Posh for beautiful theme
winget install JanDeDobbeleer.OhMyPosh

# Step 4: Install Nerd Fonts
# Download: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip
# Extract and install all .ttf files
```

### **Windows WSL2 (Recommended for Full Experience):**
```powershell
# Install WSL2 first
wsl --install

# After restart, open Ubuntu and run:
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

## ✨ Features

### 🎨 **Beautiful Terminal Experience**
- **Oh My Posh** with custom Gruvbox-themed `jandedobbeleer` prompt
- **Cross-platform compatibility** - Works on PowerShell, ZSH, and Bash
- **Nerd Fonts** (CaskaydiaCove) with full icon support
- **True color** terminal with consistent theming across all platforms
- **Git integration** with branch status and change indicators

### 🛠️ **Enhanced Shell Support**
- **PowerShell** (Windows) with modern aliases and functions
- **ZSH** (Linux/macOS) with Oh-My-Zsh and curated plugins:
  - `zsh-autosuggestions` - Smart command suggestions
  - `zsh-syntax-highlighting` - Real-time syntax highlighting
  - `git`, `docker`, `kubectl`, `node`, `python` plugins
- **Bash** (fallback) with essential features
- **Modern Unix tools** integration (on Unix systems):
  - `eza` → Enhanced `ls` with git integration & icons
  - `bat` → Syntax-highlighted `cat` with themes
  - `fd` → Fast `find` replacement
  - `ripgrep` → Lightning-fast `grep` alternative
  - `fzf` → Fuzzy finder for everything
  - `zoxide` → Smart `cd` with frecency algorithm
  - `delta` → Beautiful git diffs

### 📺 **Tmux Integration** (Linux/macOS)
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
- **Git configuration** with 30+ useful aliases and delta integration
- **VS Code settings** with Gruvbox theme and optimizations (cross-platform)
- **Cross-platform functions** (weather, myip, sysinfo, backup)
- **Platform-specific optimizations** and tool integrations
- **Global gitignore** for common development files

### 📋 **Profile Management**
- **Auto-detection** based on hostname:
  - `work` - Corporate environment settings
  - `development` - Full development toolset
  - `personal` - Home machine configuration
- **Environment-specific** configurations
- **Secure secrets** management with age encryption

## 📚 Platform-Specific Usage

### **Windows PowerShell:**
```powershell
# Modern aliases
ll              # Get-ChildItem with formatting
gs              # git status  
gc "message"    # git commit
gp              # git push
weather         # Check weather via wttr.in
myip            # Show public IP address

# Development functions
mkcd newdir     # Create directory and enter it
c .             # code . (open VS Code)
```

### **Linux/macOS ZSH:**
```bash
# Modern Unix tools
eza --icons     # Enhanced file listing with icons
bat ~/.zshrc    # Syntax highlighted file viewing
fd pattern      # Fast file finding
rg "text"       # Fast text searching  
z directory     # Smart directory jumping
fzf             # Fuzzy find anything

# Git aliases (30+ available)
gs              # git status
gaa             # git add .
gcm "msg"       # git commit -m
glog            # beautiful git log
```

### **Tmux (Linux/macOS):**
```bash
# Start tmux session
tmux

# Key bindings (Prefix: Ctrl+a)
Ctrl+a |        # Split horizontally
Ctrl+a -        # Split vertically  
Ctrl+a h/j/k/l  # Navigate panes
Ctrl+a r        # Reload config
```

## 🎯 Installation Guides

- 🪟 **[Windows Setup Guide](docs/windows.md)** - Complete Windows installation
- 🍎 **[macOS Setup Guide](docs/macos.md)** - macOS with Homebrew
- 🐧 **[Linux Setup Guide](docs/linux.md)** - Multi-distro support

## 🔧 Supported Platforms

| Platform | Shell | Package Manager | Modern Tools | Status |
|----------|-------|----------------|--------------|---------|
| Windows 10/11 | PowerShell | winget | Limited | ✅ Full Support |
| Windows WSL2 | ZSH/Bash | apt/snap | Full Suite | ✅ Full Support |
| macOS | ZSH/Bash | Homebrew | Full Suite | ✅ Full Support |
| Ubuntu/Debian | ZSH/Bash | apt | Full Suite | ✅ Full Support |
| Fedora/RHEL | ZSH/Bash | dnf | Full Suite | ✅ Full Support |
| Arch Linux | ZSH/Bash | pacman | Full Suite | ✅ Full Support |

## 🎨 Terminal Screenshots

### Windows PowerShell with Oh My Posh
*Beautiful Gruvbox theme with git integration and modern PowerShell functions*

### Linux/macOS ZSH Terminal  
*Full-featured development environment with modern Unix tools and tmux integration*

### Cross-Platform Git Integration
*Consistent git status indicators and beautiful diffs across all platforms*

## 📖 Usage Examples

### **Essential Commands (All Platforms):**
```bash
# Update dotfiles
chezmoi update

# Edit configuration  
chezmoi edit ~/.zshrc    # Linux/macOS
chezmoi edit $PROFILE    # Windows

# Apply changes
chezmoi apply

# Check status
chezmoi status
```

### **Git Workflow (30+ Aliases):**
```bash
gs              # git status
gaa             # git add .
gcm "feat: add new feature"  # git commit -m
gp              # git push
gpl             # git pull
gd              # git diff (with delta)
glog            # beautiful git log
gstash          # git stash
gunstash        # git stash pop
```

### **Useful Functions (All Platforms):**
```bash
weather         # Current weather
myip            # Show IP addresses  
sysinfo         # System information
backup file.txt # Create timestamped backup
mkcd newdir     # Create and enter directory
extract file.zip # Extract any archive format
serve 8080      # Quick HTTP server
```

## 🎨 Customization

### **Terminal Setup:**
1. Install a **Nerd Font** compatible terminal
2. Set font to **"CaskaydiaCove Nerd Font"**
3. Enable **true color** support
4. Set color scheme to **Gruvbox Dark**

### **VS Code Extensions (Recommended):**
```bash
code --install-extension jdinhlife.gruvbox
code --install-extension PKief.material-icon-theme
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-eslint
```

### **Local Customizations:**
Create local override files:
- `~/.zshrc.local` - ZSH customizations (Linux/macOS)
- `~/.bashrc.local` - Bash customizations  
- `~/.tmux.conf.local` - Tmux customizations
- PowerShell: Edit `$PROFILE` directly

## 📁 Repository Structure

```
dotfiles/
├── .chezmoi.toml.tmpl          # Chezmoi configuration with prompts
├── .chezmoiignore              # Platform-specific ignore rules
├── install.sh                  # One-click installer (Unix)
├── dot_zshrc.tmpl             # ZSH configuration (Linux/macOS)
├── dot_bashrc.tmpl            # Bash configuration (fallback)
├── dot_tmux.conf.tmpl         # Tmux configuration (Linux/macOS)
├── dot_gitconfig.tmpl         # Git configuration (cross-platform)
├── dot_gitignore_global.tmpl  # Global gitignore (cross-platform)
├── dot_config/                # Config files
│   ├── oh-my-posh/
│   │   └── jandedobbeleer.omp.json    # Custom theme
│   └── Code/User/
│       ├── settings.json.tmpl         # VS Code settings  
│       └── extensions.json.tmpl       # VS Code extensions
├── docs/                      # Platform-specific guides
│   ├── windows.md
│   ├── macos.md
│   └── linux.md
└── scripts/                   # Helper scripts
    └── setup-tmux-plugins.sh
```

## 🔐 Security Features

- **Age encryption** for sensitive files
- **GPG signing** support for commits
- **SSH key** management with secure defaults
- **No secrets** stored in plain text
- **Environment-specific** configurations

## 🤝 Contributing

Your dotfiles work across multiple platforms! Contributions welcome for:

1. **Additional shell configurations**
2. **New platform support** 
3. **Theme improvements**
4. **Tool integrations**
5. **Documentation enhancements**

### **Contributing Guidelines:**
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Test on multiple platforms
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 🆘 Troubleshooting

### **Common Issues:**

**Icons not showing?**
- Install CaskaydiaCove Nerd Font
- Configure your terminal to use the font
- Restart terminal application

**Oh My Posh not loading?**
- Windows: Install with `winget install JanDeDobbeleer.OhMyPosh`
- Linux/macOS: Already included in install script
- Restart shell after installation

**Modern tools not working?**
- Linux/macOS: Tools installed automatically
- Windows: Use WSL2 for full tool suite
- Check `$PATH` includes `~/.local/bin`

**Git config errors?**
- Check template syntax in `.gitconfig`
- Verify email/name were set during chezmoi init
- Run `git config --list` to verify

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
- 📖 Documentation: [Platform Guides](docs/)

## 🏆 Why Choose Karetech Dotfiles?

✅ **Truly Cross-Platform** - Same experience on Windows, macOS, and Linux  
✅ **One-Click Installation** - Get started in minutes  
✅ **Professional Grade** - Used in production environments  
✅ **Modern Tools** - Latest and greatest development tools  
✅ **Beautiful Design** - Gruvbox theme with icons and animations  
✅ **Actively Maintained** - Regular updates and improvements  
✅ **Well Documented** - Comprehensive guides for all platforms  
✅ **Secure by Default** - Encrypted secrets and secure configurations  

---

**Made with ❤️ by Kareem Schultz for Karetech**

*Transform your terminal into a beautiful, productive development environment in minutes!*
