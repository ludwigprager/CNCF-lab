#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $BASEDIR/../set-env.sh
source $BASEDIR/../functions.sh


error=false
message=

# test container image
image=$(kubectl get deploy -n$NAMESPACE $DEPLOYMENT -o jsonpath="{$.spec.template.spec.containers[?(.name=='nginx')].image}" 2>/dev/null)
if [[ $image != $IMAGE2 ]]; then
  error=true
  echo "the container image is wrong"
fi


## test container status
#status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
##echo container status: $status
#if [[ -z "$status" ]]; then
#  error=true
#  echo "the container is not running"
#fi


## test pod status
#status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.phase}" 2>/dev/null)
#if [[ "$status" != "Running" ]] ; then
#  error=true
#  echo "the pod is not running"
#fi

### test requests
#cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.cpu}" 2>/dev/null)
#memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.memory}" 2>/dev/null)

#requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi

#[[ "$cpu" == "100m" ]] || error=true
#[[ "$memory" == "256Mi" ]] || error=true

## test limits
#cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}" 2>/dev/null)
#memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}" 2>/dev/null)

#[[ "$cpu" == "200m" ]] || error=true
#[[ "$memory" == "512Mi" ]] || error=true


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl create deployment $DEPLOYMENT --image=$IMAGE1 --replicas 3 --dry-run=client -o yaml  | kubectl apply -f -
kubectl set image deployment/$DEPLOYMENT nginx=$IMAGE2 # --record
kubectl rollout history deployment $DEPLOYMENT



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

  print-elapsed-time $BASEDIR
fi

