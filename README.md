# Haven POC reference project 
This is a reference project to challenging and demonstrating the concept of Haven. [Haven](https://haven.commonground.nl/over-haven) is a standard for platform-independent cloud hosting and is part of the [Common Ground Initiative](https://commonground.nl/).
Demonstrates set of simple microservices developed with Java Spring Boot to test the Haven POC implementation and to demonstrate its capabilities.(FluxCD + Helm + Spring Boot + Keycloak + LGTM + service-to-service auth).
[Central idea is to show how to use GitOps](./docus/GitOps.md) (FluxCD) to manage the deployment of a microservices application on Kubernetes, with a focus on configuration management, service-to-service authentication, and observability.
## Setup bootstrapping FluxCD and Deploy the Application
1. How to bootstrap FluxCD in your Kubernetes cluster:
```
flux bootstrap github --owner=agilesolutions --repository=haven-poc --branch=master --path=clusters/dev --personal
```
Read full instructions in [docus/fluxcd.md](./docus/fluxcd.md)

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
### Keycloak configuration
- docker run --name keycloak -d -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -p 8080:8080 quay.io/keycloak/keycloak start-dev --features organization
- kubectl -n keycloak port-forward pod/keycloak-keycloakx-0 8080
- flux get helmreleases -A
- kubectl logs -f pod/keycloak-keycloakx-0 -n keycloak
- kubectl describe  pod/keycloak-keycloakx-0 -n keycloak
- kubectl logs -f deploy/kustomize-controller -n flux-system
- [Configure Keycloak realm and clients](https://medium.com/@phat.tan.nguyen/oauth-2-0-the-client-credentials-grant-type-with-keycloak-2debb88a1c70)
- curl --location 'http://localhost:8080/auth/realms/demo/protocol/openid-connect/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=service-a' --data-urlencode 'client_secret=9ZGDYDxB7eQH1SdoK81u9EFlrB4b3NYc'
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
## OpenTelemetry configuration
- Add OTel Java agent to Spring Boot app (e.g., via Helm values.yaml)
- Configure OTel Collector to receive telemetry data and export to LGTM stack
- Use Grafana to visualize logs, metrics, and traces for troubleshooting and performance monitoring
- Example OTel Collector config:
```
Spring Boot services
        |
        v
OpenTelemetry Collector
        |
   +----+--------+---------+
   |             |         |
  Loki         Tempo    Prometheus
 (logs)       (traces)   (metrics)
        |
        v
      Grafana
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


