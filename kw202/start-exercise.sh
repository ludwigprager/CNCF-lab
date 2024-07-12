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

kubectl run $POD --image=nginx
kubectl run $TESTPOD  --image=nginx 

kubectl wait --for=condition=Ready pod/$POD --timeout=5m
kubectl wait --for=condition=Ready pod/$TESTPOD --timeout=5m

cat << EOF > task.txt

Q2 Expose an existing pod called $POD as a service. Service should be $SERVICE.

Port: $PORT



EOF
clear
cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
