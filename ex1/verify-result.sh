#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source set-env.sh

error=false

cpu=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}")
memory=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}")

[[ "$cpu" == "100m" ]] || error=true
[[ "$memory" == "256Mi" ]] || error=true


if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

kubectl run -n$NS nginx --image=nginx --limits='cpu=200m,memory=512Mi'

EOF

else
    echo PASSED
fi
