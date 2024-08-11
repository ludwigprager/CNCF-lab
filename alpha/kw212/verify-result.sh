#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )

if [[ "$node" != "cncf-$(whoami)-control-plane" ]]; then
  error=true
  echo "pod doesn't run on controlplane"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

copy from https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/


kubectl apply -f - << EOT
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $PERSISTENTVOLUME
spec:
  capacity:
    storage: $CAPACITY
# volumeMode: Filesystem
  accessModes:
    - $ACCESSMODE
  hostPath:
    path: "$HOSTPATH"
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

