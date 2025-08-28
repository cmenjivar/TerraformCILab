terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.43.0"
    }
  }
  cloud {
    organization = "CARLOS-training"
    workspaces {
      name = "TerraformCI"
    }
  }
}

provider "azurerm" {
  features {}                       #empty features block.
  skip_provider_registration = true #environment with limited permissions.
}

# Generates a random suffix
resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "688-a8481db2-menjivar-test-5m6"
  location = "West US"
}

# Register Azure subscription to use the Microsoft.Storage resource provider.
resource "azurerm_resource_provider_registration" "storage" {
  name = "Microsoft.Storage"
}

resource "azurerm_storage_account" "storage" {
  name                     = "stmenjivartest${random_id.suffix.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  # Update your storage account resource to depend on the registration.
  depends_on = [
    azurerm_resource_provider_registration.storage
  ]
}
