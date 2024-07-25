
export TASK=${PWD##*/}

POD=consumer
IMAGE=nginx
NAMESPACE=secret-ops
SECRET=my-secret
#TYPE="kubernetes.io/ssh-auth"
#KEY=ssh-privatekey
MOUNTPATH=/var/app/
