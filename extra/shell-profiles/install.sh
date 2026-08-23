#!/bin/bash
# filepath: /workspaces/git_workshop_champlain_college_2025/shell-profiles/install.sh

# Git Workshop Shell Profile Installer
# This script installs enhanced shell profiles with modern fzf integration for the git workshop
# 
# Features:
# - Latest fzf with Ctrl+T file finder, Ctrl+R history search, Alt+C directory finder
# - Cross-platform support (Ubuntu, Debian, Fedora, Arch, macOS)
# - Compatible with both bash and zsh
# - Enhanced file previews with bat and fd integration
# - Git-aware fuzzy finding in git-focused profile
#
# Usage: ./install.sh [profile_name] [--auto] [--minimal-deps]

set -e

# Parse arguments
AUTO_MODE=false
MINIMAL_DEPS=false
PROFILE_ARG=""

for arg in "$@"; do
    case $arg in
        --auto)
            AUTO_MODE=true
            ;;
        --minimal-deps)
            MINIMAL_DEPS=true
            ;;
        --help|-h)
            echo "Usage: $0 [profile_name] [--auto] [--minimal-deps]"
            echo "  profile_name: minimal, developer, poweruser, or git-focused"
            echo "  --auto: Skip interactive prompts for optional components"
            echo "  --minimal-deps: Only install essential dependencies"
            exit 0
            ;;
        -*)
            echo "Unknown option: $arg"
            exit 1
            ;;
        *)
            if [ -z "$PROFILE_ARG" ]; then
                PROFILE_ARG="$arg"
            fi
            ;;
    esac
done

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Environment validation
validate_environment() {
    echo -e "${BLUE}Validating environment...${NC}"
    
    # Check if HOME is set
    if [ -z "$HOME" ]; then
        echo -e "${RED}Error: HOME environment variable not set${NC}"
        return 1
    fi
    
    # Check if we can write to HOME
    if [ ! -w "$HOME" ]; then
        echo -e "${RED}Error: Cannot write to HOME directory: $HOME${NC}"
        return 1
    fi
    
    # Check current user
    CURRENT_USER="${USER:-$(whoami 2>/dev/null || echo 'unknown')}"
    echo -e "${GREEN}✓ Running as user: $CURRENT_USER${NC}"
    echo -e "${GREEN}✓ HOME directory: $HOME${NC}"
    
    # Check shell availability
    if [ -n "$ZSH_VERSION" ]; then
        echo -e "${GREEN}✓ Running in zsh: $ZSH_VERSION${NC}"
    elif [ -n "$BASH_VERSION" ]; then
        echo -e "${GREEN}✓ Running in bash: $BASH_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠️  Unknown shell, but proceeding...${NC}"
    fi
    
    # Check if we're in a container/codespace
    if [ -f /.dockerenv ] || [ -n "$CODESPACES" ] || [ -n "$GITPOD_WORKSPACE_ID" ]; then
        echo -e "${BLUE}ℹ️  Container/Cloud environment detected${NC}"
    fi
    
    return 0
}

# Fix Windows line endings if running on Unix-like systems
if command -v dos2unix >/dev/null 2>&1; then
    # Convert this script and all profile files to Unix line endings
    dos2unix "$0" 2>/dev/null || true
    find "$SCRIPT_DIR" -name "*.sh" -exec dos2unix {} \; 2>/dev/null || true
elif command -v sed >/dev/null 2>&1; then
    # Fallback: use sed to remove carriage returns
    sed -i 's/\r$//' "$0" 2>/dev/null || true
    find "$SCRIPT_DIR" -name "*.sh" -exec sed -i 's/\r$//' {} \; 2>/dev/null || true
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Git Workshop Shell Profile Installer${NC}"
echo "========================================="

