output vnet_id {
  description = "Generated VNET ID"
  value       = azurerm_virtual_network.nbaks_vnet.id
}

output subnet_ids {
  description = "Generated subnet IDs map"
  value       = { for subnet in azurerm_subnet.nbaks_subnet : subnet.name => subnet.id }
}