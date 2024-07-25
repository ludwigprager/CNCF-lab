#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

pod2=$( kubectl get po -l app=$DEPLOYMENT2 -o jsonpath='{.items[0].metadata.name}' )

kubectl exec -ti $pod2 -- sh -c "curl --fail -s --connect-timeout 2 $DEPLOYMENT3:$PORT3  > /dev/null"
if [[ $? -ne 0 ]]; then
  echo $DEPLOYMENT3 could not be reached from $DEPLOYMENT2
  error=true
fi


pod1=$( kubectl get po -l app=$DEPLOYMENT1 -o jsonpath='{.items[0].metadata.name}' )

kubectl exec -ti $pod1 -- sh -c "curl --fail -s --connect-timeout 2 $DEPLOYMENT3:$PORT3  > /dev/null"
if [[ $? -eq 0 ]]; then
  echo $DEPLOYMENT3 must not be reached from $DEPLOYMENT1
  error=true
fi


pod3=$( kubectl get po -l app=$DEPLOYMENT3 -o jsonpath='{.items[0].metadata.name}' )

kubectl exec -ti $pod3 -- sh -c "curl --fail -s --connect-timeout 2 $DEPLOYMENT3:$PORT3  > /dev/null"
if [[ $? -ne 0 ]]; then
  echo $DEPLOYMENT3 must not be reached from $DEPLOYMENT3 via DNS
  error=true
fi




if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:


cat << EOT | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: kw210
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: $DEPLOYMENT3
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: $DEPLOYMENT2
    ports:
    - protocol: TCP
      port: $NGINX_PORT
EOT

Note: the allowed ports refer to the container, i.e. to the 'target-port' of the service not the service port.


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi
