# Exercise 10

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a cronjob called 'rand' that starts a job which quickly returns with either success or error.

- Use the image 'ludwigprager/k8s-random:2'.

- Start the cronjob every 3 minutes.

- Set the environment variables
  - MODE=RANDOMFAIL
  - FAILURE_RATE=80
  which will make the job fail in 80% of all incarnations.

- The cronjob shall run no more than 2 job instances at a time.

- Once a job succeeds no more jobs shall be started.

- When no job ran to success after 5 tries the cronjob run shall be marked as failed, too.

- If a job does not complete after 170 seconds it shall be terminated and considered as failed.

Use namespace 'ckad-ex10'.
```

# Notes
Play around with the values in [set-env.sh](./set-env.sh) to learn the behaviour of a kubernetes cronjob.  
The default settings will in most cases lead to completion of the jobs.
A `kubectl get cronjob` will show a log similar to the following:
```
NAME                    READY   STATUS      RESTARTS   AGE
rand-1617665580-wlkqf   0/1     Error       0          3m52s
rand-1617665580-tcfgg   0/1     Error       0          3m50s
rand-1617665580-8d8nf   0/1     Completed   0          3m39s
rand-1617665760-v5ktw   0/1     Error       0          60s
rand-1617665760-xr82q   0/1     Error       0          58s
rand-1617665760-rtrhm   0/1     Error       0          48s
rand-1617665760-vdq82   0/1     Completed   0          8s
```
