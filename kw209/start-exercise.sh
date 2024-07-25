#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source ../set-env.sh
source ../functions.sh

../10-prepare.sh
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT
source ../.env

# cordon all nodes except master
nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )
for node in $nodes; do
  test $node != cka-$(whoami)-control-plane && kubectl cordon $node
done

echo "Preparing the environment ..."

cat << EOF > task.txt

Q9 Create a pod named '$POD' with the '$IMAGE' image. The pod should run a sleep command for $SLEEP seconds. Verify that the pod is running in node $NODE

Pod: $POD
Image: $IMAGE
Sleep: $SLEEP
Node: $NODE
EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
