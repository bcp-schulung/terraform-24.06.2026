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

# One SSH key pair per VM role
resource "tls_private_key" "main" {
  for_each  = var.vms
  algorithm = "ED25519"
}

# Shared virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# One public IP per VM role
resource "azurerm_public_ip" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}-pip"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# One NSG per VM role with dynamic rules for each configured port
resource "azurerm_network_security_group" "main" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

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

  network_interface_ids = [azurerm_network_interface.main[each.key].id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.main[each.key].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
