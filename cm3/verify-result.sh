#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false


value1=$( kubectl exec -ti pod41 -- bash -c "source $MOUNTPATH/$FILENAME ; printf \$$KEY1" )
if [[ $value1 != $VALUE1 ]]; then
  error=true
  echo "value for $KEY1 could not be resolved in $POD1"
fi


value1=$( kubectl exec -ti pod42 -- bash -c "source $MOUNTPATH/$KEY ; printf \$$KEY1" )
if [[ $value1 != $VALUE1 ]]; then
  error=true
  echo "value for $KEY1 could not be resolved in $POD2"
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

echo -e "$KEY1=$VALUE1\n$KEY2=$VALUE2" > $FILENAME
kubectl create cm $CONFIGMAP1 --from-file=$FILENAME
kubectl create cm $CONFIGMAP2 --from-file=$KEY=$FILENAME

kubectl apply -f - << EOT

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD1
  name: $POD1
spec:

  volumes: # add a volumes list
  - name: v1
    configMap:
      name: $CONFIGMAP1

  containers:
  - image: nginx
    name: cm4
    volumeMounts: # your volume mounts are listed here
    - name: v1
      mountPath: $MOUNTPATH

---

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD2
  name: $POD2
spec:

  volumes: # add a volumes list
  - name: v1
    configMap:
      name: $CONFIGMAP2

  containers:
  - image: nginx
    name: cm4
    volumeMounts: # your volume mounts are listed here
    - name: v1
      mountPath: $MOUNTPATH



EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

