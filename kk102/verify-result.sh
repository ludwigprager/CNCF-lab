#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test pod exists
name=$(kubectl get pod ${NAME} -o jsonpath='{$.spec.containers[0].name}')
if [[ $name != "${NAME}" ]]; then
  error=true
  echo "pod ${NAME} was not found"
fi

# test label
label=$(kubectl get pod ${NAME} -o jsonpath="{$.metadata.labels.${KEY}}")

if [[ $label != "${VALUE}" ]]; then
  error=true
  echo "the label was not correct"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl run ${NAME} --image=${IMAGE} -l ${KEY}=${VALUE}

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

