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
$CKA_BASEDIR/10-prepare.sh
source $CKA_BASEDIR/.env

echo "Preparing the environment ..."
kubectl run $TESTPOD  --image=nginx 
kubectl wait --for=condition=Ready pod/$TESTPOD --timeout=5m

cat << EOF > task.txt

Q Create a pod with an $IMAGE1 container exposed on port $PORT. Add a $IMAGE2 init container which downloads a page using "wget -O $PATH2/index.html http://neverssl.com/online". Make a volume of type emptyDir and mount it in both containers. For the nginx container, mount it on "$PATH1" and for the initcontainer, mount it on "$PATH2".

Image: $IMAGE1
Init Container Image: $IMAGE2
Mountpath: $PATH1
Init Container Mountpath: $PATH2

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
