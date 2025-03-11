# Azure Subscription and Authentication
subscription_id  = "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"

# # Resource Group and Storage Account for Backend

# storage_account_name = "tfbackendstorage"
# container_name       = "terraform-state"

# Deployment Location
rg="nbaksclust-rg"
location = "East US"
# Virtual Network (VNet) and Subnet Configuration
vnet_name      = "prod-vnet"
address_space  = ["10.0.0.0/16"]
vnet_cidr      = "10.0.0.0/16"
# public_ip_name = "jenkpip"

subnet_name  = "prod-subnet"
subnet_cidr  = "10.0.1.0/24"
subnets = [
  {
    name           = "prod-subnet"
    address_prefix = "10.0.1.0/24"
  }
]

# Network Security Group (NSG)
nsg_name = "prod-nsg"

# Virtual Machine (Jenkins)
vm_name        = "prod-jenkins-vm"
admin_username = "azureuser"
ssh_key_path   = "~/.ssh/id_rsa.pub"
subnet_id      = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/tfstate-rg/providers/Microsoft.Network/virtualNetworks/prod-vnet/subnets/prod-subnet"

# Azure Kubernetes Service (AKS)
aks_name        = "prod-aks"
aks_cluster_name = "prod-aks-cluster"
dns_prefix      = "prodaks"
node_count      = 2
node_vm_size    = "Standard_D2s_v3"

# Tags (Metadata)
tags = {
  environment = "production"
  owner       = "Nexgbits"
}
resource_group_name = "nbaksclust-rg"


