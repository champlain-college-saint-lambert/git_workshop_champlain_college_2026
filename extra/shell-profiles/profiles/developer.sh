#!/bin/bash
# Developer Profile - Balanced setup for daily development
# Compatible with Bash and Zsh on Linux and macOS

# Prevent issues when sourcing .bashrc from Zsh or vice versa
# This profile is cross-shell compatible but warns about improper sourcing
if [ -n "$ZSH_VERSION" ] && [[ "${(%):-%N}" == *".bashrc"* ]]; then
    echo "Warning: You're sourcing .bashrc from Zsh. Consider using .zshrc instead."
    echo "This profile works in both shells, but your .bashrc may have Bash-specific commands."
elif [ -n "$BASH_VERSION" ] && [[ "${BASH_SOURCE[0]}" == *".zshrc"* ]]; then
    echo "Warning: You're sourcing .zshrc from Bash. Consider using .bashrc instead."
fi

# Profile info
export SHELL_PROFILE_NAME="developer"
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
export SHELL_PROFILE_NAME="developer"
export SHELL_PROFILE_VERSION="1.0.0"

# Development aliases
alias c='clear'
alias h='history'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Enhanced directory navigation
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# File and directory operations
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

# Search and find
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Process management
alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Network
alias myip='curl -s http://whatismyip.akamai.com/'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

# Enhanced Git aliases
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcam='git commit -a -m'
alias gca='git commit --amend'
alias gcl='git clone'
alias gcp='git cherry-pick'
alias gf='git fetch'
alias gm='git merge'
alias gr='git remote'
alias grv='git remote -v'
alias gs='git stash'
alias gsp='git stash pop'
alias gt='git tag'
alias gw='git show'
alias gy='git history'
# Remove any alias for gclean to avoid conflict with function
unalias gclean 2>/dev/null

# Git flow aliases
alias gfl='git flow'
alias gfli='git flow init'
alias gflf='git flow feature'
alias gflfs='git flow feature start'
alias gflff='git flow feature finish'

# OS-specific enhancements
if [[ "$CURRENT_OS" == "macos" ]]; then
    # macOS specific
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    alias o='open'
    alias oo='open .'
    
    # Homebrew
    if command -v brew >/dev/null 2>&1; then
        alias brewup='brew update && brew upgrade && brew cleanup'
    fi
else
    # Linux specific
    alias open='xdg-open'
    alias o='xdg-open'
    alias oo='xdg-open .'
    
    # Package management
    if command -v apt-get >/dev/null 2>&1; then
        alias aptup='sudo apt-get update && sudo apt-get upgrade'
        alias aptshow='apt-cache show'
        alias aptsearch='apt-cache search'
    fi
fi

# Enhanced functions
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

mktar() { tar czf "${1%%/}.tar.gz" "${1%%/}/"; }
mkzip() { zip -r "${1%%/}.zip" "$1" ; }

# Git workflow functions
gnb() {
    git checkout -b "$1"
}

# Removed function gbd to avoid conflict with alias

grename() {
    git branch -m "$1" "$2"
}

gundo() {
    git reset --soft HEAD~1
}

gclean() {
    git branch --merged | grep -v "\*\|master\|main\|develop" | xargs -n 1 git branch -d
}

# Project navigation
cdp() {
    cd ~/projects 2>/dev/null || cd ~/Projects 2>/dev/null || cd ~
}

cdd() {
    cd ~/Downloads 2>/dev/null || cd ~/downloads 2>/dev/null || cd ~
}

# Enhanced prompt with Git status (compatible Bash/Zsh)
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats '(%b)'
    setopt PROMPT_SUBST
    PS1='%n@%m:%~${vcs_info_msg_0_}$ '
else
    git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    PS1='\u@\h:\w$(git_branch)$ '
fi

# History settings
if [ -n "$ZSH_VERSION" ]; then
    HISTSIZE=10000
    SAVEHIST=10000
    setopt HIST_VERIFY
    setopt SHARE_HISTORY
    setopt APPEND_HISTORY
    setopt INC_APPEND_HISTORY
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_REDUCE_BLANKS
    setopt HIST_IGNORE_SPACE
