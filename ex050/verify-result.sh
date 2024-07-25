#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

mountpath=$( kubectl get sts online -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].mountPath}' )

if [[ "$mountpath" != $MOUNTPATH ]]; then
  error=true
  echo "mountpath is wrong"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

run 'kubectl edit stst online' and set mountpath

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

