#!/bin/bash

# installation script for various things
# for a fresh machine, do the steps in order: env, dotfiles, apps

if [ "$1" == "env" ]; then # set up environment

  echo "Setting up base environment..."

  # apple developer tools
  xcode-select --install

  # homebrew + homebrew cask
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/cask

  # node
  brew install node

  # vim
  brew install vim --with-override-system-vi

  # fish
  brew install fish
  echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/fish

  # oh my fish
  curl -L https://get.oh-my.fish | fish
  omf install pure

elif [ "$1" == "dotfiles" ]; then # install & symlink dotfiles

  echo "Installing dotfiles..."

  # init
  cd ~/dotfiles
  git submodule update --init --recursive
  mkdir -p ~/.config

  # dependencies
  brew install cmake

  # git
  ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
  ln -s ~/dotfiles/git/gitignore ~/.gitignore

  # fish
  ln -s ~/dotfiles/fish ~/.config/fish

  # oh my fish
  ln -s ~/dotfiles/omf ~/.config/omf

  # base16-shell
  ln -s ~/dotfiles/base16-shell ~/.config/base16-shell

  # vim
  ln -s ~/dotfiles/vim/vimrc ~/.vimrc

  # youcompleteme
  cd ~/dotfiles/vim/pack/jmarquis/start/youcompleteme && ./install.py --js-completer

elif [ "$1" == "apps" ]; then # install apps

  echo "Installing apps..."

  brew cask install alfred
  brew cask install iterm2
  brew cask install simplenote
  brew cask install bettertouchtool
  brew cask install istat-menus
  brew cask install dropshare
  brew cask install slack
  brew cask install github
  brew cask install yakyak
  brew cask install sip

  # mac app store cli
  brew install mas

  mas install 419330170 # moom
  mas install 1263070803 # lungo
  mas install 975937182 # fantastical 2
  mas install 1017470484 # next meeting
  mas install 1053031090 # boxy
  mas install 512617038 # snappy
  mas install 411643860 # daisydisk
  mas install 904280696 # things 3
  mas install 668208984 # giphy capture

elif [ "$1" == "personal-apps" ]; then # install apps for personal use

  echo "Installing personal apps..."

  brew cask install transmission
  brew cask install private-internet-access
  brew cask install beamer

else

  echo "Available options: env, dotfiles, apps"

fi
