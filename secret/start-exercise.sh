#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

CKA_BASEDIR=${BASEDIR}/..

source set-env.sh
source ../set-env.sh
source ../functions.sh

../10-prepare.sh
source ../.env

function finish {
  $CKA_BASEDIR/90-teardown.sh
}
trap finish INT TERM EXIT

echo "Preparing the environment ..."


cat << EOF > task.txt

Q1: Create a secret called mysecret with the values password=mypass
Q2: Create a secret called mysecret2 that gets key/value from a file
Q3: Get the value of mysecret2
Q4: Create an nginx pod that mounts the secret mysecret2 in a volume on path /etc/foo
Q5: Delete the pod you just created and mount the variable 'username' from secret mysecret2 onto a new nginx pod in env variable called 'USERNAME'
Q6: Create a Secret named 'ext-service-secret' in the namespace 'secret-ops'. Then, provide the key-value pair API_KEY=LmLHbYhsgWZwNifiqaRorH8T as literal.
Q7: Consuming the Secret. Create a Pod named 'consumer' with the image 'nginx' in the namespace 'secret-ops' and consume the Secret as an environment variable. Then, open an interactive shell to the Pod, and print all environment variables.
Q8: Create a Secret named 'my-secret' of type 'kubernetes.io/ssh-auth' in the namespace 'secret-ops'. Define a single key named 'ssh-privatekey', and point it to the file 'id_rsa' in this directory.
Q9: Create a Pod named 'consumer' with the image 'nginx' in the namespace 'secret-ops', and consume the Secret as Volume. Mount the Secret as Volume to the path /var/app with read-only access. Open an interactive shell to the Pod, and render the contents of the file.

(from: https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets )


EOF

cat task.txt

take-down-time $BASEDIR
bash --rcfile <(cat $CKA_BASEDIR/.env $CKA_BASEDIR/set-env.sh set-env.sh)
#../90-teardown.sh
