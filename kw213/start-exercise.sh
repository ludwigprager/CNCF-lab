#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
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

Q13 Create a cronjob for running every 2 minutes with $IMAGE image. The jo name should be $JOB and it should print the current date and time to the console. After running the job save any one of the pod logs to below path $LOGPATH.

Job: $JOB
Image: $IMAGE
Path: $LOGPATH

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
