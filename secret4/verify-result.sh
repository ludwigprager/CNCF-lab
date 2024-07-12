#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


#k get secret -n secops -o jsonpath='{.items[*].data.ssh-privatekey}' | base64 -d

key=$( kubectl get secret $SECRET -n $NAMESPACE -o jsonpath='{.data.ssh-privatekey}' )

if [[ -z $key  ]]; then
  error=true
  echo " key not found"
fi

printf $key  | base64 -d > $TASK.key


#diff $TASK.key id_rsa > /dev/null
#if [[ $? != 0 ]]; then


diff $TASK.key id_rsa > /dev/null


if [[ $? -ne 0 ]] ; then
  error=true
  echo " wrong key found"
fi


#ssh-keygen -q -t rsa -N '' -f ./id_rsa <<<y

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:



kubectl create secret generic $SECRET -n $NAMESPACE --type="kubernetes.io/ssh-auth" --from-file=ssh-privatekey=./id_rsa


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

