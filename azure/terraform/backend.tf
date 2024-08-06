terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mytfsa"
    storage_account_name = "mytfstorage"
    container_name       = "tf-statefiles"
    key                  = "monolith.tfstate"
  }
}