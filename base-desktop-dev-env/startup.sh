#!/bin/bash
set -e

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM



## write correct window size to chrome properties
VNC_RES_W=${VNC_RESOLUTION%x*}
VNC_RES_H=${VNC_RESOLUTION#*x}

echo -e "\n------------------ update chromium-browser.init ------------------"
echo -e "\n... set window size $VNC_RES_W x $VNC_RES_H as chrome window size!\n"

echo "CHROMIUM_FLAGS='--no-sandbox --disable-gpu --user-data-dir --window-size=$VNC_RES_W,$VNC_RES_H --window-position=0,0'" > $ROOT_DIR/.chromium-browser.init



## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
mkdir -p "$ROOT_DIR/.vnc"
PASSWD_PATH="$ROOT_DIR/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

echo "$VNC_PASSWD" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH


## start vnc server
echo -e "\n------------------ start VNC server ------------------------"
vncserver -kill $VNC_DISPLAY &> $ROOT_DIR/$INST_DIR/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $ROOT_DIR/$INST_DIR/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
vncserver $VNC_DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION
echo -e "start window manager\n..."
./wm_startup.sh &> $ROOT_DIR/$INST_DIR/wm_startup.log

VNC_IP=$(hostname -i)
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on VNC_DISPLAY= $VNC_DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"


## output logs or last command executing
if [[ $OUTPUT == true ]]; then
    echo "Showing output:\n"
    tail -f $ROOT_DIR/$INST_DIR/*.log $ROOT_DIR/.vnc/*$VNC_DISPLAY.log
else
    echo "Executing command: '$@'"
    exec "$@"
fi    
