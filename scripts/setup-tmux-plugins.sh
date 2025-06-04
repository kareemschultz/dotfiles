#!/bin/bash
# Tmux Plugin Setup Script

echo "🔧 Setting up Tmux Plugin Manager..."

# Create tmux plugins directory
mkdir -p "$HOME/.tmux/plugins"

# Clone TPM if not exists
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "📦 Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "✅ TPM already installed"
fi

# Install plugins
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "🔌 Installing Tmux plugins..."
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
    echo "✅ Tmux plugins installed"
else
    echo "❌ TPM not found"
    exit 1
fi

echo "🎉 Tmux setup complete!"
echo ""
echo "Usage:"
echo "• Prefix key changed to Ctrl+a"
echo "• Split panes: Ctrl+a | (horizontal) or Ctrl+a - (vertical)"
echo "• Navigate panes: Ctrl+a h/j/k/l or Alt+Arrow keys"
echo "• Reload config: Ctrl+a r"
echo "• Install plugins: Ctrl+a I"
echo "• Update plugins: Ctrl+a U"
