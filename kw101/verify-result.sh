#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false


nodes=$( kubectl get nodes -o jsonpath='{$.items[*].metadata.name}' )
for node in $nodes; do
  version=$( kubectl get nodes $node -o jsonpath='{.status.nodeInfo.kubeletVersion}' )
  if [[ "$version" != "v${VERSION}" ]]; then
    echo $node does not run kubelet version $VERSION
    error=true
  fi
# docker exec $node bash -c 'apt-get update'
# docker exec $node bash -c 'apt-get -y install etcd-client'
# docker exec $node bash -c 'mkdir -p /root/backup/'
done




if [ "$error" = true ] ; then

cat << EOF

# FAILED
# suggested solution:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# master

kubectl drain cncf-$(whoami)-control-plane --ignore-daemonsets

docker  exec -ti cncf-$(whoami)-control-plane apt update -y
docker  exec -ti cncf-$(whoami)-control-plane apt list -a kubeadm | grep $VERSION
docker  exec -ti cncf-$(whoami)-control-plane apt install -y kubeadm=1.27.16-1.1
docker  exec -ti cncf-$(whoami)-control-plane kubeadm upgrade apply v$VERSION
docker  exec -ti cncf-$(whoami)-control-plane systemctl restart kubelet


# node

kubectl drain cncf-$(whoami)-worker --ignore-daemonsets

docker  exec -ti cncf-$(whoami)-worker apt update -y
docker  exec -ti cncf-$(whoami)-worker apt list -a kubelet | grep $VERSION
docker  exec -ti cncf-$(whoami)-worker apt install -y kubelet=1.27.16-1.1
docker  exec -ti cncf-$(whoami)-worker systemctl daemon-reload
docker  exec -ti cncf-$(whoami)-worker systemctl restart kubelet

kubectl uncordon cncf-$(whoami)-worker

#

# list available versions
apt list -a kubeadm
EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi


