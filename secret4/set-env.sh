
export TASK=secret4

SECRET=mysecret3
TYPE="kubernetes.io/ssh-auth"
NAMESPACE=secret-ops
KEY=ssh-privatekey
FILENAME=id_rsa
MOUNTPATH=/var/spp/
POD=pod3

NAMESPACE=secops
export TASK=${PWD##*/}
