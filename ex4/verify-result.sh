#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=

# test container image
image=$(kubectl -n$NS get pod -l app=nginx-deploy -o jsonpath="{$.items[0].spec.containers[?(.name=='nginx')].image}" 2> /dev/null  )
if [[ $image != nginx:1.13 ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod  -l app=nginx-deploy -o=jsonpath="{$.items[0].status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null )
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod  -l app=nginx-deploy -o=jsonpath="{$.items[0].status.phase}" 2>/dev/null )
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

# test deployment description
description=$(kubectl  -n$NS describe deployment nginx-deploy 2>/dev/null)

# 1. strategy type
echo "$description" | grep -qx 'StrategyType:.*RollingUpdate$'
if [ $? -ne 0 ]; then
    error=true
    echo 'StrategyType: Rollingupdate' not found
fi


# 2. surge + unavailable
echo "$description" | grep -qx 'RollingUpdateStrategy:.*2 max unavailable, 1 max surge$'
if [ $? -ne 0 ]; then
    error=true
    echo 'max surge' or 'max unavailable' not correct
fi

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:

1. create a yaml file:
k create deployment nginx-deploy --image=nginx:1.13 --replicas=4 -o yaml --dry-run=client > nginx-deploy.yaml

2. modify the strategy:

  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2

2. create the deployment with:
kubectl -n$NS create -f nginx-deploy.yaml 

3. upgrade the deployment
kubectl -n$NS set image deploy nginx-deploy nginx=nginx:1.14

4. rollback:
kubectl -n$NS rollout undo deployment nginx-deploy
EOS


else
    echo PASSED
fi
