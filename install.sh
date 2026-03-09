#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║           dotfiles — interactive onboarding wizard                          ║
# ║           Usage: bash install.sh   (or curl piped to bash)                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
# Supports: macOS · Linux (Ubuntu/Debian) · Windows WSL2
# One-command bootstrap:
#   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kareemschultz
#
# Or step through this wizard manually:
#   bash <(curl -fsSL https://raw.githubusercontent.com/kareemschultz/dotfiles/main/install.sh)

set -euo pipefail

# ── Colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

ok()   { echo -e "${GREEN}  ✓${RESET}  $*"; }
warn() { echo -e "${YELLOW}  ⚠${RESET}  $*"; }
info() { echo -e "${CYAN}  →${RESET}  $*"; }
die()  { echo -e "${RED}  ✗  $*${RESET}" >&2; exit 1; }
hr()   { echo -e "${BLUE}$(printf '─%.0s' {1..72})${RESET}"; }

# ── Banner ────────────────────────────────────────────────────────────────────
clear
echo ""
echo -e "${BOLD}${CYAN}"
cat << 'BANNER'
  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
BANNER
echo -e "${RESET}"
echo -e "  ${BOLD}Cross-platform developer environment${RESET} — chezmoi managed"
echo -e "  ${CYAN}Ghostty · Zsh · Starship · Neovim (LazyVim) · tmux · Catppuccin${RESET}"
echo ""
hr

# ── Detect platform ───────────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Darwin)  PLATFORM="macOS" ;;
    Linux)   PLATFORM="Linux" ;;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="Windows" ;;
    *)       PLATFORM="Unknown" ;;
esac

echo ""
echo -e "  ${BOLD}Platform detected:${RESET} ${GREEN}${PLATFORM} (${ARCH})${RESET}"
echo ""

# ── Pre-flight checks ─────────────────────────────────────────────────────────
hr
echo -e "\n  ${BOLD}Pre-flight checks...${RESET}\n"

# git
if command -v git &>/dev/null; then
    ok "git $(git --version | awk '{print $3}')"
else
    die "git not found. Install git first."
fi

# curl
if command -v curl &>/dev/null; then
    ok "curl available"
else
    die "curl not found. Install curl first."
fi

# Internet connectivity
if curl -fsS --max-time 5 https://get.chezmoi.io > /dev/null 2>&1; then
    ok "Internet connectivity"
else
    die "Cannot reach get.chezmoi.io — check your connection."
fi

echo ""

# ── Interactive prompts ───────────────────────────────────────────────────────
hr
echo -e "\n  ${BOLD}Let's configure your machine...${RESET}\n"

# GitHub username
echo -e "  ${CYAN}Your GitHub username${RESET} (dotfiles repo must be at github.com/USERNAME/dotfiles):"
printf "  › "; read -r GITHUB_USER
[[ -z "$GITHUB_USER" ]] && die "GitHub username is required."

# Full name
echo -e "\n  ${CYAN}Your full name${RESET} (used in git commits):"
printf "  › "; read -r GIT_NAME
[[ -z "$GIT_NAME" ]] && die "Name is required."

# Email
echo -e "\n  ${CYAN}Your git email address:${RESET}"
printf "  › "; read -r GIT_EMAIL
[[ -z "$GIT_EMAIL" ]] && die "Email is required."

# Profile
echo -e "\n  ${CYAN}Machine profile:${RESET}"
echo "    1) personal  — full stack: terminal, editor, shell, Obsidian"
echo "    2) work      — same as personal + work git email override"
echo "    3) server    — minimal: no terminal apps, no Obsidian, no greeting"
printf "  › [1/2/3]: "; read -r PROFILE_CHOICE
case "$PROFILE_CHOICE" in
    1|"") PROFILE="personal" ;;
    2)    PROFILE="work" ;;
    3)    PROFILE="server" ;;
    *)    PROFILE="personal" ;;
esac
ok "Profile: ${BOLD}$PROFILE${RESET}"

# Obsidian vault (skip for server)
OBSIDIAN_VAULT=""
if [[ "$PROFILE" != "server" ]]; then
    echo -e "\n  ${CYAN}Obsidian vault path${RESET} (leave blank to use ~/notes):"
    printf "  › "; read -r OBSIDIAN_VAULT
    OBSIDIAN_VAULT="${OBSIDIAN_VAULT:-$HOME/notes}"
    OBSIDIAN_VAULT="${OBSIDIAN_VAULT/#\~/$HOME}"
    ok "Obsidian vault: ${BOLD}$OBSIDIAN_VAULT${RESET}"
fi

