#!/usr/bin/env bash
set -e
## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

## write correct window size to chrome properties
./$INST_DIR/chrome-init.sh

## resolve_vnc_connection
VNC_IP=$(hostname -i)

## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
# first entry is control, second is view (if only one is valid for both)
mkdir -p "$ROOT_DIR/.vnc"
PASSWD_PATH="$ROOT_DIR/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

# if [[ $VNC_VIEW_ONLY == "true" ]]; then
#     echo "start VNC server in VIEW ONLY mode!"
#     #create random pw to prevent access
#     echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > $PASSWD_PATH
# fi
echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH


## start vncserver and noVNC webclient
# echo -e "\n------------------ start noVNC  ----------------------------"
# if [[ $DEBUG == true ]]; then echo "$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT"; fi
# $NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &> $STARTUPDIR/no_vnc_startup.log &
# PID_SUB=$!

echo -e "\n------------------ start VNC server ------------------------"
echo "remove old vnc locks to be a reattachable container"
vncserver -kill $DISPLAY &> ./$INST_DIR/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> ./$INST_DIR/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
if [[ $DEBUG == true ]]; then echo "vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION"; fi
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION &> ./$INST_DIR/no_vnc_startup.log
echo -e "start window manager\n..."
./wm_startup.sh &> ./$INST_DIR/wm_startup.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$VNC_IP:$NO_VNC_PORT/?password=...\n"


# if [[ $DEBUG == true ]] || [[ $1 =~ -t|--tail-log ]]; then
#     echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
#     # if option `-t` or `--tail-log` block the execution and tail the VNC log
#     tail -f $STARTUPDIR/*.log $HOME/.vnc/*$DISPLAY.log
# fi

# if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
#     wait $PID_SUB
# else
#     # unknown option ==> call command
#     echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
#     echo "Executing command: '$@'"
#     exec "$@"
# fi