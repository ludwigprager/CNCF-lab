#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source ../set-env.sh
source ../functions.sh


function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT
../10-prepare.sh
source ../.env

echo "Preparing the environment ..."

kubectl create namespace $NAMESPACE
kubectl create deployment $DEPLOYMENT --replicas=3 --image=redis -n $NAMESPACE

cat << EOF

Q4. you can find an existing deployment $DEPLOYMENT in $NAMESPACE namespace, scale down the replicas to $REPLICAS and change the image to $IMAGE

Deployment: $DEPLOYMENT
Namespace: $NAMESPACE
Replicas: $REPLICAS
Image: $IMAGE

EOF

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
