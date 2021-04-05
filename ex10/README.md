# Exercise 9

You need [microk8s](https://microk8s.io/) installed to run the exercises in this repo.

```
Create a cronjob called 'rand' that starts a job which quickly returns with either a success or an error.

- Use the image 'ludwigprager/k8s-random:2'.

- Start the cronjob every 3 minutes.

- Set the environment variables
  - MODE=RANDOMFAIL
  - FAILURE_RATE=80
  which will make the job fail in 80% of all incarnations.

- The cronjob shall run no more than 2 job instances at a time.

- Once a job succeds no more jobs shall be started.

- When no job ran to success after 5 tries the cronjob run shall be marked as failed, too.

- If a job does not complete after 30 seconds it shall be terminated and considered as failed.

Use namespace 'ckad-ex10'.
```
