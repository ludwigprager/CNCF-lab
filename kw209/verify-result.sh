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

if [[ "$node" != $NODE ]]; then
  error=true
  echo "pod doesn't run on $NODE"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:


kubectl run my-busybox --image=busybox:1.31.1 --command sleep 4800
kubectl uncordon $NODE


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

