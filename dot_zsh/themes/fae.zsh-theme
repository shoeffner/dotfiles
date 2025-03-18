export VIRTUAL_ENV_DISABLE_PROMPT=1
setopt PROMPT_SUBST

function virtual_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        p="$(echo "${VIRTUAL_ENV##*/}" | rev | cut -c10- | rev)"
        if [ ! -n "${p}" ]; then
            p=${VIRTUAL_ENV%/*}
            print "${p##*/}"
        else
            print "${p}"
        fi
    else
        print ""
    fi
}

function git_simple_repository() {
    if GIT_OPTIONAL_LOCKS=0 command git rev-parse --git-dir &> /dev/null; then
        GITREPO=$(GIT_OPTIONAL_LOCKS=0 command git remote get-url origin 2>/dev/null)
        if [[ $GITREPO == http* ]]; then
            printf " %s" $(echo $GITREPO | cut -f 4 -d "/" | cut -c 1,2)/$(echo ${GITREPO##*/} | cut -f 1 -d ".")
        elif [[ $GITREPO == git* ]] || [[ $GITREPO == fae* ]]; then
            printf " %s" $(echo $GITREPO | cut -f 2 -d ":" | cut -c 1,2)/$(echo $GITREPO | cut -f 2 -d "/" | cut -f 1 -d ".")
        else
            print ""
        fi
    else
        print ""
    fi
}

function parse_git_dirty() {
    STATUS=$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain 2> /dev/null | tail -n 1)
    if [[ -n $STATUS ]]; then
        echo ' ⚡'
    else
        echo ""
    fi
}

function git_branch() {
    if ! GIT_OPTIONAL_LOCKS=0 command git rev-parse --git-dir &> /dev/null; then
        return 0;
    fi
  
    # Get either:
    # - the current branch name
    # - the tag name if we are on a tag
    # - the short SHA of the current commit
    local ref
    ref=$(GIT_OPTIONAL_LOCKS=0 command git symbolic-ref --short HEAD 2> /dev/null) \
    || ref=$(GIT_OPTIONAL_LOCKS=0 command git describe --tags --exact-match HEAD 2> /dev/null) \
    || ref=$(GIT_OPTIONAL_LOCKS=0 command git rev-parse --short HEAD 2> /dev/null) \
    || return 0
  
    print " ${${ref:gs/%/%%}//feature/f}$(parse_git_dirty)"
}

COLOR_SUCCESS="%{%F{190}%}"
COLOR_FAILURE="%{%F{196}%}"
COLOR_VENV="%{%F{182}%}"
COLOR_DEFAULT="%{%F{249}%}"
COLOR_PATH="%{%F{3}%}"
COLOR_REPO="%{%F{153}%}"
COLOR_BRANCH="%{%F{14}%}"

PROMPT='${COLOR_VENV}$(virtual_env)%(1l. .)%(?.${COLOR_SUCCESS}.${COLOR_FAILURE})%#${COLOR_DEFAULT} '
RPS1='${COLOR_PATH}%2~${COLOR_REPO}$(git_simple_repository)${COLOR_BRANCH}$(git_branch)%{%f%}'

