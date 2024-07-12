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
  rm $CKA_BASEDIR/kubectl
}
trap finish INT TERM EXIT
rm -f ../kubectl
bash ../10-prepare.sh 1.27.2 1.26.0 kind.config.kw11
source ../.env

echo "Preparing the environment ..."

nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )

for node in $nodes; do
  docker cp prepare.sh $node:/prepare.sh
  docker exec -ti $node bash -c '/prepare.sh'
done

clear


cat << EOF > task.txt

Q1 Given a cluster running version 1.26.0, upgrade the master node and worker node to version 1.27.0. e sure to drain the master and worker node efore upgrading it and uncordon it after the upgrade.

Hint: use the following command for a shell in control-plane and worker nodes:
docker exec -ti cka-$(whoami)-control-plane bash
docker exec -ti cka-$(whoami)-worker        bash
docker exec -ti cka-$(whoami)-worker1       bash
docker exec -ti cka-$(whoami)-worker2       bash

You can review these text at any time in the file task.txt

EOF

cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
