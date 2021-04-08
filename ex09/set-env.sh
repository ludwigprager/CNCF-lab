#!/usr/bin/env bash

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl

export NS=ckad-ex09
export PORT=8765
export IMAGE=ludwigprager/k8s-random:1
export DELAY=15
