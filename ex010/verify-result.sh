#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test tain exists
taint=$(kubectl get nodes cka-$(whoami)-worker  -o jsonpath="{.spec.taints[?(.key==\"spray\")]}")
if [[ -z $taint ]]; then
  error=true
  echo "the taint was not found"
fi

# test container image
effect=$(kubectl get nodes cka-$(whoami)-worker  -o jsonpath="{.spec.taints[?(.key==\"spray\")].effect}")

if [[ $effect != 'NoSchedule' ]]; then
  error=true
  echo "the taint was not correct"
fi

node=$( kubectl get pod ${POD1} -o jsonpath="{.spec.nodeName}" )
if [[ $node == cka-$(whoami)-worker ]]; then
  error=true
  echo "$POD1 should not run on cka-$(whoami)-worker"
fi

node=$( kubectl get pod ${POD2} -o jsonpath="{.spec.nodeName}" )
if [[ $node != cka-$(whoami)-worker ]]; then
  error=true
  echo "$POD1 should run on cka-$(whoami)-worker"
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

# suggested solution:

kubectl taint node cka-$(whoami)-worker $KEY=$VALUE:NoSchedule

kubectl run $POD1 --image=redis:alpine

kubectl run $POD2 --image=redis:alpine --dry-run=client -o yaml > $POD2

# add:
  tolerations:
  - key: $KEY
    effect: NoSchedule
    operator: Equal
    value: $VALUE

kubectl apply -f no-redis
kubectl apply -f pro-redis
EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

