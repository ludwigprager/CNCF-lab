#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS --grace-period=0 > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

cat << EOF

Create a cronjob called 'rand' that runs single-container pods with image '$IMAGE'.

- Set the environment variables
  - MODE=$MODE
  - FAILURE_RATE=$FAILURE_RATE
  which will make the job fail in ${FAILURE_RATE}% of all incarnations or run to completion otherwise.

- Start the cronjob every $INTERVAL minutes.

- The cronjob shall run no more than $PARALLELISM job instances at a time.

- Once a job succeeds no more jobs shall be started.

- When no job ran to success after $BACKOFFLIMIT tries the cronjob run shall be marked as failed, too.

- If a job does not complete after $TIMEOUT seconds it shall be terminated and considered as failed.

Use namespace '${NS}'.

Call the script '$DIR/verify-result.sh' when done

EOF

