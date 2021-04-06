#!/usr/bin/env bash

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl

#export NS=cka-1-exercise1
export NS=ex1
#export CONTAINER_IMAGE=nginx
#export CONTAINER_NAME=nginx
