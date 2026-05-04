module "haven_platform" {
  source = "./modules/haven-baseline"

  keycloak_admin_password = var.keycloak_admin_password
  keycloak_database_host = azurerm_postgresql_flexible_server.postgres.fqdn
}