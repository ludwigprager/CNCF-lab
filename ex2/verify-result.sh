#!/usr/bin/env bash

set -u

source set-env.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS nginx -o jsonpath="{$.spec.containers[?(.name=='nginx')].image}")
if [[ $image != nginx ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}")
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.phase}")
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

set +u

# test environment variables
string=$(kubectl exec -nex2 -ti  nginx -- env)
if [[ $string != *"UNCHANGED_REFERENCE=https://172.17.0.1:80"* ]]; then
  error=true
  echo "environment variable 'UNCHANGED_REFERENCE' not found or wrong"
#echo found: $string
fi
if [[ $string != *"SERVICE_ADDRESS=https://172.17.0.1:80"* ]]; then
  error=true
  echo "environment variable 'SERVICE_ADDRESS' not found or wrong"
#echo found: $string
fi
if [[ $string != *"ESCAPED_REFERENCE=https://172.17.0.1:80"* ]]; then
  error=true
  echo "environment variable 'ESCAPED_REFERENCE' not found or wrong"
#echo found: $string
fi


#f [[ "$string" != "https://172.17.0.1:80" ]] ; then
# error=true
# echo "environment variable 'UNCHANGED_REFERENCE' not found or wrong"
# echo found: $string
#i


#SERVICE_ADDRESS=https://172.17.0.1:80
#ESCAPED_REFERENCE=https://172.17.0.1:80


#alias k='kubectl'
#source $(k completion bash | 's/kubectl/k/g')
#do="-o yaml --dry-run=client"

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message

suggested solution:

1. create a env-file:
cat << EOF > a.env
UNCHANGED_REFERENCE=https://172.17.0.1:80
SERVICE_ADDRESS=https://172.17.0.1:80
ESCAPED_REFERENCE=https://172.17.0.1:80
EOF

2. create a config map:
k create cm -n$NS --from-env-file=a.env

3. create a yaml file for the pod:

do="-o yaml --dry-run=client"
kubectl run -n$NS nginx --image=nginx \$do > pod.yaml

4. edit pod.yaml, use the 'envFrom' tag.

    envFrom:
    - configMapRef:
        name: cm1


5. create the pod:
kubectl create -f pod.yaml

EOS

else
    echo PASSED
fi
