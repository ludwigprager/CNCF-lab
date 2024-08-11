#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT

export BASEDIR
envsubst < kind.config.tpl > kind.config

$CKA_BASEDIR/10-prepare.sh 1.30.2 1.30.0 $BASEDIR/kind.config

source $CKA_BASEDIR/.env

echo "Preparing the environment ..."
kubectl wait --for=condition=Ready node cncf-$(whoami)-control-plane

test  $NAMESPACE != "default"  && kubectl create namespace $NAMESPACE
kubectl create secret generic $SECRET1 -n $NAMESPACE --from-literal=a=b
kubectl create secret generic $SECRET2 -n $NAMESPACE --from-literal=a=b
kubectl create serviceaccount $SERVICE_ACCOUNT_NAME -n $NAMESPACE


#envsubst < pod.yaml.tpl | kubectl apply -f -


envsubst < role.yaml.tpl | kubectl apply -f -


kubectl create token $SERVICE_ACCOUNT_NAME -n $NAMESPACE -o jsonpath='{.status.token}' > token
#cat token | jwt -show -

TOKEN=$( cat token )
SERVER=$( kubectl config view --raw -o json | jq -r '.clusters[0].cluster.server' )
echo curl -k -H "Authorization: Bearer $TOKEN"   ${SERVER}/api/v1/
echo curl -k -H "Authorization: Bearer $TOKEN"   ${SERVER}/api/v1/namespaces/$NAMESPACE/pods
echo kubectl auth can-i get pods --as=system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT_NAME -n $NAMESPACE 


log=$( docker exec -ti cncf-$(whoami)-control-plane bash -c 'find /var/log/pods/kube-system_kube-apiserver* -name \*.log' | sed 's/\r//' )
docker cp cncf-$(whoami)-control-plane:/var/log/kubernetes/kube-apiserver-audit.log $LOGPATH



cat << EOF > task.txt

Q Namespace $NAMESPACE contains five secrets of type opaque which can be considered highly confidential. The latest incident-prevention-investigation revealed that service account $SERVICE_ACCOUNT_NAME had too broad access to the cluster for some time. This SA should have never had access to any secret in that namespace.

Find out which secrets in namespace $NAMESPACE this SA did access by looking at the audit logs under $LOGPATH.

Change the password to any new string of only those secrets that were accessed by this SA.

(from: killer.sh CKS Question 18 )

EOF
#clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
