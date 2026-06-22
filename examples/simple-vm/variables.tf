variable "prefix" {
  description = "Prefix to prepend to all resource names. Must be 2–10 lowercase alphanumeric characters."
  type        = string
  default     = "demo"

  validation {
    condition     = var.prefix != "demo"
    error_message = "prefix must not be 'demo'. Please choose a unique prefix for your resources."
  }
}

variable "resource_group_name" {
  description = "Name of the existing Azure resource group to deploy resources into."
  type        = string
  default     = "rg-tf-lab"

  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90 && can(regex("^[a-zA-Z0-9._()-]+[a-zA-Z0-9_()-]$", var.resource_group_name))
    error_message = "resource_group_name must be 1–90 characters, consist of alphanumerics, underscores, parentheses, hyphens, and periods, and must not end with a period."
  }
}

variable "location" {
  description = "Azure region for all resources (e.g. germanywestcentral, westeurope, eastus)."
  type        = string
  default     = "germanywestcentral"

  validation {
    condition = contains([
      "germanywestcentral",
      "westeurope",
      "northeurope",
      "eastus",
      "eastus2",
      "westus",
      "westus2",
      "centralus",
      "southeastasia",
      "australiaeast",
    ], var.location)
    error_message = "location must be a valid Azure region slug (e.g. germanywestcentral, westeurope, eastus)."
  }
}

variable "vm_name" {
  description = "Base name of the virtual machine. Combined with prefix to form the final VM name."
  type        = string
  default     = "simple-vm"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,13}[a-zA-Z0-9]$", var.vm_name)) || can(regex("^[a-zA-Z][a-zA-Z0-9]$", var.vm_name))
    error_message = "vm_name must be 2–15 characters, start with a letter, end with a letter or digit, and contain only letters, digits, and hyphens."
  }
}

variable "vm_size" {
  description = "Azure VM SKU size. Must be a valid Standard tier size (e.g. Standard_B1s, Standard_D2s_v3)."
  type        = string
  default     = "Standard_B1s"

  validation {
    condition     = can(regex("^Standard_[A-Z][A-Za-z0-9_]+$", var.vm_size))
    error_message = "vm_size must be a valid Azure VM size starting with 'Standard_' (e.g. Standard_B1s, Standard_D2s_v3)."
  }
}

variable "admin_username" {
  description = "Administrator username for the Linux VM. Must not be a reserved Linux username."
  type        = string
  default     = "azureuser"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,30}[a-z0-9_$-]?$", var.admin_username))
    error_message = "admin_username must be a valid Linux username: start with a lowercase letter or underscore, 1–32 characters, containing only lowercase letters, digits, hyphens, and underscores."
  }

  validation {
    condition = !contains([
      "root", "daemon", "bin", "sys", "sync", "games", "man", "lp",
      "mail", "news", "uucp", "proxy", "www-data", "backup", "list",
      "irc", "gnats", "nobody", "systemd-network", "systemd-resolve",
      "syslog", "messagebus", "uuidd", "sshd", "admin", "ubuntu", "guest",
    ], var.admin_username)
    error_message = "admin_username must not be a reserved Linux system username (e.g. root, daemon, admin, ubuntu)."
  }
}



