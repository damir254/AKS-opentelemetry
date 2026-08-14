# AKS OpenTelemetry GitOps Platform

A production-style Azure Kubernetes Service and DevOps portfolio project built
around selected OpenTelemetry Demo services. It focuses on reproducible cloud
infrastructure, secure CI/CD, GitOps delivery, observability, and day-to-day
Kubernetes platform operations.

## Architecture

```mermaid
flowchart LR
    Developer --> GitHub
    GitHub --> Actions[GitHub Actions]
    Actions --> OIDC[GitHub OIDC]
    OIDC --> ACR[Azure Container Registry]

    ACR --> Updater[Argo CD Image Updater]
    Updater --> Values[Git values.yaml update]
    Values --> Argo[Argo CD]
    Argo --> AKS

    Terraform --> AKS
    Terraform --> ACR
    Terraform --> KV[Azure Key Vault]
    Terraform --> Identities[Managed Identities]
    Terraform --> Network[Networking]

    KV --> WI[AKS Workload Identity]
    WI --> ESO[External Secrets Operator]
    ESO --> Secrets[Kubernetes Secrets]
    Secrets --> Workloads

    Gateway[Gateway API] --> Proxy[frontend-proxy]
    Proxy --> Services[Internal services]

    Monitoring[Prometheus and Grafana] --> Observability
```

## Technologies

| Area | Technologies |
| --- | --- |
| Cloud / IaC | Azure, Terraform, AKS, ACR, Azure Key Vault |
| Kubernetes / Platform | Kubernetes, Helm, Gateway API, HPA and PDB templates, NetworkPolicy, External Secrets Operator |
| CI/CD / GitOps | GitHub Actions, GitHub OIDC, Argo CD, Argo CD Image Updater |
| Observability | OpenTelemetry Collector, Prometheus, Grafana, kube-state-metrics, node-exporter |
| Custom services | Product Catalog (Go), Payment (Node.js), Recommendation (Python) |

## What the Project Implements

- Modular Terraform for AKS, ACR, Key Vault, networking, managed identities,
  federated credentials, and scoped Azure RBAC.
- AKS Workload Identity for External Secrets Operator and Argo CD Image Updater,
  without static Azure credentials in Kubernetes.
- Key Vault-backed secrets synchronized into Kubernetes by External Secrets
  Operator.
- Service-specific GitHub Actions validation and OIDC-authenticated image pushes
  to ACR using immutable full Git commit SHA tags.
- Helm deployment of the OpenTelemetry application stack, including the three
  custom-built services.
- Argo CD App-of-Apps bootstrap with automated synchronization, pruning, and
  drift self-healing.
- Argo CD Image Updater discovery of new ACR images and Git write-back to the
  application values file.
- kube-prometheus-stack monitoring with Prometheus, Grafana,
  kube-state-metrics, node-exporter, and Alertmanager.
- Gateway API routing through `frontend-proxy`; the chart also contains
  conditional HPA, PDB, and NetworkPolicy templates, with PostgreSQL network
  policy enabled in the current values.

## CI/CD Flow

1. A developer pushes a change to a custom service.
2. Its service-specific GitHub Actions validation runs.
3. On `main`, Docker builds the image and tags it with the full Git SHA.
4. GitHub authenticates to Azure through OIDC.
5. The image is pushed to ACR.
6. Argo CD Image Updater detects the new eligible SHA tag.
7. Image Updater writes the tag to `helm/otel-demo/values.yaml` in Git.
8. Argo CD reconciles the Helm release into AKS.

GitHub Actions builds and publishes images; it does **not** deploy directly to
the cluster.

## Security

- GitHub OIDC replaces long-lived Azure client secrets in CI.
- AKS Workload Identity gives workloads federated access to Azure resources.
- Azure Key Vault remains the source of truth for secret values, while External
  Secrets materializes the required Kubernetes Secrets.
- Dedicated identities receive scoped roles such as `AcrPush`, `AcrPull`, and
  `Key Vault Secrets User`.
- Custom images use immutable 40-character Git SHA tags.
- Third-party Helm charts managed by child Applications are pinned to explicit
  versions.

## GitOps

Git is the desired-state source. The `platform-root` Argo CD Application watches
the child Application manifests in `platform/argocd/applications/`, which manage:

- `otel-demo` — the application Helm chart in `helm/otel-demo/`
- `external-secrets` — the ESO chart and repository platform configuration
- `monitoring` — the pinned kube-prometheus-stack chart and custom values
- `image-updater` — the controller, ACR authentication, Git credentials, and
  image update policy

Each child Application uses automated synchronization with `prune` and
`selfHeal` enabled.

## Screenshots

### Argo CD Applications

![Argo CD Applications](docs/argoapplications.png)

### External Secrets

![External Secrets](docs/externalsecrets.png)

### Image Updater

![Argo CD Image Updater](docs/imageupdater.png)

### AKS Workloads

![AKS Pods](docs/pods.png)

## Repository Structure

```text
.
├── terraform/
├── helm/otel-demo/
├── platform/
├── src/
├── .github/workflows/
└── docs/
```

## Recreation

The full rebuild procedure is documented in
[docs/recreation.md](docs/recreation.md). At a high level: apply Terraform,
securely populate the required Key Vault values, install Argo CD, and apply the
root Application so GitOps can reconcile the remaining platform components.

## What This Project Demonstrates

- Infrastructure as Code and reproducible Azure environments
- Kubernetes platform engineering and operational controls
- Secure, identity-based CI/CD and secret management
- GitOps-driven deployment and image promotion
- OpenTelemetry-based observability and platform troubleshooting
