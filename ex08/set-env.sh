#!/usr/bin/env bash

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl
export NS=ckad-ex08
export SERVICE=ex08


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

