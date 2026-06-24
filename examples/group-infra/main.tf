data "azurerm_resource_group" "main" {
  name = "rg-tf-lab"
}

# ---------------------------------------------------------------------------
# Customer A — add more module blocks below to onboard additional customers.
# Each block gets its own isolated VNet, subnets, LB, VMSS, VM and database.
# ---------------------------------------------------------------------------
module "customer_a" {
  source = "./modules/mother_of_modules"

  name                = "customer-a"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  tags = {
    environment = "prod"
    customer    = "customer-a"
    managed_by  = "terraform"
  }

  # Networking — each customer must use a unique, non-overlapping address space
  vnet_cidr            = ["10.0.0.0/16"]
  frontend_subnet_cidr = ["10.0.1.0/24"]
  backend_subnet_cidr  = ["10.0.2.0/24"]
  database_subnet_cidr = ["10.0.3.0/24"]

  # Load balancer resource names
  azurerm_public_ip               = "pip-customer-a"
  azurerm_lb                      = "lb-customer-a"
  azurerm_lb_backend_address_pool = "lbbap-customer-a"
  azurerm_lb_probe                = "lbprobe-customer-a"
  azurerm_backend_address_pool_ids = "lbbap-customer-a"
  azurerm_lb_rule                 = "lbrule-customer-a"

  # Compute
  vm_size                    = "Standard_B2s"
  frontend_instance_count_min = 1
  frontend_instance_count_max = 5

  # Credentials — provided via variables.tf / terraform.tfvars
  admin_username = "azureuser"
  admin_password = var.admin_password
}
