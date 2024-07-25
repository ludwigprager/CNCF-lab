#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl expose pod messaging --name messaging-service --port 3297 --target-port 6379

hint: verify with
kubectl describe service messaging-service

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

