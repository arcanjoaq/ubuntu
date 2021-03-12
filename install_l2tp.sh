#!/bin/bash
sudo add-apt-repository ppa:nm-l2tp/network-manager-l2tp 
sudo apt-get update && \
sudo apt-get install libreswan network-manager-l2tp network-manager-l2tp-gnome  -y && \
sudo service xl2tpd stop && sudo update-rc.d xl2tpd disable
