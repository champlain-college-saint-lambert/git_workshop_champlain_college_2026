# Oh My Zsh Custom Configuration for Git Workshop
# Source this file in your .zshrc after Oh My Zsh initialization
export SHELL_PROFILE_NAME="oh-my-zsh-custom"

# Git Workshop Theme Configuration
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Custom Git Workshop prompt
git_workshop_prompt() {
    local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
    PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
}

# Enable the custom prompt
git_workshop_prompt

# Enhanced Git aliases for workshop
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout develop'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# Workshop specific functions
git_workshop_info() {
    echo "🎓 Git Workshop - Oh My Zsh Custom Configuration Loaded"
    echo "📚 Available workshop aliases:"
    echo "   gwip/gunwip - Work in progress commits"
    echo "   gco/gcb/gcm/gcd - Enhanced checkout commands"
    echo "   gcp/gcpa/gcpc - Cherry-pick workflow"
}

# Auto-run info on load
git_workshop_info

# Enhanced completion settings
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# Git workshop specific settings
setopt auto_cd
setopt correct
setopt hist_verify
setopt share_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_save_no_dups

# Key bindings for Git workflow
bindkey '^Gg' 'git status^M'
bindkey '^Ga' 'git add .^M'
bindkey '^Gc' 'git commit -m "^["'

# Workshop progress tracking
export GIT_WORKSHOP_PROGRESS_FILE="$HOME/.git_workshop_progress"

track_git_command() {
    echo "$(date): $*" >> "$GIT_WORKSHOP_PROGRESS_FILE"
}

# Wrap git command to track usage
git() {
    command git "$@"
    track_git_command "$@"
}

# Display workshop stats
git_workshop_stats() {
    if [[ -f "$GIT_WORKSHOP_PROGRESS_FILE" ]]; then
        echo "📊 Your Git Workshop Progress:"
        echo "Commands used: $(wc -l < "$GIT_WORKSHOP_PROGRESS_FILE")"
        echo "Most used commands:"
        cut -d' ' -f3 "$GIT_WORKSHOP_PROGRESS_FILE" | sort | uniq -c | sort -nr | head -5
    else
        echo "🆕 Welcome to the Git Workshop! Start using Git commands to track your progress."
    fi
}
