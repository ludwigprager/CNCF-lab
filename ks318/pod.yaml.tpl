apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  serviceAccountName: $SERVICEACCOUNT
  volumes:
  - name: token-volume
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
#         audience: my-audience
