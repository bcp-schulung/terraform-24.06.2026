# Tests for the database module.
# Uses mock_provider so no real Azure credentials or API calls are needed.
mock_provider "azurerm" {}

# ── Naming convention ────────────────────────────────────────────────────────

run "database_naming_convention" {
  command = plan

  module {
    source = "./modules/database"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-database"
    vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = azurerm_postgresql_flexible_server.main.name == "psql-test-customer"
    error_message = "PostgreSQL server name must follow the 'psql-{name}' convention."
  }

  assert {
    condition     = azurerm_private_dns_zone.main.name == "test-customer.postgres.database.azure.com"
    error_message = "Private DNS zone name must follow the '{name}.postgres.database.azure.com' convention."
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.main.name == "vnetlink-test-customer-db"
    error_message = "VNet link name must follow the 'vnetlink-{name}-db' convention."
  }
}

# ── Engine version and SKU ────────────────────────────────────────────────────

run "database_engine_version_and_sku" {
  command = plan

  module {
    source = "./modules/database"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-database"
    vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = azurerm_postgresql_flexible_server.main.version == "16"
    error_message = "PostgreSQL server must use version 16."
  }

  assert {
    condition     = azurerm_postgresql_flexible_server.main.sku_name == "B_Standard_B1ms"
    error_message = "PostgreSQL server SKU must be B_Standard_B1ms."
  }

  assert {
    condition     = azurerm_postgresql_flexible_server.main.storage_mb == 32768
    error_message = "PostgreSQL server storage must be 32768 MB (32 GB)."
  }
}

# ── Private network configuration ─────────────────────────────────────────────

run "database_private_network" {
  command = plan

  module {
    source = "./modules/database"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-database"
    vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.main.private_dns_zone_name == azurerm_private_dns_zone.main.name
    error_message = "VNet link must reference the DNS zone created by this module."
  }
}
