#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set-env.sh

echo "Preparing the environment ..."

# setup

kubectl delete ns $NS --grace-period=0 > /dev/null 2>&1 > /dev/null || true
kubectl create ns $NS > /dev/null

kubectl run -n$NS ui --image=nginx --labels='tier=front,env=prod' --annotations=owner=petr > /dev/null
kubectl run -n$NS db --image=nginx --labels='tier=front,env=prod,tirr=front' > /dev/null

kubectl run -n$NS pod1 --image=nginx --labels=podname=dummy > /dev/null
kubectl run -n$NS pd1 --image=nginx --labels=podname=dummy > /dev/null
kubectl run -n$NS od1 --image=nginx --labels=podname=dummy > /dev/null
kubectl run -n$NS pdd1 --image=nginx --labels=podname=dummy > /dev/null
kubectl run -n$NS ppppd1 --image=nginx --labels=podname=dummy > /dev/null
kubectl run -n$NS papppod1 --image=nginx --labels=podname=dummy > /dev/null

kubectl run -n$NS apod1 --image=nginx --labels=apodname=d1mmy > /dev/null
kubectl run -n$NS apd1 --image=nginx --labels=apodname=d2mmy > /dev/null
kubectl run -n$NS aod1 --image=nginx --labels=apodname=d3mmy > /dev/null
kubectl run -n$NS apdd1 --image=nginx --labels=apodname=d4mmy > /dev/null
kubectl run -n$NS appppd1 --image=nginx --labels=apodname=d5mmy > /dev/null
kubectl run -n$NS apapppod1 --image=nginx --labels=apodname=d6mmy > /dev/null

echo "Waiting for resources to get ready ..."
kubectl wait --for=condition=Ready pods --all -n $NS --timeout=120s > /dev/null


cat << EOF


Several pods are running in namespace '$NS'.

1.
change the annotation 'owner' of pod 'ui' to 'peter'

2.
change the label 'env' of pod 'ui' to 'test'

3.
remove the label 'tirr' from pod db

4.
delete all pods that match the label 'podname = dummy'

5.
delete all pods that have a label 'apodname'

6.
create a pod 'ex7' with labels
- tier : front
- env : prod

Use namespace ${NS}.

Call the script '$DIR/verify-result.sh' when done

EOF

