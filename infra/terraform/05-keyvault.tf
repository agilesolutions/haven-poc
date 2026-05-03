# Create a Key Vault for Service B to store secrets
resource "azurerm_key_vault" "services_kv" {
  name                = "serviceskv"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  public_network_access_enabled = false
  sku_name                 = "standard"
  purge_protection_enabled = true
}

# Grant access to the Key Vault for the AKS cluster's managed identity
resource "azurerm_key_vault_access_policy" "service_b_kv_ap" {
  key_vault_id = azurerm_key_vault.services_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "data.azurerm_kubernetes_cluster.${local.cluster_name}.key_vault_secrets_provider[0].secret_identity[0].object_id"

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}