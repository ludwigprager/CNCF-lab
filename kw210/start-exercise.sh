#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
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

cat << EOF

Q10 the cluster run a three-tier web application: a frontend tier (port 80), an application  tier (port 8080) and a backend tier (3306). The security team has mandated that the backend tier should only be accessible from the application tier.

Deployment 1: $DEPLOYMENT1
Port 1: $PORT1
Deployment 2: $DEPLOYMENT2
Port 2: $PORT2
Deployment 3: $DEPLOYMENT3
Port 3: $PORT3

EOF

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
