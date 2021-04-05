#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=

# test container image
image=$(kubectl get cronjob -n$NS rand -o jsonpath="{$.spec.jobTemplate.spec.template.spec.containers[?(.name=='rand')].image}" 2>/dev/null)
if [[ $image != $IMAGE ]]; then
  error=true
  echo "the container image is wrong"
# echo "image found: $image"
fi

# test parallelism
parallelism=$(kubectl get cronjob -n$NS rand -o jsonpath="{$.spec.jobTemplate.spec.parallelism}" 2>/dev/null)
if [[ $parallelism != $PARALLELISM ]]; then
  error=true
  echo "parallelism is missing or wrong"
fi

# test backoffLimit
backofflimit=$(kubectl get cronjob -n$NS rand -o jsonpath="{$.spec.jobTemplate.spec.backoffLimit}" 2>/dev/null)
if [[ $backofflimit != $BACKOFFLIMIT ]]; then
  error=true
  echo "backoffLimit is missing or wrong"
fi

# test activeDeadlineSeconds
activedeadlineseconds=$(kubectl get cronjob -n$NS rand -o jsonpath="{$.spec.jobTemplate.spec.activeDeadlineSeconds}" 2>/dev/null)
if [[ $activedeadlineseconds != $TIMEOUT ]]; then
  error=true
  echo "activeDeadlineSeconds is missing or wrong"
fi


set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message




suggested solution:

1.
kubectl -n$NS create cronjob rand \
  --schedule='*/$INTERVAL * * * *' \
  --image=$IMAGE \
  --dry-run=client -o yaml > rand.yaml

2. set the cronjob properties:

      parallelism: $PARALLELISM
      backoffLimit: $BACKOFFLIMIT
      activeDeadlineSeconds: $TIMEOUT
      completions: 1

3. add the job template section:

        spec:
          containers:
          - image: $IMAGE
            name: rand
            resources: {}
            env:
            - name: MODE
              value: $MODE
            - name: FAILURE_RATE
              value: "$FAILURE_RATE"
          restartPolicy: Never

4. create the cronjob:
kubectl -n$NS create -f rand.yaml

Alternatively, use this command:

cat <<EOF | kubectl -n$NS create -f -
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  creationTimestamp: null
  name: rand
spec:
  schedule: '*/$INTERVAL * * * *'
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: rand
    spec:

      parallelism: $PARALLELISM
      backoffLimit: $BACKOFFLIMIT
      activeDeadlineSeconds: $TIMEOUT
      completions: 1

      template:
        metadata:
          creationTimestamp: null

        spec:
          containers:
          - image: $IMAGE
            name: rand
            resources: {}
            env:
            - name: MODE
              value: $MODE
            - name: FAILURE_RATE
              value: "$FAILURE_RATE"
          restartPolicy: Never
EOF


EOS

else
    echo PASSED
fi


