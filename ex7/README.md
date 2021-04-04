# Exercise 7

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Several pods are running in namespace 'ckad-ex7'.

1.
change the annotation 'owner' of pod 'ui' to 'peter'

2.
change the label 'env' of pod 'ui' to 'test'

3.
remove the label 'tirr' from pod db

4.
delete all pods that match the label 'podname = dummy'

5.
delete all pods that have a label 'apodname'

6.
create a pod 'ex7' with labels
- tier : front
- env : prod

Use namespace 'ckad-ex7'.
```
