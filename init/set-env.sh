
export TASK=${PWD##*/}

IMAGE1=nginx
IMAGE2=busybox:1.28

#POD=my-busybox
#NODE=worker
#VOLUMEPATH=/var/busybox/log
#COMMAND="tail -f ${VOLUMEPATH}/*.log"

PATH1="/usr/share/nginx/html"
PATH2="/work-dir"
PORT=80

TESTPOD=curler
