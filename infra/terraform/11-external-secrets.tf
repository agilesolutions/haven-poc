# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry_project
data "azurerm_client_config" "current" {}

# Create a secret in the Key Vault for the PostgreSQL password
resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = var.postgres_admin_password
  key_vault_id = azurerm_key_vault.services_kv.id
}

# Create a secret in the Key Vault for the PostgreSQL username
resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-username"
  value        = var.postgres_admin_user
  key_vault_id = azurerm_key_vault.services_kv.id
}

# Create a user-assigned managed identity for the External Secrets Operator to access the Key Vault
resource "azurerm_user_assigned_identity" "eso" {
  name                = "eso-managed-identity"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Grant the user-assigned managed identity access to read secrets from the Key Vault
resource "azurerm_role_assignment" "eso_secret_reader" {
  scope                = azurerm_key_vault.services_kv.id
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

  set = [
    {
      name  = "serviceAccount.create"
      value = "false"
    }
  ]

  depends_on = [
    azurerm_role_assignment.eso_secret_reader
  ]
}