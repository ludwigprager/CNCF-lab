apiVersion: v1
kind: ConfigMap
metadata:
  name: $TIER
  namespace: $NAMESPACE
data:
  nginx.conf: |
    user nginx;
    worker_processes  1;
    events {
      worker_connections  10240;
    }
    http {
      server {
          listen       $PORT;
          server_name  localhost;
          location / {
            root   /usr/share/nginx/html; #Change this line
            index  index.html index.htm;
        }
      }
    }

---

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: $TIER
  namespace: $NAMESPACE
spec:
  selector:
    matchLabels:
      app: $TIER
#  serviceName: "$TIER"
  template:
    metadata:
      labels:
        app: $TIER
    spec:
#     terminationGracePeriodSeconds: 10

      volumes:
        - name: v1
          configMap:
            name: $TIER
      containers:
      - name: $TIER
        image: $IMAGE
        ports:
        - containerPort: $PORT

        volumeMounts:
          - name: v1
            mountPath: /etc/nginx/
