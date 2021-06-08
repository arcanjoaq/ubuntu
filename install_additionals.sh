#!/bin/bash
function install_golang() {
  if ! [ -d "/usr/local/go" ]; then
    echo "Installing Golang..."
    GO_VERSION=go1.16.5
    cd ~
    if [ ! -f "${GO_VERSION}.linux-amd64.tar.gz" ]; then
      wget https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz -O ${GO_VERSION}.linux-amd64.tar.gz
    fi
    tar -xzf ${GO_VERSION}.linux-amd64.tar.gz && \
      mv go ${GO_VERSION} && \
      sudo mv ${GO_VERSION} /usr/local/${GO_VERSION} && \
      sudo ln -sf /usr/local/${GO_VERSION} /usr/local/go && \
      rm ${GO_VERSION}.linux-amd64.tar.gz && \
      mkdir -p ${HOME}/golang && \
      echo 'export GOPATH=${HOME}/golang' >> ${HOME}/.profile && \
      echo 'export PATH=${PATH}:/usr/local/go/bin' >> ${HOME}/.profile && \
      echo 'export GOBIN=/usr/local/go/bin' >> ${HOME}/.profile && \
      source ${HOME}/.profile
  else
    echo "GoLang is already installed"
  fi
}

function install_virtualbox() {
  if ! [ -x "$(command -v virtualbox)" ]; then
    cd ~ && \
    curl -Lo virtualbox "https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Linux_amd64.run" && \
    chmod u+x virtualbox && \
    sudo ./virtualbox && \
    rm virtualbox
  else
    echo "Virtualbox is already installed"
  fi
}

function install_ab() {
  if ! [ -x "$(command -v ab)" ]; then
    sudo apt-get install -y apache2-utils
  fi	
}

install_golang
install_virtualbox
install_ab
