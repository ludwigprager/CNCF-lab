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

kubectl drain $NODE --ignore-daemonsets # --delete-local-data
kubectl delete node  $NODE

cat << EOF > task.txt

Q3  Join $NODE worker node to the cluster and you hav to deploy a pod in the $NODE, pod name should be $POD and image should be $IMAGE

Hint: use the following command for a shell in control-plane and worker nodes:
docker exec -ti cncf-$(whoami)-control-plane bash

You can review this task at any time in the file task.txt
EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
