#!/bin/bash
set -euo pipefail

# ── Install TPM (tmux plugin manager) ────────────────────────────────────────
# run_once_ = never re-runs unless this script's content changes
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "==> Installing TPM..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "==> TPM installed. Open tmux and press Prefix + I to install plugins."
else
    echo "==> TPM already installed."
fi
