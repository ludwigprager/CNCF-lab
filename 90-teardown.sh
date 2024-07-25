#!/usr/bin/env bash

set -eu
CKA_BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CKA_BASEDIR

export NS=none
source functions.sh
source set-env.sh

#set -x
set +e

#./k3d cluster delete $CLUSTER || true

echo tearing down the cluster ...
./kind delete clusters $CLUSTER -q || true

MY_RANDOM=$RANDOM
mv kubeconfig kubeconfig.${MY_RANDOM} 2> /dev/null || true

: '


# end process port-forward
fwdps=$(ps -ef|grep port-forward|grep -v grep)

# kill process forwarding the ports TODO: check it 
for ps_str in "${fwdps[@]}" 
do
  # echo "ps_str $ps_str"
  idx=0
  for word in $ps_str
  do
    ((idx++))
    if [ $idx -eq 2 ]
    then
      pid=$word
      echo "kill $pid"
      kill -9 $pid
      break
    fi
  done
done

'
