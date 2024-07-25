#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
# test container image
#emptydir=$(kubectl get pod $POD -o jsonpath="{$.spec.containers[?(.name==\"$POD\")].image}" 2>/dev/null)
emptydir=$(kubectl get pod $POD -o jsonpath="{$.spec.volumes[0].emptyDir}" 2>/dev/null)
if [[ -z $emptydir  ]]; then
  error=true
  echo "expected an 'EmptyDir' volume"
fi




if [ "$error" = true ] ; then

cat << EOF
# FAILED
# suggested solution:

kubectl apply -f - << EOT

apiVersion: v1
kind: Pod
metadata:
  name: $POD
spec:
  containers:
  - image: $IMAGE
    name: test-container
    volumeMounts:
    - mountPath: $MOUNTPATH
      name: v1
  volumes:
  - name: v1
    emptyDir: {}

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

