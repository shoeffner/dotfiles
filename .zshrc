# ENVIRONMENT
export PATH="/usr/local/sbin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export VIRTUAL_ENV_DISABLE_PROMPT=1


# ANTIGEN
source /usr/local/opt/antigen/share/antigen/antigen.zsh
# antigen init ${HOME}/.antigenrc # See https://github.com/zsh-users/antigen/issues/391 for details
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
    git
    pip
    python
    Tarrasch/zsh-autoenv
    vi-mode
    wd
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-autosuggestions
EOBUNDLES
antigen theme shoeffner/dotfiles fae.zsh-theme
antigen apply


# ALIASES
eval "$(thefuck --alias)"
alias json='python -m json.tool | ccat'


# VIM MODE
bindkey -v
export KEYTIMEOUT=1
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


# UPDATE COMMAND
# updates brew and antigen
function update () {
    brew upgrade
    brew update
    antigen update
}

