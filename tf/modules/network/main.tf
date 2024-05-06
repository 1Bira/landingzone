
data "terraform_remote_id" "resource_group_prod" {
  path="../base"
}

resource "azurerm_network_security_group" "vsg_conectivity_stage" {
  name = "virtual-security-goup"
  location = data.re
}
