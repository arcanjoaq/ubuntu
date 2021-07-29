#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

function install_snap() {
  if ! [ -x "$(command -v snap)" ]; then
    sudo rm /etc/apt/preferences.d/nosnap.pref > /dev/null 2>&1
    sudo apt update && \
    sudo apt install snapd
  fi
}

function init_sdkman() {
  [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

function install_sdkman() {
  if ! [ -x "${HOME}/.sdkman" ]; then
    cd ~ && curl -s "https://get.sdkman.io" | bash
  else
    echo "SKDMan is already installed"
  fi
  init_sdkman
  sdk update
}

function install_java() {
  sdk install java 11.0.11-zulu
}

function install_maven3() {
  sdk install maven 3.6.3
}

function init_nvm() {
  [ -s "${HOME}/.nvm/nvm.sh" ] && \. "${HOME}/.nvm/nvm.sh"
  [ -s "${HOME}/.nvm/bash_completion" ] && \. "${HOME}/.nvm/bash_completion"
}

function install_nvm() {
  if ! [ -x "${HOME}/.nvm" ]; then
    cd ~ && curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && source ~/.bashrc
    init_nvm
  else
    echo "NVM is already installed"
  fi
}

function install_npm() {
  if [ -x "$(command -v node)" ]; then
    echo "Node is already installed"
  else
    init_nvm
    nvm install node v14.8.0
  fi
}

function install_docker() {
  if ! [ -x "$(command -v docker)" ]; then
    sudo apt-get update && sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
    cd ~ && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable" && \
    sudo apt-get update && \
    sudo apt-get -y install docker-ce
    sudo usermod -aG docker $CURRENT_USER
  else
    echo "Docker is already installed"
  fi
}

function install_docker_compose() {
  if ! [ -x "$(command -v docker)" ]; then
    DOCKER_COMPOSE_VERSION=1.29.2
    DOCKER_COMPOSE_DIR=/usr/local/bin
    sudo curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64" -o ${DOCKER_COMPOSE_DIR}/docker-compose && \
    sudo chmod u+x ${DOCKER_COMPOSE_DIR}/docker-compose && \
    sudo ln -sf ${DOCKER_COMPOSE_DIR}/docker-compose /usr/bin/docker-compose && \
    ${DOCKER_COMPOSE_DIR}/docker-compose --version && \
    sudo curl -sL "https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose
  else
    echo "Docker Compose is already installed"
  fi	
}

function install_kubectl() {
  if ! [ -x "$(command -v kubectl)" ]; then
    cd ~ && curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod u+x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl
  else
    echo "Kubectl is already installed"
  fi
}

function install_helm3() {
  if ! [ -x "$(command -v helm)" ]; then
    cd ~ && curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  else
    echo "Helm 3 is already installed"
  fi    
}

function install_micro() {
  if ! [ -x "$(command -v micro)" ]; then
    cd ~ && curl -s https://getmic.ro | bash && sudo mv micro /usr/local/bin
  else
    echo "Micro is already installed"
  fi
  sudo apt-get install editorconfig -y
  if  [ -f "/usr/local/bin/micro" ]; then
    /usr/local/bin/micro -plugin install editorconfig    
  fi
}

function install_code() {
  if ! [ -x "$(command -v code)" ]; then
    cd ~ && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    sudo apt-get update && \
    sudo apt-get install code -y && \
    rm packages.microsoft.gpg
  else
    echo "Code is already installed"
  fi    
}

function install_aws_cli() {
  if ! [ -x "$(command -v aws)" ]; then
    cd /tmp && \
	  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
	  unzip awscliv2.zip && \
	  sudo ./aws/install && \
	  rm -rf aws && \
	  rm -rf awscliv2.zip 
  fi	
}

function install_psql() {
  if ! [ -x "$(command -v psql)" ]; then
    sudo apt-get install -y postgresql-client
  fi	
}

function install_mongo() {
  if ! [ -x "$(command -v mongo)" ]; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    sudo apt-get update && \
      sudo apt-get install -y mongodb-org-shell mongodb-org-tools
  fi	
}

function install_postman() {
  sudo snap install postman
}

function install_idea() {
  sudo snap install intellij-idea-community --classic
}

function install_gradle() {
  sdk install gradle 7.0.2
}

function install_packages() {
  cat packages.txt | xargs sudo apt-get install -y
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
  else
    echo "GoLang is already installed"
  fi
}

function install_virtualbox() {
  if ! [ -x "$(command -v virtualbox)" ]; then
    cd ~ && \
    curl -sLo virtualbox "https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Linux_amd64.run" && \
    chmod u+x virtualbox && \
    sudo ./virtualbox && \
    rm virtualbox
  else
    echo "Virtualbox is already installed"
  fi
}

function install_antlr() {
  if ! [ -f "/usr/local/lib/antlr-4.9.2-complete.jar" ]; then
    cd /usr/local/lib
    sudo curl -s -O https://www.antlr.org/download/antlr-4.9.2-complete.jar && \
    sudo ln -sf /usr/local/lib/antlr-4.9.2-complete.jar /usr/local/lib/antlr.jar 
  fi    
}

function create_symlinks() {
  ln -sf ${SCRIPT_PATH}/.gitconfig ${HOME}/.gitconfig
  ln -sf ${SCRIPT_PATH}/.gitignore ${HOME}/.gitignore
  ln -sf ${SCRIPT_PATH}/.profile ${HOME}/.profile
  ln -sf ${SCRIPT_PATH}/.vimrc ${HOME}/.vimrc
  ln -sf ${SCRIPT_PATH}/.zshrc ${HOME}/.zshrc
}

function install_l2tp() {
  sudo add-apt-repository ppa:nm-l2tp/network-manager-l2tp 
  sudo apt-get update && \
  sudo apt-get install libreswan network-manager-l2tp network-manager-l2tp-gnome -y && \
  sudo service xl2tpd stop && sudo update-rc.d xl2tpd disable	
}

function install_minikube() {
  if ! [ -x "$(command -v minikube)" ]; then
    cd ~ &&  curl -sLO 'https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64' && \
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
  fi    	
}

# Main

function main() {
  if [ -z "$USER" ]; then
    CURRENT_USER=$(id -un)
  else
    CURRENT_USER="$USER"
  fi

  export CURRENT_USER
  echo "Current user is $CURRENT_USER"

  sudo apt-get update

  install_packages
  create_symlinks
  install_snap
  install_sdkman
  install_nvm
  install_docker
  install_docker_compose
  install_micro
  install_ohmyzsh
  install_ohmyzsh_plugins
  install_java
  install_maven3
  install_npm
  install_kubectl
  install_helm3
  install_code
  install_aws_cli
  install_psql
  install_mongo
  install_postman
  install_idea
  install_gradle
  install_golang
  install_virtualbox
  install_antlr
  install_l2tp
  install_minikube
}

main
