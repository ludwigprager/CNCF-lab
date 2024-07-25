#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

#node=$( kubectl get pod -l app=$DEPLOYMENT -o jsonpath='{.spec.nodeName}' )
node=$( kubectl get pod -l app=$DEPLOYMENT -o jsonpath='{.items[0].spec.nodeName}' )


if [[ "$node" == "$NODE" ]]; then
  error=true
  message="pod with label app=$DEPLOYMENT still running on $NODE"
fi



if [ "$error" = true ] ; then

cat << EOF

FAILED
$message

suggested solution:

kubectl drain cka-$(whoami)-worker --ignore-daemonsets

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

