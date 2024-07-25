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
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT



cat << EOF > task.txt

Q2/Q4:
- Create a secret called mysecret2 that gets key/value from a file
- Create an nginx pod that mounts the secret $SECRET in a volume on path $MOUNTPATH

Secret: $SECRET
Key: $KEY
Value: $VALUE
Pod: $POD
Path: $MOUNTPATH

(from: https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets )


EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
