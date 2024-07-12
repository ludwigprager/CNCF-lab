#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test result file exists

if [[ ! -f ex${ex}.txt ]]; then
  error=true
  echo "result file ex${ex}.txt does not exist"
fi


# generate result and compare to answer
kubectl get pod -A -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\n"}' | sort > .my-result.txt
cat ex${ex}.txt | sort > .his-result.txt
if ! cmp --silent -- .my-result.txt .his-result.txt; then
  error=true
  echo "the result is not correct. Here is the diff between your result and the solution:"
  diff .my-result.txt .his-result.txt
fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl get pod -A -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\n"}' > ex${ex}.txt


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

