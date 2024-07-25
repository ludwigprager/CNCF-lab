#!/usr/bin/env bash

set -u

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CKA_BASEDIR=${BASEDIR}/..

source $BASEDIR/set-env.sh
source $CKA_BASEDIR/set-env.sh
source $CKA_BASEDIR/functions.sh


error=false
message=

# test service exists
service=$(kubectl get service ${SERVICE} -o jsonpath='{.metadata.name}')
if [[ $service != ${SERVICE} ]]; then
  error=true
  echo "service ${SERVICE} not found"
fi

port=$( kubectl get svc hr-web-app-service -o jsonpath='{.spec.ports[0].port}' )
if [[ $port != ${NODEPORT} ]]; then
  error=true
  echo "port not set correctly"
fi

targetport=$( kubectl get svc hr-web-app-service -o jsonpath='{.spec.ports[0].targetPort}' )
if [[ $targetport != ${PORT} ]]; then
  error=true
  echo "port not set correctly"
fi

type=$( kubectl get svc hr-web-app-service -o jsonpath='{.spec.type}' )
if [[ $type != NodePort ]]; then
  error=true
  echo "port type is wrong"
fi



## test ready replicas
#ready=$(kubectl get deployment ${DEPLOYMENT} -o jsonpath='{.status.readyReplicas}')
#if [[ ! $ready -eq 2 ]]; then
#  error=true
#  echo "replicas not ready"
#fi

if [ "$error" = true ] ; then

cat << EOF
FAILED
$message

suggested solution:

kubectl expose deployment ${DEPLOYMENT} --name ${SERVICE} --port ${NODEPORT} --target-port ${PORT} --type NodePort

# find 2 endpoints listed:
kubectl describe service/${SERVICE} | grep ^Endpoints:



EOF

else
  echo PASSED
  print-elapsed-time $BASEDIR
fi

