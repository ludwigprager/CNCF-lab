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
envsubst < service.yaml.tpl | kubectl apply -f -

cat << EOF > task.txt

Q Use namespace $NAMESPACE for the following task. Create a single pod $POD1 with image $IMAGE1. Configure a livenessprobe which simply runs 'true'. Also, configure a readinessprobe wich checks if the URL 'http://$SERVICE:$PORT' is reachable. Use command 'wget -T2 -O- http://$SERVICE:$PORT'. 
Create a second pod $POD2 with image $IMAGE2 with label $KEY: $VALUE

(from: killer.sh CKA Question 04 https://www.youtube.com/watch?v=1Q4Sqdl9Rao )

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