echo ""
hr
echo ""
echo -e "  ${BOLD}Summary — about to apply:${RESET}"
echo ""
echo -e "  GitHub user : ${GREEN}$GITHUB_USER${RESET}"
echo -e "  Name        : ${GREEN}$GIT_NAME${RESET}"
echo -e "  Email       : ${GREEN}$GIT_EMAIL${RESET}"
echo -e "  Profile     : ${GREEN}$PROFILE${RESET}"
[[ -n "$OBSIDIAN_VAULT" ]] && echo -e "  Vault       : ${GREEN}$OBSIDIAN_VAULT${RESET}"
echo -e "  Platform    : ${GREEN}$PLATFORM${RESET}"
echo ""
echo -e "  ${BOLD}Scripts that will run:${RESET}"
[[ "$PLATFORM" == "macOS" ]] && echo "    • Install Homebrew (if missing)"
echo "    • Install packages (brew/apt/scoop depending on platform)"
[[ "$PLATFORM" == "Linux" ]] && echo "    • Install JetBrains Mono Nerd Font"
echo "    • Install TPM (tmux plugin manager)"
[[ "$PROFILE" != "server" ]] && echo "    • Set zsh as default shell"
[[ "$PROFILE" != "server" && -n "$OBSIDIAN_VAULT" ]] && echo "    • Bootstrap Obsidian vault at $OBSIDIAN_VAULT"
echo ""

printf "  ${BOLD}Proceed?${RESET} [Y/n] "; read -r CONFIRM
case "${CONFIRM:-Y}" in
    [Yy]*|"") ;;
    *) echo "Aborted."; exit 0 ;;
esac

echo ""
hr
echo -e "\n  ${BOLD}Step 1/3 — Installing chezmoi...${RESET}\n"

if command -v chezmoi &>/dev/null; then
    ok "chezmoi $(chezmoi --version | awk '{print $3}') already installed"
else
    info "Downloading chezmoi installer..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
    ok "chezmoi installed to ~/.local/bin/chezmoi"
fi

echo ""
hr
echo -e "\n  ${BOLD}Step 2/3 — Initialising dotfiles repo...${RESET}\n"
info "Cloning github.com/$GITHUB_USER/dotfiles..."
echo ""

# Build the init command — pass all our answers as promptString flags
# so chezmoi never interactively prompts (fully non-interactive)
CHEZMOI_ARGS=(
    init
    --apply
    --promptString "name=$GIT_NAME"
    --promptString "email=$GIT_EMAIL"
    --promptChoice "profile=$PROFILE"
)
[[ -n "$OBSIDIAN_VAULT" ]] && CHEZMOI_ARGS+=(--promptString "obsidian_vault=$OBSIDIAN_VAULT")
CHEZMOI_ARGS+=("$GITHUB_USER")

chezmoi "${CHEZMOI_ARGS[@]}"

echo ""
hr
echo -e "\n  ${BOLD}Step 3/3 — Post-install steps...${RESET}\n"

# Verify key tools
TOOLS=(zsh starship nvim tmux atuin)
[[ "$PROFILE" != "server" ]] && TOOLS+=(lazygit gh fastfetch)
for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &>/dev/null; then
        ok "$tool"
    else
        warn "$tool not found — may need a new shell session or PATH update"
    fi
done

echo ""
hr
echo ""
echo -e "  ${BOLD}${GREEN}✓ Done!${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo ""
echo -e "  1. ${CYAN}Reload your shell${RESET}"
echo -e "     ${BOLD}exec zsh${RESET}   (or open a new terminal window)"
echo ""
echo -e "  2. ${CYAN}Install tmux plugins${RESET}"
echo -e "     Start tmux, then press ${BOLD}Ctrl+A  I${RESET}  (capital i)"
echo ""
echo -e "  3. ${CYAN}Install Neovim plugins${RESET}"
echo -e "     Open nvim — LazyVim will auto-install everything on first launch"
echo ""
if [[ "$PROFILE" != "server" ]]; then
echo -e "  4. ${CYAN}Set up shell history sync (Atuin)${RESET}"
echo -e "     ${BOLD}atuin register${RESET}  (atuin.sh cloud, E2E encrypted)"
echo -e "     or: ${BOLD}atuin login -u USERNAME${RESET}  (if already registered)"
echo ""
echo -e "  5. ${CYAN}Set up GitHub CLI${RESET}"
echo -e "     ${BOLD}gh auth login${RESET}"
echo -e "     ${BOLD}gh extension install dlvhdr/gh-dash${RESET}   ← GitHub dashboard"
echo ""
fi
echo -e "  ${BOLD}Daily workflow:${RESET}"
echo -e "     ${CYAN}chezmoi update${RESET}          pull + apply latest"
echo -e "     ${CYAN}chezmoi edit --apply FILE${RESET}   edit a dotfile"
echo -e "     ${CYAN}chezmoi diff${RESET}            preview pending changes"
echo -e "     ${CYAN}chezmoi cd${RESET}              open source dir in shell"
echo ""
echo -e "  ${CYAN}Full docs:${RESET} https://github.com/$GITHUB_USER/dotfiles"
echo ""
hr
echo ""
