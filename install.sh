#!/bin/bash

# Configuration functions

function configure_git() {
  echo "Configuring Git..."
  echo ".classpath
.project
.settings
target
bin
.idea
*.log
*.*~
*.out
.class
*.pyc
*.pyo
*.swp
*.swo
node_modules
package.lock" > ~/.gitignore && \
        git config --global core.excludesfile ~/.gitignore && \
        git config --global diff.tool meld && \
        git config --global difftool.prompt false && \
        git config --global merge.tool meld && \
        git config --global mergetool.keepbackup false && \
        git config --global core.editor "micro" && \
        git config --global core.commentchar "@" && \
        git config --global http.postBuffer 524288000 && \
        git config --global http.sslVerify false && \
        git config --global grep.lineNumber true && \
        git config --global pull.rebase false && \
        git config --global remote.origin.prune true && \
        git config --global alias.s 'stash --all' && \
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
}

function configure_vim() {
  echo "Configuring vim..."
  echo 'syntax enable

set autoindent
set smartindent

set number
set encoding=utf-8

set ignorecase
set hlsearch
set incsearch

nnoremap <esc><esc> :noh<return>

set clipboard=unnamedplus

autocmd FileType html,css,ruby,javascript,java,dart,kotlin setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,bash,sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType ruby,javascript,java,python,bash,sh,html,css,yaml,make autocmd BufWritePre * %s/\s\+$//e' > ~/.vimrc
}

# Installation functions

function install_libraries() {
    echo "Installing Libraries..."
        sudo apt-get install -y build-essential \
        checkinstall \
        libreadline-gplv2-dev \
        libncursesw5-dev \
        libssl-dev \
        libsqlite3-dev \
        tk-dev \
        libgdbm-dev \
        libc6-dev \
        libbz2-dev \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        openvpn \
        openssh-client \
        openssh-server \
        net-tools \
        zip \
        unzip \
        sed \
        curl \
        wget \
        jq \
        xclip \
        xsel \
        htop \
        ncdu
}

function install_terminator() {
  echo "Installing Terminator..."
  sudo apt-get install -y terminator
}

function install_vim() {
  echo "Installing Vim..."
  sudo apt-get install -y vim 
  configure_vim
}

function install_git() {
  if ! [ -x "$(command -v git)" ]; then
    echo "Installing Git..."
    sudo apt-get install -y git
  else
    echo "Git is already installed"
  fi
  configure_git
}

function install_meld() {
  if ! [ -x "$(command -v meld)" ]; then
    echo "Installing Meld..."
    sudo apt-get install -y meld
  else
    echo "Meld is already installed"
  fi
}

