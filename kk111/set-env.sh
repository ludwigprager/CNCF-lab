
export TASK=kk111

VOLUME="pv-analytics"
STORAGE="100Mi"
MODE="ReadWriteMany"
HOSTPATH="/pv/data-analytics"
export TASK=${PWD##*/}
