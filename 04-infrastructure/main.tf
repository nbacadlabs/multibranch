module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet_name
  resource_group_name = var.rg
  location            = var.location
  address_space       = var.address_space
  subnets = [
    { name = "subnet1", address_prefix = "10.0.1.0/24" },
    { name = "subnet2", address_prefix = "10.0.2.0/24" }
  ]

  tags = var.tags
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = var.nsg_name
  resource_group_name = var.rg
  location            = var.location
  tags = var.tags
}

# module "vm" {
#   source              = "./modules/vm"
#   vm_name             = var.vm_name
#   resource_group_name = var.rg
#   location            = var.location
#   admin_username      = var.admin_username
#   ssh_key_path        = "~/.ssh/id_rsa.pub"
#   subnet_id           = module.vnet.subnet_ids["subnet1"]
#   nsg_name            = module.nsg.nsg_name
#   depends_on          = [ module.nsg ]
# }

module "aks" {
  source              = "./modules/aks"
  aks_name            = "prod-aks"
  resource_group_name = var.rg
  location            = "East US"
  dns_prefix          = "prodaks"
  node_count          = 1
  tags = {
    environment = "production"
  }
  depends_on = [ module.vnet ]
}
