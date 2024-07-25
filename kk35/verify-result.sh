#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

#error=true
kubectl exec -ti $TESTPOD -- sh -c "curl --fail -s --connect-timeout 2 np-test-1 > /dev/null"
if [[ $? -ne 0 ]]; then
  echo $SERVICE could not be reached
  error=true
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:


kubectl apply -f - << EOT

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: kk35
spec:
  podSelector:
    matchLabels:
      app: np-test-1
  policyTypes:
  - Ingress
  ingress:
    - from:
      ports:
        - protocol: TCP
          port: 80

EOT

Note: Network Policies are additive, so you can have multiple policies targeting a particular Pod. The sum of the “allow” rules from all the policies will apply. Traffic from or to sources that don’t match any of the “allow” rules will be blocked if the target Pod is also covered by a “deny” policy.


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

