#!/usr/bin/env bash

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl
export NS=ex6

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export HOSTPATH=${DIR}/redis-ex6/
export PODNAME="pod-ex6"

