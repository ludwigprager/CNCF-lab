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

kubectl create ns $NAMESPACE
kubectl create deployment $DEPLOYMENT -n $NAMESPACE --image=nginx
kubectl run $TESTPOD  --image=nginx  -n $NAMESPACE

kubectl wait --for=condition=Ready -n $NAMESPACE deployment/$DEPLOYMENT --timeout=5m
kubectl wait --for=condition=Ready -n $NAMESPACE pod/$TESTPOD --timeout=5m


echo "Preparing the environment ..."

#kubectl create deployment ${POD} --image=nginx

cat << EOF > task.txt

Q6 Expose existing deployment in $NAMESPACE namespace namd as $DEPLOYMENT through Nodeport and Nodeport service should be $SERVICE

Deployment: $DEPLOYMENT
Namespace: $NAMESPACE
Service: $SERVICE
Port: $PORT

You can review this task at any time in the file task.txt

EOF

clear
cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
