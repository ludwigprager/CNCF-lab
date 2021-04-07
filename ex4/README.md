# Exercise 4

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Preparing the environment ...

1.
Create a new deployment 'nginx-deploy' with image 'nginx:1.13' and 4 replicas.
The deployment shall use a 'rolling update' strategy with at least 3 and no more than 6 pods ready during the update.

2.
Then, upgrade the deployment to version 1.14

3.
Roll back 

Use namespace ex4.
```

# Some Remarks to this exercise.
- I found no proper example in the kubernetes docs that you can copy&paste for the rolling update scenario.
- The 'type: RollingUpdate' tag is omitted in the 'proposed solution' since it is the default. The complete strategy specification is
```
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
```
