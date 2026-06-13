#!/usr/bin/env bash
set -euo pipefail

CONTEXT="${1:-aks-blog-castilho-brazilsouth}"
NAMESPACE_TO_BACKUP="${2:-app-producao}"
BACKUP_NAME="backup-${NAMESPACE_TO_BACKUP}-$(date +%Y%m%d-%H%M)"

echo "=== Iniciando backup: $BACKUP_NAME ==="
echo "Cluster  : $CONTEXT"
echo "Namespace: $NAMESPACE_TO_BACKUP"

velero backup create "$BACKUP_NAME" \
  --include-namespaces "$NAMESPACE_TO_BACKUP" \
  --snapshot-volumes=true \
  --storage-location default \
  --kubecontext "$CONTEXT"

echo "Aguardando conclusão..."
velero backup wait "$BACKUP_NAME" --kubecontext "$CONTEXT"

echo ""
velero backup describe "$BACKUP_NAME" --details --kubecontext "$CONTEXT"
echo ""
echo "Backup concluído: $BACKUP_NAME"
