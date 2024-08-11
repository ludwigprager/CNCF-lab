#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh

error=false

node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )

if [[ "$node" != "$NODE" ]]; then
  error=true
  echo "pod doesn't run on node $NODE"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED

# suggested solution:

kubectl apply -f - << EOT

apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  nodeName: cncf-$(whoami)-worker2
  containers:
  - image: nginx
    name: web
# dnsPolicy: ClusterFirst


EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

