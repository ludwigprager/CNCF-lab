#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

Create a pod 'redis' that mounts the directory '${HOSTPATH}' from the host where
it is running onto the directory '/redis' inside the container.

Use
- container image: 'redis'
- volume name: 'v1'

Do not use a 'persistent volume' or 'persistent volume claim'.

Use namespace ${NS}.

Call the script '$DIR/verify-result.sh' when done

EOF

