variable "keycloak_database_host" {
  type        = string
  default     = "localhost"
  description = "The hostname of the database server for Keycloak. This should be set to the FQDN of the Azure PostgreSQL Flexible Server instance created for Keycloak."
  sensitive = false
}
variable "keycloak_admin_password" {
  type       = string
  default    = "admin123!"
  description = "The admin password for Keycloak. This should be set to a strong password"
  sensitive = true
}