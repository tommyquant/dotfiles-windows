#!/bin/bash

# Read environment variables
set -o allexport
source .env
set +o allexport

###############################################################################
# Base packages
###############################################################################

sudo apt-get update

sudo apt-get install -y curl
sudo apt-get install -y fonts-powerline
sudo apt-get install -y git
sudo apt-get install -y locales
sudo apt-get install -y zsh

# Install Oh My Zsh. This needs curl, git and zsh packages installed first.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

###############################################################################
# Dev dependencies
###############################################################################

echo 'Installing dev dependencies...'

# Install Node
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

###############################################################################
# Additional setup
###############################################################################

echo 'Performing additional setup...'

# Set up locale needed for Oh My Zsh themes
locale-gen en_US.UTF-8
# Configure Git user
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

echo 'Copying dotfiles...'
cp -R ./.dotfiles/. ~/