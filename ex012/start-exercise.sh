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
../10-prepare.sh 1.30.2 1.30.0 kind.config.cilium
source ../.env

../cilium install #--version 1.15.6

kubectl create namespace $NAMESPACE

kubectl apply -f deny-all.yaml
kubectl apply -f deny-all.yaml -n $NAMESPACE

kubectl run $POD -n $NAMESPACE  --image=nginx
kubectl expose pod $POD -n $NAMESPACE --port=$PORT

kubectl run $TESTPOD  --image=nginx 
kubectl run $TESTPOD -n $NAMESPACE --image=nginx 

../cilium status --wait
kubectl wait --for=condition=Ready pod/$TESTPOD
kubectl wait --for=condition=Ready pod/$TESTPOD -n $NAMESPACE
kubectl wait --for=condition=Ready pod/$POD -n $NAMESPACE

echo "Preparing the environment ..."

cat << EOF > task.txt

Q012 Create a netpol that allows all pods in the $NAMESPACE namespace to communicate on port $PORT.
(orig: 'Create a netpol that allows all pods in the $NAMESPACE namespace to have communication only on a single port.')

Port: $PORT
Namespace: $NAMESPACE

EOF
cat task.txt
clear
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
