#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS || true
kubectl create ns $NS

cat << EOF

Create a pod with name nginx and image 'nginx' with requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi
Use namespace ${NS}

Call the script './verify-result.sh' when done

EOF

