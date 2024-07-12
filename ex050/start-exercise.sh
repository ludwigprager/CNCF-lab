#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR
CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source ../set-env.sh
source ../functions.sh
function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT
../10-prepare.sh
source ../.env


#kubectl create namespace $NAMESPACE
#kubectl apply -n $NAMESPACE -f policy.yaml
#kubectl run $POD -n $NAMESPACE  --image=nginx -l app=$POD
#kubectl expose pod $POD -n $NAMESPACE --port=$PORT

#kubectl run $TESTPOD  --image=nginx 
#kubectl run $TESTPOD -n $NAMESPACE --image=nginx 

#../cilium status --wait
#kubectl wait --for=condition=Ready pod/$TESTPOD
#kubectl wait --for=condition=Ready pod/$TESTPOD -n $NAMESPACE
#kubectl wait --for=condition=Ready pod/$POD -n $NAMESPACE

kubectl apply -f statefulset.yaml

echo "Preparing the environment ..."

cat << EOF > task.txt

Q050 Change the mountpath of the nginx container in the 'online' statefulset to "usr/share/nginx/updated-html 

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
