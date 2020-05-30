#!/usr/bin/env bash
set -e

echo "Install TigerVNC server"
apt-get install -y ttf-wqy-zenhei
apt-get -y install python-numpy
wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /