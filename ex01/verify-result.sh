#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS nginx -o jsonpath="{$.spec.containers[?(.name=='nginx')].image}" 2>/dev/null)
if [[ $image != nginx ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.phase}" 2>/dev/null)
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

# test requests
cpu=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.cpu}" 2>/dev/null)
memory=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.memory}" 2>/dev/null)

#requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi

[[ "$cpu" == "100m" ]] || error=true
[[ "$memory" == "256Mi" ]] || error=true

# test limits
cpu=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}" 2>/dev/null)
memory=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}" 2>/dev/null)

[[ "$cpu" == "200m" ]] || error=true
[[ "$memory" == "512Mi" ]] || error=true


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl run -n$NS nginx --image=nginx --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi'


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

