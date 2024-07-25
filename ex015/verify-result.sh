#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh


print-solution() {
cat << EOF
FAILED

suggested solution:

# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/

# Create private key 
openssl genrsa -out $USER.key 2048
openssl req -new -key $USER.key -out $USER.csr -subj "/CN=$USER"

request=\$(cat $USER.csr | base64 | tr -d "\n" )

# Create a CertificateSigningRequest 
kubectl apply -f - << EOT
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $USER
spec:
  request: \$request
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOT

# Approve the CertificateSigningRequest 
kubectl certificate approve $USER

# Export the issued certificate from the CertificateSigningRequest.
kubectl get csr $USER -o jsonpath='{.status.certificate}'| base64 -d > $USER.crt

# Create Role and RoleBinding 
kubectl create -n $NAMESPACE role developer --verb=create --verb=get --verb=list --verb=update --verb=delete --resource=pods
kubectl create -n $NAMESPACE rolebinding developer-binding-$USER --role=developer --user=$USER

# Add to kubeconfig and test
kubectl config set-credentials $USER --client-key=$USER.key --client-certificate=$USER.crt --embed-certs=true
kubectl config set-context $USER --cluster=kind-cka-$(whoami) --user=$USER
kubectl config use-context $USER

kubectl get po -n $NAMESPACE

EOF


}



source $CKA_BASEDIR/functions.sh
function finish {
  print-solution
}
trap finish INT TERM EXIT


error=false

export KUBECONFIG=$BASEDIR/kubeconfig.$TASK
cp .kubeconfig-for-verification $KUBECONFIG

kubectl config delete-user kind-cka-$(whoami)
kubectl config delete-context kind-cka-$(whoami)

kubectl config set-credentials $USER --client-key=$USER.key --client-certificate=$USER.crt --embed-certs=true
kubectl config set-context $USER --cluster=kind-cka-$(whoami) --user=$USER
kubectl config use-context $USER

#kubectl get pod
pod=$RANDOM$RANDOM

if ! kubectl run $pod --image=nginx -n $NAMESPACE; then
  error=true
else
    kubectl wait --for=condition=Ready pod/$pod -n $NAMESPACE
fi
if ! kubectl get pod $pod -n $NAMESPACE ; then
  error=true
fi
if ! kubectl delete pod $pod -n $NAMESPACE ; then
  error=true
fi




if [ "$error" = true ] ; then
  solution
else
  echo PASSED
  print-elapsed-time $BASEDIR
fi



