#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

Create a pod with name nginx and image 'nginx' with the following environment variables:

UNCHANGED_REFERENCE https://172.17.0.1:80
SERVICE_ADDRESS     https://172.17.0.1:80
ESCAPED_REFERENCE   https://172.17.0.1:80

Ensure the pod is running.
Use namespace ${NS}.

Call the script './verify-result.sh' when done

EOF

