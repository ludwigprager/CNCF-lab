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

Q8 Deploy a pod with the following specifcations:

Pod: $POD
Image: $IMAGE
Node: $NODE

Note: do not modify any settings on master or worker nodes


EOF

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
