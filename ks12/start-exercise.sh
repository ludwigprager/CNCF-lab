#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT
$CKA_BASEDIR/10-prepare.sh
source $CKA_BASEDIR/.env

echo "Preparing the environment ..."
#envsubst < service.yaml.tpl | kubectl apply -f -
kubectl create ns project-tiger

cat << EOF > task.txt

Q Use namespace $ NAMESPACE. Create a deployment $DEPLOYMENT with label $KEY=$VALUE and $REPLICAS replicas and image $IMAGE.
Limit this deployment's number of pod per node to a single instance, i.e. simulate the behaviour of a daemonset.

(from: killer.sh CKA Question 12 https://www.youtube.com/watch?v=yfZkhs68Sz4 )

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
