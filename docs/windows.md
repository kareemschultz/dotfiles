# 🪟 Windows Setup Guide

## Prerequisites

### Windows Subsystem for Linux (WSL2)
```powershell
# Enable WSL2
wsl --install
wsl --set-default-version 2

# Install Ubuntu (recommended)
wsl --install -d Ubuntu
```

### Windows Terminal
```powershell
# Install via Microsoft Store or winget
winget install Microsoft.WindowsTerminal
```

## Installation

### Option 1: WSL2 (Recommended)
```bash
# Inside WSL2
sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"
```

### Option 2: PowerShell
```powershell
# Install Chezmoi
irm get.chezmoi.io/ps1 | iex

# Initialize dotfiles
chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
```

## Terminal Configuration

### Windows Terminal Settings
1. Open Windows Terminal
2. Press `Ctrl+,` to open settings
3. Set default profile to WSL2/Ubuntu
4. Configure font: "CaskaydiaCove Nerd Font"

### Color Scheme
Add Gruvbox color scheme to Windows Terminal:
```json
{
    "name": "Gruvbox Dark",
    "background": "#32302F",
    "foreground": "#EBDBB2",
    "black": "#32302F",
    "red": "#FB4934",
    "green": "#B8BB26",
    "yellow": "#FABD2F",
    "blue": "#83A598",
    "purple": "#D3869B",
    "cyan": "#8EC07C",
    "white": "#EBDBB2",
    "brightBlack": "#928374",
    "brightRed": "#FB4934",
    "brightGreen": "#B8BB26",
    "brightYellow": "#FABD2F",
    "brightBlue": "#83A598",
    "brightPurple": "#D3869B",
    "brightCyan": "#8EC07C",
    "brightWhite": "#FBF1C7"
}
```

## Troubleshooting

### Font Issues
If icons don't display:
1. Install Nerd Fonts manually
2. Restart Windows Terminal
3. Check font settings

### WSL Path Issues
```bash
# Add to ~/.zshrc.local
export PATH="/mnt/c/Users/YourUser/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
```
