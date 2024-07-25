#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test service exists
#service=$(kubectl get service ${SERVICE} -o jsonpath='{.metadata.name}')
#if [[ $service != ${SERVICE} ]]; then
#  error=true
#  echo "service ${SERVICE} not found"
#fi

## test ready replicas
#ready=$(kubectl get deployment ${DEPLOYMENT} -o jsonpath='{.status.readyReplicas}')
#if [[ ! $ready -eq 2 ]]; then
#  error=true
#  echo "replicas not ready"
#fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl get nodes -o wide -o jsonpath='{$.items[].status.nodeInfo.osImage}'  > /tmp/${FILENAME}



EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

