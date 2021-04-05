# Exercise 9

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a pod named 'probe' and image 'ludwigprager/k8s-random:1' that
- is restarted when the endpoint /healthz on port 8765 fails
- receives traffic only if the endpoint /readz on port 8765 is functional.
- skip livenessprobe during the first 15 seconds after the start of the container.
- watch the container getting 'ready'

Use namespace 'ckad-ex9'.

Call the script '/home/lprager/work/git/github/ludwigprager/ckad-exercises/ex9/verify-result.sh' when done
```
