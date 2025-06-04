# 🐧 Linux Setup Guide

## Supported Distributions

- Ubuntu/Debian
- Fedora/RHEL/CentOS
- Arch Linux/Manjaro
- Most other distributions

## Installation

### One-Click Install
```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### Manual Installation

#### Ubuntu/Debian
```bash
# Update packages
sudo apt update && sudo apt upgrade

# Install chezmoi
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin

# Initialize dotfiles
~/.local/bin/chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

#### Fedora
```bash
# Update packages
sudo dnf update

# Install chezmoi
sudo dnf install chezmoi

# Initialize dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

#### Arch Linux
```bash
# Update packages
sudo pacman -Syu

# Install chezmoi
sudo pacman -S chezmoi

# Initialize dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

## Terminal Emulators

### GNOME Terminal
1. Preferences → Profiles
2. Create new profile
3. Set font: "CaskaydiaCove Nerd Font 12"
4. Colors: Use Gruvbox Dark scheme

### Alacritty (Recommended)
```bash
# Install Alacritty
sudo apt install alacritty  # Ubuntu
sudo dnf install alacritty  # Fedora
sudo pacman -S alacritty    # Arch
```

### Terminator
```bash
# Install
sudo apt install terminator

# Configuration will be automatically applied
```

## Distribution-Specific Notes

### Ubuntu/Debian
- Some tools may need manual installation (exa, bat, delta)
- Use `batcat` instead of `bat`
- Use `fdfind` instead of `fd`

### Fedora
- Most modern tools available in repositories
- SELinux may require additional configuration

### Arch Linux
- All tools available in repositories or AUR
- Use `yay` for AUR packages if needed

## X11/Wayland Clipboard

### X11
```bash
# Install xclip
sudo apt install xclip  # Ubuntu
sudo dnf install xclip  # Fedora
sudo pacman -S xclip    # Arch
```

### Wayland
```bash
# Install wl-clipboard
sudo apt install wl-clipboard  # Ubuntu
sudo dnf install wl-clipboard  # Fedora
sudo pacman -S wl-clipboard    # Arch
```

## Troubleshooting

### Font Issues
```bash
# Refresh font cache
fc-cache -fv
```

### Snap Packages
```bash
# If using snap packages
export PATH="$PATH:/snap/bin"
```

### Flatpak
```bash
# For Flatpak applications
flatpak --user override --filesystem=home
```
