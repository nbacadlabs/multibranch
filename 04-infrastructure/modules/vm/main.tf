# # resource "azurerm_linux_virtual_machine" "nbaks_vm" {
# #   name                  = var.vm_name
# #   resource_group_name   = var.resource_group_name
# #   location              = var.location
# #   size                  = "Standard_DS1_v2"
# #   admin_username        = var.admin_username
# #   disable_password_authentication = false
# #   network_interface_ids = [azurerm_network_interface.nbaks-int.id]

# #   admin_ssh_key {
# #     username   = var.admin_username
# #     public_key = file(var.ssh_key_path)
# #   }

# #   os_disk {
# #     caching              = "ReadWrite"
# #     storage_account_type = "Standard_LRS"
# #   }

# #   identity {
# #     type = "SystemAssigned"
# #   }

# #   source_image_reference {
# #     publisher = "canonical"
# #     offer     = "0001-com-ubuntu-server-focal"
# #     sku       = "20_04-lts-gen2"
# #     version   = "latest"
# #   }

# #   custom_data = filebase64("modules/vm/cloud_init.yaml")
# # }
# resource "azurerm_network_security_group" "nbvm-nsg" {
#   name                = "nbvm-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_network_interface" "nbaks-int" {
#   name                = "${var.vm_name}-nic"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = var.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }


# resource "azurerm_network_security_rule" "allow_ssh" {
#   name                        = "AllowSSH"
#   priority                    = 1000
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.nbvm-nsg.name
# }

# resource "azurerm_network_security_rule" "allow_http" {
#   name                        = "AllowHTTP"
#   priority                    = 1010
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.nbvm-nsg.name
# }

# resource "azurerm_public_ip" "vm_pip" {
#   name                = "vm-public-ip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_public_ip" "vm_pip1" {
#   name                = "vm-public-ip1"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_network_interface" "vm_nic" {
#   name                = "vm-nic"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "vm-nic-config"
#     subnet_id                     = var.subnet_id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm_pip.id
#   }
# }

# resource "azurerm_network_interface" "vm_nic1" {
#   name                = "vm-nic1"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "vm-nic-config"
#     subnet_id                     = var.subnet_id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm_pip1.id
#   }
# }

# resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc" {
#   network_interface_id      = azurerm_network_interface.vm_nic.id
#   network_security_group_id = azurerm_network_security_group.nbvm-nsg.id
# }


# resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc1" {
#   network_interface_id      = azurerm_network_interface.vm_nic1.id
#   network_security_group_id = azurerm_network_security_group.nbvm-nsg.id
# }

# resource "azurerm_linux_virtual_machine" "nbaks_vm" {
#   name                  = var.vm_name
#   resource_group_name   = var.resource_group_name
#   location              = var.location
#   size                  = "Standard_DS1_v2"
#   admin_username        = var.admin_username
#   network_interface_ids = [azurerm_network_interface.vm_nic.id]

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file(var.ssh_key_path)
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   source_image_reference {
#     publisher = "canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts-gen2"
#     version   = "latest"
#   }

#   custom_data = base64encode(file("${path.module}/config-jenkins.sh"))
#   # custom_data = filebase64("~/terraform/azure-infra/modules/vm/cloud_init.yaml")
# }



# # resource "azurerm_linux_virtual_machine" "nbaks_vm1" {
# #   name                  = "nbjenkins-slave"
# #   resource_group_name   = var.resource_group_name
# #   location              = var.location
# #   size                  = "Standard_DS1_v2"
# #   admin_username        = var.admin_username
# #   network_interface_ids = [azurerm_network_interface.vm_nic1.id]

# #   admin_ssh_key {
# #     username   = var.admin_username
# #     public_key = file(var.ssh_key_path)
# #   }

# #   os_disk {
# #     caching              = "ReadWrite"
# #     storage_account_type = "Standard_LRS"
# #   }

# #   identity {
# #     type = "SystemAssigned"
# #   }

# #   source_image_reference {
# #     publisher = "canonical"
# #     offer     = "0001-com-ubuntu-server-focal"
# #     sku       = "20_04-lts-gen2"
# #     version   = "latest"
# #   }

# #   # custom_data = base64encode(file("jenkins-install.sh"))
# #   custom_data = filebase64("~/terraform/azure-infra/modules/vm/cloud_init.yaml")
# # }