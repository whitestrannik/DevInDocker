#!/usr/bin/env bash
set -e

echo "Install common tools and libs"
apt-get update 
apt-get install -y nano mc wget net-tools locales bzip2 python-numpy
apt-get clean -y

echo "generate locales en_US.UTF-8"
locale-gen en_US.UTF-8