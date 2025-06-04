# 🍎 macOS Setup Guide

## Prerequisites

### Xcode Command Line Tools
```bash
xcode-select --install
```

### Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

### One-Click Install
```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### Manual Install
```bash
# Install chezmoi
brew install chezmoi

# Initialize dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

## Terminal Configuration

### iTerm2 (Recommended)
```bash
# Install iTerm2
brew install --cask iterm2
```

#### iTerm2 Settings:
1. **Font**: CaskaydiaCove Nerd Font, 14pt
2. **Color Scheme**: Import Gruvbox Dark
3. **Key Mappings**: 
   - `⌘+←` → Send Escape Sequence `[H`
   - `⌘+→` → Send Escape Sequence `[F`

### Terminal.app
1. Preferences → Profiles
2. Create new profile "Karetech"
3. Set font to "CaskaydiaCove Nerd Font"
4. Import Gruvbox color scheme

## macOS-Specific Features

### Finder Enhancements
```bash
# Show hidden files
showfiles

# Hide hidden files  
hidefiles

# Flush DNS
flushdns
```

### Homebrew Integration
All tools are automatically installed via Homebrew and kept up to date.

## Troubleshooting

### Permission Issues
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

### Python Issues
```bash
# Use Homebrew Python
brew install python3
brew link python3
```