# Function to detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Function to install packages based on distribution
install_package() {
    local package="$1"
    local distro=$(detect_distro)
    
    echo -e "${BLUE}Installing $package...${NC}"
    
    case "$distro" in
        ubuntu|debian|pop)
            if sudo apt update && sudo apt install -y "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        fedora)
            if sudo dnf install -y "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        centos|rhel|rocky|almalinux)
            if sudo yum install -y "$package" || sudo dnf install -y "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        arch|manjaro)
            if sudo pacman -S --noconfirm "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        opensuse*)
            if sudo zypper install -y "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        alpine)
            if sudo apk add "$package"; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                return 1
            fi
            ;;
        *)
            echo -e "${YELLOW}Unknown distribution ($distro). Please install $package manually.${NC}"
            echo -e "${YELLOW}Common commands:${NC}"
            echo -e "  ${YELLOW}Ubuntu/Debian:${NC} sudo apt install $package"
            echo -e "  ${YELLOW}Fedora:${NC} sudo dnf install $package"
            echo -e "  ${YELLOW}CentOS/RHEL:${NC} sudo yum install $package"
            echo -e "  ${YELLOW}Arch:${NC} sudo pacman -S $package"
            return 1
            ;;
    esac
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${BLUE}Installing Oh My Zsh...${NC}"
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        elif command -v wget >/dev/null 2>&1; then
            sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
        else
            echo -e "${RED}Error: curl or wget required to install Oh My Zsh${NC}"
            return 1
        fi
        echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
    else
        echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
    fi
}

# Function to install Starship prompt
# Function to install Starship prompt
install_starship() {
    if ! command -v starship >/dev/null 2>&1; then
        echo -e "${BLUE}Installing Starship prompt...${NC}"
        if command -v curl >/dev/null 2>&1; then
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        else
            echo -e "${YELLOW}Please install Starship manually: https://starship.rs/guide/#step-1-install-starship${NC}"
            return 1
        fi
        echo -e "${GREEN}✓ Starship installed and will be auto-configured${NC}"
        echo -e "${BLUE}Note: Starship will be automatically initialized in developer, poweruser, and git-focused profiles${NC}"
    else
        echo -e "${GREEN}✓ Starship already installed and will be auto-configured${NC}"
    fi
}

# Function to install fzf and related tools
install_fzf() {
    echo -e "${BLUE}Installing latest fzf and related tools...${NC}"
    
    # Remove any existing fzf installation
    if [ -d "$HOME/.fzf" ]; then
        echo -e "${YELLOW}Removing existing fzf installation...${NC}"
        rm -rf "$HOME/.fzf"
    fi
    
    # Clone latest fzf from GitHub
    echo -e "${BLUE}Cloning latest fzf from GitHub...${NC}"
    if git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"; then
        cd "$HOME/.fzf"
        
        # Get the latest stable version
        git fetch --tags >/dev/null 2>&1
        latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null || echo "main")
        if [ "$latest_tag" != "main" ]; then
            echo -e "${BLUE}Switching to latest version: $latest_tag${NC}"
            git checkout "$latest_tag" >/dev/null 2>&1
        fi
        
        # Install fzf with proper shell integration
        echo -e "${BLUE}Installing fzf with shell integration...${NC}"
        "$HOME/.fzf/install" --all --no-update-rc
        
        # Fix .fzf.zsh to prioritize new fzf binary in PATH
        cat > "$HOME/.fzf.zsh" << 'EOF'
# Setup fzf - prioritize latest version over system fzf
# ---------
# Remove any existing ~/.fzf/bin from PATH and add it to the front
PATH_WITHOUT_FZF="${PATH//:$HOME\/.fzf\/bin/}"
PATH_WITHOUT_FZF="${PATH_WITHOUT_FZF//$HOME\/.fzf\/bin:/}"
PATH_WITHOUT_FZF="${PATH_WITHOUT_FZF//$HOME\/.fzf\/bin/}"
export PATH="$HOME/.fzf/bin:$PATH_WITHOUT_FZF"

