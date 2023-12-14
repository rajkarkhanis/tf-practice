terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=3.70.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "first-rg" {
    location = var.location
    name = "first-rg"
}
