#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


#value1=$( kubectl exec -ti $POD -- /bin/sh -c "cat /secret" )
#if [[ $password != $PASSWORD]]; then
#  error=true
#  echo "password wrong or not found"
#fi

error=true


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

# kubectl create secret generic $SECRET --from-iteral=password=$PASSWORD


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

