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

kubectl create namespace $NAMESPACE
ssh-keygen -t rsa -f $BASEDIR/id_rsa -N '' <<< y



cat << EOF > task.txt

Q4: Create a Secret named '$SECRET' of type 'kubernetes.io/ssh-auth' in the namespace '$NAMESPACE'. Define a single key named 'ssh-privatekey', and point it to the file 'id_rsa' in this directory.

Create a Pod named $POD with the image 'nginx' in the namespace '$NAMESPACE', and consume the Secret as Volume. Mount the Secret as Volume to the path $MOUNTPATH with read-only access. Open an interactive shell to the Pod, and render the contents of the file.

(from: https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets )


EOF

cat task.txt

take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
#../90-teardown.sh
