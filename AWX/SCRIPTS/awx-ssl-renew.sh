#!/bin/bash
cd /opt/k3s-projects/awx-operator
kubectl create secret tls awx-tls-cert --cert=/opt/k3s-projects/ssl/crt.crt --key=/opt/k3s-projects/ssl/key.key -n awx --dry-run=client -o yaml | kubectl apply -f -