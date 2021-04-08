# Exercise 8

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a deployment with image 'nginx:1.16' of 2 replicas, expose it via a ClusterIP service on
port 80. Use service name 'ex08'.
Create a NetworkPolicy so that only pods with labels 'access: granted' can
access the deployment and apply it

Use namespace 'ckad-ex08'.
```
