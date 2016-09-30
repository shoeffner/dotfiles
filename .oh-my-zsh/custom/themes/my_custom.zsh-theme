if [ -n "$VENV_VIRTUAL_ENV" ] && [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]; then
    echo Please put "export VIRTUAL_ENV_DISABLE_PROMPT=1" somewhere into your .zshrc!
fi

if [[ $(whence git_prompt_info) != "git_prompt_info" ]]; then
    echo Please use the git-plugin in your .zshrc!
fi

function git_simple_repository (
    if [[ $(git_prompt_info) ]]; then
        GITREPO=$(git remote get-url origin 2>/dev/null)
        if [[ $GITREPO == http* ]]; then
            print $(echo $GITREPO | cut -f 4 -d "/" | cut -c 1,2)/$(echo ${GITREPO##*/} | cut -f 1 -d ".")
        elif [[ $GITREPO == git* ]]; then
            print $(echo $GITREPO | cut -f 2 -d ":" | cut -c 1,2)/$(echo $GITREPO | cut -f 2 -d "/" | cut -f 1 -d ".")
        else
            print ""
        fi
    else
        print ""
    fi
)


PROMPT='%{%F{182}%}${VENV_VIRTUAL_ENV##*/}%(1l. .)%f%(?.%{%F{green}%}.%{%F{red}%})%#%{%F{249}%} '
FIND_FEATURE="feature"
REPL_FEATURE="f"
RPS1='%{%f%}%{%F{220}%}%2~%{%f%}%{%F{236}%} ${$(git_simple_repository)}%{%f%} ${$(git_prompt_info)//$FIND_FEATURE/$REPL_FEATURE}'

ZSH_THEME_GIT_PROMPT_PREFIX='%{%F{60}%}'
ZSH_THEME_GIT_PROMPT_SUFFIX='%{%f%}'
ZSH_THEME_GIT_PROMPT_DIRTY=' ⚡'
ZSH_THEME_GIT_PROMPT_CLEAN=''

