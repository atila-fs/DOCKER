#!/bin/bash
set -euo pipefail

kubectl -n kafka-drop rollout restart deployment kafdrop
kubectl -n kafka-drop rollout status deployment kafdrop