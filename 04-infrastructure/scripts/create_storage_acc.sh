#!/bin/bash

#-----------create RG---------------
RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstatenbs1004
CONTAINER_NAME=nbtfstate



# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

#-----------create the SP-------------
SERVICE_PRINCIPAL_NAME="nbsp102"

SP_INFO=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --query "{appId:appId, password:password, tenant:tenant}" --output json)

#-----------create teh keyvaul---------
# KEYVAULT_NAME="nbkvs101"
# SECRET_NAME="nbkvsecrets101"

# #extract information for JSON output
# SP_APP_ID=$(echo $SP_INFO | jq -r .appId)
# SP_PASSWORD=$(echo $SP_INFO | jq -r .password)
# SP_TENANT_ID=$(echo $SP_INFO | jq -r .tenant)

# az keyvault create --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location eastus         #create the keyvault


