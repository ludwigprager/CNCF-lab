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

if [[ "$node" != "cncf-$(whoami)-control-plane" ]]; then
  error=true
  echo "pod doesn't run on controlplane"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl run nginxpod --image nginx --dry-run=client -o yaml > p
kubectl explain pod.spec | grep -i node

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  name: $POD
spec:
  nodeName: cncf-$(whoami)-control-plane
  containers:
  - image: $IMAGE
    name: $POD
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

