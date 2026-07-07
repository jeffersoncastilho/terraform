# Art. 01 — Observabilidade no AKS (Prometheus + Grafana + App Insights)

Stack de observabilidade **standalone** provisionada via Terraform, reutilizando
os módulos do repo. Entrega os endpoints/segredos como outputs.

## Recursos provisionados

| Pilar | Recurso | Módulo |
|-------|---------|--------|
| — | Resource Group | `terraform-resource-group-modules` |
| Logs | Log Analytics Workspace | `terraform-log-analytics-modules` |
| Métricas | Azure Monitor Workspace + DCE/DCR | `terraform-monitor-workspace-modules` |
| Visualização | Azure Managed Grafana + RBAC | `terraform-grafana-modules` + `terraform-role-assignment-modules` |
| Traces | Application Insights | `terraform-app-insights-modules` |
| Alertas | Prometheus Rule Group | `terraform-prometheus-rules-modules` |

## Como aplicar

```bash
export TF_VAR_subscription_id="$(az account show --query id -o tsv)"

terraform init
terraform plan -out=tf.plan
terraform apply tf.plan

# Outputs
terraform output grafana_endpoint
terraform output -raw appinsights_connection_string
```

## Parte que roda no cluster / versão Azure CLI

A associação com o AKS (`monitor_metrics`, `oms_agent`, DCR Association) e o
PodMonitor exigem um cluster existente. O caminho **Azure CLI** completo (equivalente
a este ambiente) fica no repositório de scripts, não neste repo de IaC:

`github.com/jeffersoncastilho/azure` → pasta **"Observabilidade no AKS"** →
`observabilidade-aks.sh`

## Limpeza

```bash
terraform destroy
```

## Notas

- **State local** neste ambiente (lab). Para state remoto, use `backend.hcl.example`.
- A stack não depende de um cluster AKS — os outputs de Grafana e App Insights
  são gerados de forma autônoma.
