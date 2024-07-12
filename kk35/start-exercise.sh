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

kubectl apply -f policy.yaml
kubectl run $POD --image=nginx -l app=$POD
kubectl expose pod $POD --port=$PORT --name $SERVICE

kubectl run $TESTPOD  --image=nginx 

../cilium status --wait
kubectl wait --for=condition=Ready pod/$TESTPOD --timeout=5m

echo "Preparing the environment ..."

cat << EOF > task.txt

Q5 We deployed a pod $POD and a service $SERVICE. Incoming connections are not working. Fix it.
Create a network policy $POLICY that allows incoming connections over port $PORT.

- Don't alter existing objects
- Network policy applied to All sources, from all pods.
- Network policy applied to correct pod, with correct port

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
