#!/bin/bash

RESOURCE_GROUP="nbdb2u-aks-cluster"
LOCATION="eastus"
BLOCK_STORAGE_ACCOUNT="db2blockstorage01"
FILE_STORAGE_ACCOUNT="db2filestorage01"
NUM_NODES=1
NODE_VM_SIZE=Standard_D8as_v4
NODE_POOL=npdb2demo
CLUSTER=aks-db2-demo-eastus-001
SUBSCRIPTION_ID=a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf
PRINCIPAL_ID=db2u

#create the resource group
az group create \
--name $RESOURCE_GROUP \
--location $LOCATION

#create the aks cluster
az aks create \
--resource-group $RESOURCE_GROUP \
--name ${CLUSTER} \
--vm-set-type VirtualMachineScaleSets \
--node-count 3 \
--node-vm-size Standard_D2_v3 \
--generate-ssh-keys \
--load-balancer-sku standard

#add node pools
az aks nodepool add \
--resource-group $RESOURCE_GROUP \
--cluster-name $CLUSTER \
--name $NODE_POOL \
--node-count $NUM_NODES \
--node-vm-size $NODE_VM_SIZE


# set subscription
az account set --subscription $SUBSCRIPTION_ID

# get the kubecconfig file
az aks get-credentials \
--resource-group $RESOURCE_GROUP \
--name $CLUSTER \
--overwrite-existing

# Block storage account (Premium SSD for disk volumes)
az storage account create \
  --name $BLOCK_STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Premium_LRS \
  --kind BlockBlobStorage

  # File storage account (Premium Files for NFS)
az storage account create \
  --name $FILE_STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Premium_LRS \
  --kind FileStorage

#update drivers
az aks update -n ${CLUSTER} -g ${RESOURCE_GROUP} --enable-disk-driver --enable-file-driver

# kubectl create namespace olm

# curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0

# kubectl get pods -n olm