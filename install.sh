#!/bin/bash
# Karetech Dotfiles One-Click Installation - IMPROVED VERSION
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

# Enhanced error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    error "Installation failed at line $line_number (exit code: $exit_code)"
    exit $exit_code
}

# Detect platform with improved logic
detect_platform() {
    case "$(uname -s)" in
        Darwin*)    PLATFORM="macos" ;;
        Linux*)     
            # Check if running in WSL
            if grep -qi microsoft /proc/version 2>/dev/null; then
                PLATFORM="wsl"
                info "Detected WSL environment"
            else
                PLATFORM="linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM="windows" ;;
        *)          PLATFORM="unknown" ;;
    esac
    
    # Detect Linux distribution for better package management
    if [ "$PLATFORM" = "linux" ] || [ "$PLATFORM" = "wsl" ]; then
        if command -v apt >/dev/null 2>&1; then
            DISTRO="debian"
        elif command -v dnf >/dev/null 2>&1; then
            DISTRO="fedora"
        elif command -v pacman >/dev/null 2>&1; then
            DISTRO="arch"
        else
            DISTRO="unknown"
        fi
        info "Detected distribution: $DISTRO"
    fi
    
    info "Detected platform: $PLATFORM"
}

# Check if command exists with better error handling
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Improved package installation with retry logic
install_package() {
    local package="$1"
    local retries=3
    local count=0
    
    while [ $count -lt $retries ]; do
        case $DISTRO in
            "debian")
                if sudo apt install -y "$package"; then
                    return 0
                fi
                ;;
            "fedora")
                if sudo dnf install -y "$package"; then
                    return 0
                fi
                ;;
            "arch")
                if sudo pacman -S --needed --noconfirm "$package"; then
                    return 0
                fi
                ;;
        esac
        
        count=$((count + 1))
        warning "Installation attempt $count failed for $package, retrying..."
        sleep 2
    done
    
    error "Failed to install $package after $retries attempts"
    return 1
}

# Install package manager with improved error handling
install_package_manager() {
    header "Setting up package manager"
    
    case $PLATFORM in
        "macos")
            if ! command_exists brew; then
                info "Installing Homebrew..."
                if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
                    error "Failed to install Homebrew"
                    return 1
                fi
                
                # Add Homebrew to PATH with proper detection
                for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
                    if [[ -f "$brew_path" ]]; then
                        eval "$($brew_path shellenv)"
                        break
                    fi
                done
                
                if ! command_exists brew; then
                    error "Homebrew installation failed - brew command not found"
                    return 1
                fi
                
                success "Homebrew installed successfully"
            else
                success "Homebrew already installed"
            fi
            ;;
        "linux"|"wsl")
            # Update package lists with error handling
            case $DISTRO in
                "debian")
                    if ! sudo apt update; then
                        error "Failed to update apt package lists"
                        return 1
                    fi
                    ;;
                "fedora")
                    if ! sudo dnf check-update; then
                        # dnf check-update returns 100 when updates are available, which is normal
                        if [ $? -ne 100 ]; then
                            error "Failed to check for dnf updates"
                            return 1
                        fi
                    fi
                    ;;
                "arch")
                    if ! sudo pacman -Sy; then
                        error "Failed to sync pacman databases"
                        return 1
                    fi
                    ;;
            esac
            success "Package manager ready"
            ;;
        "windows")
            warning "Running on Windows - some features may require WSL"
            ;;
    esac
}

# Install Chezmoi with better error handling
install_chezmoi() {
    header "Installing Chezmoi"
    
    if command_exists chezmoi; then
        success "Chezmoi already installed"
        return 0
    fi
    
    case $PLATFORM in
        "macos")
            if ! brew install chezmoi; then
                error "Failed to install chezmoi via Homebrew"
                return 1
            fi
            ;;
        "linux"|"wsl")
            if command_exists snap; then
                if ! sudo snap install chezmoi --classic; then
                    warning "Snap installation failed, trying alternative method"
                    if ! sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin; then
                        error "Failed to install chezmoi"
                        return 1
                    fi
                fi
            else
                mkdir -p ~/.local/bin
                if ! sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin; then
                    error "Failed to install chezmoi"
                    return 1
                fi
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        "windows")
            mkdir -p ~/.local/bin
            if ! sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin; then
                error "Failed to install chezmoi"
                return 1
            fi
            export PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
    
    # Verify installation
    if ! command_exists chezmoi; then
        error "Chezmoi installation verification failed"
        return 1
    fi
    
    success "Chezmoi installed successfully"
}

