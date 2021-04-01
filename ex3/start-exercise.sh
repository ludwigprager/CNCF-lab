#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS  > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

1.
Create a new deployment called nginx-deploy, with image nginx:1.13 and 1 replica.
Record the command in the resource annotation. 
Hint: you need to use 'kubectl apply' since 'kubectl create' does not have the '--record' option anymore.

2.
Then, upgrade the deployment four times using versions
- nginx:1.14
- nginx:1.15
- nginx:1.16
- nginx:1.17

Record the version upgrade in the resource annotation. 

3.
Roll back to the second version, i.e. when 'nginx:1.14' was running.

Use namespace ${NS}.

Call the script '$DIR/verify-result.sh' when done

EOF

