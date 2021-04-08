#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS --grace-period=0 > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null
kubectl create -n$NS -f deny-all-ingress.yaml


#echo "Waiting for resources to get ready ..."
#kubectl wait --for=condition=Ready pods --all -n $NS --timeout=120s > /dev/null


cat << EOF

Create a deployment 'nginx' with image 'nginx:1.16' of 2 replicas, expose it via a ClusterIP service on
port 80. Use service name '$SERVICE'.
Create a NetworkPolicy so that only pods with labels 'access: granted' can
access the deployment and apply it

Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

take-down-time $DIR
