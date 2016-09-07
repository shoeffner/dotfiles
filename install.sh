# better not run this file as of now, just see it as advice on what to do
return

cd ~
# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew upgrade

# brew formulae and cask formulae
brew install zsh cask macvim git python python3 thefuck wget ccat bash \
    bash-completion pandoc swi-prolog wget cmake boost htop-osx node \
    go keybase neovim/neovim/neovim gpg
brew cask install amethyst mactex haskell-platform java steam docker \
    xquartz
brew tap caskroom/versions

# npm installs
npm i -g eslint estraverse estraverse-fb eslint-plugin-react babel-eslint

# fix links for python3
rm /usr/local/bin/python
rm /usr/local/bin/pip
ln -s /usr/local/bin/python3 /usr/local/bin/python
ln -s /usr/local/bin/pip3 /usr/local/bin/pip

# make vim and neovim use the same files
mkdir ~/.config
mkdir ~/.vim
ln -s ~/.vim ~/.config/.nvim
ln -s ~/.vimrc ~/.config/.nvimrc

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir ~/.oh-my-zsh && cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
cd /usr/local/Caskroom/haskell-platform
open Haskell\ Platform\ 8.0.1\ Full\ 64bit-signed-a.pkg
cd ~/Downloads
git clone git://github.com/mbrubeck/compleat.git
(cd compleat && ./Setup.lhs configure && ./Setup.lhs build && sudo ./Setup.lhs install)

# TODO: link files in this project to their respective counterparts
# e.g. ln -s ~/projects/dotfiles/.vimrc ~/.vimrc

# git settings:
git config --global color.diff.old "red strike"
git config --global color.diff.new "green"


# add gpg key from keybase to gpg and set it as the default for git
# keybase export needs utf-8
echo charset utf-8 >> ~/.gnupg/gpg.conf
keybase pgp export | gpg --import
keybase pgp export --secret | gpg --import --allow-secret-key-import

# trust your secret key ultimately (also trusts your public key) - just type 
# trust\n 5\n y\n quit\n
gpg --edit-key $(gpg --list-secret-keys | grep ^sec | cut -d ' '  -f 4 | cut -d '/' -f 2)
# set default gpg key
echo default-key $(gpg --list-secret-keys | grep ^sec | cut -d ' '  -f 4 | cut -d '/' -f 2) >> ~/.gnupg/gpg.conf
git config --global user.signingkey $(gpg --list-secret-keys | grep ^sec | cut -d ' '  -f 4 | cut -d '/' -f 2)

# to auto sign set in your git repo:
git config --local commit.gpgsign true
