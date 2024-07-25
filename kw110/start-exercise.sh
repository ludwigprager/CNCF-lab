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
bash ../10-prepare.sh
source ../.env

echo "Preparing the environment ..."

envsubst < namespace.yaml.tpl | kubectl apply -f -

cat << EOF > task.txt

Q.10 Create a new serviceaccount $SERVICEACCOUNT in namespace $NAMESPACE. Create a role $ROLE and rolebinding $ROLEBINDING. These should allow the new SA to only create secrets and configmaps in that namespace.

EOF
clear
cat task.txt
take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
