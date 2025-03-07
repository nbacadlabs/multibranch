resource "azurerm_resource_group" "nbtest-rg" {
  name     = "nbtest-rg"
  location = var.location
}

resource "azurerm_virtual_network" "nbtest-netw" {
  name                = "example-network"
  location            = azurerm_resource_group.nbtest-rg.location
  resource_group_name = azurerm_resource_group.nbtest-rg.name
  address_space       = ["10.0.0.0/16"]

  depends_on = [ azurerm_resource_group.nbtest-rg ]
}

resource "azurerm_subnet" "nbtest-subnet" {
  name                 = "nbtest-snet-1"
  resource_group_name  = azurerm_resource_group.nbtest-rg.name
  virtual_network_name = azurerm_virtual_network.nbtest-netw.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nbtest-sg" {
  name                = "nbtest-nsg"
  location            = azurerm_resource_group.nbtest-rg.location
  resource_group_name = azurerm_resource_group.nbtest-rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nbtest-sg.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "AllowHTTP"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nbtest-sg.name
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.nbtest-rg.location
  resource_group_name = azurerm_resource_group.nbtest-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.nbtest-rg.location
  resource_group_name = azurerm_resource_group.nbtest-rg.name

  ip_configuration {
    name                          = "vm-nic-config"
    subnet_id                     = azurerm_subnet.nbtest-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.nbtest-sg.id
}

resource "azurerm_linux_virtual_machine" "nbaks_vm" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  admin_password        = "+Laravan2010"
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  disable_password_authentication = false

  # admin_ssh_key {
  #   username   = var.admin_username
  #   public_key = file("$SSH_KEY")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(file("jenkins-install.sh"))
  # custom_data = filebase64("cloud_init.yaml")
}

