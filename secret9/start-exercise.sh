#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
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
kubectl create secret generic $SECRET -n $NAMESPACE --type="kubernetes.io/ssh-auth" --from-file=ssh-privatekey=id_rsa



cat << EOF > task.txt

Q9: Create a Pod named '$POD' with the image '$IMAGE' in the namespace '$NAMESPACE', and consume the secret '$SECRET' as Volume. Mount the Secret as Volume to the path '$MOUNTPATH' with read-only access. Open an interactive shell to the Pod, and render the contents of the file.

Secret '$SECRET' already exists

(from: https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets )

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
