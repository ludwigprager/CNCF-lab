#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

node=$( kubectl get pod ${POD} -o jsonpath="{.spec.nodeName}" )

if [[ "$node" != "cka-$(whoami)-control-plane" ]]; then
  error=true
  echo "pod doesn't run on controlplane"
fi



if [ "$error" = true ] ; then

cat << EOF
FAILED

suggested solution:

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  snapshot save /tmp/etcd-backup-new.db

ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/etcd-backup-new.db

ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd-backup snapshot restore /root/backup/etcd-backup-old.db

Hint:

grep -- --advertise-client-url /etc/kubernetes/manifests/etcd.yaml
grep -- --cert-file /etc/kubernetes/manifests/etcd.yaml
grep -- --key-file /etc/kubernetes/manifests/etcd.yaml
grep -- --trusted-ca-file /etc/kubernetes/manifests/etcd.yaml

EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

