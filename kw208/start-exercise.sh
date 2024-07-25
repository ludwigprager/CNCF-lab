#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source ../set-env.sh
source ../functions.sh
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT
../10-prepare.sh
source ../.env

envsubst < namespace.yaml.tpl | kubectl apply -f -

cat << EOF > task.txt

Q8 Create a new PersistentVolume name web-pv. It should have a capacity of $CAPACITY, accessMode $ACCESSMODE, hostPath $HOSTPATH and no storageClassName defined.

Next create a new PersistentVolumeClaim in Namespace $NAMESPACE name web-pvc. It shoud request 2Gi storage, accessMode $ACCESSMODE and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally, create a new deployment web-deploy in namespace $NAMESPACE which mounts that volume at /tmp/web-data. The pods of that deployment should be of image $IMAGE

PersistentVolume: $PERSISTENTVOLUME
Capacity: $CAPACITY
AccessMode: $ACCESSMODE
hostPath: $HOSTPATH

PersistentVolumeClaim: $PERSISTENTVOLUMECLAIM
Deployment: $DEPLOYMENT
mountPath: $MOUNTPATH


EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
