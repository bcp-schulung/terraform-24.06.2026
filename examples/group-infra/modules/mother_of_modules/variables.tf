variable "name" {
  type        = string
  description = "Customer/environment name used as a prefix for all resources."
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
}

variable "admin_password" {
  type        = string
  description = "Administrator password for all VMs and the database."
  sensitive   = true
}

variable "frontend_instance_count_min" {
  type        = number
  description = "Minimum number of frontend VMSS instances."
  default     = 1
}

variable "frontend_instance_count_max" {
  type        = number
  description = "Maximum number of frontend VMSS instances."
  default     = 5
}
