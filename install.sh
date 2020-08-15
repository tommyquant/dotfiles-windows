#!/bin/bash

# Read environment variables
set -o allexport
source .env
set +o allexport

###############################################################################
# Base packages
###############################################################################

sudo apt update

# GCC compiler
sudo apt install -y build-essential
sudo apt install -y curl
sudo apt install -y fonts-powerline
sudo apt install -y git
sudo apt install -y locales
sudo apt install -y zsh

# Install Oh My Zsh. This needs curl, git and zsh packages installed first.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

###############################################################################
# Dev dependencies
###############################################################################

echo 'Installing dev dependencies...'

# Install Node
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Install Rust
export RUSTUP_IO_THREADS=1
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y

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