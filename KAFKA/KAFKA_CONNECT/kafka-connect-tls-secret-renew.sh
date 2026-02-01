#!/bin/bash
cd /opt/k3s/services/kafka-connect
kubectl create secret tls kafka-connect-tls  --cert=/opt/k3s/ssl/crt.crt   --key=/opt/k3s/ssl/key.key   -n kafka-drop   --dry-run=client -o yaml | kubectl apply -f -