# Load fzf shell integration
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    # Use modern integration for fzf 0.48+
    source <(fzf --zsh)
  else
    # Fallback for older versions
    [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
    source "$HOME/.fzf/shell/key-bindings.zsh"
  fi
fi
EOF
        
        # Fix .fzf.bash to prioritize new fzf binary in PATH
        cat > "$HOME/.fzf.bash" << 'EOF'
# Setup fzf - prioritize latest version over system fzf
# ---------
# Remove any existing ~/.fzf/bin from PATH and add it to the front
PATH_WITHOUT_FZF="${PATH//:$HOME\/.fzf\/bin/}"
PATH_WITHOUT_FZF="${PATH_WITHOUT_FZF//$HOME\/.fzf\/bin:/}"
PATH_WITHOUT_FZF="${PATH_WITHOUT_FZF//$HOME\/.fzf\/bin/}"
export PATH="$HOME/.fzf/bin:$PATH_WITHOUT_FZF"

# Load fzf shell integration
if command -v fzf >/dev/null 2>&1; then
  if fzf --bash >/dev/null 2>&1; then
    # Use modern integration for fzf 0.48+
    source <(fzf --bash)
  else
    # Fallback for older versions
    [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null
    source "$HOME/.fzf/shell/key-bindings.bash"
  fi
fi
EOF
        
        echo -e "${GREEN}✓ Latest fzf installed successfully${NC}"
        echo -e "${BLUE}fzf version: $(~/.fzf/bin/fzf --version)${NC}"
    else
        echo -e "${RED}✗ Failed to clone fzf repository${NC}"
        return 1
    fi
    
    # Install bat for better file previews
    local distro=$(detect_distro)
    case "$distro" in
        ubuntu|debian|pop)
            if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1; then
                echo -e "${BLUE}Installing bat for file previews...${NC}"
                sudo apt update >/dev/null 2>&1
                sudo apt install -y bat || true
                # Create bat symlink if it was installed as batcat
                if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
                    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
                fi
            fi
            ;;
        fedora|rhel|centos)
            if ! command -v bat >/dev/null 2>&1; then
                echo -e "${BLUE}Installing bat for file previews...${NC}"
                sudo dnf install -y bat || true
            fi
            ;;
        arch|manjaro)
            if ! command -v bat >/dev/null 2>&1; then
                echo -e "${BLUE}Installing bat for file previews...${NC}"
                sudo pacman -S --noconfirm bat || true
            fi
            ;;
        *)
            echo -e "${YELLOW}bat package not available for this distribution. File previews will use basic 'head' command${NC}"
            ;;
    esac
    
    # Install fd for better file finding (optional)
    case "$distro" in
        ubuntu|debian|pop)
            if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
                echo -e "${BLUE}Installing fd for enhanced file finding...${NC}"
                sudo apt install -y fd-find || true
                # Create fd symlink if it was installed as fdfind
                if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
                fi
            fi
            ;;
        fedora|rhel|centos)
            if ! command -v fd >/dev/null 2>&1; then
                echo -e "${BLUE}Installing fd for enhanced file finding...${NC}"
                sudo dnf install -y fd-find || true
            fi
            ;;
        arch|manjaro)
            if ! command -v fd >/dev/null 2>&1; then
                echo -e "${BLUE}Installing fd for enhanced file finding...${NC}"
                sudo pacman -S --noconfirm fd || true
            fi
            ;;
        *)
            echo -e "${YELLOW}fd package not available for this distribution. Using standard find command${NC}"
            ;;
    esac
}

# Function to install fonts and icon support
install_fonts_and_icons() {
    echo -e "\n${BLUE}Installing fonts and icon support...${NC}"
    
    local distro=$(detect_distro)
    
    case "$distro" in
        ubuntu|debian|pop)
            # Install font management tools
            if ! command -v fc-list >/dev/null 2>&1; then
                echo -e "${BLUE}Installing fontconfig...${NC}"
                sudo apt update && sudo apt install -y fontconfig
            fi
            
            # Install essential fonts for icons and symbols
            echo -e "${BLUE}Installing fonts for terminal icons...${NC}"
            sudo apt install -y \
                fonts-powerline \
                fonts-font-awesome \
                fonts-dejavu \
                fonts-liberation \
                fonts-noto-color-emoji \
                ttf-ubuntu-font-family \
                fontconfig-config \
                unzip \
                ca-certificates || true
            
            # Install Nerd Fonts (FiraCode Nerd Font)
            if [ ! -f "$HOME/.local/share/fonts/FiraCodeNerdFont-Regular.ttf" ]; then
                echo -e "${BLUE}Installing FiraCode Nerd Font...${NC}"
                mkdir -p "$HOME/.local/share/fonts"
                cd /tmp
                
                if curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip; then
                    if command -v unzip >/dev/null 2>&1; then
                        unzip -o FiraCode.zip -d "$HOME/.local/share/fonts/"
                        rm -f FiraCode.zip
                        fc-cache -fv 2>/dev/null || true
                        echo -e "${GREEN}✓ FiraCode Nerd Font installed${NC}"
                    else
                        echo -e "${YELLOW}⚠ unzip not available, skipping Nerd Font installation${NC}"
                        rm -f FiraCode.zip
                    fi
                else
                    echo -e "${YELLOW}⚠ Failed to download FiraCode Nerd Font${NC}"
                fi
            fi
            ;;
        fedora)
            sudo dnf install -y \
                fontconfig \
                powerline-fonts \
                fontawesome-fonts \
                dejavu-fonts-all \
                liberation-fonts \
                google-noto-emoji-color-fonts || true
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum install -y fontconfig || sudo dnf install -y fontconfig || true
            # Note: Many font packages may not be available in default repos
            echo -e "${YELLOW}Some font packages may need to be installed manually on RHEL-based systems${NC}"
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm \
                fontconfig \
                powerline-fonts \
                ttf-font-awesome \
                ttf-dejavu \
                ttf-liberation \
                noto-fonts-emoji || true
            ;;
        opensuse*)
            sudo zypper install -y \
                fontconfig \
                powerline-fonts \
                fontawesome-fonts \
                dejavu-fonts \
                liberation-fonts || true
            ;;
        alpine)
            sudo apk add \
                fontconfig \
                font-awesome \
                ttf-dejavu \
                ttf-liberation || true
            ;;
        *)
            echo -e "${YELLOW}Unknown distribution. Please install fonts manually:${NC}"
            echo -e "  - fontconfig (font management)"
            echo -e "  - powerline-fonts (powerline symbols)"
            echo -e "  - font-awesome (icon fonts)"
            echo -e "  - A Nerd Font (recommended: FiraCode Nerd Font)"
            ;;
    esac
    
    echo -e "${GREEN}✓ Font and icon support installed${NC}"
}

