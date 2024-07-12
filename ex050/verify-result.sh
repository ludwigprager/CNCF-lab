#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
error=true



if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:



EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

