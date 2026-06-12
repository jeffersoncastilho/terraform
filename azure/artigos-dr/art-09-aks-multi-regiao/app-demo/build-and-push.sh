#!/usr/bin/env bash
set -euo pipefail

ACR="acrblogcastilho.azurecr.io"
IMAGE="dr-demo"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

az acr login --name acrblogcastilho

build_and_push() {
  local region=$1
  local tag="$ACR/$IMAGE:$region"
  echo "=== Build: $tag ==="
  docker build \
    --build-arg REGION="$region" \
    -t "$tag" \
    "$SCRIPT_DIR"
  docker push "$tag"
  echo "Push concluído: $tag"
}

build_and_push "Brazil South"
build_and_push "East US"
