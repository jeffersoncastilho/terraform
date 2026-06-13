#!/usr/bin/env bash
set -euo pipefail

BACKUP_NAME="${1:?Uso: $0 <nome-do-backup> [namespace-destino]}"
TARGET_NAMESPACE="${2:-}"
TARGET_CONTEXT="aks-blog-castilho-eastus"
RESTORE_NAME="restore-$(date +%Y%m%d-%H%M)"

echo "=== Iniciando restore: $RESTORE_NAME ==="
echo "Backup : $BACKUP_NAME"
echo "Cluster: $TARGET_CONTEXT"

EXTRA_ARGS=()
if [[ -n "$TARGET_NAMESPACE" ]]; then
  EXTRA_ARGS+=(--include-namespaces "$TARGET_NAMESPACE")
fi

velero restore create "$RESTORE_NAME" \
  --from-backup "$BACKUP_NAME" \
  "${EXTRA_ARGS[@]}" \
  --kubecontext "$TARGET_CONTEXT"

echo "Aguardando conclusão..."
velero restore wait "$RESTORE_NAME" --kubecontext "$TARGET_CONTEXT"

echo ""
velero restore describe "$RESTORE_NAME" --details --kubecontext "$TARGET_CONTEXT"
