#!/bin/bash

# Set Azure subscription
az account set --subscription "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
AZ_SUBSCRIPTION_ID="a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
# Get all AKS clusters in the subscription
aks_clusters=$(az aks list --query '[].{Name:name, ResourceGroup:resourceGroup}' -o json)

# Loop through each AKS cluster
echo "$aks_clusters" | jq -c '.[]' | while IFS= read -r cluster; do
    # Extract cluster name and resource group
    cluster_name=$(echo "$cluster" | jq -r '.Name')
    resource_group=$(echo "$cluster" | jq -r '.ResourceGroup')

    echo "Processing Cluster: $cluster_name (Resource Group: $resource_group)"
    
    # Get all node pools in the cluster
    node_pools=$(az aks nodepool list --resource-group "$resource_group" --cluster-name "$cluster_name" --query '[].{Name:name}' -o json)

    # Loop through each node pool
    echo "$node_pools" | jq -c '.[]' | while IFS= read -r nodepool; do
        nodepool_name=$(echo "$nodepool" | jq -r '.Name')

        echo "Processing Node Pool: $nodepool_name"

        # Fetch nodes in the current node pool
        NODES=$(kubectl get nodes -o json | jq -r '.items[] | select(.metadata.labels["agentpool"]=="'"$nodepool_name"'") | .metadata.name')

        for NODE in $NODES; do
            echo "Node Name: $NODE"

            # Get CPU and Memory usage
            CPU_AVG=$(kubectl top node "$NODE" --no-headers | awk '{print $2}')
            MEM_RSS=$(kubectl top node "$NODE" --no-headers | awk '{print $4}')

            # Get Memory Working Set Percentage
            MEM_USAGE=$(kubectl top node "$NODE" --no-headers | awk '{print $4}')
            TOTAL_MEM=$(kubectl get node "$NODE" -o json | jq -r '.status.capacity.memory' | sed 's/Ki//')

            if [ -n "$TOTAL_MEM" ] && [ "$TOTAL_MEM" -ne 0 ]; then
                MEM_WORKING_SET=$(echo "scale=2; ($MEM_USAGE * 100) / $TOTAL_MEM" | bc 2>/dev/null)
            else
                MEM_WORKING_SET="N/A"
            fi

            # Get VM Size and Type
            VM_SIZE=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "vmSize" -o tsv)

            # Get Power State
            NODE_VM=$(az vm list --query "[?contains(name,'$NODE')].{Name:name,PowerState:powerState}" -o json | jq -r '.[0].PowerState')

            # Get Scale Method
            SCALE_METHOD=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "enableAutoScaling" -o tsv)
            if [ "$SCALE_METHOD" = "true" ]; then
                SCALE_METHOD="Autoscaling Enabled"
            else
                SCALE_METHOD="Manual Scaling"
            fi

            # Get Target Nodes and Ready Nodes
            TARGET_NODES=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "count" -o tsv)
            READY_NODES=$(kubectl get nodes | grep -c " Ready")

                        # Get Min and Max Node Count for Autoscaling
            MIN_NODES=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "minCount" -o tsv)
            MAX_NODES=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "maxCount" -o tsv)

               # Get Core CPU Count
            CORE_CPU=$(kubectl get node "$NODE" -o json | jq -r '.status.capacity.cpu')

            # Get Max Memory (Converted to MiB)
            MAX_MEMORY=$(echo "scale=2; $TOTAL_MEM / 1024" | bc 2>/dev/null)

            # Get Autoscaling Status
            AUTOSCALING_STATUS=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "enableAutoScaling" -o tsv)

            # Get Mode (System/User)
            NODE_MODE=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "mode" -o tsv)

            # Get Operating System
            OS_TYPE=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "osType" -o tsv)

            # Get Core CPU Count
            CORE_CPU=$(kubectl get node "$NODE" -o json | jq -r '.status.capacity.cpu')

            # Get Max Memory (Converted to MiB)
            MAX_MEMORY=$(echo "scale=2; $TOTAL_MEM / 1024" | bc 2>/dev/null)

            # Get OS Disk Size
            OS_DISK_SIZE=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "osDiskSizeGb" -o tsv)

            # Get Max Pods per Node
            MAX_PODS=$(az aks nodepool show --resource-group "$resource_group" --cluster-name "$cluster_name" --name "$nodepool_name" --query "maxPods" -o tsv)

            # Get 30-day CPU & Memory Average from Azure Monitor
            CPU_30D_AVG=$(az monitor metrics list --resource "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$resource_group/providers/Microsoft.ContainerService/managedClusters/$cluster_name" \
                --metric "node_cpu_usage_percentage" \
                --aggregation Average \
                --interval PT1H \
                --query "value[].timeseries[].data[].average" -o tsv | awk '{sum+=$1; count++} END {if (count>0) print sum/count; else print "N/A"}')

            MEM_30D_AVG=$(az monitor metrics list --resource "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$resource_group/providers/Microsoft.ContainerService/managedClusters/$cluster_name" \
                --metric "node_memory_working_set_percentage" \
                --aggregation Average \
                --interval PT1H \
                --query "value[].timeseries[].data[].average" -o tsv | awk '{sum+=$1; count++} END {if (count>0) print sum/count; else print "N/A"}')

            MEM_RSS_30D_AVG=$(az monitor metrics list --resource "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$resource_group/providers/Microsoft.ContainerService/managedClusters/$cluster_name" \
                --metric "node_memory_rss_percentage" \
                --aggregation Average \
                --interval PT1H \
                --query "value[].timeseries[].data[].average" -o tsv | awk '{sum+=$1; count++} END {if (count>0) print sum/count; else print "N/A"}')

            # Display Node Information
            echo "CPU (Avg): $CPU_AVG"
            echo "Memory RSS (Avg): $MEM_RSS"
            echo "Memory Working Set %: $MEM_WORKING_SET%"
            echo "VM Size & Type: $VM_SIZE"
            echo "Power State: $NODE_VM"
            echo "Scale Method: $SCALE_METHOD"
            echo "Target Nodes: $TARGET_NODES"
            echo "Ready Nodes: $READY_NODES"
            echo "Autoscaling Status: $AUTOSCALING_STATUS"
            echo "Mode: $NODE_MODE"
            echo "Min Nodes: $MIN_NODES"
            echo "Max Nodes: $MAX_NODES"
            echo "Core CPU: $CORE_CPU"
            echo "Max Memory: ${MAX_MEMORY}MiB"
            echo "Operating System: $OS_TYPE"
            echo "Core CPU: $CORE_CPU"
            echo "Max Memory: ${MAX_MEMORY}MiB"
            echo "OS Disk Size: ${OS_DISK_SIZE}GB"
            echo "Max Pods per Node: $MAX_PODS"
            echo "30-Day Avg CPU Usage: $CPU_30D_AVG%"
            echo "30-Day Avg Memory Working Set: $MEM_30D_AVG%"
            echo "30-Day Avg Memory RSS: $MEM_RSS_30D_AVG%"
            echo "--------------------------------------------"

        done # End node loop
    done # End node pool loop
done # End cluster loop