# Check and install prerequisites
check_prerequisites() {
    echo -e "\n${BLUE}Checking prerequisites...${NC}"
    
    # Check for Zsh
    if ! command -v zsh >/dev/null 2>&1; then
        echo -e "${YELLOW}Zsh not found. Installing...${NC}"
        install_package "zsh"
        
        # Offer to change default shell
        if command -v zsh >/dev/null 2>&1; then
            echo -e "${YELLOW}Would you like to make Zsh your default shell? (y/n):${NC}"
            read -r make_default
            if [[ "$make_default" =~ ^[Yy]$ ]]; then
                if command -v chsh >/dev/null 2>&1; then
                    chsh -s "$(which zsh)"
                    echo -e "${GREEN}✓ Default shell changed to Zsh${NC}"
                    echo -e "${YELLOW}Please log out and back in for the change to take effect${NC}"
                else
                    echo -e "${YELLOW}chsh not available. Please change default shell manually${NC}"
                fi
            fi
        fi
    else
        echo -e "${GREEN}✓ Zsh found${NC}"
    fi
    
    # Check for Git
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${YELLOW}Git not found. Installing...${NC}"
        install_package "git"
    else
        echo -e "${GREEN}✓ Git found${NC}"
    fi
    
    # Check for curl or wget
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        echo -e "${YELLOW}curl/wget not found. Installing curl...${NC}"
        install_package "curl"
    else
        echo -e "${GREEN}✓ curl/wget found${NC}"
    fi
    
    # Check for unzip (needed for font installation)
    if ! command -v unzip >/dev/null 2>&1; then
        echo -e "${YELLOW}unzip not found. Installing...${NC}"
        install_package "unzip"
    else
        echo -e "${GREEN}✓ unzip found${NC}"
    fi
    
    # Install fonts and icons for proper terminal display
    install_fonts_and_icons
    
    echo -e "${GREEN}✓ Basic prerequisites checked${NC}"
}

# Ask about optional components
ask_optional_components() {
    if [ "$MINIMAL_DEPS" = true ]; then
        echo -e "${YELLOW}Minimal dependencies mode - skipping optional components${NC}"
        return 0
    fi
    
    echo -e "\n${BLUE}Optional components:${NC}"
    
    # Oh My Zsh
    if command -v zsh >/dev/null 2>&1 && [ ! -d "$HOME/.oh-my-zsh" ]; then
        if [ "$AUTO_MODE" = true ]; then
            echo -e "${BLUE}Auto mode: Installing Oh My Zsh${NC}"
            install_oh_my_zsh
        else
            echo -e "${YELLOW}Install Oh My Zsh for enhanced Zsh experience? (y/n):${NC}"
            read -r install_omz
            if [[ "$install_omz" =~ ^[Yy]$ ]]; then
                install_oh_my_zsh
            fi
        fi
    fi
    
    # Starship
    if ! command -v starship >/dev/null 2>&1; then
        if [ "$AUTO_MODE" = true ]; then
            echo -e "${BLUE}Auto mode: Installing Starship${NC}"
            install_starship
        else
            echo -e "${YELLOW}Install Starship for a modern cross-shell prompt? (y/n):${NC}"
            read -r install_star
            if [[ "$install_star" =~ ^[Yy]$ ]]; then
                install_starship
            fi
        fi
    fi
    
    # fzf - Always install/update to latest version for Ctrl+T functionality
    if [ "$AUTO_MODE" = true ]; then
        echo -e "${BLUE}Auto mode: Installing/updating fzf to latest version${NC}"
        install_fzf
    else
        if command -v fzf >/dev/null 2>&1; then
            echo -e "${YELLOW}fzf found. Update to latest version for enhanced Ctrl+T functionality? (y/n):${NC}"
        else
            echo -e "${YELLOW}Install fzf for fuzzy finding and enhanced Ctrl+T search? (y/n):${NC}"
        fi
        read -r install_fzf_opt
        if [[ "$install_fzf_opt" =~ ^[Yy]$ ]]; then
            install_fzf
        fi
    fi
}

