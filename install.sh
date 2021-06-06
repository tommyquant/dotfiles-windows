#!/bin/bash

# Read environment variables
set -o allexport
source .env
set +o allexport

###############################################################################
# Dotfiles
###############################################################################

echo 'Copying dotfiles...'
cp -R ./.dotfiles/. ~/

###############################################################################
# Base packages
###############################################################################

echo 'Installing base packages...'

sudo apt update

# GCC compiler
sudo apt install -y build-essential
sudo apt install -y curl
sudo apt install -y git
sudo apt install -y pulseaudio
sudo apt install -y libgtk-3-0

###############################################################################
# Dev dependencies
###############################################################################

echo 'Installing dev dependencies...'

# NVM and Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Rust
export RUSTUP_IO_THREADS=1
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y

# Sciter
git clone --depth 1 https://github.com/c-smile/sciter-js-sdk ~/sciter
chmod -R 777 ~/sciter

###############################################################################
# Additional setup
###############################################################################

echo 'Performing additional setup...'

# Configure Git user
echo 'Configuring Git user...'
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
