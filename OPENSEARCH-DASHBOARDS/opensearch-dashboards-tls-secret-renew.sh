#!/bin/bash
cd /opt/k3s/services/opensearch-dashboards
kubectl create secret tls opensearch-tls-secret --cert=/opt/k3s/ssl/crt.crt   --key=/opt/k3s/ssl/key.key   -n kafka-drop   --dry-run=client -o yaml | kubectl apply -f -