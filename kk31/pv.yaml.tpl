apiVersion: v1
kind: PersistentVolume
metadata:
  name: $TASK
  labels:
    task: $TASK
spec:
# storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $TASK
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
