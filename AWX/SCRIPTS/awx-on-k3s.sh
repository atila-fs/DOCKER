#!/bin/bash

# Modo "exit on error"
set -e

# Variáveis
NAMESPACE="awx"
DOMAIN="awx<valid_domain>"
CERT_PATH="/opt/k3s-projects/ssl"
CERT_CRT="$CERT_PATH/crt.crt"
CERT_KEY="$CERT_PATH/key.key"
SECRET_NAME="awx-tls-cert"
AWX_DIR="/opt/k3s-projects/awx-operator"

# 1. Instalar dependências
echo "Verificando se 'git' está instalado..."
command -v git >/dev/null 2>&1 || { echo "git não encontrado. Instale com: apt install git -y"; exit 1; }

# 2. Clonar repositório oficial do AWX Operator
echo "Clonando AWX Operator..."
rm -rf "$AWX_DIR"
git clone https://github.com/ansible/awx-operator.git "$AWX_DIR"
cd "$AWX_DIR"

# Pega a última versão estável (começa com número, ex: '2.10.0')
LATEST_TAG=$(git tag | grep -E '^[0-9]+\.[0-9]+' | sort -Vr | head -n1)
git checkout "$LATEST_TAG"

# 3. Criar namespace AWX
echo "Criando namespace $NAMESPACE..."
kubectl create namespace "$NAMESPACE" || true

# 4. Instalar operador AWX
echo "Aplicando operador AWX..."
kubectl apply -k config/default -n "$NAMESPACE"

# 5. Criar Secret com certificado SSL
echo "Criando Secret TLS com certificado personalizado..."
kubectl create secret tls "$SECRET_NAME" \
  --cert="$CERT_CRT" \
  --key="$CERT_KEY" \
  -n "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# 6. Criar recurso AWX com Ingress
echo "Gerando recurso AWX..."
cat <<EOF | kubectl apply -f -
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
  namespace: $NAMESPACE
spec:
  service_type: ClusterIP
  ingress_type: ingress
  hostname: $DOMAIN
  ingress_tls_secret: $SECRET_NAME
EOF

echo "AWX instalado com sucesso! Aguarde alguns minutos até os pods ficarem prontos."
echo ""
echo "Quando estiver tudo pronto, rode este comando para obter a senha do admin:"
echo "kubectl get secret awx-admin-password -n awx -o jsonpath="{.data.password}" | base64 -d && echo"