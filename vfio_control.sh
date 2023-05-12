#!/bin/bash

ID1="0000:01:00.0"


function start_app() {
  sh -c "echo -n $ID1 > /sys/bus/pci/drivers/vfio-pci/bind" || echo "Failed to bind $ID1"
  /sbin/lspci -kn | grep -A 2 ${ID1}
}

function stop_app() {
  sh -c "echo -n $ID1 > /sys/bus/pci/drivers/vfio-pci/unbind" || echo "Failed to unbind $ID1"
  /sbin/lspci -kn | grep -A 2 ${ID1}
}


case "$1" in
    start_app)   start_app ;;
    stop_app)    stop_app ;;
    restart) stop_app; start_app ;;
    *) echo "usage: $0 start_app|stop_app|restart_app" >&2
       exit 1
       ;;
esac