#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > $FILE.verify
diff --strip-trailing-cr $FILE $FILE.verify || error=true

if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > $FILE

EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

