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
cat << EOF > task.txt

Q5: Create a configMap '$CONFIGMAP' with values '$KEY1=$VALUE1', '$KEY2=$VALUE2'. Load this configMap as env variables into a new nginx pod $POD

EOF
cat task.txt
clear
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
