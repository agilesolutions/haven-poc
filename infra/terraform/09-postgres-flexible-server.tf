# This Terraform configuration file sets up an Azure PostgreSQL Flexible Server instance, along with a database and firewall rules to allow access from Azure services and an AKS cluster. Adjust the parameters as needed for your specific environment and requirements.
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "pg-payments-${var.environment}"
  resource_group_name    = azurerm_resource_group.aks_rg.name
  location               = azurerm_resource_group.aks_rg.location

  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password

  version                = "16"

  storage_mb             = 32768
  sku_name               = "B_Standard_B2s"

  backup_retention_days  = 7

  zone                   = "1"

  public_network_access_enabled = true
}

# Create a PostgreSQL database within the Flexible Server instance. Adjust the collation and charset as needed for your specific use case.
resource "azurerm_postgresql_flexible_server_database" "payments" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# This firewall rule allows Azure services to access the PostgreSQL Flexible Server. Adjust the IP range as needed for your specific use case.
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# This firewall rule allows outbound traffic from AKS to PostgreSQL Flexible Server. Adjust the IP range as needed for your specific AKS cluster.
resource "azurerm_postgresql_flexible_server_firewall_rule" "aks_outbound" {
  name             = "AKSOutbound"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "20.10.10.1"
  end_ip_address   = "20.10.10.10"
}