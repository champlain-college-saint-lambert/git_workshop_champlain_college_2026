#!/bin/bash
# filepath: /workspaces/git_workshop_champlain_college_2025/shell-profiles/profiles/git-focused.sh

# Git-focused shell profile
# Loads minimal profile first, then adds Git enhancements

# Prevent issues when sourcing .bashrc from Zsh or vice versa
# This profile is cross-shell compatible but warns about improper sourcing
if [ -n "$ZSH_VERSION" ] && [[ "${(%):-%N}" == *".bashrc"* ]]; then
    echo "Warning: You're sourcing .bashrc from Zsh. Consider using .zshrc instead."
    echo "This profile works in both shells, but your .bashrc may have Bash-specific commands."
elif [ -n "$BASH_VERSION" ] && [[ "${BASH_SOURCE[0]}" == *".zshrc"* ]]; then
    echo "Warning: You're sourcing .zshrc from Bash. Consider using .bashrc instead."
fi

# Profile info
export SHELL_PROFILE_NAME="git-focused"
export SHELL_PROFILE_VERSION="1.0.0"

# Load minimal profile as base (robust for Bash and Zsh)
if [ -n "$BASH_VERSION" ]; then
    _PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
    _PROFILE_DIR="$(cd "$(dirname "${(%):-%N}" 2>/dev/null)" && pwd)"
else
    _PROFILE_DIR="$(cd "$(dirname "$0" 2>/dev/null)" && pwd)"
fi
if [ -f "$_PROFILE_DIR/minimal.sh" ]; then
    . "$_PROFILE_DIR/minimal.sh"
elif [ -f "$_PROFILE_DIR/../minimal.sh" ]; then
    . "$_PROFILE_DIR/../minimal.sh"
fi

# Re-export profile info after loading base profile
export SHELL_PROFILE_NAME="git-focused"
export SHELL_PROFILE_VERSION="1.0.0"

# Load color themes
if [ -f "$_PROFILE_DIR/../themes/bash-colors.sh" ]; then
    . "$_PROFILE_DIR/../themes/bash-colors.sh"
fi

# Enhanced Git aliases
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gr='git remote'
alias grv='git remote -v'
alias gf='git fetch'
alias gt='git tag'
alias gst='git stash'
alias gsp='git stash pop'
alias gss='git stash save'
alias gsl='git stash list'

# Advanced Git aliases
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gloga='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all'
alias gcount='git shortlog -sn'
alias guncommit='git reset --soft HEAD~1'
alias gdiscard='git checkout -- .'
alias gclean='git clean -fd'

# Git workflow aliases
alias gmain='git checkout main'
alias gmaster='git checkout master'
alias gdevelop='git checkout develop'

# Remove any alias for gwip to avoid conflict with function
unalias gwip 2>/dev/null
gwip() {
    git add -A
    git commit -m "WIP: work in progress"
}

# Remove any alias for gunwip to avoid conflict with function
unalias gunwip 2>/dev/null
gunwip() {
    git log -n 1 --pretty=format:%s | grep -q "WIP: work in progress" && git reset HEAD~1
}

