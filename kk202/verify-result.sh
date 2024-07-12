#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

cpu=$(kubectl get pod $POD -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
memory=$(kubectl get pod $POD -o jsonpath='{.spec.containers[0].resources.requests.memory}')

if [[ "$cpu" != "$CPU" ]] ; then
  error=true
  echo "cpu doesn't match"
fi

if [[ "$memory" != "$MEMORY" ]] ; then
  error=true
  echo "memory doesn't match"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  name: elephant
spec:
  containers:
  - image: redis
    name: elephant
    resources:
      requests:
        cpu: "${CPU}"
        memory: "${MEMORY}"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

