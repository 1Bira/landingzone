
data "azurerm_virtual_network" "hub" {
    name = "vnet-hub-${var.prefix}-weu-01"
    resource_group_name = var.rg
}

data "azurerm_subnet" "GatewaySubnet" {
  name = "GatewaySubnet"
  resource_group_name = var.rg
  virtual_network_name = data.azurerm_virtual_network.hub.name
}


resource "azurerm_public_ip" "pip_vpn_gatway" {
    name = "pip_vpn_gatway"
    location = data.azurerm_virtual_network.hub.location
    resource_group_name = data.azurerm_virtual_network.hub.resource_group_name

    allocation_method = "Dynamic"

    tags = {
      "Solution" = "Public IP VPNG"
      "Critical" = "Yes" 
    }  
}


resource "azurerm_virtual_network_gateway" "gateway" {
  name = "vpng-hub-${var.prefix}-01"
  resource_group_name = data.azurerm_virtual_network.hub.resource_group_name
  location = data.azurerm_virtual_network.hub.location

  type = "VPN"
  vpn_type = "RouteBased"

  active_active = "false"
  enable_bgp = "false"
  sku = "VpnGw1"

  tags = {
    "critical" = "yes"
    "Solution" = "VPNGateway"
  }

  ip_configuration {
    name = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.pip_vpn_gatway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = data.azurerm_subnet.GatewaySubnet.id
  }
}



resource "azurerm_local_network_gateway" "lcl-net-gateway" {
    name = "lcng-hub-${var.prefix}-01"
    resource_group_name = data.azurerm_virtual_network.hub.resource_group_name
    location = data.azurerm_virtual_network.hub.location
    gateway_address = ""
    address_space = ["20.0.0.0/24"]
}


resource "azurerm_virtual_network_gateway_connection" "onpremiss" {
  name = "onpremiss"
  location = data.azurerm_virtual_network.hub.location
  resource_group_name = data.azurerm_virtual_network.hub.resource_group_name

  type = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway.id
  local_network_gateway_id = azurerm_local_network_gateway.lcl-net-gateway.id

  shared_key = ""

}