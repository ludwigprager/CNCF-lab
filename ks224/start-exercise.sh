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

kubectl create ns $NAMESPACE

export TIER=$TIER1
export PORT=$PORT1
envsubst < statefulset.yaml.tpl | kubectl apply -f -

export TIER=$TIER2
export PORT=$PORT2
envsubst < statefulset.yaml.tpl | kubectl apply -f -

export TIER=$TIER3
export PORT=8888
envsubst < statefulset.yaml.tpl | kubectl apply -f -


export TIER=$TIER4
export PORT=$PORT4
envsubst < statefulset.yaml.tpl | kubectl apply -f -

../cilium status --wait
kubectl wait --for=condition=Ready -n $NAMESPACE pod/${TIER1}-0 --timeout=5m
kubectl wait --for=condition=Ready -n $NAMESPACE pod/${TIER2}-0 --timeout=5m
kubectl wait --for=condition=Ready -n $NAMESPACE pod/${TIER3}-0 --timeout=5m
kubectl wait --for=condition=Ready -n $NAMESPACE pod/${TIER4}-0 --timeout=5m

echo "Preparing the environment ..."

cat << EOF > task.txt

Q24 Create a NetworkPolicy called '$POLICY' in namespace '$NAMESPACE'. It should allow the ${TIER3}-* pods only to
- connect to '${TIER1}-*' pods on port $PORT1
- connect to '${TIER2}-*' pods on port $PORT2

Use the pod's 'app' label in your policy.

(from: killer.sh CKA Question 24 https://www.youtube.com/watch?v=ymhjqTOjY2E )


EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
