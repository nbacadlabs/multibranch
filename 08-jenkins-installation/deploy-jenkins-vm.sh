#!/bin/bash

# Define variables
export AKS_INFRA_GROUP=nbaksclust-rg
export VM_INFRA_GROUP=jenkins-vm-rg
VM_NAME=nbjenkins
ADMIN_USER=azureuser
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"  # Use absolute path for SSH key
CUSTOM_SCRIPT='{"fileUris": ["https://github.com/nbacadlabs/multibranch/raw/main/08-jenkins-installation/config-jenkins.sh"],"commandToExecute": "./config-jenkins.sh"}'

# Create resource groups if they don't exist
# az group create --name $AKS_INFRA_GROUP --location eastus
az group create --name $VM_INFRA_GROUP --location eastus

# Create a new virtual machine, generating SSH keys if not present
az vm create --resource-group $VM_INFRA_GROUP --name $VM_NAME --admin-username $ADMIN_USER --image Ubuntu2404 --ssh-key-values $SSH_KEY_PATH

# Open necessary ports (80, 22, 8080) for web and SSH traffic
az vm open-port --port 80 --resource-group $VM_INFRA_GROUP --name $VM_NAME --priority 101
az vm open-port --port 22 --resource-group $VM_INFRA_GROUP --name $VM_NAME --priority 102
az vm open-port --port 8080 --resource-group $VM_INFRA_GROUP --name $VM_NAME --priority 103

# Retrieve the public IP of the VM
ip=$(az vm list-ip-addresses --resource-group $VM_INFRA_GROUP --name $VM_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)

# Retrieve the VM ID
vm_id=$(az vm show --resource-group $VM_INFRA_GROUP --name $VM_NAME --query "id" --output tsv)

# Apply the CustomScript extension to the VM
az vm extension set \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --vm-name $VM_NAME \
  --resource-group $VM_INFRA_GROUP \
  --settings "$CUSTOM_SCRIPT"

# Print Jenkins unlock URL and key
echo "Jenkins is installed. Open a browser to http://$ip:8080"
echo "Enter the following to unlock Jenkins:"
ssh -o "StrictHostKeyChecking no" $ADMIN_USER@$ip sudo "cat /var/lib/jenkins/secrets/initialAdminPassword"
