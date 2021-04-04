#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=



# test container status
status=$(kubectl -n$NS get pod pod-ex6 -o=jsonpath="{$.status.containerStatuses[?(.name=='pod-ex6')].state.running}" 2>/dev/null )
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod pod-ex6 -o=jsonpath="{$.status.phase}" 2>/dev/null )
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

# test volume
#hostpath=$(kubectl -n$NS get pod pod-ex6 -o=jsonpath="{$.spec.volumes[?(@.name=='v1')].hostPath.path}" 2>/dev/null )
hostpath=$(kubectl -n$NS get pv pv-ex6 -o jsonpath="{$.spec.hostPath.path}" 2>/dev/null )

if [[ "$hostpath" != "$HOSTPATH" ]]; then
  error=true
  echo "the hostpath is not correct"
  echo "host path expected: $HOSTPATH"
  echo "host path found:    $hostpath"
fi

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:

cat <<EOF | kubectl -n$NS create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-ex6
spec:
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 2Gi
  hostPath:
    path: ${HOSTPATH}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-ex6
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
---
apiVersion: v1
kind: Pod
metadata:
  labels:
  name: redis
spec:
  containers:
  - image: redis
    name: redis
    volumeMounts:
      - mountPath: /var/log/ex6
        name: v1
  volumes:
    - name: v1
      persistentVolumeClaim:
        claimName: pvc-ex6
EOF
EOS


else
    echo PASSED
fi

