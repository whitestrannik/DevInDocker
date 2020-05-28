#!/usr/bin/env bash
set -e

echo "Install common tools and libs"
apt-get update 
apt-get install -y nano mc wget net-tools locales bzip2 python-numpy

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb

echo "Install Powershell core"
# Register the Microsoft repository GPG keys
dpkg -i packages-microsoft-prod.deb

# Update the list of products
apt-get update

# Enable the "universe" repositories
#add-apt-repository universe

# Install PowerShell
apt-get install -y powershell

apt-get clean -y

echo "generate locales en_US.UTF-8"
locale-gen en_US.UTF-8