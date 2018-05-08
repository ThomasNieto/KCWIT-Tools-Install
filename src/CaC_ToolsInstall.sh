#!/bin/sh

if [ -z "$(command -v brew)" ]; then 
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap caskroom/cask
brew install wget
brew install git
brew install node
brew cask install cakebrew
brew cask install google-chrome
brew cask install atom
brew cask install gitkraken
npm install npm -g