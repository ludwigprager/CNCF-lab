#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# since alias doesn't work in a script
function kubectl () {
  microk8s.kubectl $*
}

export -f kubectl

export NS=ex1
