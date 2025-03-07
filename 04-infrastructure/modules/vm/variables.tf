variable "vm_name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_username" { type = string }
variable "ssh_key_path" { type = string }
variable "subnet_id" { type = string }

variable "public_ip_name" {
  description = "Public IP for Azure DevOPS Agent"
  type = string
  default = "jenkinspip"
}
variable "nsg_name" {
  description = "Security group name assigned to the agent vm"
  type = string
}