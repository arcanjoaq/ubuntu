#!/bin/bash
sudo journalctl --vacuum-time=1d

sudo apt-get autoclean -y

sudo apt-get autoremove -y

if [ -x "$(command -v docker)" ]; then
	docker system prune -a --volumes -f
	docker network prune -f
fi	
