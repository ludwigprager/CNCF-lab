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

kubectl create deployment ${DEPLOYMENT} --image=nginx

cat << EOF > task.txt

Q109: Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster.
The web application listens on port 8080.

Name: ${SERVICE}
Type: ${TYPE}
Endpoints: ${ENDPOINTS}
Port: ${PORT}
Nodeport: ${NODEPORT}


EOF
clear
cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
