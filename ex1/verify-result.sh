#!/usr/bin/env bash

set -u

source set-env.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS nginx -o jsonpath="{$.spec.containers[?(.name=='nginx')].image}")
if [[ $image != nginx ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}")
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.phase}")
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

# test requests
cpu=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.cpu}")
memory=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.memory}")

#requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi

[[ "$cpu" == "100m" ]] || error=true
[[ "$memory" == "256Mi" ]] || error=true

# test limits
cpu=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}")
memory=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}")

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
    echo PASSED
fi
