# ENVIRONMENT
export PATH="/usr/local/sbin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)
export VIRTUAL_ENV_DISABLE_PROMPT=1
export LC_ALL='en_US.utf-8'
export LANG='en_US.utf-8'
export HOMEBREW_EDITOR=vim


# ANTIGEN
source /usr/local/opt/antigen/share/antigen/antigen.zsh
antigen init ${HOME}/.antigenrc

# bash completions
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(pandoc --bash-completion)"


# ALIASES
eval "$(thefuck --alias)"
alias json='python -m json.tool | less'
alias tag="[ -d .git ] && ctags -R -f ./.git/tags . || ctags -R ."
alias dignews="dig +short -t txt istheinternetonfire.com"
alias gcm="git checkout master"


# VIM MODE
set -o vi
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
function update() {
    brew doctor
    brew update
    brew bundle --global
    brew upgrade
    brew cleanup
    brew cask upgrade
    brew cask cleanup
    antigen update
    tldr --update
    vim +PluginUpdate +qall
}


# FIX ME COMMAND
# fixes common problems with antigen and oh-my-zsh...
function fixme() {
    rm -rf ${HOME}/.zcompdump
    antigen update
}


# INSTALL IPYKERNEL
function mkipykernel() {
    if [ -n $VIRTUAL_ENV ]; then
        venv=${VIRTUAL_ENV##*/}
        python -m ipykernel install --user --name "${venv}" --display-name "${venv} ($(python --version))"
    else
        echo "Can not create ipykernel if not in a virtual environment."
    fi
}


# REMOVE IPYKERNEL
function rmipykernel() {
    if [ -n $VIRTUAL_ENV ]; then
        venv=${VIRTUAL_ENV##*/}
        kernelpath=${HOME}/Library/Jupyter/kernels/${venv}
        rm -rf ${kernelpath}
        if [ $? -eq 0 ]; then
            echo "Removed kernelspec from ${kernelpath}"
        else
            echo "Unable to remove kernelspec from ${kernelpath}"
        fi
    else
        echo "Can not remove ipykernel if not in a virtual environment."
    fi
}


# CREATE PYTHON PIPENV
# Takes the venv name and all but the filepath parameter of python's venv module as parameters.
function mkvenv() {
    pipenv lock
    echo "unsetopt AUTO_CD\nsource $(pipenv --venv)/bin/activate" > $(pipenv --where)/.autoenv.zsh
    echo "deactivate\nsetopt AUTO_CD" > $(pipenv --where)/.autoenv_leave.zsh
    cd .
}


# REMOVE PYTHON PIPENV
# Takes the venv name as a parameter.
function rmvenv() {
    source $(pipenv --where)/.autoenv_leave.zsh
    rm $(pipenv --where)/.autoenv.zsh
    rm $(pipenv --where)/.autoenv_leave.zsh
    rm -rf $(pipenv --venv)
}
