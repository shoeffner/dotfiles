# Configuration
PROJECTS_DIR=~/Projects
DOTFILES_DIR=$PROJECTS_DIR/dotfiles


# Runs a command and echos an error if it was not successful.
# Example: checked 'Some error with brew!' brew --version
function checked() {
    "${@:2}" 2>/dev/null
    local status=$?
    if [ $status -ne 0 ]; then
        echo $1
    fi
    return $status
}


# Install brew if not installed.
checked 'Brew not installed. Installing...' brew --version
if [ $? -ne 0 ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit 1
    brew update
    brew upgrade
    brew doctor
    # tap bundle to be able to install bundles
    brew tap Homebrew/bundle
fi


# Install git if not installed.
checked 'Git not installed. Installing...' git --version
if [ $? -ne 0 ]; then
    brew install git || (echo 'Can not install git.' && exit 1)
fi


# Clone dotfiles repository properly.
mkdir -p $PROJECTS_DIR
if [ ! -d $DOTFILES_DIR ]; then
    git clone --recursive https://github.com/shoeffner/dotfiles.git $DOTFILES_DIR
fi


# Link dotfiles to their proper locations.
function lnifnotexists() {
    [ -L ~/$1 ] || (mkdir -p ~/$(dirname $1) && ln -s $DOTFILES_DIR/$1 ~/$1)
}

for link in \
    '.antigenrc' \
    '.Brewfile' \
    '.jupyter/nbconfig/notebook.json' \
    '.vim/bundle/Vundle.vim' \
    '.vimrc' \
    '.zshrc' \
    ; do
    lnifnotexists $link
done


# Install brew bundles
# FIXME @shoeffner: Due to a bug only brew install works for python at the moment
if brew ls --versions myformula > /dev/null; then
    brew install python3
fi
brew bundle --global


# Install Python requirements
checked 'Python not linked propertly. Forcing links.' python3 --version
if [ $? -ne 0 ]; then
    brew link python3 --force
fi
pip3 install -r $DOTFILES_DIR/python3_requirements.txt


# Install VIM Plugins
vim +PluginInstall +qall
# Compile YouCompleteMe
(cd ~/.vim/bundle/YouCompleteMe && ./install.py)


# Install settings
git config --global color.diff.old "red strike"
git config --global color.diff.new "green"
git config --global alias.st "status -sb"
git config --global alias.slog "log --pretty='format:%C(green)%h%Creset %C(green dim)%aI%Creset %C(magenta)%s%Creset%n        %C(yellow)%aN <%ae>%Creset %C(cyan)[%G?% GS]%Creset'"
git config --global credential.helper osxkeychain


# Prompt about other things:
cat << INFO_TEXT

Almost everything is set up! Here are some notes on what to do:


- Remember to set up your shell properly to use /bin/zsh
- Start Caffeine
- Start Amethyst (and give it accesibility rights)


Some git setups to do:
git config --global user.email "info@sebastian-hoeffner.de"
git config --global user.name "Sebastian Höffner"


To handle gpg keys (assuming keybase is up and running):
echo charset utf-8 >> ~/.gnupg/gpg.conf
keybase pgp export | gpg --import
keybase pgp export --secret | gpg --import --allow-secret-key-import
echo default-key <KEY ID> >> ~/.gnupg/gpg.conf
git config --global user.signingkey <KEY ID>

Use gpg --edit-key <KEY ID> to edit a key, e.g. trust it


Some template files can be found here:
https://github.com/shoeffner/dotfiles/tree/master/templates
INFO_TEXT

