variable "name" {
  type        = string
  description = "Base name used as a prefix for all database resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for all database resources."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all database resources."
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "ID of the delegated subnet for the PostgreSQL Flexible Server."
}

variable "vnet_id" {
  type        = string
  description = "ID of the virtual network, used to link the private DNS zone."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the database server."
  default     = "pgadmin"

  validation {
    condition     = length(var.admin_username) > 0 && !contains(["admin", "administrator", "root", "postgres", "azure_superuser"], lower(var.admin_username))
    error_message = "admin_username must not be empty and must not be a reserved PostgreSQL username (admin, administrator, root, postgres, azure_superuser)."
  }
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the database server."
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters long (Azure requirement)."
  }
}
