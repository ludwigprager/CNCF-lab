# CKA/CKAD hands-on exercises

## Overview

Train for CKA and CKAD on a local kind kubernetes cluster.  
Similar to 'killer.sh' or 'killercoda.com' but completely free and on your PC or laptop or VM.

## Prerequisites
- docker
- envsubst
- base64
- ssh-keygen


## Step-by-Step Guide
1. Clone the repository

```
git clone https://github.com/ludwigprager/CKA-CKAD-exercises.git
```

2. Start a randomly selected exercise

```
./CKA-CKAD-exercises/run-random-task.sh
```

## Time Saving Settings

```
sudo yum -y install bash-completion
source <(kubectl completion bash | sed 's/kubectl/k/g' )
source /etc/bash_completion
alias k=kubectl

drc="dry-run=client"
drs="dry-run=server"

ns() {
  kubectl config set-context --current --namespace=$1
}

```

# CKA Domains & Competencies
(from: https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)

### Storage 10%
- Understand storage classes, persistent volumes
- Understand volume mode, access modes and reclaim policies for volumes
- Understand persistent volume claims primitive
- Know how to configure applications with persistent storage
### Troubleshooting 30%
- Evaluate cluster and node logging
- Understand how to monitor applications
- Manage container stdout & stderr logs
- Troubleshoot application failure
- Troubleshoot cluster component failure
- Troubleshoot networking
### Workloads & Scheduling 15%
- Understand deployments and how to perform rolling update and rollbacks
- Use ConfigMaps and Secrets to configure applications
- Know how to scale applications
- Understand the primitives used to create robust, self-healing, application deployments
- Understand how resource limits can affect Pod scheduling
- Awareness of manifest management and common templating tools
### Cluster Architecture, Installation & Configuration25%
- Manage role based access control (RBAC)
- Use Kubeadm to install a basic cluster
- Manage a highly-available Kubernetes cluster
- Provision underlying infrastructure to deploy a Kubernetes cluster
- Perform a version upgrade on a Kubernetes cluster using Kubeadm
    - [kw101](./kw101)
- Implement etcd backup and restore
### Services & Networking 20%
- Understand host networking configuration on the cluster nodes
- Understand connectivity between Pods
- Understand ClusterIP, NodePort, LoadBalancer service types and endpoints
- Know how to use Ingress controllers and Ingress resources
- Know how to configure and use CoreDNS
- Choose an appropriate container network interface plugin


## Multi-Container Pods (10%)
## Pod Design (20%)
[Exercise 01: requests and limits](./ex01/)  
[Exercise 02: environment variables](./ex2/)  
[Exercise 07: labels and annotations](./ex7/)  
[Exercise 10: cron jobs](./ex10/)  
## State Persistence (8%)
[Exercise 05: hostPath](./ex5/)  
[Exercise 06: hostPath in a persistent volume](./ex6/)  
## Configuration (18%)
[Exercise 03: rollout, rollback, record](./ex3/)  
[Exercise 04: rollout](./ex4/)  
## Observability (18%)
[Exercise 09: readiness and liveliness](./ex09/)  
## Services and Networking (13%)
[Exercise 08: ClusterIP and network policy](./ex08/)  

---

#CKA Curriculum

https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/

## Exercise Origins

