# Exercise 3

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
1.
Create a new deployment called nginx-deploy, with image nginx:1.13 and 1 replica.
Record the command in the resource annotation. 
Hint: you need to use 'kubectl apply' since 'kubectl create' does not have the '--record' option anymore.

2.
Then, upgrade the deployment four times using versions
- nginx:1.14
- nginx:1.15
- nginx:1.16
- nginx:1.17

Record the version upgrade in the resource annotation. 

3.
Roll back to the second version, i.e. when 'nginx:1.14' was running.

Use namespace ex3.
```

# Some Remarks to this exercise.
These issues might be bugs, they are confusing at the least.  
- The '--record' option was available for 'kubectl create' in a previous version but seems now gone. In case you want the whole history in the annotations I only found the 'kubectl apply' to be functional.
- The annotations seem to get overwritten if you use a 'set image' command.

# Screen Cast
[![asciicast](../ex1/ex1.png)](https://asciinema.org/a/IZoHkloerTBJ048gs3ByHhiSJ)