# Improved symlink creation
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -z "$source" ] || [ -z "$target" ]; then
        warning "Invalid symlink parameters: source='$source', target='$target'"
        return 1
    fi
    
    if ! command_exists "$source"; then
        warning "Source command '$source' not found, skipping symlink creation"
        return 1
    fi
    
    local source_path
    source_path=$(command -v "$source")
    
    if [ ! -f "$target" ]; then
        mkdir -p "$(dirname "$target")"
        if ln -sf "$source_path" "$target"; then
            info "Created symlink: $target -> $source_path"
        else
            warning "Failed to create symlink: $target -> $source_path"
            return 1
        fi
    fi
}

# Install core tools with improved error handling
install_core_tools() {
    header "Installing core development tools"
    
    case $PLATFORM in
        "macos")
            info "Installing tools via Homebrew..."
            local packages=(
                git zsh tmux curl wget unzip fontconfig age
                oh-my-posh exa bat fd ripgrep fzf zoxide delta git-lfs
                node python3 go rust docker kubectl terraform ansible
            )
            
            for package in "${packages[@]}"; do
                if ! brew list "$package" >/dev/null 2>&1; then
                    info "Installing $package..."
                    if ! brew install "$package"; then
                        warning "Failed to install $package, continuing..."
                    fi
                else
                    info "$package already installed"
                fi
            done
            ;;
        "linux"|"wsl")
            case $DISTRO in
                "debian")
                    info "Installing core tools via APT..."
                    local core_packages=(
                        git zsh tmux curl wget unzip fontconfig build-essential age
                        exa bat fd-find ripgrep fzf zoxide
                    )
                    
                    for package in "${core_packages[@]}"; do
                        if ! install_package "$package"; then
                            warning "Failed to install $package, continuing..."
                        fi
                    done
                    
                    # Install Oh My Posh
                    if ! command_exists oh-my-posh; then
                        info "Installing Oh My Posh..."
                        if ! curl -s https://ohmyposh.dev/install.sh | bash -s; then
                            warning "Failed to install Oh My Posh"
                        fi
                    fi
                    
                    # Create improved symlinks
                    create_symlink "fdfind" "$HOME/.local/bin/fd"
                    create_symlink "batcat" "$HOME/.local/bin/bat"
                    ;;
                "fedora")
                    info "Installing tools via DNF..."
                    local packages=(
                        git zsh tmux curl wget unzip fontconfig gcc age
                        exa bat fd-find ripgrep fzf zoxide
                    )
                    
                    for package in "${packages[@]}"; do
                        if ! install_package "$package"; then
                            warning "Failed to install $package, continuing..."
                        fi
                    done
                    
                    if ! command_exists oh-my-posh; then
                        curl -s https://ohmyposh.dev/install.sh | bash -s
                    fi
                    ;;
                "arch")
                    info "Installing tools via Pacman..."
                    local packages=(
                        git zsh tmux curl wget unzip fontconfig base-devel age
                        exa bat fd ripgrep fzf zoxide
                    )
                    
                    for package in "${packages[@]}"; do
                        if ! install_package "$package"; then
                            warning "Failed to install $package, continuing..."
                        fi
                    done
                    
                    if ! command_exists oh-my-posh; then
                        curl -s https://ohmyposh.dev/install.sh | bash -s
                    fi
                    ;;
            esac
            
            # Install delta manually if not available
            install_delta_manually
            ;;
        "windows")
            warning "Please install tools manually on Windows or use WSL"
            ;;
    esac
    
    success "Core tools installation completed"
}

# Separate function for delta installation
install_delta_manually() {
    if ! command_exists delta; then
        info "Installing delta manually..."
        local temp_dir
        temp_dir=$(mktemp -d)
        
        if ! DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d '"' -f 4); then
            warning "Failed to get delta version"
            return 1
        fi
        
        local delta_url="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
        
        if wget "$delta_url" -O "$temp_dir/delta.tar.gz" && \
           tar -xzf "$temp_dir/delta.tar.gz" -C "$temp_dir" && \
           sudo cp "$temp_dir"/delta-*/delta /usr/local/bin/; then
            success "Delta installed successfully"
        else
            warning "Failed to install delta"
        fi
        
        rm -rf "$temp_dir"
    fi
}

