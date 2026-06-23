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

variable "admin_username" {
  description = "Administrator username for the Linux VMs. Must not be a reserved Linux username."
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

# ── Networking ────────────────────────────────────────────────────────────────

variable "vnet_address_space" {
  description = "Address space for the virtual network (CIDR notation). Provide one or more non-overlapping CIDR blocks."
  type        = list(string)
  default     = ["10.0.0.0/16"]

  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "vnet_address_space must contain at least one CIDR block."
  }
}

variable "subnet_address_prefix" {
  description = "Address prefix(es) for the subnet. Must fall within vnet_address_space."
  type        = list(string)
  default     = ["10.0.1.0/24"]

  validation {
    condition     = length(var.subnet_address_prefix) > 0
    error_message = "subnet_address_prefix must contain at least one CIDR block."
  }
}

# ── Image lookup ──────────────────────────────────────────────────────────────

variable "image_publisher" {
  description = "Publisher of the Marketplace image (e.g. Canonical, RedHat)."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the Marketplace image (e.g. ubuntu-24_04-lts)."
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "image_sku" {
  description = "SKU of the Marketplace image (e.g. server, gen2)."
  type        = string
  default     = "server"
}

# ── OS disk ───────────────────────────────────────────────────────────────────

variable "os_disk_caching" {
  description = "Caching mode for the OS disk. ReadWrite is recommended for most workloads."
  type        = string
  default     = "ReadWrite"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "os_disk_caching must be one of: None, ReadOnly, ReadWrite."
  }
}

variable "os_disk_storage_account_type" {
  description = "Default storage account type (performance tier) for all OS disks. Can be overridden per VM via the disk_type field in the vms map."
  type        = string
  default     = "Standard_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "UltraSSD_LRS"], var.os_disk_storage_account_type)
    error_message = "os_disk_storage_account_type must be one of: Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS."
  }
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Map of tags to apply to all taggable resources."
  type        = map(string)
  default     = {}
}

# ── VMs ───────────────────────────────────────────────────────────────────────

variable "vms" {
  description = <<-EOT
    Map of VMs to create. The key becomes the VM role name (e.g. db, frontend, backend).

    Fields:
      size       - Azure VM size (e.g. Standard_B1s)
      open_ports - TCP ports to allow inbound (e.g. ["22", "80"])
      disk_type  - (optional) Override the global os_disk_storage_account_type for this VM.
                   Allowed values: Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS.
                   Omit or set to null to use the global default.
  EOT
  type = map(object({
    size       = string
    open_ports = list(string)
    disk_type  = optional(string)
  }))

  default = {
    db = {
      size       = "Standard_B1s"
      open_ports = ["22", "5432"]
      disk_type  = null
    }
    frontend = {
      size       = "Standard_B1s"
      open_ports = ["22", "80", "443"]
      disk_type  = null
    }
    backend = {
      size       = "Standard_B1s"
      open_ports = ["22", "8080"]
      disk_type  = null
    }
  }

  validation {
    condition     = length(var.vms) > 0
    error_message = "At least one VM must be defined in the vms map."
  }

  validation {
    condition = alltrue([
      for vm in values(var.vms) :
      vm.disk_type == null || contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "UltraSSD_LRS"], vm.disk_type)
    ])
    error_message = "Each VM's disk_type must be null or one of: Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS."
  }
}
