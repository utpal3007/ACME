provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "acme_rg" {
  name     = "acme_rg"
  location = "West Europe"  
}

# Create an Azure App Service Plan for your web app
resource "azurerm_app_service_plan" "acme-svc-plan" {
  name                = "acme-svc-plan"
  location            = azurerm_resource_group.acme_rg.location
  resource_group_name = azurerm_resource_group.acme_rg.name
  kind                = "Linux"  # For Linux web app plan
  reserved            = true    # Set this to true for Linux plans


  sku {
    tier = "Basic"  # Change SKU as needed
    size = "B1"     # Change SKU size as needed
  }
}

# Create a web app and enable Local Git deployment
resource "azurerm_app_service" "acme-app-svc" {
  name                = "acme-app-svc"
  location            = azurerm_resource_group.acme_rg.location
  resource_group_name = azurerm_resource_group.acme_rg.name
  app_service_plan_id = azurerm_app_service_plan.acme-svc-plan.id

  site_config {
    always_on = true

    scm_type = "LocalGit"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Create a deployment slot
resource "azurerm_app_service_slot" "acme_ds" {
  name                = "staging"  # Change the slot name as needed
  location            = azurerm_resource_group.acme_rg.location
  resource_group_name = azurerm_resource_group.acme_rg.name
  app_service_name    = azurerm_app_service.acme-app-svc.name
  app_service_plan_id = azurerm_app_service_plan.acme-svc-plan.id
}

# Output the URLs of the main app and the deployment slot
output "main_app_url" {
  value = azurerm_app_service.acme-app-svc.default_site_hostname
}

output "slot_url" {
  value = azurerm_app_service_slot.acme_ds.default_site_hostname
}
