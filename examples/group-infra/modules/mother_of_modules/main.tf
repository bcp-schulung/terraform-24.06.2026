module "network" {
  source = "../network"

  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  tags                 = var.tags
  vnet_cidr            = var.vnet_cidr
  frontend_subnet_cidr = var.frontend_subnet_cidr
  backend_subnet_cidr  = var.backend_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
}

module "loadbalancer" {
  source = "../loadbalancer"

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tags                            = var.tags
  sku                             = var.sku
  azurerm_public_ip               = var.azurerm_public_ip
  azurerm_lb                      = var.azurerm_lb
  azurerm_lb_backend_address_pool = var.azurerm_lb_backend_address_pool
  azurerm_lb_probe                = var.azurerm_lb_probe
  azurerm_lb_rule                 = var.azurerm_lb_rule
}

module "frontend_vmss" {
  source = "../frontend-vmss"

  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  vm_size                  = var.vm_size
  subnet_id                = module.network.frontend_subnet_id
  backend_address_pool_ids = [module.loadbalancer.backend_address_pool_id]
  instance_count_min       = var.frontend_instance_count_min
  instance_count_max       = var.frontend_instance_count_max
  admin_username           = var.admin_username
  admin_password           = var.admin_password
}

module "backend_vm" {
  source = "../backend-vm"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  vm_size             = var.vm_size
  subnet_id           = module.network.backend_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "database" {
  source = "../database"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  subnet_id           = module.network.database_subnet_id
  vnet_id             = module.network.vnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
