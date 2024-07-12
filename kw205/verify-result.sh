#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# spec:
#   maxReplicas: 5
#   metrics:
#   - resource:
#       name: cpu
#       target:
#         averageUtilization: 80
#         type: Utilization
#     type: Resource
#   minReplicas: 3


min=$( kubectl -n production get horizontalpodautoscalers.autoscaling -o jsonpath='{.items[0].spec.minReplicas}' )
max=$( kubectl -n production get horizontalpodautoscalers.autoscaling -o jsonpath='{.items[0].spec.maxReplicas}' )
cpu=$( kubectl -n production get horizontalpodautoscalers.autoscaling -o \
  jsonpath='{.items[0].spec.metrics[0].resource.target.averageUtilization}' )

if [[ "$min" != $MIN ]]; then
  error=true
  echo "min doesn't match"
fi

if [[ "$max" != $MAX ]]; then
  error=true
  echo "max doesn't match"
fi

if [[ "$cpu" != $CPU ]]; then
  error=true
  echo "cpu doesn't match"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl -n $NAMESPACE autoscale deployment $DEPLOYMENT  --min $MIN --max $MAX --cpu-percent $CPU




EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

