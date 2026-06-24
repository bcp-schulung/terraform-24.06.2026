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

variable "admin_username" {
  type        = string
  description = "Administrator username for the database server."
  default     = "pgadmin"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for the database server."
  sensitive   = true
}
