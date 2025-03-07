#!/bin/bash

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name  nbkeyvault01 --query value -o tsv)
