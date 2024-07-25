apiVersion: v1
kind: Pod
metadata:
  name: $POD
  labels:
    app: $POD
spec:
  containers:
  - name: $POD
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-$POD
    image: busybox:1.28
    command: ['sh', '-c', "sleeep 2"]

