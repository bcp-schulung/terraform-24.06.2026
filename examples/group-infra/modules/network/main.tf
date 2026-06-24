resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "snet-${var.name}-frontend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.frontend_subnet_cidr
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-${var.name}-backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.backend_subnet_cidr
}

resource "azurerm_subnet" "database" {
  name                 = "snet-${var.name}-database"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.database_subnet_cidr

  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
