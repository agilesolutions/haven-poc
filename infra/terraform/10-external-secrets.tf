# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry_project
data "azurerm_client_config" "current" {}

# Create a Key Vault for Service B to store secrets
resource "azurerm_key_vault" "service_b_kv" {
  name                = "service_b_kv"
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
  key_vault_id = azurerm_key_vault.service_b_kv_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_kubernetes_cluster.local.cluster_name.key_vault_secrets_provider[0].secret_identity[0].object_id

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

# Create a secret in the Key Vault for the PostgreSQL password
resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = "MySuperSecurePassword123!"
  key_vault_id = azurerm_key_vault.service_b_kv.id
}

# Create a user-assigned managed identity for the External Secrets Operator to access the Key Vault
resource "azurerm_user_assigned_identity" "eso" {
  name                = "eso-managed-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Grant the user-assigned managed identity access to read secrets from the Key Vault
resource "azurerm_role_assignment" "eso_secret_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.eso.principal_id
}

# Deploy the External Secrets Operator using Helm, configured to use the user-assigned managed identity for authentication
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  depends_on = [
    azurerm_role_assignment.eso_secret_reader
  ]
}