#!/usr/bin/env bash
set -e

echo "Install Xfce4"
apt-get install -y supervisor xfce4 xfce4-terminal xterm
apt-get purge -y pm-utils xscreensaver*
