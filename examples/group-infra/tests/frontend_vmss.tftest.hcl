# Tests for the frontend-vmss module.
# Uses mock_provider so no real Azure credentials or API calls are needed.
mock_provider "azurerm" {}

# ── Naming and basic configuration ───────────────────────────────────────────

run "vmss_naming_and_configuration" {
  command = plan

  module {
    source = "./modules/frontend-vmss"
  }

  variables {
    name                     = "test-customer"
    resource_group_name      = "rg-tf-lab"
    subnet_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-frontend"
    backend_address_pool_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/loadBalancers/lb-test/backendAddressPools/lbbap-test"]
    admin_password           = "TestPassword123!"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.name == "vmss-test-customer-frontend"
    error_message = "VMSS name must follow the 'vmss-{name}-frontend' convention."
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.sku == "Standard_B2s"
    error_message = "VMSS SKU must reflect the vm_size input (default: Standard_B2s)."
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.instances == 1
    error_message = "VMSS initial instance count must equal instance_count_min (default: 1)."
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.disable_password_authentication == false
    error_message = "VMSS must allow password authentication (disable_password_authentication = false)."
  }

  assert {
    condition     = azurerm_monitor_autoscale_setting.main.name == "autoscale-test-customer-frontend"
    error_message = "Autoscale setting name must follow the 'autoscale-{name}-frontend' convention."
  }
}

# ── Custom scaling bounds ────────────────────────────────────────────────────

run "vmss_custom_scaling_bounds" {
  command = plan

  module {
    source = "./modules/frontend-vmss"
  }

  variables {
    name                     = "test-customer"
    resource_group_name      = "rg-tf-lab"
    subnet_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-frontend"
    backend_address_pool_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/loadBalancers/lb-test/backendAddressPools/lbbap-test"]
    admin_password           = "TestPassword123!"
    instance_count_min       = 2
    instance_count_max       = 4
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.instances == 2
    error_message = "VMSS initial instances must equal the custom instance_count_min."
  }
}

# ── Custom VM size ────────────────────────────────────────────────────────────

run "vmss_custom_vm_size" {
  command = plan

  module {
    source = "./modules/frontend-vmss"
  }

  variables {
    name                     = "test-customer"
    resource_group_name      = "rg-tf-lab"
    subnet_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-frontend"
    backend_address_pool_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/loadBalancers/lb-test/backendAddressPools/lbbap-test"]
    admin_password           = "TestPassword123!"
    vm_size                  = "Standard_D2s_v3"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.main.sku == "Standard_D2s_v3"
    error_message = "VMSS SKU must reflect the custom vm_size input."
  }
}
