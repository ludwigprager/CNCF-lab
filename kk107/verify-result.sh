#!/usr/bin/env bash

set -u
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh
error=false

# test pod exists
deployment=$(kubectl get pod ${POD-cncf-$(whoami)-control-plane} -o jsonpath='{.metadata.name}')
if [[ $deployment != ${POD} ]]; then
  error=true
  echo "pod ${POD} not found"
fi

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

# suggested solution:
# on the master node run

kubectl run pod ${POD} --image ${IMAGE} --command ${COMMAND} > /etc/kubernetes/manifests/$POD.yaml

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

