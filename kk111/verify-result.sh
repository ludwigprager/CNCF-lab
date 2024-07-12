#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

pv=$(kubectl get pv $VOLUME )
hostpath=$( kubectl get pv -o jsonpath="{.items[?(@.metadata.name==\"${VOLUME}\")].spec.hostPath.path}" )

if [[ "$hostpath" != "${HOSTPATH}" ]]; then
  error=true
  echo "pv not found or hostPath not correct"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl apply -f - << EOT
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${VOLUME}
spec:
  capacity:
    storage: ${STORAGE}
  volumeMode: Filesystem
  accessModes:
  - ${MODE}
  hostPath:
    path: "${HOSTPATH}"
EOT






EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

