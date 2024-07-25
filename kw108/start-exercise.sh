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

envsubst < namespace.yaml.tpl | kubectl apply -f -

#kubectl create deployment $DEPLOYMENT --image=$IMAGE 
#nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )

#for node in $nodes; do
#  test "$node" != "$NODE" && kubectl drain $node --ignore-daemonsets
#done
#for node in $nodes; do
#  test "$node" != "$NODE" && kubectl uncordon $node
#done



cat << EOF > task.txt

Q.8 Use namespace $NAMESPACE for the following. Create a daemonset named $DAEMONSET with image $IMAGE and labels $KEY1=$VALUE1 and $KEY2=$VALUE2. The pods it creates should request $CPU millicore cpu and $MEMORY mebibyte memory. The pods of that daemonset should run on all nodes, also controlplanes.

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
