#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


#value=$( kubectl exec $POD -- /bin/sh -c "cat $MOUNTPATH" )
value=$( kubectl exec $POD -- cat $MOUNTPATH/$KEY )
if [[ $value != $VALUE ]]; then
  error=true
  echo "secret wrong or not found"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

echo username > admin
kubectl create secret generic $SECRET --from-file admin

kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  name: $POD
spec:
  volumes:
    - name: secret-volume
      secret:
        secretName: $SECRET
  containers:
  - image: nginx
    name: $POD
    volumeMounts:
      - name: secret-volume
        mountPath: "$MOUNTPATH"
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

