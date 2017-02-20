# ENVIRONMENT
export PATH="/usr/local/sbin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export VIRTUAL_ENV_DISABLE_PROMPT=1


# ANTIGEN
source /usr/local/opt/antigen/share/antigen/antigen.zsh
antigen init ${HOME}/.antigenrc

# ALIASES
eval "$(thefuck --alias)"
alias json='python -m json.tool | ccat'
alias tag="[ -d .git ] && ctags -R -f ./.git/tags . || ctags -R ."


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
    brew cleanup
    brew doctor
    brew update
    brew bundle --global
    brew upgrade
    antigen update
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
        python -m ipykernel install --user --name ${venv} --display-name "${venv} ($(python --version))"
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


# CREATE PYTHON VENV
# Takes the venv name and all but the filepath parameter of python's venv module as parameters.
function mkvenv() {
    if [ -n "$1" ]; then
        venvpath=${HOME}/.virtualenvs/$1
        /usr/local/bin/python3.6 -m venv ${venvpath} ${@:2}
        echo "source \${HOME}/.virtualenvs/$1/bin/activate" >> .autoenv.zsh
        echo "deactivate" >> .autoenv_leave.zsh
        cd . # load autoenv directly

        echo "Installed virtual environment to ${venvpath}."
        echo "To add opencv3 to it, run:"
        echo "echo /usr/local/opt/opencv3/lib/python3.6/site-packages >> ${venvpath}/lib/python3.6/site-packages/opencv3.pth"
    else
        echo "Please provide a name for the virtual environment."
    fi
}

# REMOVE PYTHON VENV
# Takes the venv name as a parameter.
function rmvenv() {
    if [ -n "$1" ]; then
        venvpath=${HOME}/.virtualenvs/$1
        rm -rf ${venvpath}
        if [ -f .autoenv.zsh ]; then
            cat .autoenv.zsh | grep $1 > /dev/null
            if [ $? -eq 0 ]; then
                rm .autoenv.zsh
                rm .autoenv_leave.zsh
                deactivate
            else
                echo "Wrong .autoenv.zsh detected. Won't delete it nor .autoenv_leave.zsh"
            fi
        else
            echo "Can't find .autoenv.zsh, you might need to remove it yourself."
        fi
    else
        echo "Please provide the name of the virtual environment you want to delete."
    fi
}

