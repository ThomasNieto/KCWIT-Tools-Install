#!/bin/sh

if [ -z "$(command -v brew)" ]; then 
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

BrewInstalled=$(brew list)
BrewCaskInstalled=$(brew cask list)

brew tap caskroom/cask

if echo $BrewInstalled | grep wget; then
    echo 'wget already installed.'
else
    echo 'Installing wget.'
    brew install wget
fi

if echo $BrewInstalled | grep git; then
    echo 'git already installed.'
else
    echo 'Installing git.'
    brew install git
fi

if echo $BrewInstalled | grep node; then
    echo 'Node.Js already installed.'
else
    echo 'Installing Node.Js.'
    brew install node
fi

if echo $BrewCaskInstalled | grep cakebrew; then
    echo 'CakeBrew already installed.'
else
    echo 'Installing CakeBrew.'
    brew cask install cakebrew
fi

if echo $BrewCaskInstalled | grep google-chrome; then
    echo 'Google Chrome already installed.'
else
    echo 'Installing Google Chrome.'
    brew cask install google-chrome
fi

if echo $BrewCaskInstalled | grep atom then
    echo 'Atom already installed.'
else
    echo 'Installing Atom.'
    brew cask install atom
fi

if echo $BrewCaskInstalled | grep gitkraken then
    echo 'Git Kraken already installed.'
else
    echo 'Installing Git Kraken.'
    brew cask install gitkraken
fi

echo 'Updating npm.'
npm install npm -g