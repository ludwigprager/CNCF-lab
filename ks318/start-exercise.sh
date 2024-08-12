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

test  $NAMESPACE_1 != "default"  && kubectl create namespace $NAMESPACE_1
test  $NAMESPACE_2 != "default"  && kubectl create namespace $NAMESPACE_2

for secret in $SECRET1 $SECRET2 $SECRET3 $SECRET4 $SECRET5 $SECRET6; do
  password=$( echo "${RANDOM}${RANDOM}${RANDOM}" | tr '[0-9]' '[a-z]' )
  kubectl create secret generic $secret -n $NAMESPACE_2 --from-literal=password=$password
done

kubectl create serviceaccount $SERVICEACCOUNT -n $NAMESPACE_1

envsubst < role.yaml.tpl | kubectl apply -f -


kubectl create token $SERVICEACCOUNT -n $NAMESPACE_1 -o jsonpath='{.status.token}' > token
#cat token | jwt -show -

TOKEN=$( cat token )
SERVER=$( kubectl config view --raw -o json | jq -r '.clusters[0].cluster.server' )

curl -k -H "Authorization: Bearer $TOKEN"   ${SERVER}/api/v1/namespaces/$NAMESPACE_2/secrets/$SECRET1 > result.json
echo kubectl auth can-i get secrets --as=system:serviceaccount:$NAMESPACE_1:$SERVICEACCOUNT -n $NAMESPACE_2 


log=$( docker exec -ti cncf-$(whoami)-control-plane bash -c 'find /var/log/pods/kube-system_kube-apiserver* -name \*.log' | sed 's/\r//' )
docker cp cncf-$(whoami)-control-plane:/var/log/kubernetes/kube-apiserver-audit.log $LOGPATH



cat << EOF > task.txt

Q Namespace $NAMESPACE_2 contains five secrets of type opaque which can be considered highly confidential. The latest incident-prevention-investigation revealed that service account $SERVICEACCOUNT in namespace $NAMESPACE_1 had too broad access to the cluster for some time. This SA should have never had access to any secret in that namespace.

Find out which secrets in namespace $NAMESPACE_2 this SA did access by looking at the audit logs under $LOGPATH.

Change the password to any new string of only those secrets that were accessed by this SA.

(from: killer.sh CKS Question 18 )

EOF
#clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
