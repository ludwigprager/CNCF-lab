#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test deployment exists
deployment=$(kubectl get deployment ${DEPLOYMENT} -o jsonpath='{.metadata.name}')
if [[ $deployment != ${DEPLOYMENT} ]]; then
  error=true
  echo "deployment ${DEPLOYMENT} not found"
fi

# test ready replicas
ready=$(kubectl get deployment ${DEPLOYMENT} -o jsonpath='{.status.readyReplicas}')
if [[ ! $ready -eq 2 ]]; then
  error=true
  echo "replicas not ready"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl run pod ${POD} --image ${IMAGE} --command ${COMMAND} > pod.yaml

Place pod.yaml in /etc/kubernetes/manifests/ on the node.

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

