#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
# test limits
cpu=$(kubectl get pod $POD -o=jsonpath="{$.spec.containers[?(@.image==\"$IMAGE\")].resources.limits.cpu}" 2>/dev/null)
memory=$(kubectl get pod $POD -o=jsonpath="{$.spec.containers[?(@.image==\"$IMAGE\")].resources.limits.memory}" 2>/dev/null)

if [[ $cpu != $CPU ]]; then
  echo "cpu limits found: $cpu, expected: $CPU
  error=true
fi
if [[ $memory != $MEMORY ]]; then
  echo "memory limits found: $memory, expected: $MEMORY
  error=true
fi

if [ "$error" = true ] ; then

cat << EOF
# FAILED
# suggested solution:
# https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD
  name: $POD
spec:
  containers:
  - image: redis:alpine
    name: $POD
    resources:
      limits:
        memory: "$MEMORY"
        cpu: "$CPU"

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi
