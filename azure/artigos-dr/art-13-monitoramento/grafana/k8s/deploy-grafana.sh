#!/usr/bin/env bash
set -euo pipefail

: "${SUBSCRIPTION_ID:?Defina SUBSCRIPTION_ID antes de executar}"
: "${TENANT_ID:?Defina TENANT_ID antes de executar}"
: "${KV_NAME:?Defina KV_NAME antes de executar}"
: "${LAW_WORKSPACE_ID:?Defina LAW_WORKSPACE_ID antes de executar}"
: "${AKS_RG:?Defina AKS_RG antes de executar}"
: "${AKS_NAME:?Defina AKS_NAME antes de executar}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DASHBOARDS_DIR="$SCRIPT_DIR/../dashboards"

az aks get-credentials \
  --resource-group "$AKS_RG" \
  --name "$AKS_NAME" \
  --overwrite-existing

CLIENT_ID=$(az keyvault secret show \
  --vault-name "$KV_NAME" \
  --name "grafana-client-id" \
  --query "value" -o tsv)

CLIENT_SECRET=$(az keyvault secret show \
  --vault-name "$KV_NAME" \
  --name "grafana-client-secret" \
  --query "value" -o tsv)

kubectl apply -f "$SCRIPT_DIR/00-namespace.yaml"

kubectl create secret generic grafana-azure-monitor \
  --namespace monitoring \
  --from-literal=AZURE_TENANT_ID="$TENANT_ID" \
  --from-literal=AZURE_CLIENT_ID="$CLIENT_ID" \
  --from-literal=AZURE_CLIENT_SECRET="$CLIENT_SECRET" \
  --from-literal=AZURE_SUBSCRIPTION_ID="$SUBSCRIPTION_ID" \
  --from-literal=LAW_WORKSPACE_ID="$LAW_WORKSPACE_ID" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap grafana-dashboards \
  --namespace monitoring \
  --from-file=dr-overview.json="$DASHBOARDS_DIR/dr-overview.json" \
  --from-file=replication-health.json="$DASHBOARDS_DIR/replication-health.json" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "$SCRIPT_DIR/01-configmap-provisioning.yaml"
kubectl apply -f "$SCRIPT_DIR/02-pvc.yaml"
kubectl apply -f "$SCRIPT_DIR/03-deployment.yaml"
kubectl apply -f "$SCRIPT_DIR/04-service.yaml"

kubectl rollout status deployment/grafana -n monitoring --timeout=180s

echo ""
echo "=== Grafana endpoint ==="
for i in $(seq 1 12); do
  IP=$(kubectl get svc grafana -n monitoring \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  if [[ -n "$IP" ]]; then
    echo "http://$IP  (admin / admin)"
    break
  fi
  echo "Aguardando LoadBalancer IP... ($i/12)"
  sleep 10
done
