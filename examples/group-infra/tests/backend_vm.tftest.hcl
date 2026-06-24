# Tests for the backend-vm module.
# Uses mock_provider so no real Azure credentials or API calls are needed.
mock_provider "azurerm" {}

# ── Naming and configuration ──────────────────────────────────────────────────

run "backend_vm_naming_and_configuration" {
  command = plan

  module {
    source = "./modules/backend-vm"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-backend"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.main.name == "vm-test-customer-backend"
    error_message = "VM name must follow the 'vm-{name}-backend' convention."
  }

  assert {
    condition     = azurerm_network_interface.main.name == "nic-test-customer-backend"
    error_message = "NIC name must follow the 'nic-{name}-backend' convention."
  }

  assert {
    condition     = azurerm_linux_virtual_machine.main.size == "Standard_B2s"
    error_message = "VM size must match the vm_size input (default: Standard_B2s)."
  }

  assert {
    condition     = azurerm_linux_virtual_machine.main.disable_password_authentication == false
    error_message = "VM must allow password authentication (disable_password_authentication = false)."
  }
}

# ── Custom VM size ────────────────────────────────────────────────────────────

run "backend_vm_custom_size" {
  command = plan

  module {
    source = "./modules/backend-vm"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-backend"
    vm_size             = "Standard_B4ms"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.main.size == "Standard_B4ms"
    error_message = "VM size must reflect the custom vm_size input."
  }
}

# ── NIC is attached to VM ────────────────────────────────────────────────────

run "backend_vm_nic_attachment" {
  command = plan

  module {
    source = "./modules/backend-vm"
  }

  variables {
    name                = "test-customer"
    resource_group_name = "rg-tf-lab"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-lab/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-test-backend"
    admin_password      = "TestPassword123!"
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.main.network_interface_ids) == 1
    error_message = "Backend VM must have exactly one network interface attached."
  }
}
