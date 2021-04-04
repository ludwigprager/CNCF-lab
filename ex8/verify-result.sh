#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=




expected_reply=$(<expected-reply.txt)


# test pod with    label -> should be allowed
reply=$( kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never --labels=access=granted -- wget -O- http://nginx:80 --timeout 2 )
if [[  "$expected_reply" =~ *"$reply"* ]]; then
  error=true
  echo "the netpol blocks a pod that should be allowed"
echo reply: $reply
fi

# test pod without label -> should be blocked
reply=$( kubectl -n$NS run busybox --image=busybox --rm -it --restart=Never -- wget -O- http://nginx:80 --timeout 2 2>/dev/null)
if [[  "$expected_reply" =~ *"$reply"* ]]; then
  error=true
  echo "the netpol allows a pod that should be blocked"
fi

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:


kubectl -n$NS create deployment nginx --image=nginx:1.16 --replicas=2
kubectl -n$NS expose deployment nginx --port=80


cat << EOS | kubectl -n$NS create -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: netpol-ex8
spec:
  podSelector:
    matchLabels:
      app: nginx
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: granted
EOS


else
    echo PASSED
fi

