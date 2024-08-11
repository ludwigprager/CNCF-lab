#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )

if [[ "$node" != "$NODE" ]]; then
  error=true
  echo "pod doesn't run on $NODE"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubeadm  token create --print-join-command

kubeadm join cncf-$(whoami)-control-plane:6443 --token XXXXXXXXXXXXXXXXXXXXXXX --discovery-token-ca-cert-hash sha256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX --ignore-preflight-errors=all


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

