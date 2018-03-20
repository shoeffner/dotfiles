# Configuration
PROJECTS_DIR="${HOME}/Projects"
DOTFILES_DIR="${PROJECTS_DIR}/dotfiles"


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


# Clone dotfiles repository properly.
mkdir -p ${PROJECTS_DIR}
if [ ! -d ${DOTFILES_DIR} ]; then
    git clone --recursive https://github.com/shoeffner/dotfiles.git ${DOTFILES_DIR}
fi


# Link dotfiles to their proper locations.
function lnifnotexists() {
    [ -L "${HOME}/$1" ] || (mkdir -p "${HOME}/$(dirname $1)" && ln -s "${DOTFILES_DIR}/$1" "${HOME}/$1")
}

for link in \
    '.Brewfile' \
    '.antigenrc' \
    '.gitconfig' \
    '.inputrc' \
    '.jupyter/nbconfig/notebook.json' \
    '.ssh/config' \
    '.vim/bundle/Vundle.vim' \
    '.vimrc' \
    '.warprc' \
    '.zshrc' \
    ; do
    lnifnotexists $link
done
ln -s "${DOTFILES_DIR}/.gitignore" "${HOME}/.gitignore_global"

# Install brew bundles
brew bundle --global


# Link Python and install Python requirements
brew link --overwrite python
pip3 install --upgrade pip setuptools wheel


# Install VIM Plugins
vim +PluginInstall +qall
# Compile YouCompleteMe
(cd ${HOME}/.vim/bundle/YouCompleteMe && ./install.py --clang-completer)


# Write defaults
defaults write com.apple.CrashReporter UseUNC 1


# Prompt about other things:
cat << INFO_TEXT

Almost everything is set up! Here are some notes on what to do:


- Remember to set up your shell properly to use /bin/zsh
- Start Caffeine
- Start Amethyst (and give it accesibility rights)


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

