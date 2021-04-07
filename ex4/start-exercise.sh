#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

1.
Create a new deployment 'nginx-deploy' with image 'nginx:1.13' and 4 replicas.
The deployment shall use a 'rolling update' strategy with at least 3 and no more than 6 pods ready during the update.

2.
Then, upgrade the deployment to version 1.14

3.
Roll back 

Use namespace ${NS}.

Call the script '$DIR/verify-result.sh' when done

EOF

take-down-time $DIR
