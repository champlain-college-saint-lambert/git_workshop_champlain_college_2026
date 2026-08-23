#!/bin/bash
# filepath: /workspaces/git_workshop_champlain_college_2025/shell-profiles/themes/bash-colors.sh

# Bash Color Schemes for Git Workshop
# Source this file in your .bashrc

# Only proceed if we're in bash
if [ -z "$BASH_VERSION" ]; then
    echo "Warning: bash-colors.sh is designed for bash shell"
    return 1 2>/dev/null || exit 1
fi

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Git status colors
GIT_CLEAN_COLOR=$GREEN
GIT_DIRTY_COLOR=$YELLOW
GIT_STAGED_COLOR=$CYAN
GIT_UNTRACKED_COLOR=$RED

# Prompt color schemes
SCHEME_1_USER=$GREEN
SCHEME_1_HOST=$BLUE
SCHEME_1_PATH=$PURPLE
SCHEME_1_GIT=$YELLOW

SCHEME_2_USER=$CYAN
SCHEME_2_HOST=$GREEN
SCHEME_2_PATH=$BLUE
SCHEME_2_GIT=$RED

SCHEME_3_USER=$YELLOW
SCHEME_3_HOST=$PURPLE
SCHEME_3_PATH=$CYAN
SCHEME_3_GIT=$GREEN

# Git status function for Bash
git_status_color() {
    if ! command -v git >/dev/null 2>&1; then
        return
    fi
    
    local git_status="$(git status --porcelain 2>/dev/null)"
    local git_branch="$(git branch --show-current 2>/dev/null)"
    
    if [[ -n "$git_branch" ]]; then
        if [[ -z "$git_status" ]]; then
            echo -e "${GIT_CLEAN_COLOR}(${git_branch})${NC}"
        elif echo "$git_status" | grep -q '^??'; then
            echo -e "${GIT_UNTRACKED_COLOR}(${git_branch}?)${NC}"
        elif echo "$git_status" | grep -q '^[AM]'; then
            echo -e "${GIT_STAGED_COLOR}(${git_branch}+)${NC}"
        else
            echo -e "${GIT_DIRTY_COLOR}(${git_branch}*)${NC}"
        fi
    fi
}

# Prompt schemes with proper escaping
set_prompt_scheme_1() {
    PS1="\[\033[0;32m\]\u\[\033[0m\]@\[\033[0;34m\]\h\[\033[0m\]:\[\033[0;35m\]\w\[\033[0m\] \$(git_status_color)\$ "
}

set_prompt_scheme_2() {
    PS1="\[\033[0;36m\]\u\[\033[0m\]@\[\033[0;32m\]\h\[\033[0m\]:\[\033[0;34m\]\w\[\033[0m\] \$(git_status_color)\n\[\033[1;37m\]➜ \[\033[0m\]"
}

set_prompt_scheme_3() {
    PS1="\[\033[1m\]\[\033[1;33m\]\u\[\033[0m\] at \[\033[0;35m\]\h\[\033[0m\] in \[\033[0;36m\]\w\[\033[0m\] \$(git_status_color)\n\[\033[1;37m\]λ \[\033[0m\]"
}

# Default scheme
set_prompt_scheme_1

# Functions to change schemes
scheme1() { set_prompt_scheme_1; echo "Prompt scheme 1 activated"; }
scheme2() { set_prompt_scheme_2; echo "Prompt scheme 2 activated"; }
scheme3() { set_prompt_scheme_3; echo "Prompt scheme 3 activated"; }

# Color test function
color_test() {
    echo -e "${RED}Red${NC} ${GREEN}Green${NC} ${YELLOW}Yellow${NC} ${BLUE}Blue${NC} ${PURPLE}Purple${NC} ${CYAN}Cyan${NC} ${WHITE}White${NC}"
    echo -e "${BOLD}Bold${NC} Normal"
    echo "Git status examples:"
    echo -e "  ${GIT_CLEAN_COLOR}(main)${NC} - Clean repository"
    echo -e "  ${GIT_DIRTY_COLOR}(main*)${NC} - Modified files"
    echo -e "  ${GIT_STAGED_COLOR}(main+)${NC} - Staged files"
    echo -e "  ${GIT_UNTRACKED_COLOR}(main?)${NC} - Untracked files"
}

# Export colors for use in other scripts
export RED GREEN YELLOW BLUE PURPLE CYAN WHITE BOLD NC
export GIT_CLEAN_COLOR GIT_DIRTY_COLOR GIT_STAGED_COLOR GIT_UNTRACKED_COLOR

echo "🎨 Bash color schemes loaded! Use 'scheme1', 'scheme2', or 'scheme3' to change, 'color_test' to preview."