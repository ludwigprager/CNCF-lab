#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
source ../set-env.sh
source ../functions.sh

../10-prepare.sh
source ../.env

kubectl apply -f deployment.yaml

function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT

echo "Preparing the environment ..."

#kubectl create deployment ${POD} --image=nginx

cat << EOF

Q15 Deploy a pod nod node $NODE as per the below specification

Pod: $POD
Container name: $CONTAINER
Image: $IMAGE

Command: $COMMAND
Image: $IMAGE
Container: $CONTAINER
Volumepath: $VOLUMEPATH

EOF

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
