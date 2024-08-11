#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

#node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )
#
#if [[ "$node" != "cncf-$(whoami)-control-plane" ]]; then
#  error=true
#  echo "pod doesn't run on controlplane"
#fi

#status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)

phase=$( kubectl get po -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].status.phase}' )
if [[ "$phase" != "Running" ]]; then
  echo "pod is not running"
  error=true
fi

# get volume name that uses pvc
name=$( kubectl get po -n production \
  -l app=web-deploy \
  -o jsonpath="{.items[0].spec.volumes[?(.persistentVolumeClaim.claimName==\"$PERSISTENTVOLUMECLAIM\")].name}" )

if [[ -z $name ]]; then
  echo "$PERSISTENTVOLUMECLAIM not found in pod"
  error=true
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

copy from https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/

kubectl apply -f - << EOT

apiVersion: v1
kind: PersistentVolume
metadata:
  name: $PERSISTENTVOLUME
spec:
  capacity:
    storage: $CAPACITY
  volumeMode: Filesystem
  accessModes:
    - $ACCESSMODE
  hostPath:
    path: $HOSTPATH

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $PERSISTENTVOLUMECLAIM
  namespace: $NAMESPACE
spec:
  accessModes:
    - $ACCESSMODE
  resources:
    requests:
      storage: $CAPACITY

---

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: $DEPLOYMENT
  name: $DEPLOYMENT
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $DEPLOYMENT
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: $DEPLOYMENT
    spec:
      volumes:
      - name: v1
        persistentVolumeClaim:
          claimName: $PERSISTENTVOLUMECLAIM
      containers:
      - image: $IMAGE
        name: nginx
        resources: {}
        volumeMounts:
        - name: v1
          mountPath: $MOUNTPATH

EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

