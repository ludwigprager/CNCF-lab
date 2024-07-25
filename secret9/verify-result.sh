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

#kubectl cp -n $NAMESPACE $POD:$MOUNTPATH/ssh-privatekey $TASK.id_rsa
kubectl exec -ti -n secret-ops consumer -- cat $MOUNTPATH/ssh-privatekey > $TASK.id_rsa
diff --strip-trailing-cr $TASK.id_rsa  id_rsa
#diff $TASK.id_rsa id_rsa > /dev/null

if [[ $? -ne 0 ]] ; then
  error=true
  echo "secret doesn't match"
fi

#key=$( kubectl get secret $SECRET -n $NAMESPACE -o jsonpath='{.data.ssh-privatekey}' )
#
#if [[ -z $key  ]]; then
#  error=true
#  echo " key not found"
#fi

#printf $key  | base64 -d > $TASK.key


#diff $TASK.key id_rsa > /dev/null
#if [[ $? != 0 ]]; then


#diff $TASK.key id_rsa > /dev/null


#if [[ $? -ne 0 ]] ; then
#  error=true
#  echo " wrong key found"
#fi


#ssh-keygen -q -t rsa -N '' -f ./id_rsa <<<y

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

cat << EOT | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: $POD
  name: $POD
  namespace: $NAMESPACE
spec:
  volumes:
  - name: v1
    secret:
      secretName: my-secret
  containers:
  - image: nginx
    name: $POD
    volumeMounts:
    - name: v1
      mountPath: $MOUNTPATH
      readOnly: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

