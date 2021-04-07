#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS -l app=nginx-deploy -o jsonpath="{$.items[0].spec.containers[?(.name=='nginx')].image}" 2> /dev/null  )
if [[ $image != nginx:1.14 ]]; then
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



# test history
history=$(kubectl -n$NS rollout history deployment nginx-deploy)

lines=$(echo "$history" | wc -l)
if [[ "$lines" -lt 5 ]] ; then
  error=true
  echo "the history seems short. There need to be at least 5 entries."
fi

# get last line in history
last_line=$(echo "$history" | tail -1)

# needs to contain 'nginx:1.14'
if [[ ! $last_line =~ nginx:1.14 ]]; then
  error=true
  echo "the last entry in the history should contain the string 'nginx:1.14'."
  echo last line: $last_line
fi

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:

1. create a yaml file:
kubectl -n$NS create deployment nginx-deploy --image=nginx:1.13 -o yaml --dry-run=client > nginx-deploy.yaml

2. apply the yaml file:
kubectl -n$NS apply -f nginx-deploy.yaml  --record

3. upgrade the deployment several times:
kubectl -n$NS set image deploy nginx-deploy nginx=nginx:1.14 --record
kubectl -n$NS set image deploy nginx-deploy nginx=nginx:1.15 --record
kubectl -n$NS set image deploy nginx-deploy nginx=nginx:1.16 --record
kubectl -n$NS set image deploy nginx-deploy nginx=nginx:1.17 --record

4. rollback:
kubectl -n$NS rollout undo deployment nginx-deploy  --to-revision=2
EOS


else
  echo PASSED
  print-elapsed-time $DIR
fi
