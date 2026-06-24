variable "name" {
  type        = string
  description = "Customer/environment name used as a prefix for all resources."

  validation {
    condition     = length(var.name) > 0 && can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must be non-empty and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for all resources in this environment."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources in this environment."
  default     = {}
}

variable "vnet_cidr" {
  type        = list(string)
  description = "Address space for the virtual network, e.g. [\"10.0.0.0/16\"]."
}

variable "frontend_subnet_cidr" {
  type        = list(string)
  description = "Address prefix for the frontend subnet, e.g. [\"10.0.1.0/24\"]."
}

variable "backend_subnet_cidr" {
  type        = list(string)
  description = "Address prefix for the backend subnet, e.g. [\"10.0.2.0/24\"]."
}

variable "database_subnet_cidr" {
  type        = list(string)
  description = "Address prefix for the database subnet, e.g. [\"10.0.3.0/24\"]."
}

variable "azurerm_public_ip" {
  type        = string
  description = "Name for the public IP resource."
}

variable "azurerm_lb" {
  type        = string
  description = "Name for the load balancer resource."
}

variable "azurerm_lb_backend_address_pool" {
  type        = string
  description = "Name for the load balancer backend address pool."
}

variable "azurerm_lb_probe" {
  type        = string
  description = "Name for the load balancer health probe."
}

variable "azurerm_backend_address_pool_ids" {
  type        = string
  description = "Name for the backend address pool IDs reference used by the VMSS."
}

variable "azurerm_lb_rule" {
  type        = string
  description = "Name for the load balancer rule."
}

variable "sku" {
  type        = string
  description = "SKU for the public IP and load balancer (Standard or Basic)."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Basic"], var.sku)
    error_message = "sku must be either 'Standard' or 'Basic'."
  }
}

variable "vm_size" {
  type        = string
  description = "VM size used for the backend VM and frontend VMSS instances."
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  description = "Administrator username for all VMs and the database."
  default     = "azureuser"

  validation {
    condition     = length(var.admin_username) > 0 && !contains(["admin", "administrator", "root"], lower(var.admin_username))
    error_message = "admin_username must not be empty and must not be a reserved name (admin, administrator, root)."
  }
}

variable "admin_password" {
  type        = string
  description = "Administrator password for all VMs and the database."
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters long (Azure requirement)."
  }
}

variable "frontend_instance_count_min" {
  type        = number
  description = "Minimum number of frontend VMSS instances."
  default     = 1

  validation {
    condition     = var.frontend_instance_count_min >= 1
    error_message = "frontend_instance_count_min must be at least 1."
  }
}

variable "frontend_instance_count_max" {
  type        = number
  description = "Maximum number of frontend VMSS instances."
  default     = 5

  validation {
    condition     = var.frontend_instance_count_max >= 1 && var.frontend_instance_count_max <= 100
    error_message = "frontend_instance_count_max must be between 1 and 100."
  }
}
