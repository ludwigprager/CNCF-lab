#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false

: '
expected=$(<expected-reply.txt)

# test pod with label -> should be allowed
reply=$( kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never --labels=access=granted -- "wget -O- -T 2 http://$SERVICE:80" )
echo "$reply" > reply

#if [[  "$expected" != *"$reply"* ]]; then
if grep -q "$expected" <<< "$reply"; then
  error=true
  echo "the netpol blocks a pod that should be allowed"
  echo reply: "$reply"
#  echo
#  echo
#  echo expected: "$expected"
#  echo
#  echo
fi


printf "error: %s" $error
exit

# test pod without label -> should be blocked
reply=$( kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never                         -- "wget -O- -T 2 http://$SERVICE:80" )
if [[  "$expected" == *"$reply"* ]]; then
  error=true
  echo "the netpol allows a pod that should be blocked"
fi
'

error=true
echo
echo
echo sorry: test is not working == not yet available

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED

suggested solution:


kubectl -n$NS create deployment nginx --image=nginx:1.16 --replicas=2
kubectl -n$NS expose deployment nginx --port=80 --name=$SERVICE


cat << EOS | kubectl -n$NS create -f -
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
EOS


else
    echo PASSED
fi

