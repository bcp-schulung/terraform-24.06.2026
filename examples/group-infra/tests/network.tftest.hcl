# Tests for the network module.
# Uses mock_provider so no real Azure credentials or API calls are needed.
mock_provider "azurerm" {}

# ── Naming convention ────────────────────────────────────────────────────────

run "network_naming_convention" {
  command = plan

  module {
    source = "./modules/network"
  }

  variables {
    name                 = "test-customer"
    resource_group_name  = "rg-tf-lab"
    vnet_cidr            = ["10.99.0.0/16"]
    frontend_subnet_cidr = ["10.99.1.0/24"]
    backend_subnet_cidr  = ["10.99.2.0/24"]
    database_subnet_cidr = ["10.99.3.0/24"]
  }

  assert {
    condition     = azurerm_virtual_network.main.name == "vnet-test-customer"
    error_message = "VNet name must follow the 'vnet-{name}' convention, got '${azurerm_virtual_network.main.name}'."
  }

  assert {
    condition     = azurerm_subnet.frontend.name == "snet-test-customer-frontend"
    error_message = "Frontend subnet must follow the 'snet-{name}-frontend' convention."
  }

  assert {
    condition     = azurerm_subnet.backend.name == "snet-test-customer-backend"
    error_message = "Backend subnet must follow the 'snet-{name}-backend' convention."
  }

  assert {
    condition     = azurerm_subnet.database.name == "snet-test-customer-database"
    error_message = "Database subnet must follow the 'snet-{name}-database' convention."
  }
}

# ── CIDR propagation ─────────────────────────────────────────────────────────

run "network_cidr_propagation" {
  command = plan

  module {
    source = "./modules/network"
  }

  variables {
    name                 = "test-customer"
    resource_group_name  = "rg-tf-lab"
    vnet_cidr            = ["10.99.0.0/16"]
    frontend_subnet_cidr = ["10.99.1.0/24"]
    backend_subnet_cidr  = ["10.99.2.0/24"]
    database_subnet_cidr = ["10.99.3.0/24"]
  }

  assert {
    condition     = contains(azurerm_virtual_network.main.address_space, "10.99.0.0/16")
    error_message = "VNet address space must reflect the vnet_cidr input."
  }

  assert {
    condition     = contains(azurerm_subnet.frontend.address_prefixes, "10.99.1.0/24")
    error_message = "Frontend subnet address prefix must reflect the frontend_subnet_cidr input."
  }

  assert {
    condition     = contains(azurerm_subnet.backend.address_prefixes, "10.99.2.0/24")
    error_message = "Backend subnet address prefix must reflect the backend_subnet_cidr input."
  }

  assert {
    condition     = contains(azurerm_subnet.database.address_prefixes, "10.99.3.0/24")
    error_message = "Database subnet address prefix must reflect the database_subnet_cidr input."
  }
}

# ── PostgreSQL delegation ─────────────────────────────────────────────────────

run "database_subnet_has_postgresql_delegation" {
  command = plan

  module {
    source = "./modules/network"
  }

  variables {
    name                 = "test-customer"
    resource_group_name  = "rg-tf-lab"
    vnet_cidr            = ["10.99.0.0/16"]
    frontend_subnet_cidr = ["10.99.1.0/24"]
    backend_subnet_cidr  = ["10.99.2.0/24"]
    database_subnet_cidr = ["10.99.3.0/24"]
  }

  assert {
    condition     = length(azurerm_subnet.database.delegation) == 1
    error_message = "Database subnet must have exactly one delegation block (for PostgreSQL Flexible Server)."
  }

  assert {
    condition     = azurerm_subnet.frontend.name != azurerm_subnet.backend.name
    error_message = "Frontend and backend subnets must have distinct names."
  }
}
