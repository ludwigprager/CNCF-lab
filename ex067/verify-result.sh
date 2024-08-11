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
taint=$(kubectl get nodes cncf-$(whoami)-worker  -o jsonpath="{.spec.taints[?(.key==\"$KEY\")]}")
if [[ -z $taint ]]; then
  error=true
  echo "the taint was not found"
fi

# test container image
value=$(kubectl get nodes cncf-$(whoami)-worker  -o jsonpath="{.spec.taints[?(.key==\"$KEY\")].value}")
effect=$(kubectl get nodes cncf-$(whoami)-worker  -o jsonpath="{.spec.taints[?(.key==\"$KEY\")].effect}")

if [[ $value != $VALUE ]]; then
  error=true
  echo "the taint value is not correct"
fi

if [[ $effect != 'NoSchedule' ]]; then
  error=true
  echo "the taint effect is not correct"
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl taint node cncf-$(whoami)-worker $KEY=$VALUE:NoSchedule

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

