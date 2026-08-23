#!/bin/bash
# Power User Profile - Feature-rich configuration
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
export SHELL_PROFILE_NAME="poweruser"
export SHELL_PROFILE_VERSION="1.0.0"

# Load developer profile as base (robust for Bash and Zsh)
if [ -n "$BASH_VERSION" ]; then
    _PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
    _PROFILE_DIR="$(cd "$(dirname "${(%):-%N}" 2>/dev/null)" && pwd)"
else
    _PROFILE_DIR="$(cd "$(dirname "$0" 2>/dev/null)" && pwd)"
fi
if [ -f "$_PROFILE_DIR/developer.sh" ]; then
    . "$_PROFILE_DIR/developer.sh"
elif [ -f "$_PROFILE_DIR/../developer.sh" ]; then
    . "$_PROFILE_DIR/../developer.sh"
fi

# Re-export profile info after loading base profile
export SHELL_PROFILE_NAME="poweruser"
export SHELL_PROFILE_VERSION="1.0.0"

# Advanced aliases
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -ltr --color=auto'    # Sort by date
alias lS='ls -lSr --color=auto'    # Sort by size
alias lh='ls -lSrh --color=auto'   # Human readable sizes

# Enhanced commands
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
    alias less='bat'
fi

if command -v exa >/dev/null 2>&1; then
    alias ls='exa'
    alias ll='exa -la'
    alias lt='exa -la --sort=modified'
    alias tree='exa --tree'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi

# System monitoring
alias df='df -h'
alias du='du -ch'
alias free='free -mt'
alias top='htop'

# Network tools
alias ports='netstat -tulanp'
alias wget='wget -c'
alias curl='curl -L'

# Development tools
alias serve='python3 -m http.server 8000'
alias jsonpp='python3 -m json.tool'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# Git power aliases
alias gaa='git add --all'
alias gau='git add --update'
alias gap='git add --patch'
alias gcaa='git commit -a --amend'
alias gcn='git commit --no-verify'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias gdca='git diff --cached'
alias gdt='git difftool'
alias gdct='git difftool --cached'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='gitk --all --branches'
alias gl='git pull'
alias glg='git log --stat --color'
alias glgg='git log --graph --color'
alias glgga='git log --graph --decorate --all'
alias glo='git log --oneline --decorate --color'
alias glog='git log --oneline --decorate --color --graph'
alias glol='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glola='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all'
alias glp='git log --pretty=format:"%h - %an, %ar : %s"'
alias gm='git merge'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmom='git merge origin/master'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gtl='gtl(){ git tag --sort=-version:refname -n -l ${1}* }; noglob gtl'
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"'

# Remove any alias for gf to avoid conflict with function
unalias gf 2>/dev/null
gf() {
    if [ "$#" -ne 0 ]; then
        git flow "$@"
    else
        git flow
    fi
}

grename() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: grename old_branch new_branch"
        return 1
    fi
    
    # Rename branch locally
    git branch -m "$1" "$2"
    # Rename branch in origin remote
    if git push origin :"$1"; then
        git push --set-upstream origin "$2"
    fi
}

grbf() {
    git rebase -i HEAD~"$1"
}

gsync() {
    local current_branch=$(git symbolic-ref --short HEAD)
    git fetch origin
    git checkout master
    git pull origin master
    git checkout "$current_branch"
    git rebase master
}

