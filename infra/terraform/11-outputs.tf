# Output Values - Resource Group
output "resource_group_id" {
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.aks_rg.id
}
output "resource_group_name" {
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.aks_rg.name
}
output "mysql_server_fqdn" {
  description = "MySQL Server FQDN"
  value = azurerm_mysql_server.mysql_server.fqdn
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account"
  # Argument Reference
  value = azurerm_ai_services.ai_service.primary_access_key
}

output "instrumentation_key" {
  description = "The Instrumentation Key for this Application Insights component"
  value = azurerm_application_insights.example.instrumentation_key
  sensitive = false
}

output "app_id" {
  description = "The App ID associated with this Application Insights component"
  value = azurerm_application_insights.example.app_id
  sensitive = false
}

output "eso_client_id" {
  value = azurerm_user_assigned_identity.eso.client_id
}