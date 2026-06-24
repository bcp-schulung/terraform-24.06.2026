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
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to attach the backend VM NIC to."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the backend VM."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the backend VM."
  sensitive   = true
}
