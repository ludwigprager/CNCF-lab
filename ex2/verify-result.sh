#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS nginx -o jsonpath="{$.spec.containers[?(.name=='nginx')].image}" 2>/dev/null)
if [[ $image != nginx ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test pod status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.phase}" 2>/dev/null)
if [[ "$status" != "Running" ]] ; then
  error=true
  echo "the pod is not running"
fi

set +u

# test environment variables
string=$(kubectl -n$NS exec -ti  nginx -- env 2>/dev/null)
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
kubectl -n$NS create cm cm1 --from-env-file=a.env

3. create a yaml file for the pod:

do="-o yaml --dry-run=client"
kubectl -n$NS run nginx --image=nginx \$do > pod.yaml

4. edit pod.yaml, use the 'envFrom' tag.

    envFrom:
    - configMapRef:
        name: cm1


5. create the pod:
kubectl -n$NS create -f pod.yaml

EOS

else
    echo PASSED
fi
