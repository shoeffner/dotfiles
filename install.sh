# better not run this file as of now, just see it as advice on what to do

cd ~
# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew upgrade

# brew formulae and cask formulae
brew install zsh cask macvim git python python3 thefuck wget ccat bash \
    bash-completion pandoc swi-prolog wget cmake boost htop-osx node \
    go keybase neovim/neovim/neovim
brew cask install amethyst mactex haskell-platform java steam docker \
    xquartz

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
