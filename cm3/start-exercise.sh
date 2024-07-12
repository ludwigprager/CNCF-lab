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

Q3: Create and display a configmap $CONFIGMAP1 from a file, giving the key '$KEY'
Q3: Create and display a configmap $CONFIGMAP2 from a file

Create the file with
echo -e "$KEY1=$VALUE1\n$KEY2=$VALUE2" > $FILENAME

my extension:
mount the cm $CONFIGMAP1 in a pod $POD1 in path $MOUNTPATH on path '$MOUNTPATH'.
mount the cm $CONFIGMAP2 in a pod $POD2 in path $MOUNTPATH on path '$MOUNTPATH'.

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
