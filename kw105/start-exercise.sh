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
bash ../10-prepare.sh
source ../.env

echo "Preparing the environment ..."

kubectl create deployment $DEPLOYMENT --image=$IMAGE 

nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )

for node in $nodes; do
  test "$node" != "$NODE" && kubectl drain $node --ignore-daemonsets
done
for node in $nodes; do
  test "$node" != "$NODE" && kubectl uncordon $node
done

clear


cat << EOF > task.txt

Q5 Mark the worker node cncf-$(whoami)-worker as unschedulable and reschedule all the pods running on it.

You can review this task at any time in the file task.txt
EOF

cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
