#!/bin/bash
sudo journalctl --vacuum-time=1d

sudo apt-get autoclean -y

sudo apt-get clean -y

sudo apt-get autoremove -y --purge

if [ -x "$(command -v docker)" ]; then
	docker system prune -a --volumes -f
	docker network prune -f
fi	
