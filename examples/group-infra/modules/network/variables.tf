variable "name" {
  type        = string
  description = "Base name used as a prefix for all network resources."

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
  description = "Azure region for all network resources."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all network resources."
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
