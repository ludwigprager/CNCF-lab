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
pod=$(kubectl get pod ${POD} -o jsonpath='{.metadata.name}')
if [[ $pod != ${POD} ]]; then
  error=true
  echo "pod ${POD} not found"
fi

# test container status
status=$(kubectl get pod $POD -o=jsonpath="{$.status.containerStatuses[?(.name==\"$POD\")].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl get po $POD -o yaml > $POD.yaml
sed -i 's/sleeep/sleep/' $POD.yaml
kubectl delete pod $POD
kubectl apply -f $POD.yaml




EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

