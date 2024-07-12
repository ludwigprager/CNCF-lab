
export TASK=kw209

POD=my-busybox
IMAGE=busybox:1.31.1
SLEEP=4800
NODE=cka-$(whoami)-worker
export TASK=${PWD##*/}
