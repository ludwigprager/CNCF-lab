#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source /set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test container image
image=$(kubectl get deploy -n$TASK nginx-deploy -o jsonpath="{$.spec.template.spec.containers[?(.name=='nginx')].image}" 2>/dev/null)
if [[ $image != nginx:1.17 ]]; then
  error=true
  echo "the container image is wrong"
fi


## test container status
#status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
##echo container status: $status
#if [[ -z "$status" ]]; then
#  error=true
#  echo "the container is not running"
#fi


## test pod status
#status=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.status.phase}" 2>/dev/null)
#if [[ "$status" != "Running" ]] ; then
#  error=true
#  echo "the pod is not running"
#fi

### test requests
#cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.cpu}" 2>/dev/null)
#memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.requests.memory}" 2>/dev/null)

#requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi

#[[ "$cpu" == "100m" ]] || error=true
#[[ "$memory" == "256Mi" ]] || error=true

## test limits
#cpu=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.cpu}" 2>/dev/null)
#memory=$(kubectl -n$TASK get pod nginx -o=jsonpath="{$.spec.containers[?(@.image=='nginx')].resources.limits.memory}" 2>/dev/null)

#[[ "$cpu" == "200m" ]] || error=true
#[[ "$memory" == "512Mi" ]] || error=true


if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

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
#  source 
#    start=$(<start.time)
#    now=$(date +%s)
#    elapsed=$( echo "$now - $start" | bc -l )
#    minutes=$(( elapsed/60 ))
#    seconds=$(( elapsed - (minutes * 60) ))
    echo PASSED
#    printf "Time taken: $minutes minutes, $seconds seconds\n"

  print-elapsed-time $BASEDIR
fi

