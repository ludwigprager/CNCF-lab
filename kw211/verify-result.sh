#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false


POD1=$( kubectl get po -l tier=$TIER1 -n $TIER1 -o jsonpath='{.items[0].metadata.name}' )
POD2=$( kubectl get po -l tier=$TIER2 -n $TIER2 -o jsonpath='{.items[0].metadata.name}' )
POD3=$( kubectl get po -l tier=$TIER3 -n $TIER3 -o jsonpath='{.items[0].metadata.name}' )

# status == 0: curl successful
# status != 0: curl failed

kubectl exec -ti $POD2 -n $TIER2 -- curl --fail -s --connect-timeout 1 -o /dev/null http://$TIER1.$TIER1
status=$?
if [ $status -ne 0 ]; then
  error=true
  echo "$TIER2 can't reach pod in $TIER1"
fi

kubectl exec -ti $POD3 -n $TIER3 -- curl --fail -s --connect-timeout 1 -o /dev/null http://$TIER1.$TIER1
status=$?
if [ $status -eq 0 ]; then
  error=true
  echo "$TIER3 can still reach pod in $TIER1"
fi

IP1=$( kubectl get po -l tier=$TIER1 -n $TIER1 -o jsonpath='{.items[0].status.podIP}' )
kubectl exec -ti $POD3 -n $TIER3 -- curl --fail -s --connect-timeout 1 -o /dev/null http://$IP1
status=$?
if [ $status -eq 0 ]; then
  error=true
  echo "$TIER3 can still reach pod in $TIER1 via IP $IP1"
fi


if [ "$error" = true ] ; then

cat << EOF

# FAILED
# suggested solution:

kubectl apply -f - << EOT
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: kw211
  namespace: $TIER1
spec:
  podSelector:
    matchLabels:
      tier: $TIER1
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          tier: $TIER2
    - podSelector:
        matchLabels:
          tier: $TIER2
    ports:
    - protocol: TCP
      port: 80

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

