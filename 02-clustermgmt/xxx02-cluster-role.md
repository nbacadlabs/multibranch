# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRole
# metadata:
#   name: admin
# rules:
#   - apiGroups: [""]
#     resources: ["pods", "pods/log", "services", "nodes", "namespaces", "secrets", "configmaps", "persistentvolumeclaims"]
#     verbs: ["get", "watch", "list", "create", "delete", "update", "patch"]
#   - apiGroups: ["apps"]
#     resources: ["deployments", "statefulsets"]
#     verbs: ["get", "watch", "list", "create", "delete", "update", "patch"]
#   - apiGroups: ["batch"]
#     resources: ["jobs", "cronjobs"]
#     verbs: ["get", "watch", "list", "create", "delete", "update", "patch"]
#   - apiGroups: ["rbac.authorization.k8s.io"]
#     resources: ["roles", "rolebindings"]
#     verbs: ["get", "list", "watch"]


