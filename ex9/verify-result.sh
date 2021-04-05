#!/usr/bin/env bash

set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

error=false
message=

# test container image
image=$(kubectl get pod -n$NS probe -o jsonpath="{$.spec.containers[?(.name=='probe')].image}" 2>/dev/null)
if [[ $image != "$IMAGE" ]]; then
  error=true
  echo "the container image is wrong"
fi


# test container status
status=$(kubectl -n$NS get pod probe -o=jsonpath="{$.status.containerStatuses[?(.name=='probe')].state.running}" 2>/dev/null)
#echo container status: $status
if [[ -z "$status" ]]; then
  error=true
  echo "the container is not running"
fi

# test container ready
ready=$(kubectl -n$NS get pod probe -o=jsonpath="{$.status.containerStatuses[?(.name=='probe')].ready}" 2>/dev/null)
#echo container ready: $ready
if [[ "$ready" != "true" ]]; then
  error=true
  echo "the container is not ready"
fi


# test readinessProbe
path=$(kubectl -n$NS get pod probe -o=jsonpath="{$.spec.containers[?(@.name=='probe')].readinessProbe.httpGet.path}" 2>/dev/null)
port=$(kubectl -n$NS get pod probe -o=jsonpath="{$.spec.containers[?(@.name=='probe')].readinessProbe.httpGet.port}" 2>/dev/null)


if [[ $path != "/readz" ]]; then
  error=true
  echo "the readiness probe path is wrong"
#echo found: $path
fi

if [[ $port != "$PORT" ]]; then
  error=true
  echo "the readiness probe port is wrong"
#echo found: $port
fi


# test livenessProbe
path=$(kubectl -n$NS get pod probe -o=jsonpath="{$.spec.containers[?(@.name=='probe')].livenessProbe.httpGet.path}" 2>/dev/null)
port=$(kubectl -n$NS get pod probe -o=jsonpath="{$.spec.containers[?(@.name=='probe')].livenessProbe.httpGet.port}" 2>/dev/null)


if [[ $path != "/healthz" ]]; then
  error=true
  echo "the livenessProbe probe path is wrong"
#echo found: $path
fi

if [[ $port != "$PORT" ]]; then
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
kubectl -n$NS run probe --image=$IMAGE -o yaml --dry-run=client > pod.yaml

2. add the livenessProbe section:

    livenessProbe:
      httpGet:
        path: /healthz
        port: $PORT
      initialDelaySeconds: 15

3. add the readinessProbe section:

    readinessProbe:
      httpGet:
        path: /readz
        port: $PORT

4. watch the status until it is ready:
kubectl -n$NS get pod probe -w

EOS

else
    echo PASSED
fi

