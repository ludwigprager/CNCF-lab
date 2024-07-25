#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

# test pod exists
pod=$(kubectl get pod -n ${NAMESPACE} ${POD} -o jsonpath='{.metadata.name}')
if [[ $pod != ${POD} ]]; then
  error=true
  echo "pod ${POD} not found in namespace ${NAMESPACE}"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl create namespace ${NAMESPACE}
kubectl run pod ${POD} --image ${IMAGE} -n ${NAMESPACE}

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

