#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

#kubectl exec -ti $TESTPOD -- sh -c "curl --fail -s --connect-timeout 2 $SERVICE:$PORT > /dev/null"
kubectl exec -ti curler -- curl --fail -s --connect-timeout 1  $IMAGE1 > result

if [[ $? -ne 0 ]]; then
  echo pod could not be reached on port $PORT
  error=true
fi

curl -L -s --fail http://neverssl.com/online > result.verify

diff --strip-trailing-cr result result.verify > /dev/null  || error=true
if [[ $? -ne 0 ]] ; then
  error=true
  echo "website doesn't match http://neverssl.com/online"
fi







if [ "$error" = true ] ; then

cat << EOF
# FAILED

# suggested solution:

cat << EOT | kubectl apply -f -

apiVersion: v1
kind: Pod
metadata:
# creationTimestamp: null
  labels:
    run: $IMAGE1
  name: $IMAGE1
spec:

  volumes:
  - name: v1
    emptyDir: {}

  containers:
  - image: $IMAGE1
    name: $IMAGE1
    ports:
    - containerPort: $PORT
    resources: {}
    volumeMounts:
    - name: v1
      mountPath: $PATH1

  initContainers:
  - name: init-myservice
    image: $IMAGE2
    command:
      - wget
      - -O
      - /work-dir/index.html
      - http://neverssl.com/online
    volumeMounts:
    - name: v1
      mountPath: $PATH2

---

apiVersion: v1
kind: Service
metadata:
  labels:
    run: nginx
  name: nginx
  namespace: default
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: nginx
  type: ClusterIP

EOT

# alternatively:
# kubectl expose pod $IMAGE1 --port $PORT
EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi


