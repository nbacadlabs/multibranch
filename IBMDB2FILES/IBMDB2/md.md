

cat << EOF | kubectl create -f - 
apiVersion: operators.coreos.com/v1 
kind: OperatorGroup 
metadata: 
  name: db2u-operator-group 
  namespace: db2u 
spec: 
  targetNamespaces: 
  - db2u
EOF

cat << EOF | kubectl create -f - 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-db2uoperator-catalog-subscription
  namespace: db2u
  generation: 1
spec:
  channel: v110509.0
  name: db2u-operator
  installPlanApproval: Automatic
  source: ibm-db2uoperator-catalog
  sourceNamespace: olm
  startingCSV: db2u-operator.v110509.0.1
EOF

kubectl get pods -n db2u | grep db2u-operator