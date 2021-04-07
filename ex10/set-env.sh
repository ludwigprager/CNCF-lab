#!/usr/bin/env bash

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl

export NS=ckad-ex10
#export PORT=8765
export IMAGE="ludwigprager/k8s-random:2"
export PARALLELISM=2
export BACKOFFLIMIT=30
export TIMEOUT=170
export INTERVAL=3
export MODE=RANDOMFAIL
export FAILURE_RATE=80
