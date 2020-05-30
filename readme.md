# Experiments with creating dev environment in Docker 
Main goal of these experiments are learning Docker and Bash scripting (so it is not supposed to be used in production). Additionally it may be useful for quick creating and running different dev environments. 

### Base dev environment image (base-dev-env)
It's base image for further experiments. It is based on Ubuntu:18.04 and includes Git, Powershell, MC, net-tools, nano etc. After run just provide bash command line. 

**How to build image:** 
> docker build --tag base-dev-env:0.1.0 .

**How to run container:** 
> docker run --rm -it base-dev-image:0.1.0  

**Environment variables:**
- ROOT_DIR (default=/root) - root directory
- DEV_DIR (default=dev) - current directory when container is run
- INST_DIR (default=install) - directory which contains all scripts were used during image building

##### Release notes
- 0.1.0 Ubuntu 18.04, Git, Powershell, nano, wget, net-tools, locales


# Base dev desktop image (base-desktop-dev-env)
Almost all code is borrowed from https://github.com/ConSol/docker-headless-vnc-container. It is based on base-dev-image:0.1.0  and includes Xfce, TigerVnc, Chrome and VS Code

**How to build image:** 
> docker build --tag base-desktop-dev-env:0.1.0 .

**How to run container:** 
> docker run --rm  -it -p 5901:5901 base-desktop-dev-env:0.1.0
OR
docker run --rm  -it -p 5901:5901 -e VNC_RESOLUTION=1920x1080 base-desktop-dev-env:0.1.0

**Environment variables:**
- VNC_PORT (default=5901) - port to connect to VNC server
- VNC_PASSWD (default=ddockerr7) - default password to connect to VNC server
- VNC_DISPLAY (default=:1) - display number
- VNC_COL_DEPTH (default=24) - color depth 
- VNC_RESOLUTION (default=1920x1080) - screen resolution
- OUTPUT (defult=false) - true - turn on showing logs, false - just run bash

##### Release notes
- 0.1.0 base-dev-env:0.1.0, Xfce, TigerVnc, Chrome, VS Code