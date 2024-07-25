
NAMESPACE=ex01
AGENTS=2
export TASK=${PWD##*/}

# requests:
CPU1=100m
MEMORY1=256Mi
# limits:
CPU2=200m
MEMORY2=512Mi

# kubectl run -n$TASK nginx --image=nginx --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi'

