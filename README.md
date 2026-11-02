::: {align="center"}
# ⚓ Haven POC

### Een cloud-native referentiearchitectuur voor Common Ground

**Ontwikkel één keer. Implementeer consistent. Beheer veilig.**

Een praktische proof of concept die laat zien hoe Java Spring
Boot-microservices kunnen worden uitgerold op een Haven
Kubernetes-platform met GitOps, Helm, identiteitsbeheer en
end-to-end-observability.

[![GitHub](https://img.shields.io/badge/GitHub-agilesolutions%2Fhaven--poc-181717?logo=github)](https://github.com/agilesolutions/haven-poc)
[![GitOps](https://img.shields.io/badge/GitOps-FluxCD-326CE5?logo=flux)](https://fluxcd.io/)
[![Kubernetes](https://img.shields.io/badge/Platform-Kubernetes-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![Java](https://img.shields.io/badge/Java-Spring%20Boot-6DB33F?logo=springboot)](https://spring.io/projects/spring-boot)
[![Identity](https://img.shields.io/badge/Identiteit-Keycloak-4D4D4D?logo=keycloak)](https://www.keycloak.org/)
[![Observability](https://img.shields.io/badge/Observability-OpenTelemetry%20%2B%20LGTM-7B42BC?logo=opentelemetry)](https://opentelemetry.io/)
:::

------------------------------------------------------------------------

## 🌐 Waarom dit project?

Overheidsorganisaties moeten samenwerken, innoveren en digitale diensten
leveren zonder afhankelijk te worden van één cloudprovider of één
specifieke infrastructuurimplementatie.

**Haven** biedt een standaard voor platformonafhankelijke cloudhosting
binnen de Nederlandse overheid en het ecosysteem van [Common
Ground](https://commonground.nl/).

Deze repository verkent dat uitgangspunt met een praktische
referentie-implementatie. De oplossing brengt de platformvoorzieningen
samen die ontwikkelteams nodig hebben om containerapplicaties te bouwen,
uit te rollen en te beheren:

-   **Consistente levering** --- declaratieve GitOps-deployments en
    packaging met Helm.
-   **Draagbare workloads** --- Kubernetes-native applicatie-uitrol.
-   **Veilige servicecommunicatie** --- OAuth 2.0-clientcredentials en
    JWT-validatie met Keycloak.
-   **Operationeel inzicht** --- gecentraliseerde logs, metrics en
    distributed traces.
-   **Infrastructure as Code** --- infrastructuurconfiguratie met
    Terraform.

> **Doel:** een herhaalbare route demonstreren van broncode naar een
> beveiligde en inzichtelijk te beheren applicatie op een Haven
> Kubernetes-platform.

## 🏗️ Architectuur in één oogopslag

De architectuur scheidt applicatieworkloads van gedeelde
platformvoorzieningen. Git is de bron van waarheid voor de gewenste
configuratie; FluxCD zorgt ervoor dat de Kubernetes-cluster continu met
die configuratie in overeenstemming wordt gebracht.

``` mermaid
flowchart TB
    DEV["👩‍💻 Ontwikkelaar / Platform Engineer"]
    GIT[("GitHub<br/>haven-poc")]
    TF["Terraform<br/>Infrastructure as Code"]
    subgraph HAVEN["Haven Kubernetes-omgeving"]
        direction TB
        FLUX["FluxCD<br/>GitOps-reconciliatie"]
        HELM["Helm + Kustomize<br/>Releases en configuratie"]
        subgraph PLATFORM["Gedeelde platformdiensten"]
            ING["Ingress Controller"]
            IAM["Keycloak<br/>OAuth2 / OIDC"]
            CERT["cert-manager"]
            OTEL["OpenTelemetry Collector"]
            LGTM["LGTM-stack<br/>Loki · Grafana · Tempo · Mimir"]
        end
        subgraph APPS["Applicatieworkloads"]
            A["Spring Boot-service A"]
            B["Spring Boot-service B"]
            C["Aanvullende services"]
        end
    end
    CLIENT["🌍 API-consument / client"]

    DEV -->|"Gewenste configuratie committen"| GIT
    DEV -->|"Infrastructuur provisionen / configureren"| TF
    TF -.->|"Clusterinfrastructuur"| HAVEN
    GIT -->|"Git-status reconciliëren"| FLUX
    FLUX --> HELM
    HELM --> PLATFORM
    HELM --> APPS
    CLIENT --> ING
    ING --> A
    A <-->|"Servicecommunicatie<br/>Bearer JWT"| B
    A -->|"Telemetrie"| OTEL
    B -->|"Telemetrie"| OTEL
    C -->|"Telemetrie"| OTEL
    OTEL --> LGTM
    A -.->|"Tokens ophalen / valideren"| IAM
    B -.->|"JWT valideren"| IAM
```

### De belangrijkste bouwstenen

  -----------------------------------------------------------------------
  Bouwsteen                           Verantwoordelijkheid
  ----------------------------------- -----------------------------------
  **Haven / Kubernetes**              Draagbare runtime-omgeving voor
                                      containerapplicaties

  **GitHub**                          Geversioneerde bron van waarheid
                                      voor applicatie- en
                                      platformconfiguratie

  **FluxCD**                          Brengt de clusterconfiguratie in
                                      overeenstemming met de gewenste
                                      status in Git

  **Helm / Kustomize**                Verpakken, configureren en
                                      samenstellen van
                                      Kubernetes-resources

  **Terraform**                       Provisioning en configuratie van
                                      infrastructuur

  **Spring Boot**                     Java-gebaseerde microservices en
                                      API's

  **Keycloak**                        OAuth 2.0 /
                                      OIDC-identiteitsprovider en
                                      tokenuitgever

  **OpenTelemetry**                   Verzamelen en doorsturen van
                                      applicatietelemetrie

  **LGTM**                            Logs (Loki), Grafana, traces
                                      (Tempo) en metrics (Mimir)

  **Ingress / cert-manager**          Externe HTTP(S)-toegang en
                                      certificaatbeheer
  -----------------------------------------------------------------------

## 🔁 GitOps-deploymentproces

Een deployment begint met een wijziging in de gewenste configuratie in
versiebeheer --- niet met het handmatig toepassen van losse resources op
de cluster.

``` mermaid
sequenceDiagram
    autonumber
    actor Developer as Ontwikkelaar
    participant Git as GitHub
    participant Flux as FluxCD
    participant Helm as Helm / Kustomize
    participant K8s as Haven Kubernetes
    participant App as Spring Boot-workload

    Developer->>Git: Commit applicatie- of configuratiewijziging
    Flux->>Git: Repository-status ophalen / volgen
    Git-->>Flux: Bijgewerkte gewenste configuratie
    Flux->>Helm: Release en manifests reconciliëren
    Helm->>K8s: Kubernetes-resources toepassen
    K8s->>App: Pods plannen en starten
    App-->>K8s: Readiness- / liveness-status
    K8s-->>Flux: Reconciliatiestatus
    Flux-->>Developer: Deploymentstatus inzichtelijk maken
```

**Het operationele principe:** Git beschrijft wat er moet draaien;
FluxCD zorgt ervoor dat de cluster naar die gewenste status convergeert.

## 🔐 Veilige communicatie tussen services

De proof of concept demonstreert een OAuth 2.0-client-credentials-flow
voor machine-to-machinecommunicatie.

``` mermaid
sequenceDiagram
    participant A as Spring Boot-service A
    participant K as Keycloak
    participant B as Spring Boot-service B

    A->>K: Access token aanvragen (client_credentials)
    K-->>A: Ondertekend JWT-access-token
    A->>B: API-aanroep + Authorization: Bearer JWT
    B->>B: Handtekening, issuer, audience en claims valideren
    B-->>A: Geautoriseerde response
```

Belangrijke uitgangspunten:

-   Services authenticeren als confidential clients.
-   Keycloak geeft access tokens uit.
-   Downstream-services valideren tokens voordat zij beschermde requests
    verwerken.
-   Credentials en tokens moeten als secrets worden behandeld en mogen
    nooit in Git worden vastgelegd.
-   Gebruik voor productie onder andere beheerde secretopslag, TLS en
    clients en rollen met beperkte rechten.

## 📊 Observability: logs, metrics en traces

Operationeel inzicht is onderdeel van het applicatieplatform en wordt
niet achteraf toegevoegd.

``` mermaid
flowchart LR
    A["Spring Boot-services"] --> O["OpenTelemetry Collector"]
    O --> L["Loki<br/>Logs"]
    O --> T["Tempo<br/>Traces"]
    O --> M["Mimir<br/>Metrics"]
    L --> G["Grafana"]
    T --> G
    M --> G
    G --> D["Dashboards · Correlatie · Probleemanalyse"]
```

Dit vormt de basis voor:

-   **Logs:** onderzoeken van applicatie-events en fouten.
-   **Metrics:** inzicht in servicegezondheid, throughput en
    resourcegebruik.
-   **Traces:** volgen van requests over servicegrenzen heen.
-   **Correlatie:** vanuit een dashboardsignaal doorklikken naar de
    relevante trace en logs.

## 🗂️ Repositorystructuur

De repository is opgezet rond applicatieworkloads, gedeelde
platformcomponenten, clusterconfiguratie, infrastructuur en
documentatie.

``` text
haven-poc/
├── apps/                 # Applicatieworkloads en deploymentdefinities
├── platform/             # Gedeelde platformdiensten en configuratie
├── clusters/
│   └── dev/              # GitOps-startpunt voor de ontwikkelcluster
├── infra/
│   └── terraform/        # Infrastructure as Code
├── docus/                # Project- en operationele documentatie
└── bruno/
    └── haven/            # API-requestcollecties
```

De exacte inhoud kan tijdens de ontwikkeling van de proof of concept
veranderen. Bekijk de betreffende mappen voor de actuele manifests,
Helm-releases en servicegerichte documentatie.

## 🚀 Aan de slag

### Benodigdheden

Zorg vóór het bootstrappen voor het volgende:

-   Toegang tot een Kubernetes-cluster die geschikt is voor de Haven
    POC.
-   `kubectl`, de Flux CLI, Git en --- waar nodig --- Terraform.
-   Ingerichte GitHub-toegang voor deze repository.
-   Clustercredentials en de benodigde rechten om platformcomponenten te
    installeren.
-   Een controle van de omgevingsspecifieke configuratie en secrets.

### FluxCD bootstrappen

Het GitOps-startpunt voor de ontwikkelomgeving staat in `clusters/dev`.
Met het onderstaande commando wordt FluxCD aan deze repository
gekoppeld:

``` bash
flux bootstrap github \
  --owner=agilesolutions \
  --repository=haven-poc \
  --branch=master \
  --path=clusters/dev \
  --personal
```

Raadpleeg voor de volledige procedure en omgevingsspecifieke vereisten
de [FluxCD-installatiehandleiding](docus/fluxcd.md).

### Reconciliatie controleren

Controleer na het bootstrappen de Flux-componenten en de
Kubernetes-workloads:

``` bash
flux get sources all -A
flux get kustomizations -A
flux get helmreleases -A
kubectl get pods -A
```

Controleer de logs van controllers en workloads wanneer reconciliatie of
het opstarten niet succesvol wordt afgerond.

## 🧭 Wat demonstreert deze POC?

  -----------------------------------------------------------------------
  Mogelijkheid                        Wat je kunt onderzoeken
  ----------------------------------- -----------------------------------
  GitOps-beheer                       FluxCD volgt Git en brengt de
                                      clusterstatus in overeenstemming

  Herhaalbare packaging               Helm-charts en Kubernetes-manifests
                                      definiëren releases

  Microservice-deployment             Spring Boot-workloads draaien als
                                      Kubernetes-services

  Machine-identiteit                  Keycloak geeft OAuth2-access-tokens
                                      uit

  API-beveiliging                     Services valideren JWT's bij
                                      beveiligde API-aanroepen

  Observability-pipeline              OpenTelemetry stuurt telemetrie
                                      naar LGTM

  Infrastructuurautomatisering        Terraform-configuratie wordt als
                                      code beheerd
  -----------------------------------------------------------------------

## 🛡️ Beveiligingsaandachtspunten

Dit project is een proof of concept en geen formele
productiebeveiligingscertificering. Beoordeel vóór toepassing in een
productieomgeving binnen de overheid ten minste de volgende punten:

1.  Sla credentials op in een goedgekeurde secretmanager; commit nooit
    secrets naar Git.
2.  Roteer credentials die mogelijk eerder in repositorygeschiedenis,
    logs of voorbeelden zichtbaar zijn geweest.
3.  Dwing TLS af voor ingress en servicecommunicatie waar dat vereist
    is.
4.  Valideer bij JWT's de handtekening, issuer, audience, vervaldatum en
    relevante autorisatieclaims.
5.  Pas least-privilege-RBAC en network policies toe.
6.  Beoordeel containerbeveiliging, herkomst van images,
    kwetsbaarheidsscans en admission controls.
7.  Leg bewaartermijnen, toegangsbeheer en privacybeleid voor logs en
    traces vast.

## 🔭 Verder verkennen

Nuttige startpunten:

-   [Haven --- platformonafhankelijk
    cloud-hosting](https://haven.commonground.nl/)
-   [Common Ground](https://commonground.nl/)
-   [FluxCD-documentatie](https://fluxcd.io/flux/)
-   [Kubernetes-documentatie](https://kubernetes.io/docs/)
-   [Spring
    Boot-documentatie](https://docs.spring.io/spring-boot/index.html)
-   [Keycloak-documentatie](https://www.keycloak.org/documentation)
-   [OpenTelemetry-documentatie](https://opentelemetry.io/docs/)
-   [Grafana LGTM-stack](https://grafana.com/oss/)

------------------------------------------------------------------------

::: {align="center"}
### Van Git-commit naar een beveiligde, inzichtelijk te beheren service op Haven.

**Een groeiende referentie-implementatie voor cloud-native workloads
binnen Common Ground.**

Voor leren, experimenteren en architectuurvalidatie.
:::
