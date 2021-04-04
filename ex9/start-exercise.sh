#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS --grace-period=0 > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null


cat << EOF

Create a pod named 'nginx' and image 'nginx:1.17' that
- is restarted when the endpoint /healthz on port 80 fails
- receives traffic only if the endpoint / on port 80 is functional.

Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

