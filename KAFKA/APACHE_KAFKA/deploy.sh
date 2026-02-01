#!/bin/bash
set -euo pipefail

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace kafka 2>/dev/null || true

helm -n kafka upgrade --install kafka bitnami/kafka \
  --version 32.2.16 \
  --reset-values \
  -f base.yml \
  -f listeners.yml \
  -f heap.yml \
  -f resources.yml \
  -f probes.yml

kubectl -n kafka rollout status statefulset/kafka-controller
kubectl -n kafka get pods -o wide

echo "Kafka instalado com sucesso."