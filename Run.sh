#!/bin/bash
source /etc/os-release

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

while IFS= read -r package; do
  [ -n "$package" ] && $COMMAND "$package"
done < Packages.txt

sudo usermod -aG prosody $(whoami) 
newgrp prosody &

while true; do
  clear
  pkill -H tor
  pkill -H prosody 
  bash ./Server.sh &
  sleep 2100
done

