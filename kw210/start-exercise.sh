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
../10-prepare.sh 1.30.2 1.30.0 kind.config.cilium
source ../.env

echo "Preparing the environment ..."
../cilium install #--version 1.15.6

kubectl create deployment $DEPLOYMENT1 --image=$IMAGE #--port=$PORT1 
kubectl create deployment $DEPLOYMENT2 --image=$IMAGE #--port=$PORT2 
kubectl create deployment $DEPLOYMENT3 --image=$IMAGE #--port=$PORT3 

kubectl expose deployment $DEPLOYMENT1 --port $PORT1 --target-port $NGINX_PORT
kubectl expose deployment $DEPLOYMENT2 --port $PORT2 --target-port $NGINX_PORT
kubectl expose deployment $DEPLOYMENT3 --port $PORT3 --target-port $NGINX_PORT

../cilium status --wait
kubectl wait pods -l app=$DEPLOYMENT1 --for condition=Ready --timeout=90s
kubectl wait pods -l app=$DEPLOYMENT2 --for condition=Ready --timeout=90s
kubectl wait pods -l app=$DEPLOYMENT3 --for condition=Ready --timeout=90s

cat << EOF > task.txt

Q10 the cluster run a three-tier web application: a $DEPLOYMENT1 tier (port $PORT1), an $DEPLOYMENT2  tier (port $PORT2) and a $DEPLOYMENT3 tier ($PORT3). The security team has mandated that the backend tier should only be accessible from the application tier.

Deployment 1: $DEPLOYMENT1
Port 1: $PORT1
Deployment 2: $DEPLOYMENT2
Port 2: $PORT2
Deployment 3: $DEPLOYMENT3
Port 3: $PORT3

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
