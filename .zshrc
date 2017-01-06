# ANTIGEN
source /usr/local/opt/antigen/share/antigen/antigen.zsh
antigen init ~/.antigenrc


# ENVIRONMENT
export PATH="/usr/local/sbin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)


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

