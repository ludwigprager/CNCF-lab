#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

cat << EOT | kubectl apply -f -

apiVersion: v1
kind: ConfigMap
metadata:
  name: $TIER1
data:
  nginx.conf: |-
    listen       $PORT1;
EOT

IP=$( kubectl get po -n $NAMESPACE ${TIER1}-0 -o jsonpath='{.status.podIP}' )
kubectl exec -ti ${TIER3}-0 -n $NAMESPACE -- curl --fail -s --connect-timeout 1 -o /dev/null http://$IP:$PORT1
status=$?
if [ $status -ne 0 ]; then
  error=true
  echo "$TIER3 can't reach pod in $TIER1"
fi

IP=$( kubectl get po -n $NAMESPACE ${TIER2}-0 -o jsonpath='{.status.podIP}' )
kubectl exec -ti ${TIER3}-0 -n $NAMESPACE -- curl --fail -s --connect-timeout 1 -o /dev/null http://$IP:$PORT2
status=$?
if [ $status -ne 0 ]; then
  error=true
  echo "$TIER3 can't reach pod in $TIER2"
fi

IP=$( kubectl get po -n $NAMESPACE ${TIER4}-0 -o jsonpath='{.status.podIP}' )
kubectl exec -ti ${TIER3}-0 -n $NAMESPACE -- curl --fail -s --connect-timeout 1 -o /dev/null http://$IP:$PORT4
status=$?
if [ $status -eq 0 ]; then
  error=true
  echo "$TIER3 can still reach $TIER4:$PORT4"
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

cat << EOT | kubectl apply -f -

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: $POLICY
  namespace: $NAMESPACE
spec:

  podSelector:
    matchLabels:
      app: $TIER3

  egress:

  - to:
    - podSelector:
        matchLabels:
          app: $TIER1
    ports:
    - protocol: TCP
      port: $PORT1

  - to:
    - podSelector:
        matchLabels:
          app: $TIER2
    ports:
    - protocol: TCP
      port: $PORT2

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi


