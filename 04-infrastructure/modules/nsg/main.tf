resource "azurerm_network_security_group" "nbaks_nsg" {
  name                  = var.nsg_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  tags                  = var.tags
}

resource "azurerm_network_security_rule" "allow_sh" {
  name = "AllowSSH"
  priority = 1001
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "Internet"
  destination_address_prefix = "*"
  network_security_group_name = azurerm_network_security_group.nbaks_nsg.name
  resource_group_name = var.resource_group_name
}