#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
source ../set-env.sh
source ../functions.sh

../10-prepare.sh
source ../.env

kubectl apply -f deployment.yaml

function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT

echo "Preparing the environment ..."

#kubectl create deployment ${POD} --image=nginx

cat << EOF > task.txt

Q12 you can find a pod named $POD is running in the cluster and that is logging to a volume. You need to insert a sidecar container into the pod that will also read the logs from the volume using this command $COMMAND. 

Pod: $POD
Command: $COMMAND
Image: $IMAGE
Volumepath: $VOLUMEPATH

EOF
cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
