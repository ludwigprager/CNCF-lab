#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false

export KUBECONFIG=$BASEDIR/kubeconfig.$TASK
cp ../kubeconfig $KUBECONFIG

kubectl config delete-user kind-cka-lprager
kubectl config delete-context kind-cka-lprager

kubectl config set-credentials $USER --client-key=$USER.key --client-certificate=$USER.crt --embed-certs=true
kubectl config set-context $USER --cluster=kind-cka-$(whoami) --user=$USER
kubectl config use-context $USER

#kubectl get pod
pod=$RANDOM$RANDOM

if ! kubectl run $pod --image=nginx ; then
  error=true
else
    kubectl wait --for=condition=Ready pod/$pod
fi
if ! kubectl get pod $pod ; then
  error=true
fi
if ! kubectl delete pod $pod ; then
  error=true
fi


if [ "$error" = true ] ; then

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

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

