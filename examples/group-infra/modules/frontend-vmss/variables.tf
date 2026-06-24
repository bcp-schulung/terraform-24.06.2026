variable "name" {
  type        = string
  description = "Base name used as a prefix for all VMSS resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to deploy into."
}

variable "location" {
  type        = string
  description = "Azure region for all VMSS resources."
  default     = "germanywestcentral"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all VMSS resources."
  default     = {}
}

variable "sku" {
  type        = string
  description = "VM SKU (size) for each instance in the scale set."
  default     = "Standard_B2s"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to attach the VMSS NICs to."
}

variable "backend_address_pool_ids" {
  type        = list(string)
  description = "List of load balancer backend address pool IDs to associate the VMSS with."
}

variable "vm_size" {
  type        = string
  description = "VM size for the VMSS instances."
  default     = "Standard_B2s"
}

variable "instance_count_min" {
  type        = number
  description = "Minimum number of VMSS instances."
  default     = 1

  validation {
    condition     = var.instance_count_min >= 1
    error_message = "instance_count_min must be at least 1."
  }
}

variable "instance_count_max" {
  type        = number
  description = "Maximum number of VMSS instances."
  default     = 5

  validation {
    condition     = var.instance_count_max >= 1
    error_message = "instance_count_max must be at least 1."
  }
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the VMSS instances."
  default     = "azureuser"

  validation {
    condition     = length(var.admin_username) > 0 && !contains(["admin", "administrator", "root"], lower(var.admin_username))
    error_message = "admin_username must not be empty and must not be a reserved name (admin, administrator, root)."
  }
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the VMSS instances."
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters long (Azure requirement)."
  }
}
