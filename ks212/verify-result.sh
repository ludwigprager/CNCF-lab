#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

running=$( kubectl get po -n project-tiger -l id=very-important --field-selector=status.phase==Running --no-headers | wc -l )
pending=$( kubectl get po -n project-tiger -l id=very-important --field-selector=status.phase==Pending --no-headers | wc -l )

if [ $pending -ne 1 ]; then
  echo "number of pending pods should be 1 but is $pending"
  error=true
fi

if [ $running -ne 2 ]; then
  echo "number of running pods should be 2 but is $running"
  error=true
fi



if [ "$error" = true ] ; then

cat << EOF
# FAILED

# suggested solution:

cat << EOT | kubectl apply -f -

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
#   app: $DEPLOYMENT
  name: $DEPLOYMENT
  namespace: $NAMESPACE
spec:
  replicas: $REPLICAS
  selector:
    matchLabels:
#     app: $DEPLOYMENT
      $KEY: $VALUE
# strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
#       app: $DEPLOYMENT
        $KEY: $VALUE
    spec:
      containers:
      - image: nginx:1.17.6-alpine
        name: nginx
        resources: {}
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: $KEY
                operator: In
                values:
                - $VALUE
            topologyKey: "kubernetes.io/hostname"



EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi
