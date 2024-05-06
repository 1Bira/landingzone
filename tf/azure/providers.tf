terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.99.0"
    }

    azapi = {
        source = "azure/api"
        version = "~>1.5"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  
  tenant_id = ""
  client_id = ""
  client_secret = ""
}