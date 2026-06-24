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
}

variable "instance_count_max" {
  type        = number
  description = "Maximum number of VMSS instances."
  default     = 5
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the VMSS instances."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the VMSS instances."
  sensitive   = true
}
