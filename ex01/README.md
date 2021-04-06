# Exercise 1

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a pod with name nginx and image 'nginx' with the following attributes:

requests:
  cpu:    100m
  memory: 256Mi
limits:
  cpu:    200m
  memory: 512Mi

Ensure the pod is running.
Use namespace ex1.

Call the script 'verify-result.sh' when done
```

# Screen Cast
[![asciicast](ex1.png)](https://asciinema.org/a/404501)
