
data "terraform_remote_id" "resource_group_prod" {
  path="../base"
}


## Create NSG
resource "azurerm_network_security_group" "nsg_hub" {
  name = "vsg-hub-${var.prefix}-weu-01"
  location = var.location
  resource_group_name = var.resource_group
  security_rule {
    name="allow-rdp"
    priority = 100
    direction = "Inbound"
    access = "Deny"
    protocol = "TCP"
    source_port_range = "*"
    destination_port_range = 3389
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }  
  
}

resource "azurerm_subnet_network_security_group_association" "nsg_hub_subnet" {
  subnet_id = azurerm_subnet.hub-snet-resources.id
  network_security_group_id = azurerm_network_security_group.nsg_hub
}

## Create Vnets
resource "azurerm_virtual_network" "vnet_hub" {
  name = "vnet-hub-${var.prefix}-weu-01"
  location = var.location
  resource_group_name = var.resource_group
  address_space = ["10.0.0.0/16"]
  tags={
    "Critical"    = "Yes"
    "Solution"    = "Vnet"
    "Environment" = "Hub"
    "Location"    = "Weu"
  }
}

resource "azurerm_virtual_network" "vnet_dev" {
  name = "vnet-dev-${var.prefix}-weu-01"
  location = var.location
  resource_group_name = var.resource_group
  address_space = ["10.1.0.0/20"]
  tags={
    "Critical"    = "Yes"
    "Solution"    = "Vnet"
    "Environment" = "Hub"
    "Location"    = "Weu"
  }
  
}

resource "azurerm_virtual_network" "vnet_prod" {
  name = "vnet-prod-${var.prefix}-weu-01"
  location = var.location
  resource_group_name = var.resource_group
  address_space = ["10.2.0.0/20"]
  tags={
    "Critical"    = "Yes"
    "Solution"    = "Vnet"
    "Environment" = "Hub"
    "Location"    = "Weu"
  }
  
}


## Create Subnets
resource "azurerm_subnet" "hub-snet-resources" {
  name = "snet-${var.prefix}-hub-weu-resources"
  resource_group_name = var.resource_group
  address_prefixes = [ "10.0.2.0/24" ]
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  
}

resource "azurerm_subnet" "snet-bastian" {
  name= "AzureBastionSubnet"
  resource_group_name = var.resource_group
  address_prefixes = [ "10.0.4.0/24" ]
  virtual_network_name = azurerm_virtual_network.vnet_hub.name  
}

resource "azurerm_subnet" "snet-bastion" {
  name= "AzureBastianSubnet"
  resource_group_name = var.resource_group
  address_prefixes = [ "10.0.3.0/24" ]
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
}

resource "azurerm_subnet" "snet-firewall" {
  name="AzureFirewall"
  resource_group_name = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.5.0/26"]
}


