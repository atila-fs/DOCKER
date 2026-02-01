#!/usr/bin/env bash

# COMO USAR
# 1) trocar a senha (exemplo)
# wazuh-change-admin-pass.sh 'Hunters@2236'
# 2) se quiser que já reinicie manager/dashboard:
# RESTART=yes wazuh-change-admin-pass.sh 'Hunters@2236'

# wazuh-change-admin-pass.sh
set -euo pipefail

# ====== ajustes rápidos se seu layout for diferente ======
WAZUH_DIR="${WAZUH_DIR:-/opt/wazuh}"
USERS_FILE="${USERS_FILE:-$WAZUH_DIR/config/wazuh_indexer/internal_users.yml}"
ADMIN_USER="${ADMIN_USER:-admin}"
RESTART="${RESTART:-no}"         # yes para reiniciar manager/dashboard ao final
# =========================================================

log() { printf "\033[1;32m[+] %s\033[0m\n" "$*"; }
err() { printf "\033[1;31m[!] %s\033[0m\n" "$*" >&2; }

# Descobre comando compose
if command -v docker &>/dev/null && docker compose version &>/dev/null; then
  COMPOSE_CMD=(docker compose -f "$WAZUH_DIR/docker-compose.yml")
elif command -v docker-compose &>/dev/null; then
  COMPOSE_CMD=(docker-compose -f "$WAZUH_DIR/docker-compose.yml")
else
  err "docker compose/docker-compose não encontrado"; exit 1
fi

# Lê nova senha (arg1 ou prompt silencioso)
NEW_PASS="${1:-}"
if [[ -z "$NEW_PASS" ]]; then
  read -s -p "Nova senha para '$ADMIN_USER': " NEW_PASS; echo
  [[ -z "$NEW_PASS" ]] && { err "Senha vazia"; exit 1; }
fi

# Validação simples de força (8+, maiúscula, minúscula, dígito, especial)
if ! [[ ${#NEW_PASS} -ge 8 && "$NEW_PASS" =~ [A-Z] && "$NEW_PASS" =~ [a-z] && "$NEW_PASS" =~ [0-9] && "$NEW_PASS" =~ [^A-Za-z0-9] ]]; then
  err "Senha fraca: precisa 8+ chars c/ maiúscula, minúscula, dígito e especial."; exit 1
fi

# Container do indexer
INDEXER_CTN="$(docker ps --format '{{.Names}}' | grep -E '^wazuh.*indexer' | head -n1 || true)"
[[ -z "$INDEXER_CTN" ]] && { err "Container do indexer não encontrado (procure por 'indexer')."; exit 1; }

# Checagens de arquivo
if [[ ! -e "$USERS_FILE" ]]; then
  err "Arquivo $USERS_FILE não existe (ou caminho errado)."; exit 1
fi
if [[ -d "$USERS_FILE" ]]; then
  err "$USERS_FILE é um DIRETÓRIO. Precisa ser ARQUIVO YAML."; exit 1
fi

log "Gerando hash no container: $INDEXER_CTN"
HASH="$(docker exec "$INDEXER_CTN" bash -lc "/usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh -p \"\$1\"" _ ignored 2>/dev/null <<<"$NEW_PASS" \
  || docker exec "$INDEXER_CTN" bash -lc "/usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh -p \"$NEW_PASS\"" \
)"
HASH="$(echo "$HASH" | tail -1 | tr -d '\r')"
[[ -z "$HASH" ]] && { err "Falha ao gerar hash."; exit 1; }

# Backup
TS="$(date +%Y%m%d-%H%M%S)"
cp -a "$USERS_FILE" "${USERS_FILE}.bak.$TS"
log "Backup feito: ${USERS_FILE}.bak.$TS"

# Atualiza o hash do usuário alvo por sed (range do bloco YAML)
log "Atualizando hash do usuário '$ADMIN_USER' em $USERS_FILE"
# shellcheck disable=SC2016
sed -i -e '/^'"$ADMIN_USER"':\s*$/,/^[^[:space:]]/ s/^\(\s*hash:\).*/\1 "'"$HASH"'"/' "$USERS_FILE"

# Aplica no OpenSearch Security
log "Aplicando no OpenSearch Security (securityadmin.sh)"
docker exec "$INDEXER_CTN" bash -lc '\
/usr/share/wazuh-indexer/plugins/opensearch-security/tools/securityadmin.sh \
  -cd /usr/share/wazuh-indexer/config/opensearch-security/ \
  -icl -nhnv \
  -cacert /usr/share/wazuh-indexer/config/certs/root-ca.pem \
  -cert  /usr/share/wazuh-indexer/config/certs/admin.pem \
  -key   /usr/share/wazuh-indexer/config/certs/admin-key.pem'

log "Senha aplicada para '$ADMIN_USER'."

# Opcional: reiniciar serviços dependentes
if [[ "$RESTART" == "yes" ]]; then
  log "Reiniciando manager (para Filebeat reler credenciais)..."
  "${COMPOSE_CMD[@]}" restart wazuh.manager || true

  log "Reiniciando dashboard (se usar o mesmo user/senha)..."
  "${COMPOSE_CMD[@]}" restart wazuh.dashboard || true
else
  cat <<EOF
[Info] Lembre-se:
  - Se o 'wazuh.manager' (Filebeat) usa $ADMIN_USER para falar com o Indexer,
    ajuste as variáveis no compose:
      INDEXER_USERNAME=$ADMIN_USER
      INDEXER_PASSWORD=<NOVA_SENHA>
    e reinicie: ${COMPOSE_CMD[*]} restart wazuh.manager

  - Para testar:
      curl -sk -u $ADMIN_USER:'<NOVA_SENHA>' https://127.0.0.1:9400/_cluster/health
EOF
fi

log "Concluído."