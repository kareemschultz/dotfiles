#!/bin/bash
# Karetech Dotfiles One-Click Installation
# Usage: sh -c "$(curl -fsLS https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)"

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
header() { echo -e "${PURPLE}🎯 $1${NC}"; }

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Darwin*)    PLATFORM="macos" ;;
        Linux*)     PLATFORM="linux" ;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM="windows" ;;
        *)          PLATFORM="unknown" ;;
    esac
    
    info "Detected platform: $PLATFORM"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install package manager
install_package_manager() {
    header "Setting up package manager"
    
    case $PLATFORM in
        "macos")
            if ! command_exists brew; then
                info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                
                # Add Homebrew to PATH
                if [[ -f /opt/homebrew/bin/brew ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                elif [[ -f /usr/local/bin/brew ]]; then
                    eval "$(/usr/local/bin/brew shellenv)"
                fi
                
                success "Homebrew installed"
            else
                success "Homebrew already installed"
            fi
            ;;
        "linux")
            # Update package lists
            if command_exists apt; then
                sudo apt update
            elif command_exists dnf; then
                sudo dnf check-update || true
            elif command_exists pacman; then
                sudo pacman -Sy
            fi
            success "Package manager ready"
            ;;
        "windows")
            warning "Running on Windows - some features may require WSL"
            ;;
    esac
}

# Install Chezmoi
install_chezmoi() {
    header "Installing Chezmoi"
    
    if command_exists chezmoi; then
        success "Chezmoi already installed"
        return
    fi
    
    case $PLATFORM in
        "macos")
            brew install chezmoi
            ;;
        "linux")
            if command_exists snap; then
                sudo snap install chezmoi --classic
            else
                sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        "windows")
            sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin
            export PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
    
    success "Chezmoi installed successfully"
}

# Install core tools
install_core_tools() {
    header "Installing core development tools"
    
    case $PLATFORM in
        "macos")
            info "Installing tools via Homebrew..."
            brew install git zsh tmux curl wget unzip fontconfig age
            
            # Install Oh My Posh
            brew install oh-my-posh
            
            # Install modern Unix tools
            brew install exa bat fd ripgrep fzf zoxide delta git-lfs
            
            # Install development tools
            brew install node python3 go rustc docker kubectl terraform ansible
            ;;
        "linux")
            if command_exists apt; then
                info "Installing tools via APT..."
                sudo apt install -y git zsh tmux curl wget unzip fontconfig build-essential age
                
                # Install Oh My Posh
                curl -s https://ohmyposh.dev/install.sh | bash -s
                
                # Install modern tools (some may need manual installation)
                sudo apt install -y exa bat fd-find ripgrep fzf zoxide
                
                # Create symlinks for different package names
                mkdir -p ~/.local/bin
                [ ! -f ~/.local/bin/fd ] && ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true
                [ ! -f ~/.local/bin/bat ] && ln -sf $(which batcat) ~/.local/bin/bat 2>/dev/null || true
                
            elif command_exists dnf; then
                info "Installing tools via DNF..."
                sudo dnf install -y git zsh tmux curl wget unzip fontconfig gcc age
                curl -s https://ohmyposh.dev/install.sh | bash -s
                sudo dnf install -y exa bat fd-find ripgrep fzf zoxide
                
            elif command_exists pacman; then
                info "Installing tools via Pacman..."
                sudo pacman -S --needed git zsh tmux curl wget unzip fontconfig base-devel age
                curl -s https://ohmyposh.dev/install.sh | bash -s
                sudo pacman -S --needed exa bat fd ripgrep fzf zoxide
            fi
            
            # Install delta (may need manual installation)
            if ! command_exists delta; then
                info "Installing delta manually..."
                DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d '"' -f 4)
                wget "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -O /tmp/delta.tar.gz
                tar -xzf /tmp/delta.tar.gz -C /tmp
                sudo cp /tmp/delta-*/delta /usr/local/bin/
                rm -rf /tmp/delta*
            fi
            ;;
        "windows")
            warning "Please install tools manually on Windows or use WSL"
            ;;
    esac
    
    success "Core tools installed"
}

