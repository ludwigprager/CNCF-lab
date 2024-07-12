#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

kubectl exec -ti $TESTPOD -n $NAMESPACE -- sh -c "curl --fail -s --connect-timeout 1 $POD > /dev/null"
if [[ $? -ne 0 ]]; then
  echo $POD could not be reached from inside $NAMESPACE
  error=true
fi

kubectl exec -ti $TESTPOD -- sh -c "curl --fail -s --connect-timeout 1 $POD.$NAMESPACE > /dev/null"
if [[ $? -eq 0 ]]; then
  echo $POD could be reached from outside $NAMESPACE
  error=true
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

kubectl apply -f - << EOT

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow
  namespace: $NAMESPACE
spec:

  ingress:

  - ports:
      - protocol: TCP
        port: $PORT

  egress:

  - ports:
    - protocol: TCP
      port: $PORT
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53

EOT

# Hint: kubectl describe netpol $TASK -n $NAMESPACE

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi
