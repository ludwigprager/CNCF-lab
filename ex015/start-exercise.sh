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
kubectl create ns $NAMESPACE
kubectl run nginx -n $NAMESPACE --image=nginx

cat << EOF > task.txt

Q015  Create a new user $USER and grant him access to the cluster. He should have perm to create, list, get, update, delete pods in $NAMESPACE namespace
Store the user's private key in a file $USER.key and the signed certificate in a file $USER.crt

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