elif [ -n "$BASH_VERSION" ]; then
    HISTSIZE=10000
    HISTFILESIZE=20000
    shopt -s histappend
    shopt -s checkwinsize
fi

# Enhanced fzf configuration
if command -v fzf >/dev/null 2>&1; then
    # Use fd or find for file listing - works in any directory
    if command -v fd >/dev/null 2>&1; then
        export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
    else
        export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
    fi
    
    # Enhanced fzf styling (compatible with fzf 0.29+)
    export FZF_CTRL_T_OPTS="--border --padding 1,2 \
        --border-label ' Files ' --preview-window=right:50% \
        --preview 'if command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:300 {}; else head -300 {}; fi' \
        --bind 'ctrl-r:reload(if command -v fd >/dev/null 2>&1; then fd --type f --hidden --follow --exclude .git; else find . -type f -not -path \"*/\.git/*\" 2>/dev/null; fi)' \
        --color 'border:#aaaaaa,preview-border:#9999cc'"
    
    # Enhanced options for newer fzf versions (0.48+)
    if command -v fzf >/dev/null 2>&1 && fzf --version | grep -E "0\.([5-9][0-9]|[4-9][8-9])" >/dev/null 2>&1; then
        export FZF_CTRL_T_OPTS="--style=full --border --padding 1,2 \
            --border-label ' Files ' --input-label ' Search ' --header-label ' File Info ' \
            --preview 'if command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:300 {}; else head -300 {}; fi' \
            --bind 'result:transform-list-label:if [[ -z \$FZF_QUERY ]]; then echo \" \$FZF_MATCH_COUNT files \"; else echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"; fi' \
            --bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
            --bind 'focus:+transform-header:file --brief {} 2>/dev/null || echo \"No file selected\"' \
            --bind 'ctrl-r:change-list-label( Reloading )+reload(sleep 1; if command -v fd >/dev/null 2>&1; then fd --type f --hidden --follow --exclude .git; else find . -type f -not -path \"*/\.git/*\" 2>/dev/null; fi)' \
            --color 'border:#aaaaaa,label:#cccccc,preview-border:#9999cc,preview-label:#ccccff,list-border:#669966,list-label:#99cc99,input-border:#996666,input-label:#ffcccc,header-border:#6699cc,header-label:#99ccff'"
    fi
    
    # Directory search
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' 2>/dev/null"
    export FZF_ALT_C_OPTS="--border --border-label ' Directories ' --preview 'ls -la {}'"
    
    # History search
    export FZF_CTRL_R_OPTS="--border --border-label ' Command History ' --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview'"
    
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
fi

# Enable completion
if [ -n "$ZSH_VERSION" ]; then
    autoload -U compinit && compinit
    zstyle ':completion:*' menu select
elif [ -n "$BASH_VERSION" ]; then
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
fi

# Override help function
profile_help() {
    echo "Developer Profile Commands:"
    echo "  Enhanced Navigation: home, cd.., ....., cdp, cdd"
    echo "  File Operations: mkdir, mv, cp, rm, extract, mktar, mkzip"
    echo "  Git Enhanced: gb, gba, gbd, gcam, gca, gnb, gundo, gclean"
    echo "  FZF Integration: Ctrl+T (files), Ctrl+R (history), Alt+C (dirs)"
    echo "  System: ps, psgrep, psmem, pscpu, myip, ping"
    echo "  Utilities: c, h, path, now, nowdate, o, oo"
    echo "  Functions: extract, mktar, mkzip, gnb, gbd, grename, gundo, gclean"
}

# Initialize Starship prompt if available
if command -v starship >/dev/null 2>&1; then
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(starship init zsh)"
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(starship init bash)"
    fi
fi

echo "Developer shell profile loaded (v$SHELL_PROFILE_VERSION) with Git integration"