- [ CKA Practice Exam (mock questions) - Real 30 Practice questions and Answers ]( https://www.youtube.com/watch?v=Zm5sy6otLGc )  
    - kw201 Q1 Deploy a pod called nginxpod with image nginx in controlplane, make sure pod is not scheduled in worker node.
    - kw202 Q2 Expose an existing pod called '$POD' as a service. Service should be '$SERVICE'.
    - kw203 Q3 Expose an existing pod called '$POD'. service name as '$SERVICE', service should access through Nodeport
    - kw204 Q4. you can find an existing deployment $DEPLOYMENT in $NAMESPACE namespace, scale down the replicas to $REPLICAS and change the image to $IMAGE
    - kw205 Q5, Auto scale the existing deployment '$DEPLOYMENT' in '$NAMESPACE' namespace at ${CPU}% of pod CPU usage, and set Minimum replicas=$MIN and Maximum replicas=$MAX.
    - kw206 Q6 Expose existing deployment in $NAMESPACE namespace namd as $DEPLOYMENT through Nodeport and Nodeport service should be $SERVICE
    - kw207 Q7 you can find a pod named $POD in the default namespace, please check the status of the pod and troubleshoot, you can recreate the pod if you want 
    - kw208 Q8 Create a new PersistentVolume name web-pv. It should have a capacity of $CAPACITY, accesMode $ACCESSMODE, hostPath $HOSTPATH and no storageClassName defined.

    - kw208 Q8 Deploy a pod with the following specifcations:
    - kw209 Q9 Create a pod name my-busybox with the busybox:1.31.1 image. The pod should ru a sleep command for 4800 seconds. Verify that the pod is running in node worker1
    - kw210 Q10 the cluster run a three-tier web application: a frontend tier (port 80), an application  tier (port 8080) and a backend tier (3306). The security team has mandated that the backend tier should only be accessible from the application tier.
    - kw211 Q11 Pods run in multiple namespaces. The security team has mandated that the $POD1 on $NAMESPACE1 namespace only accessible from the $POD2 in $NAMESPACE2.
    - kw212 Q12 you can find a pod named multi-pod is running in the cluster and that is logging to a volume. You need to insert a sidecar container into the pod that will also read the logs from the volume using this command $COMMAND. 
    - kw213 Q13 Create a cronjob for running every 2 minutes with $IMAGE image. The jo name should be $JOB and it should print the current date and time to the console. After running the job save any one of the pod logs to below path $PATH.








- [ CKA Certification SURE SHOT Questions | TOP 10 EXAM Questions | Must watch before exam - PART 1 ]( https://www.youtube.com/watch?v=vVIcyFH20qU )
    kw1...  
    - kw101 Q1 Given a cluster running version 1.26.0, upgrade the master node and worker node to version 1.27.0. e sure to drain the master and worker node efore upgrading it and uncordon it after the upgrade.
    - kw102 Q2 Create a snapshot of ETCD and save it to /root/backup/etcd-backup-new.db. Restore an old snapshot located at /root/backup/etcd-backup-old.db  to /var/lib/etcd-backup
    - kw103 Q3 Join cka-$(whoami)-worker worker node to the cluster and you hav to deploy a pod in the cka-$(whoami)-worker, pod name should be $POD and image should be $IMAGE
    - kw105 Q5  Mark the worker node cka-$(whoami)-worker as unschedulable and reschedule all the pods running on it.



- [ kodekloud CKA course ](https://kodekloud.com/courses/certified-kubernetes-administrator-cka/)
    kk...  
    kk1xx: kodekloud/CKA/15 Mock Exams/243 Solution - CKA Mock Exam 1 (optional)-saq1a72kpg.bin
- [ udemy 'Pass the CKA exam with these 100 practice questions'](https://www.udemy.com/course/learn-kubernetes-with-100-questions)  
    ex...
    - ex011 Q11: Create a new serviceaccount, clusterrole and clusterrolebinding. Make it possible to list the persisten volumes and create a pod with the new service account.
    - ex0301 Q0301: Take a backup of ETCD in file /tmp/snapshot.db
    - ex0302 Q0302: Restore ETCD using the backup file in /tmp/ex0302.snapshot.db into directory /var/lib/ex0302

    - ex052 Q52: Use JSONPATH to get a list of all the pods with name and namespace.

- [dgkanatsios d.configuration / secrets](https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#secrets)
    - secret1 Q1: Create a secret called mysecret with the values password=mypass
    - secret6 Q6: Create a Secret named 'ext-service-secret' in the namespace 'secret-ops'. Then, provide the key-value pair API_KEY=LmLHbYhsgWZwNifiqaRorH8T as literal.
    - secret7 Q7: Create a Pod named 'consumer' with the image 'nginx' in the namespace 'secret-ops' and consume the Secret as an environment variable. Then, open an interactive shell to the Pod, and print all environment variables.
    - secret8 Q8: Create a Secret named 'my-secret' of type 'kubernetes.io/ssh-auth' in the namespace 'secret-ops'. Define a single key named 'ssh-privatekey', and point it to the file 'id_rsa' in this directory.
    - secret9 Q9: Create a Pod named 'consumer' with the image 'nginx' in the namespace 'secret-ops', and consume the Secret as Volume. Mount the Secret as Volume to the path /var/app with read-only access. Open an interactive shell to the Pod, and render the contents of the file.


- [dgkanatsios d.configuration / configmaps](https://github.com/dgkanatsios/CKAD-exercises/blob/main/d.configuration.md#configmaps)
    - cm1 Q1: Create a configmap named config with values foo=lala,foo2=lolo
    - cm2 Q2: Create and display a configmap from a .env file
    - cm3 Q3: Create and display a configmap from a file, giving the key 'special'
    - cm4 Q4: Create a configMap called 'options' with the value var5=val5. Create a new nginx pod that loads the value from variable 'var5' in an env variable called 'option'
    - cm5 Q5: Create a configMap 'anotherone' with values 'var6=val6', 'var7=val7'. Load this configMap as env variables into a new nginx pod
    - cm6 Q6: Create a configMap 'cmvolume' with values 'var8=val8', 'var9=val9'. Load this as a volume inside an nginx pod on path '/etc/lala'. Create the pod and 'ls' into the '/etc/lala' directory.


## By Topic
### Network Policies
- kk35
- kw210
- kw211



## More References
https://gist.github.com/bakavets/05681473ca617579156de033ba40ee7a  


## MISC

### List all services in the default namespace using field selectors

<details><summary>show</summary>
<p>

```bash
kubectl get svc --field-selector metadata.namespace=default
```

</p>
</details>

### List the services on your Linux operating system that are associated with Kubernetes

<details><summary>show</summary>
<p>

```bash
systemctl list-unit-files --type service --all | grep kube
```

</p>
</details>

### List the status of the kubelet service running on the Kubernetes node

<details><summary>show</summary>
<p>

```bash
systemctl status kubelet
```

</p>
</details>

### List all the services created in your Kubernetes cluster, across all namespaces

<details><summary>show</summary>
<p>

```bash
kubectl get svc -A
```

</p>
</details>

