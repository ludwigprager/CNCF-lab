#!/usr/bin/env bash
set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh

replicas=$( kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath="{.spec.replicas}" )
image=$( kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath="{.spec.template.spec.containers[0].image}" )

error=false

if [[ $image != $IMAGE ]]; then
  printf "\\nimage is not $IMAGE"
  error=true
fi

if [[ $replicas -ne $REPLICAS ]]; then
  printf "\\nreplicas is not $REPLICAS"
  error=true
fi

if [ "$error" = true ] ; then

pod=$( kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath="{.spec.template.spec.containers[0].name}" )

cat << EOF

FAILED

suggested solution:

kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=$REPLICAS
kubectl set image deployment $DEPLOYMENT -n $NAMESPACE $pod=$IMAGE


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

