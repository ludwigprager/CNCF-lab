#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

#node=$( kubectl get pod -l app=$DEPLOYMENT -o jsonpath='{.items[0].spec.nodeName}' )
#if [[ "$node" == "$NODE" ]]; then
#  error=true
#  message="pod with label app=$DEPLOYMENT still running on $NODE"
#fi

  error=true



if [ "$error" = true ] ; then

cat << EOF

# FAILED
# suggested solution:

cat << EOT | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemon-imp
  namespace: project-1
  labels:
    $KEY1: $VALUE1
    $KEY2: $VALUE2
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 20m
            memory: 20Mi
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi


