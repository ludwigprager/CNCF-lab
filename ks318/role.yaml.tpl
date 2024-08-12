apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: $ROLE
  namespace: $NAMESPACE_2
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["list", "get", "create", "delete"]


---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $ROLEBINDING
  namespace: $NAMESPACE_2
subjects:
- kind: ServiceAccount
  name: $SERVICEACCOUNT
  namespace: $NAMESPACE_1
roleRef:
  kind: Role
  name: $ROLE
  apiGroup: rbac.authorization.k8s.io

