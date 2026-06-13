#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="velero"
CHART_VERSION="7.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_velero() {
  local context=$1
  local values_file=$2

  echo "=== Instalando Velero — contexto: $context ==="

  helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
  helm repo update

  helm upgrade --install velero vmware-tanzu/velero \
    --namespace "$NAMESPACE" \
    --create-namespace \
    --version "$CHART_VERSION" \
    --values "$values_file" \
    --kube-context "$context"

  kubectl wait --for=condition=ready pod \
    -l app.kubernetes.io/name=velero \
    -n "$NAMESPACE" \
    --timeout=120s \
    --context "$context"

  echo "Velero instalado em $context"
}

install_velero "aks-blog-castilho-brazilsouth" "$SCRIPT_DIR/velero-values-brazilsouth.yaml"
install_velero "aks-blog-castilho-eastus"      "$SCRIPT_DIR/velero-values-eastus.yaml"
