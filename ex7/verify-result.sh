#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=



# test annotation
value=$(kubectl -n$NS get pod ui -o jsonpath="{$.metadata.annotations.owner}"  2>/dev/null )
if [[  "$value" != "peter" ]]; then
  error=true
  echo "pod 'ui' does not have an annotation 'owner=peter'"
fi

# test label
value=$(kubectl -n$NS get pod ui -o jsonpath="{$.metadata.labels.env}"  2>/dev/null )
if [[  "$value" != "test" ]]; then
  error=true
  echo "pod 'ui' does not have a label 'env=test'"
fi


value=$(kubectl -n$NS get pod -l tirr -o jsonpath="{$.items}" 2>/dev/null )
if [[  "$value" != '[]' ]]; then
  error=true
  echo "pod 'db' still has a label 'tirr' (or you added that label to another pod)"
fi

value=$(kubectl -n$NS get pod -l podname=dummy -o jsonpath="{$.items}" 2>/dev/null )
if [[  "$value" != '[]' ]]; then
  error=true
  echo "there is still a pod with label 'podname=dummy' :"
  kubectl -n$NS get pod -l podname=dummy --show-labels
fi

label1=$(kubectl -n$NS get pod ex7 -o jsonpath="{$.metadata.labels.tier}" 2>/dev/null )
label2=$(kubectl -n$NS get pod ex7 -o jsonpath="{$.metadata.labels.env}" 2>/dev/null )

if [[  "$label1" != 'front' ]]; then
  error=true
  echo "label 'tier=front' not found for pod 'ex7'"
fi
if [[  "$label2" != 'prod' ]]; then
  error=true
  echo "label 'env=prod' not found for pod 'ex7'"
fi

set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:

kubectl -n$NS annotate pod ui owner=peter --overwrite
kubectl -n$NS run ex7 --image=nginx --labels='tier=front,env=prod'
kubectl -n$NS label pod ui env=test --overwrite
kubectl -n$NS label pod db tirr-
kubectl -n$NS delete pod -l podname=dummy

EOS


else
    echo PASSED
fi

