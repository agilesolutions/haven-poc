# Haven POC reference project 
This is a reference project for the Haven POC. [Haven](https://haven.commonground.nl/over-haven) is a standard for platform-independent cloud hosting and is part of the [Common Ground Initiative](https://commonground.nl/).
Demonstrates set of simple microservices, implemented in different languages, and using different databases. The project is used to test the Haven POC implementation and to demonstrate its capabilities.(FluxCD + Helm + Spring Boot + Keycloak + LGTM + service-to-service auth).
## Setup bootstrapping FluxCD and Deploy the Application
1. How to bootstrap FluxCD in your Kubernetes cluster:
```bash
flux bootstrap github --owner=agilesolutions --repository=haven-poc --branch=master --path=clusters/dev --personal
```


## Structure GITOPS repo
```
platform-gitops/
├── apps/
│   ├── orders-service/
│   │   ├── helm/
│   │   │   ├── Chart.yaml
│   │   │   ├── values.yaml
│   │   │   └── templates/
│   │   │       ├── deployment.yaml
│   │   │       ├── service.yaml
│   │   │       ├── ingress.yaml
│   │   │       └── configmap.yaml
│   │   ├── kustomization.yaml
│   │   └── README.md
│   │
│   ├── payments-service/
│   └── users-service/
│
├── platform/
│   ├── ingress-nginx/
│   ├── keycloak/
│   ├── lgtm-stack/
│   │   ├── loki/
│   │   ├── grafana/
│   │   ├── tempo/
│   │   └── mimir/
│   ├── external-secrets/
│   └── cert-manager/
│
├── clusters/
│   ├── dev/
│   │   ├── flux-system/
│   │   │   ├── gotk-components.yaml
│   │   │   ├── gotk-sync.yaml
│   │   │   └── kustomization.yaml
│   │   ├── apps.yaml
│   │   └── platform.yaml
│   │
│   ├── test/
│   └── prod/
│
└── infra/
    ├── terraform/
    └── scripts/
```
## Deployment flow (GitOps)
```
Developer
   |
   | commit
   v
Git Repository
   |
   v
FluxCD (GitOps controller)
   |
   | detects change
   v
Helm/Kustomize rendering
   |
   v
Kubernetes API
   |
   v
Deployments / ConfigMaps / Secrets created
   |
   v
Pods scheduled & started
   |
   v
Spring Boot application running
```
## Config update flow
```
Developer updates values.yaml
   |
   v
Git commit
   |
   v
FluxCD detects change
   |
   v
Helm renders new ConfigMap
   |
   v
Kubernetes updates ConfigMap
   |
   v
Deployment rollout triggered (if configured)
   |
   v
Pods restart
   |
   v
Spring Boot reloads config on startup
```
## Service-to-service (client credentials)
```
Service A
   |
   | 1. Request token
   v
Keycloak (OAuth2 server)
   |
   | 2. Access token (JWT)
   v
Service A
   |
   | 3. Call Service B with Bearer token
   v
Service B
   |
   | 4. Validate JWT (issuer: Keycloak)
   v
Business logic executed
```
## Observability (LGTM stack)
```
Spring Boot Service
   |
   | logs + metrics + traces
   v
OpenTelemetry Collector
   |
   +--> Loki (logs)
   +--> Tempo (traces)
   +--> Mimir (metrics)
   |
   v
Grafana dashboards
```
## External access flow
```
User / Client
   |
   v
Ingress Controller
   |
   v
Kubernetes Service
   |
   v
Spring Boot Pod
   |
   v
Response
```
## Key architectural takeaway
```
- Git = source of truth (FluxCD)
- Kubernetes = runtime platform
- Helm = packaging
- ConfigMaps/Secrets = configuration
- Keycloak = identity layer
- OTel + LGTM = observability
- Ingress = north-south traffic
- Kubernetes DNS = east-west discovery
- OAuth2 client credentials = service-to-service auth
```