# Enhanced fuzzy finding with fzf
if command -v fzf >/dev/null 2>&1; then
    # Enhanced file search with fd or find fallback
    if command -v fd >/dev/null 2>&1; then
        export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
    else
        export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
    fi
    
    # Enhanced fzf options with beautiful styling
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
    
    # Enhanced directory search
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' 2>/dev/null"
    export FZF_ALT_C_OPTS="--style full --border --border-label ' Directories ' \
        --preview 'ls -la {}' \
        --color 'border:#aaaaaa,label:#cccccc' \
        --color 'preview-border:#9999cc,preview-label:#ccccff'"
    
    # Enhanced history search
    export FZF_CTRL_R_OPTS="--style full --border --border-label ' Command History ' \
        --preview 'echo {}' --preview-window up:3:hidden:wrap \
        --bind 'ctrl-/:toggle-preview' \
        --color 'border:#aaaaaa,label:#cccccc' \
        --color 'preview-border:#9999cc,preview-label:#ccccff'"
    
    # Key bindings
    if [[ -n "$ZSH_VERSION" ]]; then
        if [ -f ~/.fzf.zsh ]; then
            source ~/.fzf.zsh
        elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
            source /usr/share/fzf/key-bindings.zsh
        fi
    else
        if [ -f ~/.fzf.bash ]; then
            source ~/.fzf.bash
        elif [ -f /usr/share/fzf/key-bindings.bash ]; then
            source /usr/share/fzf/key-bindings.bash
        fi
    fi
    
    # Enhanced Git fzf functions
    fgco() {
        local branch
        branch=$(git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | \
            fzf --border --border-label ' Git Branches ' --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {} | head -200')
        if [[ "$branch" != "" ]]; then
            git checkout "$branch"
        fi
    }
    
    fgshow() {
        git log --graph --color=always \
            --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
            --border --border-label ' Git Log ' \
            --preview 'grep -o "[a-f0-9]\{7\}" <<< {} | head -1 | xargs git show --color=always' \
            --bind "ctrl-m:execute:
                      (grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                      {}
FZF-EOF"
    }
    
    # File search with preview
    ff() {
        local file
        file=$(fzf --border --border-label ' File Search ' \
            --preview 'if command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:300 {}; else head -300 {}; fi')
        if [[ -n "$file" ]]; then
            $EDITOR "$file"
        fi
    }
    
    alias gfco='fgco'
    alias gfshow='fgshow'
fi

# Directory bookmarks
if [[ -n "$ZSH_VERSION" ]]; then
    hash -d projects=~/projects
    hash -d downloads=~/Downloads
    hash -d documents=~/Documents
    hash -d desktop=~/Desktop
fi

# Advanced history
if [[ -n "$ZSH_VERSION" ]]; then
    setopt BANG_HIST
    setopt EXTENDED_HISTORY
    setopt HIST_EXPIRE_DUPS_FIRST
    setopt HIST_FIND_NO_DUPS
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    setopt HIST_SAVE_NO_DUPS
    setopt HIST_VERIFY
    setopt INC_APPEND_HISTORY
    setopt SHARE_HISTORY
fi

# Auto-suggestions and syntax highlighting (if available)
if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh autosuggestions
    if [[ -f ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
    
    # Zsh syntax highlighting
    if [[ -f ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
fi

# Enhanced prompt with more Git info
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git*' formats '(%b%u%c)'
    zstyle ':vcs_info:git*' actionformats '(%b|%a%u%c)'
    zstyle ':vcs_info:git*' check-for-changes true
    zstyle ':vcs_info:git*' stagedstr '+'
    zstyle ':vcs_info:git*' unstagedstr '*'
    
    precmd() {
        vcs_info
    }
    
    setopt PROMPT_SUBST
    PS1='%{$fg[cyan]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}%{$fg[red]%}${vcs_info_msg_0_}%{$reset_color%} %{$fg[yellow]%}➜%{$reset_color%} '
else
    # Enhanced Bash prompt with Git status
    git_prompt() {
        local git_status="`git status -unormal 2>&1`"
        if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
            if [[ "$git_status" =~ nothing\ to\ commit ]]; then
                local ansi=42
            elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
                local ansi=43
            else
                local ansi=45
            fi
            echo -n '\[\033[0;37;'"$ansi"';1m\]'
            echo -n "$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')"
            echo '\[\033[0m\]'
        fi
    }
    
    PS1='\[\033[0;32m\]\u@\h\[\033[0m\]:\[\033[0;34m\]\w\[\033[0m\] $(git_prompt)\$ '
fi

# Useful functions
weather() {
    curl -s "wttr.in/$1"
}

cheat() {
    curl -s "cheat.sh/$1"
}

transfer() {
    if [ $# -eq 0 ]; then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi
    tmpfile=$( mktemp -t transferXXX )
    if tty -s; then
        basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]//g')
        curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
    fi
    cat $tmpfile
    rm -f $tmpfile
}

# Override help function
profile_help() {
    echo "Power User Profile Commands:"
    echo "  Enhanced Display: ll, la, l, lt, lS, lh (with exa/colors)"
    echo "  Modern Tools: cat→bat, grep→rg, ls→exa"
    echo "  Git Power: gaa, gap, gcaa, gdca, gdt, grb, grbi, grbf, gsync"
    echo "  FZF Integration: fgco, fgshow, ff (if fzf installed)"
    echo "  FZF Keybindings: Ctrl+T (files), Ctrl+R (history), Alt+C (dirs)"
    echo "  System: df, du, free, top→htop, ports"
    echo "  Dev Tools: serve, jsonpp, urlencode, urldecode"
    echo "  Utilities: weather, cheat, transfer, grename, gsync"
    echo "  Bookmarks: ~projects, ~downloads, ~documents (zsh)"
}

# Initialize Starship prompt if available
if command -v starship >/dev/null 2>&1; then
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(starship init zsh)"
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(starship init bash)"
    fi
fi

echo "Power User shell profile loaded (v$SHELL_PROFILE_VERSION) with advanced features"
