# START OH MY ZSH
export ZSH=/Users/shoeffner/.oh-my-zsh
export ZSH_THEME="my_custom"
# export ZSH_CUSTOM=/Users/shoeffner/.oh-my-zsh/custom
export UPDATE_ZSH_DAYS=7
ENABLE_CORRECTION="true"
plugins=(git brew gem compleat mvn pip python vagrant vi-mode wd venv zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
# remove arguments in argument list from auto completion
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
setopt histignorealldups
setopt histignorespace
# zsh-completions via compleat
autoload -Uz compinit bashcompinit
compinit
bashcompinit
source /usr/local/share/x86_64-osx-ghc-8.0.1/compleat-1.0/compleat_setup
# END OH MY ZSH

# START ENV
export PATH="/usr/local/sbin:$PATH"
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512m"
export EDITOR="/usr/local/bin/vim"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
# END ENV

# BEGIN ALIASES
eval "$(thefuck --alias)"
alias json='python -m json.tool | ccat'
alias findershow="defaults write com.apple.finder AppleShowAllFiles YES && echo \"Alt-Click on Finder and relaunch!\""
alias finderhide="defaults write com.apple.finder AppleShowAllFiles NO && echo \"Alt-Click on Finder and relaunch!\""
# END ALIASES


# START vim mode
bindkey -v
export KEYTIMEOUT=0.01
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
# END vim mode


# START FUNCTIONS
# git checkout commit before date (thanks @ahoereth)
git-checkout-before() {
    git checkout `git rev-list -n 1 --before="$1" $2`
}

# compiles tex projects with bibtex
pdfcomp() {
    pdflatex $1.tex && bibtex $1 && pdflatex $1.tex && pdflatex $1.tex && open $1.pdf
}

# END FUNCTIONS

