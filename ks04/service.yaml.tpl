apiVersion: v1
kind: Service
metadata:
  name: $SERVICE
  namespace: default
spec:
  ports:
  - port: $PORT
    protocol: TCP
    targetPort: $PORT
  selector:
    $KEY: $VALUE
