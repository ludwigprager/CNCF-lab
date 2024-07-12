#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../set-env.sh
source $DIR/../functions.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$TASK nginx -o jsonpath="{$.spec.containers[?(.name=='nginx')].image}" 2>/dev/null)
if [[ $image != nginx ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.phase}" 2>/dev/null)
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

# test requests
cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.cpu}" 2>/dev/null)
memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.memory}" 2>/dev/null)


if [[ $cpu != $CPU1 ]]; then
  echo "cpu requests found: $cpu, expected: $CPU1
  error=true
fi
if [[ $memory != $MEMORY1 ]]; then
  echo "memory requests found: $memory, expected: $MEMORY1
  error=true
fi

# test limits
cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}" 2>/dev/null)
memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}" 2>/dev/null)

if [[ $cpu != $CPU2 ]]; then
  echo "cpu limits found: $cpu, expected: $CPU2
  error=true
fi
if [[ $memory != $MEMORY2 ]]; then
  echo "memory limits found: $memory, expected: $MEMORY2
  error=true
fi


#kubectl run -n$TASK nginx --image=nginx --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi'

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:


kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
  namespace: ex01
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        memory: "$MEMORY1"
        cpu: "$CPU1"
      limits:
        memory: "$MEMORY2"
        cpu: "$CPU2"
EOT

EOF

else
#  source 
#    start=$(<start.time)
#    now=$(date +%s)
#    elapsed=$( echo "$now - $start" | bc -l )
#    minutes=$(( elapsed/60 ))
#    seconds=$(( elapsed - (minutes * 60) ))
    echo PASSED
#    printf "Time taken: $minutes minutes, $seconds seconds\n"

  print-elapsed-time $DIR
fi

