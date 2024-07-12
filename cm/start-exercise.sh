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

Q1: Create and display a configmap from a file with 'KEY1=VALUE1' and 'KEY2=VALUE2'
Q2: Create and display a configmap from a .env file with 'KEY1=VALUE1' and 'KEY2=VALUE2'
Q3: Create and display a configmap from a file, giving the key 'special'
Q4: Create a configMap called 'options' with the value var5=val5. Create a new nginx pod that loads the value from variable 'var5' in an env variable called 'option'
Q5: Create a configMap 'anotherone' with values 'var6=val6', 'var7=val7'. Load this configMap as env variables into a new nginx pod
Q6: Create a configMap 'cmvolume' with values 'var8=val8', 'var9=val9'. Load this as a volume inside an nginx pod on path '/etc/lala'. Create the pod and 'ls' into the '/etc/lala' directory.

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
