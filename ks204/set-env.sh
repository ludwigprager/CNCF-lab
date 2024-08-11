
export TASK=${PWD##*/}

POD1=ready-if-service-ready
POD2=am-i-ready

IMAGE1=nginx:1.16.1-alpine
IMAGE2=nginx:1.16.1-alpine

export KEY=id
export VALUE=cross-server-ready

export SERVICE=am-i-ready
NAMESPACE=default

export PORT=80