# Git branch management
gnew() {
    if [ $# -eq 0 ]; then
        echo "Usage: gnew <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

gdel() {
    if [ $# -eq 0 ]; then
        echo "Usage: gdel <branch-name>"
        return 1
    fi
    git branch -d "$1"
}

# Git status with enhanced output
gstat() {
    echo -e "${BLUE}Repository Status:${NC}"
    git status --short --branch
    
    echo -e "\n${BLUE}Recent commits:${NC}"
    git log --oneline -5
    
    echo -e "\n${BLUE}Local branches:${NC}"
    git branch
}

# Quick commit with timestamp
gquick() {
    local message="$*"
    if [ -z "$message" ]; then
        message="Quick commit $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    git add -A && git commit -m "$message"
}

# Git push with upstream tracking
gpush() {
    local current_branch=$(git branch --show-current)
    local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    
    if [ -z "$upstream" ]; then
        echo "Setting upstream for branch '$current_branch'"
        git push -u origin "$current_branch"
    else
        git push
    fi
}

# Enhanced git clone with immediate cd
gclone() {
    if [ $# -eq 0 ]; then
        echo "Usage: gclone <repository-url> [directory]"
        return 1
    fi
    
    git clone "$1" "$2"
    if [ $# -eq 2 ]; then
        cd "$2"
    else
        # Extract repo name from URL
        local repo_name=$(basename "$1" .git)
        cd "$repo_name"
    fi
}

# Directory bookmarks
# Add a named directory bookmark mapping ~src -> ~/Documents/GitHub
# Use a single variable so the path can be reused and overridden if needed
_BOOKMARK_SRC="${_BOOKMARK_SRC:-"$HOME/Documents/GitHub"}"
export _BOOKMARK_SRC

# Zsh: register a named directory so ~src expands to the path
if [ -n "$ZSH_VERSION" ]; then
    if command -v hash >/dev/null 2>&1; then
        # hash -d name=path creates a named directory accessible as ~name
        hash -d src="${_BOOKMARK_SRC}"
    fi
fi

# Bash: provide a convenient function and variable to jump to the bookmarked directory
# Note: Bash does not support ~name tilde expansion for custom names, so provide a function instead
if [ -n "$BASH_VERSION" ]; then
    src() {
        builtin cd "${_BOOKMARK_SRC}" || return $?
    }
    # Export a conventional variable for scripts or users who prefer it
    export SRC_DIR="${_BOOKMARK_SRC}"
fi

# Enhanced fzf configuration for Git workflows
if command -v fzf >/dev/null 2>&1; then
    # Git-aware file search - prefers git files in git repos, falls back to all files
    if git rev-parse --git-dir > /dev/null 2>&1; then
        export FZF_CTRL_T_COMMAND="git ls-files --cached --others --exclude-standard"
    elif command -v fd >/dev/null 2>&1; then
        export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
    else
        export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
    fi
    
    # Git-focused fzf styling (compatible with fzf 0.29+)
    export FZF_CTRL_T_OPTS="--border --padding 1,2 \
        --border-label ' Git Files ' --preview-window=right:50% \
        --preview 'if command -v batcat >/dev/null 2>&1; then batcat --color=always --style=numbers --line-range=:300 {}; elif command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:300 {}; else head -300 {}; fi' \
        --bind 'ctrl-r:reload(git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path \"*/\.git/*\" 2>/dev/null)' \
        --color 'border:#6699cc,preview-border:#9999cc'"
    
    # Enhanced options for newer fzf versions (0.48+)
    if command -v fzf >/dev/null 2>&1 && fzf --version | grep -E "0\.([5-9][0-9]|[4-9][8-9])" >/dev/null 2>&1; then
        export FZF_CTRL_T_OPTS="--style=full --border --padding 1,2 \
            --border-label ' Git Files ' --input-label ' Search ' --header-label ' File Info ' \
            --preview 'if command -v batcat >/dev/null 2>&1; then batcat --color=always --style=numbers --line-range=:300 {}; elif command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:300 {}; else head -300 {}; fi' \
            --bind 'result:transform-list-label:if [[ -z \$FZF_QUERY ]]; then echo \" \$FZF_MATCH_COUNT files \"; else echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"; fi' \
            --bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
            --bind 'focus:+transform-header:file --brief {} 2>/dev/null || echo \"No file selected\"' \
            --bind 'ctrl-r:change-list-label( Reloading )+reload(sleep 1; git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path \"*/\.git/*\" 2>/dev/null)' \
            --color 'border:#6699cc,label:#99ccff,preview-border:#9999cc,preview-label:#ccccff,list-border:#669966,list-label:#99cc99,input-border:#996666,input-label:#ffcccc,header-border:#6699cc,header-label:#99ccff'"
    fi
    
    # Source fzf key bindings - prioritize latest version
    if [ -n "$ZSH_VERSION" ]; then
        # For zsh
        if [ -f ~/.fzf.zsh ]; then
            source ~/.fzf.zsh
        elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
            source /usr/share/fzf/key-bindings.zsh
        fi
    elif [ -n "$BASH_VERSION" ]; then
        # For bash  
        if [ -f ~/.fzf.bash ]; then
            source ~/.fzf.bash
        elif [ -f /usr/share/fzf/key-bindings.bash ]; then
            source /usr/share/fzf/key-bindings.bash
        fi
    fi
    
    # Git-specific fzf function
    gfco() {
        local branch
        branch=$(git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | \
            fzf --border --border-label ' Git Branches ' \
                --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {} | head -10')
        if [[ "$branch" != "" ]]; then
            git checkout "$branch"
        fi
    }
fi

# Git help function
git_help() {
    echo -e "${BLUE}Git Workshop - Available Commands:${NC}"
    echo
    echo -e "${GREEN}Basic Git:${NC}"
    echo "  gs, gstat     - Git status (enhanced)"
    echo "  ga, gaa       - Git add / add all"
    echo "  gc, gcm, gca  - Git commit variations"
    echo "  gp, gpl       - Git push/pull"
    echo "  gl, glog      - Git log (oneline/graph)"
    echo "  gd, gdc       - Git diff (working/cached)"
    echo
    echo -e "${GREEN}Branching:${NC}"
    echo "  gb            - List branches"
    echo "  gco, gcb      - Checkout / create branch"
    echo "  gnew <name>   - Create and switch to new branch"
    echo "  gdel <name>   - Delete branch"
    echo "  gmain/gmaster - Switch to main/master"
    echo
    echo -e "${GREEN}Workflow:${NC}"
    echo "  gwip          - Work in progress commit"
    echo "  gunwip        - Undo work in progress commit"
    echo "  gquick [msg]  - Quick commit with timestamp"
    echo "  gpush         - Smart push with upstream"
    echo "  gclone <url>  - Clone and cd into repo"
    echo
    echo -e "${GREEN}Utilities:${NC}"
    echo "  gst, gsp, gss - Git stash operations"
    echo "  guncommit     - Undo last commit (keep changes)"
    echo "  gdiscard      - Discard all changes"
    echo "  gclean        - Clean untracked files"
    echo
    echo -e "${GREEN}Enhanced Features:${NC}"
    echo "  ~src          - Bookmark to ~/Documents/GitHub (Zsh)"
    echo "  src           - Jump to source directory (Bash)"
    echo "  gfco          - Fuzzy Git branch checkout (if fzf installed)"
    echo "  Ctrl+T        - Fuzzy file search (if fzf installed)"
    echo
}

# Initialize Starship prompt if available  
if command -v starship >/dev/null 2>&1; then
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(starship init zsh)"
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(starship init bash)"
    fi
fi

echo "Git-focused profile loaded! Type 'git_help' for available commands."