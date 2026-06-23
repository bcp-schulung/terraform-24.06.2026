terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "rg-tf-lab"
    storage_account_name = "stterraformshared"
    container_name       = "tfstate"
    key                  = "group-infra.tfstate"
  }
}

provider "azurerm" {
  features {}
}

