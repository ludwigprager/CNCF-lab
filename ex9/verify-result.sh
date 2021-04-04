#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=

# test container status
status=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.status.containerStatuses[?(.name=='nginx')].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi


# test readinessProbe
path=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.name=='nginx')].readinessProbe.httpGet.path}" 2>/dev/null)
port=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.name=='nginx')].readinessProbe.httpGet.port}" 2>/dev/null)


if [[ $path != "/" ]]; then
  error=true
  echo "the readiness probe path is wrong"
#echo found: $path
fi

if [[ $port != "80" ]]; then
  error=true
  echo "the readiness probe port is wrong"
#echo found: $port
fi


# test livenessProbe
path=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.name=='nginx')].livenessProbe.httpGet.path}" 2>/dev/null)
port=$(kubectl -n$NS get pod nginx -o=jsonpath="{$.spec.containers[?(@.name=='nginx')].livenessProbe.httpGet.port}" 2>/dev/null)


if [[ $path != "/healthz" ]]; then
  error=true
  echo "the livenessProbe probe path is wrong"
#echo found: $path
fi

if [[ $port != "80" ]]; then
  error=true
  echo "the livenessProbe probe port is wrong"
#echo found: $port
fi




set +u

if [ "$error" = true ] ; then

cat << EOS
FAILED
$message




suggested solution:

1.
kubectl -n$NS run nginx --image=nginx:1.17 -o yaml --dry-run=client > pod.yaml

2. add the readinessProbe section:

    readinessProbe:
      httpGet:
        path: /
        port: 80

2. add the livenessProbe section:

    livenessProbe:
      httpGet:
        path: /healthz
        port: 80
EOS

else
    echo PASSED
fi

