#!/bin/bash

LOCATION="eastus"
AKS_RG="rg-db2-demo-eastus-001 nbdb2u-aks-cluster MC_nbdb2u-aks-cluster_aks-db2-demo-eastus-001_eastus NetworkWatcherRG rg-db2-aks nbdb2u-rg-01 MC_rg-db2-aks_db2-aks-cluster_eastus MC_nbdb2u-rg-01_nbdb2u-cluster-01_eastus DefaultResourceGroup-EUS"
AKS_NAME="nbakscluster01"

# Delete resource groups if they exist
for rg in $AKS_RG; do
    echo "Checking resource group: $rg"
    
    # Suppress all output and errors from az group show
    az group show --name "$rg" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Deleting resource group: $rg"
        az group delete --name "$rg" --yes --no-wait
        echo "==========================================="
    else
        echo "Resource group '$rg' not found. Skipping..."
        echo "==========================================="
    fi
done


