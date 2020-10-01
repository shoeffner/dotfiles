# ENVIRONMENT
export PATH="/usr/local/sbin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)
export VIRTUAL_ENV_DISABLE_PROMPT=1
export LC_ALL='en_US.utf-8'
export LANG='en_US.utf-8'
export HOMEBREW_EDITOR=vim
export HOMEBREW_INSTALL_CLEANUP=1
# For ROS
export OPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.1
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/usr/local/opt/qt:/usr/local/opt/qt5
export ROS_DOMAIN_ID=71
alias sros2="source install/local_setup.zsh"

# ANTIGEN
source /usr/local/share/antigen/antigen.zsh
antigen init ${HOME}/.antigenrc

# shell completions
fpath=(${HOME}/.zsh/completions $fpath)
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(pandoc --bash-completion)"


# ALIASES
eval "$(thefuck --alias)"
function json() {
    python -m json.tool $1 | less
}
alias tag="[ -d .git ] && ctags -R -f ./.git/tags . || ctags -R ."
alias dc="docker-compose"
alias dignews="dig +short -t txt istheinternetonfire.com"
alias gcm="git checkout master"
alias pg="pass generate -c -n"
alias pc="pass -c"
alias myip="curl -s https://api.ipify.org/"
alias cpip="myip | clipcopy"

# Projects directory
function p() {
    cd ${HOME}/Projects/$1
}

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


# PRUNE DOCKER
# prunes docker containers, images, and volumes
function dprune() {
    for cmd in container image volume network; do
        yes | docker ${cmd} prune || true
    done
}


# UPDATE COMMAND
# updates brew and antigen
function update() {
    brew doctor
    brew update
    brew bundle --global
    brew upgrade
    brew cask upgrade
    brew cleanup
    tldr --update
    antigen update
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
    if [ -f Pipfile.lock ]; then
        pipenv sync
    else
        pipenv lock
    fi
    DIR=$(pipenv --where)
    cat << ENTER_EOF > ${DIR}/.autoenv.zsh
unsetopt AUTO_CD
export PIPENV_VERBOSITY=-1
source \$(pipenv --venv)/bin/activate
PIPENV_WHERE_DIR="\$(pipenv --where)"

if [ -f "\${PIPENV_WHERE_DIR}/.env" ]; then
    while IFS="" read -r ev || [ -n "\$ev" ]; do
        export \$ev
    done < "\${PIPENV_WHERE_DIR}/.env"
fi

if [ -d "\${PIPENV_WHERE_DIR}/bin" ]; then
    export OLD_PATH=\${PATH}
    export PATH="\${PIPENV_WHERE_DIR}/bin":\${PATH}
fi
ENTER_EOF

    cat << LEAVE_EOF > ${DIR}/.autoenv_leave.zsh
deactivate
unset PIPENV_VERBOSITY
setopt AUTO_CD

if [ ! -z "\${PIPENV_WHERE_DIR}" ]; then
    if [ -f "\${PIPENV_WHERE_DIR}/.env" ]; then
        while IFS="" read -r ev || [ -n "\$ev" ]; do
            unset \${ev%=*}
        done < "\${PIPENV_WHERE_DIR}/.env"
    fi

    if [ -d "\${PIPENV_WHERE_DIR}/bin" ]; then
        export PATH=\${PIPENV_WHERE_DIR}
        unset OLD_PATH
    fi
    unset PIPENV_WHERE_DIR
fi
LEAVE_EOF
    cd .
}


# REMOVE PYTHON PIPENV
# Takes the venv name as a parameter.
function rmvenv() {
    WHERE="$(pipenv --where)"
    VENV="$(pipenv --venv)"
    if [ ! -z "${WHERE}" ]; then
        source "${WHERE}/.autoenv_leave.zsh"
        rm "${WHERE}/.autoenv.zsh"
        rm "${WHERE}/.autoenv_leave.zsh"
    fi
    if [ ! -z "${VENV}" ]; then
        rm -rf "${VENV}"
    fi
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"


# ROS (2> /dev/null to suppress connext warning)
source ${HOME}/Projects/ros2-osx/setup.zsh 2> /dev/null
