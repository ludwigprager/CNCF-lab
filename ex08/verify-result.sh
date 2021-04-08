#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh
source $DIR/../functions.sh

error=false


kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never --labels=access=granted -- "nc -v -w2 -z ${SERVICE} 80" >/dev/null 2>&1
if [ $? -eq 1 ]
then
  error=true
  echo "pods are blocked that should be allowed"
fi

kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never                         -- "nc -v -w2 -z ${SERVICE} 80" >/dev/null 2>&1
if [ $? -eq 0 ]
then
  error=true
  echo "pods are allowed that should be blocked"
fi



set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED

suggested solution:


kubectl -n$NS create deployment nginx --image=nginx:1.16 --replicas=2
kubectl -n$NS expose deployment nginx --port=80 --name=$SERVICE


cat << EOF | kubectl -n$NS create -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: netpol-ex08
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: granted
    ports:
    - protocol: TCP
      port: 80
EOF
EOS


else
  echo PASSED
  print-elapsed-time $DIR
fi

