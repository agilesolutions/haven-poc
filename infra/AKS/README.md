# end-to-end setup for a Spring Boot app running on Kubernetes
This directory contains Terraform code to set up an end-to-end infrastructure for a Spring Boot application running on Kubernetes. The infrastructure includes:

- Resource Group
- Virtual Network
- Subnet
- Kubernetes Cluster (AKS)
  - Container Registry (ACR)    
  - Azure flexible server for PostgreSQL
  - Azure Key Vault
  - Azure Log Analytics
  - External Secret Store (ESS) for Kubernetes
  - External Secret Operator (ESO) for Kubernetes deployment with Helm
  - User Assigned Managed Identity (UAMI) for ESS and ESO to access Azure resources
  - 


