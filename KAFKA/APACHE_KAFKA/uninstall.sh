#!/bin/bash
set -euo pipefail

NAMESPACE="kafka"
RELEASE="kafka"

helm -n "$NAMESPACE" uninstall "$RELEASE" || echo "[WARN] Release não encontrada"

kubectl -n "$NAMESPACE" delete pvc -l app.kubernetes.io/instance="$RELEASE" --ignore-not-found=true
kubectl -n "$NAMESPACE" delete cm -l app.kubernetes.io/instance="$RELEASE" --ignore-not-found=true
kubectl -n "$NAMESPACE" delete secret -l app.kubernetes.io/instance="$RELEASE" --ignore-not-found=true
kubectl delete namespace "$NAMESPACE" --ignore-not-found=true

echo "Kafka removido com sucesso."