#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
error=true



if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:


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

