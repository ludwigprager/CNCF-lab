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

nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )
for node in $nodes; do
  docker exec $node bash -c 'apt-get update'
  docker exec $node bash -c 'apt-get -y install etcd-client'
  docker exec $node bash -c 'mkdir -p /root/backup/'
done

# create the to-be-restored-backup mentioned in the task
docker exec cka-lprager-control-plane bash -c ' \
  ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  snapshot save /root/backup/etcd-backup-old.db \
  '

clear


cat << EOF > task.txt

Q2  Create a snapshot of ETCD and save it to /root/backup/etcd-backup-new.db. Restore an old snapshot located at /root/backup/etcd-backup-old.db  to /var/lib/etcd-backup


Hint: use the following command for a shell in control-plane and worker nodes:
docker exec -ti cka-$(whoami)-control-plane bash

You can review this task at any time in the file task.txt
EOF

cat task.txt

take-down-time $BASEDIR

bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
../90-teardown.sh
