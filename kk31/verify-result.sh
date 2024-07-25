#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

error=true

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl create sa $SA
kubectl create clusterrole $CR --resource=persistentvolumes --verb=list
kubectl create clusterrolebinding $CRB --serviceaccount=default:$SA --clusterrole=$CR

# kubectl create pod $POD --dry-run=client -o yaml > pod.yaml
# kubectl run $POD --dry-run=client -o yaml --image=$IMAGE > pod.yaml

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: $POD
  name: $POD
spec:
  containers:
  - image: $IMAGE
    name: $POD
    resources: {}
    volumeMounts:
    - name: $TASK
      mountPath: /bla
  volumes:
  - name: $TASK
    persistentVolumeClaim: 
      claimName: $TASK
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  serviceAccountName: $SA
status: {}
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

