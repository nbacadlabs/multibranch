variable "aks_name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type=string }
variable "dns_prefix" { type=string }
variable "node_count" { type=number }
variable "tags" { type=map(string) }