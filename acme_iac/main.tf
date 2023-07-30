provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "acme_rg" {
  name     = "acme_rg"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "acme_app_plan" {
  name                = "acme-service-plan"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "acme_app_service" {
  name                = "acme_app_service"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  app_service_plan_id = azurerm_app_service_plan.acme_app_plan.id

  site_config {
    always_on = true
    linux_fx_version = "DOCKER|<your_docker_hub_username>/my-app-container:latest"
  }

  app_settings = {
    WEBSITES_PORT = "8080"
  }
}