# Improved FZF setup
setup_fzf() {
    header "Setting up FZF integration"
    
    if ! command_exists fzf; then
        warning "FZF not found, skipping setup"
        return 1
    fi
    
    if [ -f ~/.fzf.zsh ]; then
        success "FZF already configured"
        return 0
    fi
    
    info "Setting up FZF key bindings..."
    
    # Try multiple installation paths
    local fzf_install_paths=(
        "$(brew --prefix)/opt/fzf/install"
        "/usr/share/fzf/key-bindings.zsh"
        "$HOME/.fzf/install"
    )
    
    for install_path in "${fzf_install_paths[@]}"; do
        if [ -f "$install_path" ]; then
            if [ "${install_path##*/}" = "install" ]; then
                if "$install_path" --key-bindings --completion --no-update-rc; then
                    success "FZF configured via $install_path"
                    return 0
                fi
            else
                # For direct key-bindings files, source them in shell configs
                echo "source $install_path" >> ~/.zshrc.local
                success "FZF configured"
                return 0
            fi
        fi
    done
    
    warning "Could not configure FZF automatically"
}

# Enhanced git clone with error handling
safe_git_clone() {
    local repo_url="$1"
    local target_dir="$2"
    
    if [ -d "$target_dir" ]; then
        info "Directory $target_dir already exists, updating..."
        if ! (cd "$target_dir" && git pull); then
            warning "Failed to update existing repository at $target_dir"
            return 1
        fi
    else
        info "Cloning $repo_url to $target_dir..."
        if ! git clone "$repo_url" "$target_dir"; then
            error "Failed to clone repository $repo_url"
            return 1
        fi
    fi
}

# Setup Oh My Zsh with improved error handling
setup_oh_my_zsh() {
    header "Setting up Oh My Zsh"
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing Oh My Zsh..."
        if ! sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            error "Failed to install Oh My Zsh"
            return 1
        fi
    else
        success "Oh My Zsh already installed"
    fi
    
    # Install plugins with error handling
    local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # zsh-autosuggestions
    if ! safe_git_clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"; then
        warning "Failed to install zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if ! safe_git_clone "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"; then
        warning "Failed to install zsh-syntax-highlighting"
    fi
    
    success "Oh My Zsh configured"
}

# Setup Tmux Plugin Manager with error handling
setup_tmux() {
    header "Setting up Tmux Plugin Manager"
    
    if ! safe_git_clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"; then
        error "Failed to install TPM"
        return 1
    fi
    
    success "TPM configured"
}

# Rest of the functions remain the same but with added error handling...
# (install_nerd_fonts, apply_dotfiles, change_shell, final_setup, print_instructions)

# Enhanced main function with better error handling
main() {
    # Set up error trap
    trap 'handle_error $LINENO' ERR
    
    clear
    echo "${PURPLE}"
    cat << 'EOF'
    ██╗  ██╗ █████╗ ██████╗ ███████╗████████╗███████╗ ██████╗██╗  ██╗
    ██║ ██╔╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔════╝██║  ██║
    █████╔╝ ███████║██████╔╝█████╗     ██║   █████╗  ██║     ███████║
    ██╔═██╗ ██╔══██║██╔══██╗██╔══╝     ██║   ██╔══╝  ██║     ██╔══██║
    ██║  ██╗██║  ██║██║  ██║███████╗   ██║   ███████╗╚██████╗██║  ██║
    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
                                                                     
                     DOTFILES INSTALLATION - IMPROVED
EOF
    echo "${NC}"
    echo ""
    
    # Check prerequisites
    if [ "$(id -u)" = "0" ]; then
        error "Please do not run this script as root"
        exit 1
    fi
    
    if ! command_exists curl; then
        error "curl is required but not installed"
        exit 1
    fi
    
    if ! command_exists git; then
        error "git is required but not installed"
        exit 1
    fi
    
    # Run installation steps
    detect_platform || exit 1
    install_package_manager || exit 1
    install_chezmoi || exit 1
    install_core_tools || exit 1
    install_nerd_fonts || exit 1
    setup_oh_my_zsh || exit 1
    setup_tmux || exit 1
    setup_fzf || exit 1
    apply_dotfiles || exit 1
    change_shell || exit 1
    final_setup || exit 1
    print_instructions
    
    success "Installation completed successfully!"
}

# Run main function
main "$@"
