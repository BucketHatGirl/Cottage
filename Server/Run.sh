#!/bin/bash
source /etc/os-release

bash ./Clean.sh

case "$ID" in
  ubuntu|debian|linuxmint)
    PACKAGE_MANAGER="apt"
    COMMAND="sudo apt install -y"
    ;;
  fedora|centos|rhel)
    PACKAGE_MANAGER="dnf"
    COMMAND="sudo dnf install -y"
    ;;
  arch|manjaro)
    PACKAGE_MANAGER="pacman"
    COMMAND="sudo pacman -S --noconfirm"
    ;;
  opensuse)
    PACKAGE_MANAGER="zypper"
    COMMAND="sudo zypper install -y"
    ;;
  void)
    PACKAGE_MANAGER="xbps"
    COMMAND="sudo xbps-install -y"
    ;;
  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

echo "Using package manager: $PACKAGE_MANAGER"

while IFS= read -r PACKAGE; do
  [ -n "$PACKAGE" ] && $COMMAND "$PACKAGE"
done < Packages.txt

sudo usermod -aG prosody $(whoami) 
newgrp prosody &
sudo usermod -aG tor $(whoami) 
newgrp tor &

sudo pkill -H -f tor
sudo pkill -f prosody
sudo pkill -H -f php

clear 

bash ./BootstrapServer.sh

while true; do
  bash ./Server.sh
  sleep 2100
  SERVER_PID=$(cat "SERVER_PID.txt")
  pkill -f -h -P "$SERVER_PID"
done

