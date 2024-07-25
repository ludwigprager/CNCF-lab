#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh
error=false

kubectl get secret my-secret -n secret-ops -o jsonpath='{$.data.ssh-privatekey}'  | base64 -d > $TASK.id_rsa

diff --strip-trailing-cr $TASK.id_rsa  id_rsa


if [[ $? -ne 0 ]] ; then
  error=true
  echo "secret doesn't match"
fi

if [ "$error" = true ] ; then

cat << EOF

# FAILED
# proposed solution: 

kubectl create secret generic $SECRET -n $NAMESPACE --type="kubernetes.io/ssh-auth" --from-file=ssh-privatekey=id_rsa

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

