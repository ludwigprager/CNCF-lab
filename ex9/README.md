# Exercise 9

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a pod named 'nginx' and image 'nginx:1.17' that
- is restarted when the endpoint /healthz on port 80 fails
- receives traffic only if the endpoint / on port 80 is functional.
Use namespace 'ckad-ex9'.
```
