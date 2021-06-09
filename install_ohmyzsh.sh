#!/bin/bash

function install_zsh() {
	sudo apt-get install -y zsh
}

function install_ohmyzsh_plugins() {
  if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
    cd ${HOME}/.oh-my-zsh/custom/plugins && \
    git clone 'https://github.com/lukechilds/zsh-nvm'
  else
    echo "zsh-nvm is already installed"
  fi

  if [ ! -d "${HOME}/.oh-my-zsh/plugins/zsh-sdkman" ]; then
    cd ${HOME}/.oh-my-zsh/plugins && \
    git clone 'https://github.com/matthieusb/zsh-sdkman.git'
  else
    echo "zsh-sdkman is already installed"
  fi
}

function install_ohmyzsh() {
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    cd /tmp && \
    wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
    chmod u+x install.sh && \
    ./install.sh
  fi
}

function main() {
  install_zsh && \
  install_ohmyzsh && \
  install_ohmyzsh_plugins && \
  sed -i 's/.*plugins=(.*/plugins=(git zsh-sdkman zsh-nvm docker)/' ~/.zshrc
}

main
