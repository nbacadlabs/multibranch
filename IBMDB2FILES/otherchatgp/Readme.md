



---------------------------------------------
| Resource    |  	Required    |	Notes   |
|-------------|-----------------|-----------|
| BlockBlobStorage acct	    |   ✅ Yes |	For azuredisk provisioning (data, logs, etc.)|
| FileStorage acct  |	✅ Yes  | For azurefile-nfs provisioning (shared configs) |
| azuredisk-premium SC  |	✅ Yes  |	Needed by the operator for Db2 volumes |
| azurefile-nfs SC  |	✅ Yes  |	Needed for shared configuration volumes |


### Installation steps
1. apply the storageclass
2. apply the nf-file-storageClass
3. create olm namespace
4. apply the creds and other configs
5. create catalogSource
6. create db2u namespace
7. apply the operatorGroup
8. apply the subscription

### check db2-operator pod
kubectl get pods -n db2u | grep db2u-operator   # make sure it is running before applying the db2instance
kubectl get db2uinstance -n db2u ${DB2U_INSTANCE}

#connect to the db2 server
kubectl -n db2u exec -it c-db2oltp-test-db2u-0 -c db2u -- bash

### login to the db2 server
su - db2inst1 

### connect to the database
db2 connect to bludb

### Dynamic pod detection
POD=$(kubectl get pods -n db2u | grep db2u-0 | awk '{print $1}')
kubectl -n db2u exec -it $POD -c db2u -- bash
