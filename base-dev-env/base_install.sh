#!/usr/bin/env bash
set -e

echo "Install common tools and libs"
apt-get update 
apt-get install -y nano mc wget net-tools locales bzip2


echo "Install Powershell core"
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt-get install -y powershell

echo "Install git"
apt-get install -y git

echo "generate locales en_US.UTF-8"
locale-gen en_US.UTF-8