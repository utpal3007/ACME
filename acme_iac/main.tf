provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"  # Change this to your desired Azure region
}

# Create an Azure App Service Plan for your web app
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"  # For Linux web app plan
  reserved            = true    # Set this to true for Linux plans


  sku {
    tier = "Basic"  # Change SKU as needed
    size = "B1"     # Change SKU size as needed
  }
}

# Create a web app (main Azure App Service) and enable Local Git deployment
resource "azurerm_app_service" "example" {
  name                = "acme-app-svc"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    always_on = true

    scm_type = "LocalGit"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Create a deployment slot
resource "azurerm_app_service_slot" "example" {
  name                = "staging"  # Change the slot name as needed
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_name    = azurerm_app_service.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}

# Output the URLs of the main app and the deployment slot
output "main_app_url" {
  value = azurerm_app_service.example.default_site_hostname
}

output "slot_url" {
  value = azurerm_app_service_slot.example.default_site_hostname
}
