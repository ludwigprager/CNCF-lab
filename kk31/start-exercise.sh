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

echo "Preparing the environment ..."

envsubst < pv.yaml.tpl | kubectl apply -f -

#kubectl create deployment ${POD} --image=nginx
#kubectl apply -f pv.yaml

cat << EOF > task.txt

Q1 Create a new service account '$SA'. Grant this sa access to list all PVs in the cluster by creating an appropriate CR '$CR' and CRB called '$CRB'. Then, create a pod '$POD' with image '$IMAGE' and SA '$SA' in the default namespace.

StorageAccount: $SA
ClusterRole: $CR
ClusterRoleBinding: $CRB
Pod: $POD
Image: $IMAGE

Pod configured to use sa $SA

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