# Install Nerd Fonts
install_nerd_fonts() {
    header "Installing Nerd Fonts"
    
    FONT_DIR=""
    case $PLATFORM in
        "macos")
            FONT_DIR="$HOME/Library/Fonts"
            ;;
        "linux")
            FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"
            ;;
        "windows")
            warning "Please install Nerd Fonts manually on Windows"
            return
            ;;
    esac
    
    if [ -n "$FONT_DIR" ]; then
        info "Downloading CaskaydiaCove Nerd Font..."
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
        TEMP_DIR=$(mktemp -d)
        
        curl -L "$FONT_URL" -o "$TEMP_DIR/CascadiaCode.zip"
        unzip -q "$TEMP_DIR/CascadiaCode.zip" -d "$TEMP_DIR"
        cp "$TEMP_DIR"/*.ttf "$FONT_DIR/" 2>/dev/null || true
        
        # Refresh font cache on Linux
        if [ "$PLATFORM" = "linux" ]; then
            fc-cache -fv >/dev/null 2>&1
        fi
        
        rm -rf "$TEMP_DIR"
        success "Nerd Fonts installed"
    fi
}

# Setup Oh My Zsh
setup_oh_my_zsh() {
    header "Setting up Oh My Zsh"
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        success "Oh My Zsh already installed"
    fi
    
    # Install plugins
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
    
    success "Oh My Zsh configured"
}

# Setup Tmux Plugin Manager
setup_tmux() {
    header "Setting up Tmux Plugin Manager"
    
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        info "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed"
    else
        success "TPM already installed"
    fi
}

# Apply dotfiles
apply_dotfiles() {
    header "Applying Karetech dotfiles"
    
    info "Initializing chezmoi with dotfiles repository..."
    
    # Initialize chezmoi with the repository
    if [ -d "$HOME/.local/share/chezmoi" ]; then
        warning "Chezmoi already initialized, updating..."
        chezmoi update
    else
        chezmoi init --apply https://github.com/kareemschultz/dotfiles.git
    fi
    
    success "Dotfiles applied successfully"
}

# Change default shell
change_shell() {
    header "Setting up default shell"
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        info "Changing default shell to zsh..."
        
        # Add zsh to /etc/shells if not present
        if ! grep -q "$(which zsh)" /etc/shells; then
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        
        chsh -s "$(which zsh)"
        success "Default shell changed to zsh (will take effect on next login)"
    else
        success "Default shell is already zsh"
    fi
}

# Setup FZF
setup_fzf() {
    header "Setting up FZF integration"
    
    if command_exists fzf; then
        if [ ! -f ~/.fzf.zsh ]; then
            info "Setting up FZF key bindings..."
            $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc 2>/dev/null ||             /usr/share/fzf/key-bindings.zsh 2>/dev/null ||             ~/.fzf/install --key-bindings --completion --no-update-rc 2>/dev/null || true
        fi
        success "FZF configured"
    else
        warning "FZF not found, skipping setup"
    fi
}

# Final setup and verification
final_setup() {
    header "Final setup and verification"
    
    # Create local bin directory
    mkdir -p "$HOME/.local/bin"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Install Tmux plugins
    if [ -f "$HOME/.tmux.conf" ] && [ -d "$HOME/.tmux/plugins/tpm" ]; then
        info "Installing Tmux plugins..."
        "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
    fi
    
    # Verify installations
    info "Verifying installations..."
    
    command_exists chezmoi && echo "✅ Chezmoi: $(chezmoi --version | head -1)"
    command_exists zsh && echo "✅ ZSH: $(zsh --version)"
    command_exists tmux && echo "✅ Tmux: $(tmux -V)"
    command_exists git && echo "✅ Git: $(git --version)"
    command_exists oh-my-posh && echo "✅ Oh My Posh: $(oh-my-posh --version)"
    command_exists exa && echo "✅ Exa: $(exa --version | head -1)"
    command_exists bat && echo "✅ Bat: $(bat --version | head -1)"
    command_exists fzf && echo "✅ FZF: $(fzf --version)"
    command_exists code && echo "✅ VS Code: $(code --version | head -1)"
    
    success "Installation verification complete"
}

# Print post-installation instructions
print_instructions() {
    echo ""
    echo "🎉${GREEN} Karetech Dotfiles Installation Complete! ${NC}🎉"
    echo "=========================================================="
    echo ""
    echo "${CYAN}Next Steps:${NC}"
    echo "1. ${WHITE}Restart your terminal${NC} or run: ${YELLOW}source ~/.zshrc${NC}"
    echo "2. ${WHITE}Configure your terminal${NC} to use 'CaskaydiaCove Nerd Font'"
    echo "3. ${WHITE}Install VS Code extensions${NC} (recommended):"
    echo "   - Gruvbox Theme"
    echo "   - Material Icon Theme" 
    echo "   - GitLens"
    echo "   - Prettier"
    echo "   - ESLint"
    echo "4. ${WHITE}Test Tmux${NC}: Press ${YELLOW}Ctrl+a${NC} then ${YELLOW}r${NC} to reload config"
    echo ""
    echo "${CYAN}Useful Commands:${NC}"
    echo "• ${YELLOW}chezmoi update${NC}     - Update dotfiles"
    echo "• ${YELLOW}chezmoi edit${NC}       - Edit configuration files"
    echo "• ${YELLOW}tmux${NC}              - Start tmux session"
    echo "• ${YELLOW}weather${NC}           - Check weather"
    echo "• ${YELLOW}myip${NC}              - Show IP addresses"
    echo "• ${YELLOW}sysinfo${NC}           - System information"
    echo ""
    echo "${CYAN}Profile Information:${NC}"
    echo "• Current profile will be auto-detected based on hostname"
    echo "• Work profile: hostnames containing 'work', 'corp'"
    echo "• Development profile: hostnames containing 'dev'"
    echo "• Personal profile: default for other hostnames"
    echo ""
    echo "${CYAN}Documentation:${NC}"
    echo "📖 ${WHITE}https://github.com/kareemschultz/dotfiles${NC}"
    echo ""
    echo "${GREEN}Happy coding with Karetech! 🚀${NC}"
}

# Main installation flow
main() {
    clear
    echo "${PURPLE}"
    cat << 'EOF'
    ██╗  ██╗ █████╗ ██████╗ ███████╗████████╗███████╗ ██████╗██╗  ██╗
    ██║ ██╔╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔════╝██║  ██║
    █████╔╝ ███████║██████╔╝█████╗     ██║   █████╗  ██║     ███████║
    ██╔═██╗ ██╔══██║██╔══██╗██╔══╝     ██║   ██╔══╝  ██║     ██╔══██║
    ██║  ██╗██║  ██║██║  ██║███████╗   ██║   ███████╗╚██████╗██║  ██║
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
                                                                     
                     DOTFILES INSTALLATION
EOF
    echo "${NC}"
    echo ""
    
    detect_platform
    install_package_manager
    install_chezmoi
    install_core_tools
    install_nerd_fonts
    setup_oh_my_zsh
    setup_tmux
    setup_fzf
    apply_dotfiles
    change_shell
    final_setup
    print_instructions
}

# Handle errors
trap 'error "Installation failed at line $LINENO. Please check the output above."' ERR

# Check if running as root
if [ "$(id -u)" = "0" ]; then
    error "Please do not run this script as root"
    exit 1
fi

# Run main function
main "$@"
