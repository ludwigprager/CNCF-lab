# CKAD hands-on exercises

## TL;DR
```
sudo snap install microk8s --classic
sudo microk8s.enable dns
git clone https://github.com/ludwigprager/ckad-exercises.git
./ckad-exercises/ex1/start-exercise.sh 
```

## Multi-Container Pods (10%)
## Pod Design (20%)
[Exercise 1: requests and limits](./ex1/)  
[Exercise 2: environment variables](./ex2/)  
[Exercise 7: labels and annotations](./ex7/)  
## State Persistence (8%)
[Exercise 5: hostPath](./ex5/)  
[Exercise 6: hostPath in a persistent volume](./ex6/)  
## Configuration (18%)
[Exercise 3: rollout, rollback, record](./ex3/)  
[Exercise 4: rollout](./ex4/)  
## Observability (18%)
[Exercise 9: readiness and liveliness](./ex9/)  
## Services and Networking (13%)
[Exercise 8: ClusterIP and network policy](./ex8/)  

If you have [microk8s](https://microk8s.io/) on your computer you can try these CKAD
exercises by running the 'start-exercise.sh' scripts in the different subdiretories.  

Run the 'verify-result.sh' scripts to check if you passed the test.
It will show you the solution in case you failed to solve the exercise.

# Screen Cast
[![asciicast](ex1/ex1.png)](https://asciinema.org/a/404891)
