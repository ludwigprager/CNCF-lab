#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source ./set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

docker exec cka-$(whoami)-control-plane bash -c \
  'rm -Rf /tmp/datadir/'
docker exec cka-$(whoami)-control-plane bash -c \
  'mkdir -p /tmp/datadir/'

docker exec cka-$(whoami)-control-plane bash -c \
  'etcdctl snapshot restore --data-dir /tmp/datadir /tmp/snapshot.db > /dev/null 2>&1'

if [ $? -ne 0 ]; then
  echo the backup doesn\'t exist or is broken
  error=false
fi


if [ "$error" = true ] ; then

cat << EOF
FAILED

- https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#snapshot-using-etcdctl-options
- read the path of the config.yaml specified in the kubelet's process '--config' parameter
- take note of the 'staticPodPath' field from the kubelet config.yaml. 
- from /etc/kubernetes/manifests/etcd.yaml take note of
-- trusted-ca-file
-- cert-file
-- key-file

suggested solution:

kubectl node-shell cka-$(whoami)-control-plane
ps x | grep /usr/bin/kubelet | grep -o -- --config=[a-z,/]*
grep staticPodPath: /var/lib/kubelet/config.yaml
sed -n 's/.*--trusted-ca-file=\(.*\)$/\1/p' /etc/kubernetes/manifests/etcd.yaml
sed -n 's/.*--cert-file=\(.*\)$/\1/p' /etc/kubernetes/manifests/etcd.yaml
sed -n 's/.*--key-file=\(.*\)$/\1/p' /etc/kubernetes/manifests/etcd.yaml

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \\
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \\
  --cert=/etc/kubernetes/pki/etcd/server.crt \\
  --key=/etc/kubernetes/pki/etcd/server.key \\
  snapshot save /tmp/snapshot.db






EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

