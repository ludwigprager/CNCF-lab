#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

error=true

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

# https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD
  name: $POD
spec:
  containers:
  - image: redis:alpine
    name: $POD
    resources:
      limits:
        memory: "$MEMORY"
        cpu: "$CPU"

EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

