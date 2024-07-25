#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


value=$( kubectl get secret $SECRET -o jsonpath="{.data.$KEY}" | base64 -d )

if [[ $value != $VALUE ]]; then
  error=true
  echo "secret wrong or not found"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl create secret generic $SECRET --from-iteral=$KEY=$VALUE


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

