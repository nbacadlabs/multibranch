variable "rg" {
  description = "resource group name"
  type = string
}

# variable "storage_account_name" {
#   description = "storage account name"
#   type = string
# }

# variable "container_name" {
#   description = "container name"
#   type = string
# }

variable "subscription_id" {
  description = "Subscription ID"
  type = string
}

# variable "tenant_id" {
#   description = "Tenant id"
#   type = string
# }

# variable "client_id" {
#   description = "Client ID"
#   type = string
# }

# variable "client_secret" {
#   description = "Client secret"
#   type = string
# }

variable "location" {
  description = "where to deployment"
  type = string
}

# variable "vm_name" { type = string }
# variable "admin_username" { type = string }
# variable "ssh_key_path" { type = string }
variable "subnet_id" { type = string }
variable "nsg_name" { type = string }
variable "subnet_name" { type = string }
variable "vnet_name" {
  description = "Nb AKS VNET name"
  type = string
}
variable "address_space" { type = list(string)}
variable "subnets" {
  type = list(object({
    name            = string
    address_prefix  = string
  }))
}
variable "tags" { type=map(string)}
variable "aks_name" { type = string }
variable "dns_prefix" { type=string }
variable "node_count" { type=number }
variable "aks_cluster_name" { type=string }
variable "node_vm_size" { type=string }
variable "vnet_cidr" { type= string }
variable "subnet_cidr" { type=string }
variable "resource_group_name" {
  type = string
}