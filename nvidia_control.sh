#!/bin/bash

CURR_FOLDER=`pwd`
PCI_DEV="01:00"

# only prepend if not already done
pathprepend() {
  for ((i=$#; i>0; i--)); 
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        export PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

# only prepend if not already done
libprepend() {
  for ((i=$#; i>0; i--)); 
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$LD_LIBRARY_PATH:" != *":$ARG:"* ]]; then
        export LD_LIBRARY_PATH="$ARG${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}"
    fi
  done
}

function start() {
  echo "[+] Starting modules"
  pathprepend ${CURR_FOLDER}/bin 
  pathprepend ${CURR_FOLDER}/lib
  libprepend ${CURR_FOLDER}/lib

  insmod ./nvidia.ko > /dev/null 2>&1
  insmod ./nvidia-uvm.ko > /dev/null 2>&1
  insmod ./nvidia-modeset.ko > /dev/null 2>&1
  insmod ./nvidia-drm.ko > /dev/null 2>&1

  /sbin/lspci -kn | grep -A 2 "${PCI_DEV}"
}

function stop() {
  echo "[+] Unloading kernel modules"
  rmmod nvidia-drm > /dev/null 2>&1
  rmmod nvidia-modeset > /dev/null 2>&1
  rmmod nvidia-uvm > /dev/null 2>&1
  rmmod nvidia > /dev/null 2>&1
  /sbin/lspci -kn | grep -A 1 "${PCI_DEV}"
}


case "$1" in
    start)   start ;;
    stop)    stop ;;
    restart) stop; start ;;
    *) echo "usage: $0 start|stop|restart_app" >&2
       exit 1
       ;;
esac