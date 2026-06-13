#!/usr/bin/env bash
set -euo pipefail

CONTEXT="${1:-aks-blog-castilho-brazilsouth}"
SCHEDULE_NAME="schedule-diario"
NAMESPACE_TO_BACKUP="app-producao"

echo "=== Criando schedule de backup diário ==="
echo "Cluster  : $CONTEXT"
echo "Schedule : $SCHEDULE_NAME (02:00 UTC)"

velero schedule create "$SCHEDULE_NAME" \
  --schedule "0 2 * * *" \
  --include-namespaces "$NAMESPACE_TO_BACKUP" \
  --snapshot-volumes=true \
  --storage-location default \
  --ttl 720h \
  --kubecontext "$CONTEXT"

echo ""
echo "Schedules ativos:"
velero schedule get --kubecontext "$CONTEXT"
