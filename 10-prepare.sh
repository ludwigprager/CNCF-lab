#!/usr/bin/env bash

set -eu
CKA_BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CKA_BASEDIR

source ./functions.sh
source ./set-env.sh

KUBECTL_VERSION=${1:-1.30.2}
NODE_VERSION=${2:-1.30.0}
KIND_CONFIG=${3:-kind.config}

echo using $KIND_CONFIG


# install kubectl
if [[ ! -f ./kubectl ]]; then
  # KUBECTL_VERSION=1.30.2
  echo downloading kubectl $KUBECTL_VERSION
  curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
  chmod +x kubectl
fi

if [[ ! -f ./kind ]]; then
  KIND_VERSION=0.23.0
# KIND_VERSION=0.7.0
  echo downloading kind $KIND_VERSION
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64
  chmod +x ./kind
fi


echo PATH=$CKA_BASEDIR:$PATH > .env
echo "alias kubectl=$CKA_BASEDIR/kubectl" >> .env
echo "alias k=$CKA_BASEDIR/kubectl" >> .env
echo "KUBECONFIG=$CKA_BASEDIR/kubeconfig" >> .env

source .env

#source <( kubectl completion bash | sed 's/kubectl/k/g' )
#test -f /etc/bash_completion && source /etc/bash_completion
kubectl completion bash | sed 's/kubectl/k/g' >> .env
test -f /etc/bash_completion && cat /etc/bash_completion >> .env

if ! kind-cluster-exists $CLUSTER; then
  echo "wait for cluster to get ready ..."

# curl -LO https://raw.githubusercontent.com/cilium/cilium/1.15.6/Documentation/installation/kind-config.yaml 
  ./kind create cluster \
    -n $CLUSTER \
    --config $KIND_CONFIG \
    --image kindest/node:v${NODE_VERSION}

# --image kindest/node:v1.24.7@sha256:577c630ce8e509131eab1aea12c022190978dd2f745aac5eb1fe65c0807eb315
# kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
# kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
#  curl -L  https://docs.projectcalico.org/manifests/calico.yaml  | kubectl apply -f -

  

fi

  #-q -w 30 \
    #-q --wait 30s \


#CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CILIUM_CLI_VERSION=v0.16.10

if [[ ! -f ./cilium ]]; then
  CLI_ARCH=amd64
  curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
  tar zxvf cilium-linux-${CLI_ARCH}.tar.gz
  chmod +x cilium
fi

#cilium install --version 1.15.6
#cilium status --wait
