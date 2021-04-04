#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  pod $PODNAME > /dev/null 2>&1 > /dev/null || true
kubectl delete         pv pv-ex6 > /dev/null 2>&1 > /dev/null || true
kubectl delete ns $NS  pvc pvc-ex6 > /dev/null 2>&1 > /dev/null || true
kubectl delete ns $NS > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF


Create a pod that mounts the directory '${HOSTPATH}' from the host where it is
running onto the directory '/var/log/ex6' inside the container using a PVC.

1.
Create a Persistent Volume called 'pv-ex6' with the attributes
- storage class 'manual'
- access mode RWX
- size 2Gi

2.
Create a PVC called 'pvc-ex6' requesting 100Mi. It shall bind to the PV 'pv-ex6..

3.
Create the pod using
- pod name '$PODNAME'
- container image: 'nginx:alpine'
- volume name: 'v1'


Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

