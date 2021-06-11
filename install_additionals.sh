#!/bin/bash
function install_golang() {
  if ! [ -d "/usr/local/go" ]; then
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
      mkdir -p ${HOME}/golang

      cat ${HOME}/.profile | grep 'export GOPATH=' > /dev/null 2>&1
      [ $? -ne 0 ] && echo 'export GOPATH=${HOME}/golang' | tee -a ${HOME}/.profile
      
      cat ${HOME}/.profile | grep 'export PATH=${PATH}:/usr/local/go/bin' > /dev/null 2>&1
      [ $? -ne 0 ] && echo 'export PATH=${PATH}:/usr/local/go/bin' | tee -a ${HOME}/.profile

      cat ${HOME}/.profile | grep 'export GOBIN=' > /dev/null 2>&1
      [ $? -ne 0 ] && echo 'export GOBIN=/usr/local/go/bin' | tee -a ${HOME}/.profile

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

    cat ${HOME}/.bash_aliases | grep 'alias antlr4=' > /dev/null 2>&1
    [ $? -ne 0 ] && echo "alias antlr4='java -jar /usr/local/lib/antlr-4.9.2-complete.jar'" | tee -a ${HOME}/.bash_aliases

    cat ${HOME}/.bash_aliases | grep 'alias grun=' > /dev/null 2>&1
    [ $? -ne 0 ] && echo "alias grun='java org.antlr.v4.gui.TestRig'" | tee -a ${HOME}/.bash_aliases

    cat ${HOME}/.profile | grep 'export CLASSPATH=".:/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH"' > /dev/null 2>&1
    [ $? -ne 0 ] && echo 'export CLASSPATH=".:/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH"' | tee -a ${HOME}/.profile
  fi    
}

install_golang
install_virtualbox
install_ab
install_antlr
