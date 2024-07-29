
export TASK=${PWD##*/}

POD=my-busybox
IMAGE=busybox:1.28
NODE=worker
VOLUMEPATH=/var/busybox/log
COMMAND="tail -f ${VOLUMEPATH}/*.log"
