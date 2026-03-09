#!/bin/bash
set -euo pipefail

# ── Install bat Catppuccin Mocha theme ────────────────────────────────────────
# bat uses BAT_THEME env var (set in .zshrc) but the theme file must exist first.
# run_once_ = never repeats unless this script content changes.

if ! command -v bat &>/dev/null; then
    echo "==> bat not found, skipping theme install."
    exit 0
fi

BAT_THEMES_DIR="$(bat --config-dir)/themes"
mkdir -p "$BAT_THEMES_DIR"

THEME_FILE="$BAT_THEMES_DIR/Catppuccin-mocha.tmTheme"
if [ ! -f "$THEME_FILE" ]; then
    echo "==> Installing bat Catppuccin Mocha theme..."
    curl -fsSL \
        "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme" \
        -o "$THEME_FILE"
    bat cache --build
    echo "==> bat Catppuccin theme installed."
else
    echo "==> bat Catppuccin theme already installed."
fi
