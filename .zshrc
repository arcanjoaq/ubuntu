export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-sdkman zsh-nvm docker kubectl)

source $ZSH/oh-my-zsh.sh

# aliases
alias me="curl ifconfig.me"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias clipboard="xsel -i --clipboard"
alias antlr4='java -cp .:${HOME}/bin/antlr.jar org.antlr.v4.Tool'
alias grun='java -cp .:${HOME}/bin/antlr.jar org.antlr.v4.gui.TestRig'
alias mci="mvn clean install"
alias mdb="mvn dockerfile:build"
alias ips='ip -4 -o address show | awk "{print \$2,\$4}"'
alias autoclean='sudo journalctl --vacuum-time=1d; sudo apt-get autoclean -y; sudo apt-get clean -y; sudo apt-get autoremove -y --purge; [ -x "$(command -v docker)" ] && docker system prune -a --volumes -f && docker network prune -f'
