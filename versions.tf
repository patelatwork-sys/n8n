terraform {
  required_version = ">= 1.0.2"
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "<YOUR_SUBSCRIPTION_ID>"
}