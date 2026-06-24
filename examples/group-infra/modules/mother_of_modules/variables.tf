variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = string
}

variable "vnet_cidr" {
  type = list()
}
 
variable "frontend_subnet_cidr" {
  type = list()
}

variable "backend_subnet_cidr" {
  type = list()
}

variable "database_subnet_cidr" {
  type = list()
}

variable "azurerm_public_ip" {
  type = string
}

variable "azurerm_lb" {
  type = string
}

variable "azurerm_lb_backend_address_pool" {
  type = string
}

variable "azurerm_lb_probe" {
  type = string
}

variable "azurerm_backend_address_pool_ids" {
  type = string
}

variable "azurerm_lb_rule" {
    type = string
}

variable "sku" {
  type = string
}
