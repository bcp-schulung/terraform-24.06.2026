variable "name" {
  type        = string
  description = "Base name used as a prefix for all backend VM resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for all backend VM resources."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all backend VM resources."
  default     = {}
}

variable "vm_size" {
  type        = string
  description = "VM size for the backend virtual machine."
  default     = "Standard_B2s"

  validation {
    condition     = length(var.vm_size) > 0
    error_message = "vm_size must not be empty."
  }
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to attach the backend VM NIC to."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the backend VM."
  default     = "azureuser"

  validation {
    condition     = length(var.admin_username) > 0 && !contains(["admin", "administrator", "root"], lower(var.admin_username))
    error_message = "admin_username must not be empty and must not be a reserved name (admin, administrator, root)."
  }
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the backend VM."
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters long (Azure requirement)."
  }
}
