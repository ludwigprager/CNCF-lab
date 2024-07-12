#!/bin/bash

#https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#node-shell

# 1. update package list
apt-get update

# 2. install packages necessary for further apt steps
apt-get install -y apt-transport-https ca-certificates curl gpg

# 3. add the k8s list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.26/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
#curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.26/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
apt-get -y update

#apt-get install -y kubeadm='1.26.3-1.1' 


