terraform{
  required_version = ">1.3.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }


backend "azurerm" {
  resource_group_name   = "tfstate"
  storage_account_name  = "tfstatenb100"
  container_name        = "nbtfstate"
  key                   = "terraform.tfstate"
}
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  # client_id = var.client_id
  # client_secret = var.client_secret
  # tenant_id = var.tenant_id
}