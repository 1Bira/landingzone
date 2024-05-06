
# managment group

resource "azurerm_management_group" "IbiraIT" {
    display_name = "1bira"
}

resource "azurerm_management_group" "Plataform" {
    display_name = "Plataform"
    parent_management_group_id = azurerm_management_group.IbiraIT.id

}

resource "azurerm_management_group" "landing_zones_stage" {
    display_name = "LandingZones"
    parent_management_group_id = azurerm_management_group.IbiraIT.id
  
}

resource "azurerm_management_group" "landing_zone_prod" {
    display_name = "LandingZones"
    parent_management_group_id = azurerm_management_group.IbiraIT.id
  
}

resource "azurerm_management_group" "SandBox" {
    display_name = "SandBox"
    parent_management_group_id = azurerm_management_group.IbiraIT

}


resource "azurerm_management_group" "Identity" {
    display_name = "Identity"
    parent_management_group_id = azurerm_management_group.Plataform.id

    subscription_ids = [ 
        azurerm_subscription.identity_subscription.id
     ]

}

resource "azurerm_management_group" "managment" {
    display_name = "Managment"
    parent_management_group_id = azurerm_management_group.Plataform.id

    subscription_ids = [ 
        azurerm_subscription.managment_subscription.id
     ]
}

resource "azurerm_management_group" "connectivity" {
    display_name = "connectivity"
    parent_management_group_id = azurerm_management_group.Plataform.id

    subscription_ids = [ 
        azurerm_subscription.connectivity_subscription.id
     ]

}

resource "azurerm_management_group" "corp_prod" {
    display_name = "corp_prod"
    parent_management_group_id = azurerm_management_group.LandingZones.id

    subscription_ids = [
        azurerm_subscription.Landing_zone_prod
    ]

}

resource "azurerm_management_group" "corp_stage" {
    display_name = "Corp Stage"
    parent_management_group_id = azurerm_management_group.LandingZones.id

    subscription_ids = [
        azurerm_subscription.Landing_zone_stage.id
    ]

}





# Subscrições no terraform
resource "azurerm_subscription" "identity_subscription" {
  alias = "identity"
  subscription_name = "identity Subscription"
  subscription_id = ""
}

resource "azurerm_subscription" "managment_subscription" {
  alias = "managment"
  subscription_name = "managment subscription"
  subscription_id = ""
}

resource "azurerm_subscription" "connectivity_subscription" {
  alias = "connectivity"
  subscription_name = "connectivity subscription"
  subscription_id = ""
}

resource "azurerm_subscription" "Landing_zone_stage" {
  alias = "LandingZoneStage"
  subscription_name = "Landing stage"
  subscription_id = ""
}

resource "azurerm_subscription" "Landing_zone_prod" {
  alias = "LandingZoneProd"
  subscription_name = "Landing zone produtiva"
  subscription_id = ""
}






