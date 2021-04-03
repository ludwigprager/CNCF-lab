# Exercise 5

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a pod 'redis' that mounts the directory '<some_existing_directory>/redis/' from the host where it is running onto the directory '/redis/' inside the container.
Use the container image: 'redis'

Do not use a 'persistent volume' or 'persistent volume claim'.

Use namespace ex5.

```
Note: when performing the exercise by calling 'start-exercise.sh' you will be given a real name insted of 'some_existing_directory'

# Some Remarks to this exercise.
This is the simplest of all production-ready persistency methods in kubernetes.
Clearly, it only works if the pod will always run on the same host.
This is the case in a single-node cluster or if you use proper 'node affinity' settings.
