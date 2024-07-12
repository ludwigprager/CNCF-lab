#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test tain exists
name=$(kubectl get pod nginx-pod -o jsonpath='{$.spec.containers[0].name}')
if [[ $name != 'nginx-pod' ]]; then
  error=true
  echo "pod nginx-pod was not found"
fi

# test container image
image=$(kubectl get pod nginx-pod -o jsonpath='{$.spec.containers[0].image}')

if [[ $image != 'nginx:alpine' ]]; then
  error=true
  echo "the image was not correct"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl run nginx-alpine --image=nginx:alpine

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

