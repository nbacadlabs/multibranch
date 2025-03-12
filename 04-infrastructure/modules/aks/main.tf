resource "azurerm_kubernetes_cluster" "nbaks_cluster" {
  name = var.aks_name
  location = var.location
  resource_group_name = var.resource_group_name
  dns_prefix = var.dns_prefix

  default_node_pool {
    name = "agentpool"
    node_count = var.node_count
    vm_size = "Standard_D4_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}