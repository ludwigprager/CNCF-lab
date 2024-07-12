#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false


value1=$( kubectl exec -ti $POD -- bash -c "printf \$$KEY1" )
if [[ $value1 != $VALUE1 ]]; then
  error=true
  echo "value for $KEY1 could not be resolved in $POD"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

kubectl create cm $CONFIGMAP --from-literal=$KEY1=$VALUE1 --from-literal=$KEY2=$VALUE2


kubectl apply -f - << EOT

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD
  name: $POD
spec:
  containers:
  - image: nginx
    name: $POD

    envFrom:
      - configMapRef: 
          name: $CONFIGMAP

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

