#!/bin/bash

LOCATION="eastus"
AKS_RG="nbaksclust-rg MC_nbaksclust-rg_nbakscluster01_eastus NetworkWatcherRG nbapim-rg-dominant-titmouse"
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


