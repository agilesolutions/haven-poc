# This module deploys the Haven Platform on Azure Kubernetes Service (AKS) using Helm and Flux CD.
resource "helm_release" "flux" {
  name       = "flux2"
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  namespace  = "flux-system"

  create_namespace = true
}

# Deploy Keycloak using Helm chart from Bitnami repository. The chart will be installed in the "keycloak" namespace, and the admin password will be set using the value provided in the variable "keycloak_admin_password". The PostgreSQL database will be disabled, and an external database will be used instead, with the host set to the FQDN of the Azure PostgreSQL Flexible Server instance created for Keycloak.
resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  namespace  = "keycloak"

  create_namespace = true



  set = [
      {
            name  = "auth.adminPassword"
            value = var.keycloak_admin_password
        },
        {
            name  = "proxy"
            value = "edge"
        },
        {
            name  = "postgresql.enabled"
            value = "false"
      },
      {
            name  = "externalDatabase.host"
            value = var.keycloak_database_host
      }
  ]

}

# Deploy NGINX Ingress Controller using Helm chart from the official Kubernetes repository. The chart will be installed in the "ingress-nginx" namespace, and the namespace will be created if it doesn't already exist.
resource "helm_release" "nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  create_namespace = true
}

# Deploy cert-manager using Helm chart from the Jetstack repository. The chart will be installed in the "cert-manager" namespace, and the namespace will be created if it doesn't already exist. The Custom Resource Definitions (CRDs) required by cert-manager will also be installed by setting the "installCRDs" value to "true".
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  create_namespace = true

  set = [
      {
    name  = "installCRDs"
    value = "true"
    }
 ]
}

# Deploy External Secrets using Helm chart from the official repository. This deploys the controller that watches ExternalSecret resources.
resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
}

# Deploy LGTM using Helm chart from the Grafana repository. The chart will be installed in the "observability" namespace, and the namespace will be created if it doesn't already exist. LGTM is a distributed tracing system that helps you monitor and troubleshoot your applications by providing insights into the performance and behavior of your services.
resource "helm_release" "lgtm" {
  name       = "lgtm"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "lgtm-distributed"
  namespace  = "observability"

  create_namespace = true
}

# gatekeeper policies
resource "helm_release" "gatekeeper" {
  name       = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  namespace  = "gatekeeper-system"

  create_namespace = true
}