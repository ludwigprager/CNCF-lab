#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS --grace-period=0 > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null


cat << EOF

Create a pod named 'probe' and image '$IMAGE' that
- is restarted when the endpoint /healthz on port $PORT fails
- receives traffic only if the endpoint /readz on port $PORT is functional.
- skips the livenessprobe during the first $DELAY seconds after the start of the container.

Watch the container getting 'ready'

Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

take-down-time $DIR
