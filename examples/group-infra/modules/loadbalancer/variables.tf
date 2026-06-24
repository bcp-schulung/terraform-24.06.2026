variable "name" {
  type        = string
  description = "Base name used as a prefix for all load balancer resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for all load balancer resources."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all load balancer resources."
  default     = {}
}

variable "sku" {
  type        = string
  description = "SKU of the public IP and load balancer (Standard or Basic)."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Basic"], var.sku)
    error_message = "sku must be either 'Standard' or 'Basic'."
  }
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

variable "azurerm_lb_rule" {
  type        = string
  description = "Name for the load balancer rule."
}
