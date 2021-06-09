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
      echo 'export GOPATH=${HOME}/golang' | tee -a ${HOME}/.profile && \
      echo 'export PATH=${PATH}:/usr/local/go/bin' | tee -a ${HOME}/.profile && \
      echo 'export GOBIN=/usr/local/go/bin' | tee -a ${HOME}/.profile && \
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

function install_antlr() {
  if ! [ -f "/usr/local/lib/antlr-4.9.2-complete.jar" ]; then
    cd /usr/local/lib
    sudo curl -O https://www.antlr.org/download/antlr-4.9.2-complete.jar
    echo 'export CLASSPATH=".:/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH"' | sudo tee -a /etc/profile
    echo "alias antlr4='java -jar /usr/local/lib/antlr-4.9.2-complete.jar'" | sudo tee -a /etc/profile
    echo "alias grun='java org.antlr.v4.gui.TestRig'" | sudo tee -a /etc/profile
  fi    
}

install_golang
install_virtualbox
install_ab
install_antlr
