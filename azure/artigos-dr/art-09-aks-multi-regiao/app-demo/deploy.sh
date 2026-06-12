#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS="$SCRIPT_DIR/manifests"

deploy_to_cluster() {
  local context=$1
  local deployment_file=$2

  echo "=== Deploy no cluster: $context ==="
  kubectl apply -f "$MANIFESTS/namespace.yaml"    --context "$context"
  kubectl apply -f "$MANIFESTS/$deployment_file"  --context "$context"
  kubectl apply -f "$MANIFESTS/service.yaml"      --context "$context"

  echo "Aguardando rollout..."
  kubectl rollout status deployment/dr-demo \
    -n app-producao \
    --timeout=120s \
    --context "$context"

  echo "IP externo:"
  kubectl get svc dr-demo -n app-producao \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}' \
    --context "$context"
  echo ""
}

deploy_to_cluster "aks-blog-castilho-brazilsouth" "deployment-brazilsouth.yaml"
deploy_to_cluster "aks-blog-castilho-eastus"      "deployment-eastus.yaml"
