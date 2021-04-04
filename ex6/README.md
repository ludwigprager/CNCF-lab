# Exercise 6

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a pod that mounts the directory '<some_existing_directory>' from the host where it is
running onto the directory '/var/log/ex6' inside the container using a PVC.

1.
Create a Persistent Volume called 'pv-ex6' with the attributes
- storage class 'manual'
- access mode RWX
- size 2Gi

2.
Create a PVC called 'pvc-ex6' requesting 100Mi. It shall bind to the PV 'pv-ex6..

3.
Create the pod using
- pod name 'pod-ex6'
- container image: 'nginx:alpine'
- volume name: 'v1'


Use namespace 'ex6'.
```

Note: when performing the exercise by calling 'start-exercise.sh' you will be given a real name insted of 'some_existing_directory'
