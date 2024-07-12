
export TASK=kw208

PERSISTENTVOLUME="web-pv"
CAPACITY=2Gi
ACCESSMODE="ReadWriteOnce"
HOSTPATH="/vol/data"

PERSISTENTVOLUMECLAIM="web-pvc"
DEPLOYMENT="web-deploy"
HOSTPATH2="/tmp/web-data"

NAMESPACE=production
IMAGE=nginx:1.14.2
export TASK=${PWD##*/}
