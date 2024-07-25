#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
error=true


if [ "$error" = true ] ; then

cat << EOF
# FAILED

# suggested solution:

# Step 1:

cat << EOT | kubectl apply -f -

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: $POD1
spec:
  containers:
  - image: $IMAGE1
    name: $POD1
    resources: {}

    livenessProbe:
      exec:
        command:
        - "true"

    readinessProbe:
      exec:
        command:
        - wget
        - -T2
        - -O-
        - http://$SERVICE:$PORT
EOT

# Step 2:

cat << EOT | kubectl apply -f -

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    $KEY: $VALUE
  name: $POD2
spec:
  containers:
  - image: $IMAGE2
    name: $POD2
    resources: {}

EOT

# alternatively:
# kubectl expose pod $IMAGE1 --port $PORT
EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

