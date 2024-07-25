#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source ../set-env.sh
source ../functions.sh
../10-prepare.sh
source ../.env
function finish {
  test -f $BASEDIR/id_rsa     && mv $BASEDIR/id_rsa     id_rsa.$RANDOM 
  test -f $BASEDIR/id_rsa.pub && mv $BASEDIR/id_rsa.pub id_rsa.pub.$RANDOM 
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT

echo "Preparing the environment ..."
ssh-keygen -q -t rsa -N '' -f ./id_rsa <<<y
kubectl create ns $NAMESPACE
#kubectl create secret generic $SECRET -n $NAMESPACE --type="kubernetes.io/ssh-auth" --from-file=ssh-privatekey=id_rsa



cat << EOF > task.txt

Q8: Create a Secret named 'my-secret' of type 'kubernetes.io/ssh-auth' in the namespace 'secret-ops'. Define a single key named 'ssh-privatekey', and point it to the file 'id_rsa' in this directory.

Note: key file 'id_rsa' already exists.

(from: https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets )

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
