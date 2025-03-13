#!/bin/bash

RESOURCEGROUP=nbaksclust-rg
LOCATION=eastus
ACRNAME=nbacr013


#create the container registry
az group create --name $RESOURCEGROUP --location $LOCATION

az acr create --resource-group $RESOURCEGROUP --name $ACRNAME --sku Basic

# #build and push product service
# az acr build --registry nbacr012 --image ~/aks-store-demo/product-service:latest ./src/product-service/

# #build and push order service
# az acr build --registry nbacr012 --image ~/aks-store-demo/order-service:latest ./src/order-service/

# #build and push store service
# az acr build --registry nbacr012 --image ~/aks-store-demo/store-front:latest ./src/store-front/
echo "Storage Account: $INFRA_RG_NAME"
echo "Storage Account: $ACRNAME"