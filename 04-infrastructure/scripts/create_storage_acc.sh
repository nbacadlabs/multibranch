#!/bin/bash

#-----------create RG---------------
# RESOURCE_GROUP_NAME=tfstate
# STORAGE_ACCOUNT_NAME=tfstatenb1010
# CONTAINER_NAME=nbtfstate
LOCATION="eastus"
AKS_RG="nbaksclust-rg"
AKS_NAME="nbakscluster01"


# Create resource group
az group create --name $AKS_RG --location $LOCATION

az aks create \
  --resource-group $AKS_RG \
  --name $AKS_NAME \
  --node-vm-size Standard_D2s_v3 \
  --node-count 1 \
  --generate-ssh-keys

# az aks create \
# --resource-group $AKS_RG \
# --name $AKS_NAME \
# --node-count 2 \
# --generate-ssh-keys 
# --attach-acr $ACRNAME
# Create storage account
# az storage account create \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --name $STORAGE_ACCOUNT_NAME \
#     --sku Standard_LRS \
#     --encryption-services blob

# Retrieve storage account key
# ACCOUNT_KEY=$(az storage account keys list \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --account-name $STORAGE_ACCOUNT_NAME \
#     --query '[0].value' --output tsv)

# Create blob container with authentication
# az storage container create \
#     --name $CONTAINER_NAME \
#     --account-name $STORAGE_ACCOUNT_NAME \
#     --account-key $ACCOUNT_KEY

#-----------create the SP-------------
# SERVICE_PRINCIPAL_NAME="nbsp102"

# SP_INFO=$(az ad sp create-for-rbac \
#     --name $SERVICE_PRINCIPAL_NAME \
#     --query "{appId:appId, password:password, tenant:tenant}" \
#     --output json)

# Extract Service Principal info
# SP_APP_ID=$(echo $SP_INFO | jq -r .appId)
# SP_PASSWORD=$(echo $SP_INFO | jq -r .password)
# SP_TENANT_ID=$(echo $SP_INFO | jq -r .tenant)

# echo "Service Principal Created:"
# echo "App ID: $SP_APP_ID"
# echo "Password: $SP_PASSWORD"
# echo "Tenant ID: $SP_TENANT_ID"

#-----------create the Key Vault (Optional)---------
# KEYVAULT_NAME="nbkvs101"
# SECRET_NAME="nbkvsecrets101"

# # Create Key Vault
# az keyvault create --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION

# # Store Service Principal credentials as secrets
# az keyvault secret set --vault-name $KEYVAULT_NAME --name "sp-app-id" --value "$SP_APP_ID"
# az keyvault secret set --vault-name $KEYVAULT_NAME --name "sp-password" --value "$SP_PASSWORD"
# az keyvault secret set --vault-name $KEYVAULT_NAME --name "sp-tenant-id" --value "$SP_TENANT_ID"

# echo "Storage Account: $STORAGE_ACCOUNT_NAME"
# echo "Container: $CONTAINER_NAME"

# echo "Key Vault: $KEYVAULT_NAME"