function init_sdkman() {
  [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

function install_sdkman() {
  if ! [ -x "${HOME}/.sdkman" ]; then
    echo "Installing SDKMan..."
    cd ~ && curl -s "https://get.sdkman.io" | bash
  else
    echo "SKDMan is already installed"
  fi
  init_sdkman
  sdk update
}

function install_java() {
  echo "Installing Java..."
  sdk install java 11.0.11-zulu
}

function install_maven3() {
  echo "Installing Maven..."
  sdk install maven 3.6.3
  echo 'alias mci="mvn clean install"' | tee -a ${HOME}/.bash_aliases
  echo 'alias mcio="mvn clean install -o"' | tee -a ${HOME}/.bash_aliases
}

function init_nvm() {
  [ -s "${HOME}/.nvm/nvm.sh" ] && \. "${HOME}/.nvm/nvm.sh"
  [ -s "${HOME}/.nvm/bash_completion" ] && \. "${HOME}/.nvm/bash_completion"
}

function install_nvm() {
  if ! [ -x "${HOME}/.nvm" ]; then
    echo "Installing NVM..."
    cd ~ && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && source ~/.bashrc
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
    echo "Installing Docker..."
    sudo apt-get update && sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
    cd ~ && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable" && \
    sudo apt-get update && \
    sudo apt-get -y install docker-ce docker-compose
    sudo usermod -aG docker $CURRENT_USER
  else
    echo "Docker is already installed"
  fi
}

function install_eclipse() {
    TARGET_DIRECTORY=${HOME}/bin
    ECLIPSE_HOME=${TARGET_DIRECTORY}/eclipse

    if [ ! -d "$ECLIPSE_HOME" ]; then
      echo "Installing Eclipse IDE..."

      mkdir -p ${TARGET_DIRECTORY} && cd ${TARGET_DIRECTORY}
      if [ -e "${TARGET_DIRECTORY}/eclipse-jee.tar.gz" ]; then
        echo "Eclipse File already downloaded";
      else
        echo "Downloading Eclipse Java EE ...";
        wget -O eclipse-jee.tar.gz https://www.eclipse.org/downloads/download.php\?file\=/technology/epp/downloads/release/2020-12/R/eclipse-jee-2020-12-R-linux-gtk-x86_64.tar.gz\&r\=1
      fi

      if [ -d "${TARGET_DIRECTORY}/eclipse" ]; then
        echo "Eclipse was already installed"
      else
        echo "Extracting Eclipse Java EE ..."
        tar -xvzf ${TARGET_DIRECTORY}/eclipse-jee.tar.gz && \
          rm ${TARGET_DIRECTORY}/eclipse-jee.tar.gz

        echo "Configuring eclipse.ini..."
        ECLIPSE_INI=${ECLIPSE_HOME}/eclipse.ini
        sed 's/-Xms.*/-Xms1024m/g' -i ${ECLIPSE_INI}
        sed 's/-Xmx.*/-Xmx4096m/g' -i ${ECLIPSE_INI}

        JAVA_BIN_PATH=${HOME}/.sdkman/candidates/java/current/bin
        echo "Configuring Eclipse VM ..."
        sed "s#-vmargs#-vm\n${JAVA_BIN_PATH}\n-vmargs#" -i ${ECLIPSE_INI}
      fi
    else
      echo "Eclipse is already installed"
    fi

    ECLIPSE_DESKTOP_FILE_DIRECTORY=${HOME}/.local/share/applications
    echo "Configuring eclipse.desktop file..."
    mkdir -p $ECLIPSE_DESKTOP_FILE_DIRECTORY && echo "[Desktop Entry]
Name=Eclipse
Type=Application
Exec=${ECLIPSE_HOME}/eclipse
Terminal=false
Icon=${ECLIPSE_HOME}/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse" > $ECLIPSE_DESKTOP_FILE_DIRECTORY/eclipse.desktop
}

function install_kubectl() {
  if ! [ -x "$(command -v kubectl)" ]; then
    cd ~ && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod u+x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl
  else
    echo "Kubectl is already installed"
  fi
}

function install_helm3() {
  if ! [ -x "$(command -v helm)" ]; then
    cd ~ && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  else
    echo "Helm 3 is already installed"
  fi    
}

function install_micro() {
  if ! [ -x "$(command -v micro)" ]; then
    cd ~ && curl https://getmic.ro | bash && sudo mv micro /usr/local/bin
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
	  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
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
    sudo apt-get update && sudo apt-get install -y mongodb-org-shell mongodb-org-tools
  fi	
}

# Main

function main() {
  echo "Preparing installation..."

  if [ -z "$USER" ]; then
    CURRENT_USER=$(id -un)
  else
    CURRENT_USER="$USER"
  fi

  export CURRENT_USER
  echo "Current user is $CURRENT_USER"

  if ! [ -x "$(command -v sudo)" ]; then
    apt-get update && apt-get install sudo
  else
    echo "Updating definitions..."
    sudo apt-get update
  fi

  install_libraries && \
  install_terminator && \
  install_vim && \
  install_git && \
  install_meld && \
  install_sdkman && \
  install_java && \
  install_maven3 && \
  install_nvm && \
  install_npm && \
  install_docker && \
  install_eclipse && \
  install_kubectl && \
  install_helm3 && \
  install_micro && \
  install_code && \
  install_aws_cli && \
  install_psql && \
  install_mongo && \
  echo "Installation was finished. Reboot your system and happy coding...!!!"
}

main
