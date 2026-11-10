#!/usr/bin/env bash
# Envia N mensagens para a fila em lotes de 10 (limite do SendMessageBatch).
# Uso: QUEUE_URL=... AWS_REGION=us-east-1 ./enviar-mensagens.sh 1000
set -euo pipefail
TOTAL="${1:-1000}"
for ((i = 0; i < TOTAL; i += 10)); do
  entries=""
  for ((j = 0; j < 10 && i + j < TOTAL; j++)); do
    entries+="{\"Id\":\"m$j\",\"MessageBody\":\"job-$((i + j))\"},"
  done
  aws sqs send-message-batch --queue-url "$QUEUE_URL" --region "$AWS_REGION" \
    --entries "[${entries%,}]" --query 'length(Successful)' --output text >/dev/null
done
echo "enviadas: $TOTAL"
