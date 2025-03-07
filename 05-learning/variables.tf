
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


variable "resource_group_name" {
  type = string
}
variable "vm_name" { type=string}
variable "admin_username" { type=string}
# variable "ssh_key_path" { type=string}

