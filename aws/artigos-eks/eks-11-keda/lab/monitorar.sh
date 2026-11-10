#!/usr/bin/env bash
# Linha do tempo do teste: fila × réplicas × pods pendentes × nós do Karpenter.
# Uso: QUEUE_URL=... AWS_REGION=us-east-1 ./monitorar.sh > linha-do-tempo.csv
set -uo pipefail
INICIO=$(date +%s)
echo "segundos,visiveis,em_processamento,replicas_desejadas,pods_running,pods_pending,nos_karpenter"
while true; do
  read -r VIS INFL < <(aws sqs get-queue-attributes --queue-url "$QUEUE_URL" --region "$AWS_REGION" \
    --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible \
    --query 'Attributes.[ApproximateNumberOfMessages,ApproximateNumberOfMessagesNotVisible]' --output text)
  DESEJADAS=$(kubectl get deploy worker -n jobs -o jsonpath='{.spec.replicas}' 2>/dev/null)
  RUNNING=$(kubectl get pods -n jobs -l app=worker --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')
  PENDING=$(kubectl get pods -n jobs -l app=worker --field-selector=status.phase=Pending --no-headers 2>/dev/null | wc -l | tr -d ' ')
  NOS=$(kubectl get nodes -l karpenter.sh/nodepool=default --no-headers 2>/dev/null | wc -l | tr -d ' ')
  echo "$(( $(date +%s) - INICIO )),${VIS},${INFL},${DESEJADAS:-0},${RUNNING},${PENDING},${NOS}"
  sleep 10
done
