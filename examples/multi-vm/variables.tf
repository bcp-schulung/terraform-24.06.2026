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

variable "vms" {
  description = "Map of VMs to create. The key becomes the VM role name (e.g. db, frontend, backend)."
  type = map(object({
    size       = string
    open_ports = list(string)
  }))

  default = {
    db = {
      size       = "Standard_B1s"
      open_ports = ["22", "5432"]
    }
    frontend = {
      size       = "Standard_B1s"
      open_ports = ["22", "80", "443"]
    }
    backend = {
      size       = "Standard_B1s"
      open_ports = ["22", "8080"]
    }
  }

  validation {
    condition     = length(var.vms) > 0
    error_message = "At least one VM must be defined in the vms map."
  }
}
