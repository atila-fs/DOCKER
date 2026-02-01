#!/bin/bash
set -e

ATLANTIS_DIR="/opt/projects-ops/atlantis"
ATLANTIS_UID=100
ATLANTIS_GID=1000
TG_BIN="$ATLANTIS_DIR/terragrunt"
TG_VERSION="latest"

echo "Criando diretórios..."
mkdir -p $ATLANTIS_DIR
mkdir -p $ATLANTIS_DIR/data
mkdir -p $ATLANTIS_DIR/certs

echo "Ajustando permissões..."
chown -R $ATLANTIS_UID:$ATLANTIS_GID $ATLANTIS_DIR/data
chmod 755 $ATLANTIS_DIR/data

echo "Baixando Terragrunt..."

if [ "$TG_VERSION" = "latest" ]; then
    echo "Obtendo última versão no GitHub..."
    TG_VERSION=$(wget -qO- https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep tag_name | cut -d '"' -f 4)
    echo "Versão encontrada: $TG_VERSION"
fi

TG_URL="https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64"

echo "Baixando: $TG_URL"
wget -qO "$TG_BIN" "$TG_URL"

chmod +x "$TG_BIN"

echo "Terragrunt instalado em: $TG_BIN"

echo "Montando a imagem do Atlantis"
docker build -t atlantis-custom .

echo "Finalizando container anterior (se existir)..."
docker compose -f "$ATLANTIS_DIR/docker-compose.yml" down || true

echo "Subindo Atlantis com Docker Compose..."
cd "$ATLANTIS_DIR"
docker compose up -d --build

echo "Setup finalizado."
echo "Use: docker logs -f atlantis"
echo "Atlantis disponível na porta 4141."