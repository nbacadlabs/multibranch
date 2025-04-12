#!/bin/bash

# Set the Azure subscription (optional, if you have multiple subscriptions)

az account set --subscription "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"

aks_clusters=$(az aks list --query '[].{Name:name, ResourceGroup:resourceGroup}' -o json)

# Loop through each cluster in the JSON
echo "$aks_clusters" | jq -c '.[]' | while IFS= read -r cluster; do
    # Extract Name and ResourceGroup from each cluster object
    cluster_name=$(echo "$cluster" | jq -r '.Name')
    resource_group=$(echo "$cluster" | jq -r '.ResourceGroup')

    # Debug: Output the cluster name and resource group
    echo "Cluster Name: $cluster_name"
    echo "Resource Group: $resource_group"

    # You can add any further actions you want to perform on each cluster here
    # Example: Fetch credentials for the cluster
    echo "Fetching credentials for AKS cluster: $cluster_name in Resource Group: $resource_group"
    az aks get-credentials -n "$cluster_name" -g "$resource_group" --overwrite-existing
    az vm list -d --query "[].{Name:name, PowerState:powerState}" -o table
    az aks show --resource-group "$resource_group" --name "$cluster_name" --query "agentPoolProfiles[].scaleSetEvictionPolicy" -o table
    kubectl get nodes | awk 'NR>1 {count++; if ($2=="Ready") ready++} END {print "Target Nodes:", count, "\nReady Nodes:", ready}'
    az aks nodepool list --resource-group "$resource_group" --cluster-name "$cluster_name" --query "[].{Name:name, Autoscale:enableAutoScaling}" -o table
    az aks nodepool list --resource-group "$resource_group" --cluster-name "$cluster_name" --query "[].{Name:name, OS:osType}" -o table


    # Optionally, fetch node statistics
    echo "Getting Node Statistics for $cluster_name..."
    kubectl top nodes
  


    # Optionally, fetch pod statistics
    echo "Getting Pod Statistics for $cluster_name..."
    kubectl top pods --all-namespaces

    echo "--------------------------------------"
done