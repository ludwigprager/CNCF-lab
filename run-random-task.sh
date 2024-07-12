#!/usr/bin/env bash

set -eu
CKA_BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CKA_BASEDIR

tasks=(ex* kk* kw* secret*)
task=${tasks[ $RANDOM % ${#tasks[@]} ]}
printf "selected $task\n"

grep -o '^Q.*$' $task/start-exercise.sh || true

./$task/start-exercise.sh

