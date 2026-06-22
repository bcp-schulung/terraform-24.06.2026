variable "resource_group_name" {
  description = "Name of the existing Azure resource group"
  type        = string
  default     = "rg-tf-lab"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "germanywestcentral"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "simple-vm"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
}