# Run environment validation and prerequisite checks
if ! validate_environment; then
    echo -e "${RED}Environment validation failed. Please fix the issues above and try again.${NC}"
    exit 1
fi

check_prerequisites
ask_optional_components

echo -e "\n${BLUE}Proceeding with profile installation...${NC}"

# Detect available shells and configure accordingly
SHELLS_TO_CONFIGURE=()

# Check which shells are available and should be configured
if command -v zsh >/dev/null 2>&1 && [ -f "$HOME/.zshrc" ]; then
    SHELLS_TO_CONFIGURE+=("zsh")
fi

if command -v bash >/dev/null 2>&1 && [ -f "$HOME/.bashrc" ]; then
    SHELLS_TO_CONFIGURE+=("bash")
fi

# If no shell configs found, create them
if [ ${#SHELLS_TO_CONFIGURE[@]} -eq 0 ]; then
    if command -v zsh >/dev/null 2>&1; then
        echo -e "${BLUE}Creating ~/.zshrc...${NC}"
        touch "$HOME/.zshrc"
        SHELLS_TO_CONFIGURE+=("zsh")
    fi
    if command -v bash >/dev/null 2>&1; then
        echo -e "${BLUE}Creating ~/.bashrc...${NC}"
        touch "$HOME/.bashrc"
        SHELLS_TO_CONFIGURE+=("bash")
    fi
fi

# Determine primary shell for detection logic
SHELL_TYPE=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_TYPE="zsh"
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_TYPE="bash"
    SHELL_RC="$HOME/.bashrc"
elif command -v zsh >/dev/null 2>&1; then
    SHELL_TYPE="zsh"
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_TYPE="bash"
    SHELL_RC="$HOME/.bashrc"
fi

echo -e "Available shells to configure: ${GREEN}${SHELLS_TO_CONFIGURE[*]}${NC}"
echo -e "Primary shell detected: ${GREEN}$SHELL_TYPE${NC}"

# Check for cross-shell configuration issues
if [ "$SHELL_TYPE" = "zsh" ] && [ -f "$HOME/.bashrc" ]; then
    if grep -q "shopt\|bash_completion" "$HOME/.bashrc" 2>/dev/null; then
        echo -e "\n${YELLOW}Warning: Your .bashrc contains Bash-specific commands.${NC}"
        echo -e "${YELLOW}If you source .bashrc from Zsh, you may see 'command not found: shopt' errors.${NC}"
        echo -e "${BLUE}Our profiles are cross-shell compatible and will be installed to $SHELL_RC${NC}"
        echo -e "${BLUE}Tip: Don't run 'source ~/.bashrc' in Zsh. Use 'source ~/.zshrc' instead.${NC}"
    fi
fi

# Available profiles
PROFILES=(
    "minimal:Basic shell improvements (no external dependencies)"
    "developer:Enhanced development environment (optional: fzf, starship)"
    "poweruser:Advanced features and shortcuts (optional: fzf, starship)"
    "git-focused:Git-specific enhancements (optional: fzf)"
)

# Show available profiles
echo -e "\n${BLUE}Available profiles:${NC}"
for i in "${!PROFILES[@]}"; do
    IFS=':' read -r name desc <<< "${PROFILES[$i]}"
    echo -e "  ${GREEN}$((i+1)). $name${NC} - $desc"
done

# Function to install profile for a specific shell
install_profile_for_shell() {
    local profile_name="$1"
    local shell_type="$2"
    local profile_file="$SCRIPT_DIR/profiles/${profile_name}.sh"
    local shell_rc=""
    
    if [ "$shell_type" = "zsh" ]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.bashrc"
    fi
    
    echo -e "${BLUE}Configuring $shell_type ($shell_rc)...${NC}"
    
    # Create backup of current shell rc
    if [ -f "$shell_rc" ]; then
        cp "$shell_rc" "$shell_rc.workshop-backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${GREEN}✓ Backup created for $shell_type${NC}"
    fi
    
    # Remove any existing workshop profile lines (cross-platform sed)
    if [ -f "$shell_rc" ]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' '/# Git Workshop Profile/d' "$shell_rc"
            sed -i '' '\|source.*git_workshop.*profiles|d' "$shell_rc"
            sed -i '' '/# fzf integration/d' "$shell_rc"
            sed -i '' '\|source.*\.fzf\.|d' "$shell_rc"
        else
            sed -i '/# Git Workshop Profile/d' "$shell_rc"
            sed -i '\|source.*git_workshop.*profiles|d' "$shell_rc"
            sed -i '/# fzf integration/d' "$shell_rc"
            sed -i '\|source.*\.fzf\.|d' "$shell_rc"
        fi
    fi
    
    # Add fzf integration first (so latest version is in PATH)
    echo "" >> "$shell_rc"
    echo "# fzf integration - prioritize latest version" >> "$shell_rc"
    if [ "$shell_type" = "zsh" ]; then
        echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$shell_rc"
    else
        echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> "$shell_rc"
    fi
    
    # Add new profile
    echo "" >> "$shell_rc"
    echo "# Git Workshop Profile - $profile_name" >> "$shell_rc"
    echo "if [ -f \"$profile_file\" ]; then" >> "$shell_rc"
    echo "    source \"$profile_file\"" >> "$shell_rc"
    echo "fi" >> "$shell_rc"
    
    echo -e "${GREEN}✓ Profile '$profile_name' installed for $shell_type${NC}"
}

# Function to install profile
install_profile() {
    local profile_name="$1"
    local profile_file="$SCRIPT_DIR/profiles/${profile_name}.sh"
    
    if [ ! -f "$profile_file" ]; then
        echo -e "${RED}Error: Profile file not found: $profile_file${NC}"
        return 1
    fi
    
    # Install for all available shells
    for shell in "${SHELLS_TO_CONFIGURE[@]}"; do
        install_profile_for_shell "$profile_name" "$shell"
    done
    
    echo -e "${YELLOW}Please restart your shell(s) or run:${NC}"
    for shell in "${SHELLS_TO_CONFIGURE[@]}"; do
        if [ "$shell" = "zsh" ]; then
            echo -e "${BLUE}  source ~/.zshrc${NC}"
        else
            echo -e "${BLUE}  source ~/.bashrc${NC}"
        fi
    done
}

# Interactive mode
if [ -z "$PROFILE_ARG" ]; then
    echo -e "\n${YELLOW}Choose a profile to install (1-${#PROFILES[@]}):${NC}"
    read -r choice
    
    if [[ "$choice" =~ ^[1-9][0-9]*$ ]] && [ "$choice" -le "${#PROFILES[@]}" ]; then
        IFS=':' read -r profile_name _ <<< "${PROFILES[$((choice-1))]}"
        install_profile "$profile_name"
    else
        echo -e "${RED}Invalid choice${NC}"
        exit 1
    fi
else
    # Command line mode
    install_profile "$PROFILE_ARG"
fi

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}To activate your new profile, run:${NC}"
for shell in "${SHELLS_TO_CONFIGURE[@]}"; do
    if [ "$shell" = "zsh" ]; then
        echo -e "${BLUE}  source ~/.zshrc${NC} (for zsh)"
    else
        echo -e "${BLUE}  source ~/.bashrc${NC} (for bash)"
    fi
done

# Run icon test if available
if [ -f "$SCRIPT_DIR/test-icons.sh" ]; then
    echo -e "\n${BLUE}Testing icon and font support...${NC}"
    bash "$SCRIPT_DIR/test-icons.sh"
    echo -e "\n${YELLOW}Note: If you see boxes or question marks instead of icons,${NC}"
    echo -e "${YELLOW}configure your terminal to use 'FiraCode Nerd Font' or another Nerd Font.${NC}"
fi
