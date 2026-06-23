terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}

# Use an existing resource group (created by the seminar setup)
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Resolve the latest image version for the configured publisher / offer / SKU.
# Using a data source instead of hardcoding "latest" ensures Terraform records
# the exact version in state, making plans reproducible.
data "azurerm_platform_image" "main" {
  location  = data.azurerm_resource_group.main.location
  publisher = var.image_publisher
  offer     = var.image_offer
  sku       = var.image_sku
}

# One SSH key pair per VM role
resource "tls_private_key" "main" {
  for_each  = var.vms
  algorithm = "ED25519"
}

# Shared virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefix
}

# One public IP per VM role
resource "azurerm_public_ip" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}-pip"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# One NSG per VM role with dynamic rules for each configured port
resource "azurerm_network_security_group" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags

  dynamic "security_rule" {
    # Build a map of port => index so each rule gets a unique priority
    for_each = { for idx, port in each.value.open_ports : port => idx }
    content {
      name                       = "allow-port-${security_rule.key}"
      priority                   = 100 + security_rule.value * 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.key
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

# One NIC per VM role
resource "azurerm_network_interface" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  for_each                  = var.vms
  network_interface_id      = azurerm_network_interface.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main[each.key].id
}

# One Linux VM per role (db, frontend, backend)
resource "azurerm_linux_virtual_machine" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = each.value.size
  admin_username      = var.admin_username
  tags                = var.tags

  network_interface_ids = [azurerm_network_interface.main[each.key].id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.main[each.key].public_key_openssh
  }

  os_disk {
    caching = var.os_disk_caching
    # Per-VM disk_type overrides the global default when set
    storage_account_type = each.value.disk_type != null ? each.value.disk_type : var.os_disk_storage_account_type
  }

  # Version is resolved by the data source rather than relying on the opaque
  # "latest" alias, so the exact image used is visible in the Terraform plan.
  source_image_reference {
    publisher = data.azurerm_platform_image.main.publisher
    offer     = data.azurerm_platform_image.main.offer
    sku       = data.azurerm_platform_image.main.sku
    version   = data.azurerm_platform_image.main.version
  }
}
