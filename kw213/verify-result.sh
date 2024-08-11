#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )

if [[ "$node" != "cncf-$(whoami)-control-plane" ]]; then
  error=true
  echo "pod doesn't run on controlplane"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:



kubectl apply -f - << EOT
apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-job
spec:
  schedule: "*/2 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            command:
            - /bin/sh
            - -c
            - date
          restartPolicy: OnFailure

EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

