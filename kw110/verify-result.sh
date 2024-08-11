#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh

error=false

reply=$( kubectl auth can-i create secrets --as=system:serviceaccount:${NAMESPACE}:$SERVICEACCOUNT -n $NAMESPACE )
echo $reply
if [[ "$reply" == "no" ]]; then
  echo $SERVICEACCOUNT can\'t create secrets
  error=true
fi

reply=$( kubectl auth can-i create configmaps --as=system:serviceaccount:${NAMESPACE}:$SERVICEACCOUNT -n $NAMESPACE )
if [[ "$reply" == "no" ]]; then
  echo $SERVICEACCOUNT can\'t create configmaps
  error=true
fi


if [ "$error" = true ] ; then

cat << EOF

# FAILED
# suggested solution:

kubectl create sa $SERVICEACCOUNT -n $NAMESPACE
#kubectl create role $ROLE -n $NAMESPACE --verb=create --resource=secrets,configmaps
#kubectl create rolebinding $ROLEBINDING -n $NAMESPACE --role=$ROLE --serviceaccount=${NAMESPACE}:$SERVICEACCOUNT

cat << EOT | kubectl apply -f -


apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $NAMESPACE
  name: $ROLE
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["create"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["create"]

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $ROLEBINDING
  namespace: $NAMESPACE
subjects:
- kind: ServiceAccount
  name: $SERVICEACCOUNT
  namespace: $NAMESPACE
roleRef:
  kind: Role
  name: $ROLE
  apiGroup: rbac.authorization.k8s.io
EOT

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi


