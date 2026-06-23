variable "resource_group_name" {
  description = "Name of the existing Azure resource group to deploy resources into."
  type        = string
  default     = "rg-tf-lab"

  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90 && can(regex("^[a-zA-Z0-9._()-]+[a-zA-Z0-9_()-]$", var.resource_group_name))
    error_message = "resource_group_name must be 1–90 characters, consist of alphanumerics, underscores, parentheses, hyphens, and periods, and must not end with a period."
  }
}