#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=


value=$( kubectl exec -ti pod2 -- sh -c "printf \$ADMIN" )

if [[ $value != $VALUE ]]; then
  error=true
  echo "env variable $VARIABLE wrong or not found"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl create  secret generic $SECRET --from-literal $KEY=USER


kubectl apply -f - << EOT
apiVersion: v1
kind: Pod
metadata:
  name: $POD
spec:
  containers:
  - image: nginx
    name: $POD
    env:
      - name: $VARIABLE
        valueFrom:
          secretKeyRef:
            name: $KEY
            key: $VALUE
EOT


EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

