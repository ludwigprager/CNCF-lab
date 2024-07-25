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
../cilium status --wait

envsubst < deployment.yaml | kubectl apply -f -

kubectl wait pods -n $TIER1 -l tier=$TIER1 --for condition=Ready --timeout=90s
kubectl wait pods -n $TIER2 -l tier=$TIER2 --for condition=Ready --timeout=90s
kubectl wait pods -n $TIER3 -l tier=$TIER3 --for condition=Ready --timeout=90s

kubectl expose deployment $TIER1 -n $TIER1 --port 80 --name $TIER1 -l tier=$TIER1

echo "Preparing the environment ..."

cat << EOF > task.txt

Q11 Pods run in multiple namespaces. The security team has mandated that the deployment $TIER1 on $TIER1 namespace only accessible from the deployment $TIER2 in $TIER2.

Deployment 1: $TIER1
TIER 1: $TIER1
Deployment 2: $TIER2
TIER 2: $TIER2
Deployment 3: $TIER3
TIER 3: $TIER3

EOF
cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
