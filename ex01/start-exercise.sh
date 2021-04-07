#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

source set-env.sh
source ../functions.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

Create a pod with name nginx and image 'nginx' with the following attributes:

requests:
  cpu:    100m
  memory: 256Mi
limits:
  cpu:    200m
  memory: 512Mi

Ensure the pod is running.
Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

take-down-time
#echo $(date +%s) > $DIR/start.time

