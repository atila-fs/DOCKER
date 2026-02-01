#!/usr/bin/env bash
# Cria usuário no OpenSearch Security (Wazuh Indexer) e mapeia para uma role.
set -euo pipefail

INDEXER_URL="${INDEXER_URL:-https://127.0.0.1:9400}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-}"

echo "== Wazuh / OpenSearch Security - Criar usuário =="

# Admin auth
read -rp "Admin user [${ADMIN_USER}]: " _in || true
[[ -n "${_in}" ]] && ADMIN_USER="${_in}"
if [[ -z "${ADMIN_PASS}" ]]; then
  read -rs -p "Admin password: " ADMIN_PASS; echo
fi

# Testa conexão
if ! curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" "${INDEXER_URL}/_cluster/health" >/dev/null; then
  echo "ERRO: não consegui autenticar no Indexer em ${INDEXER_URL} com ${ADMIN_USER}" >&2
  exit 1
fi

# Novo usuário
while :; do
  read -rp "Novo username: " NEW_USER
  [[ -n "${NEW_USER}" ]] && break
done
if [[ "${NEW_USER}" == "admin" || "${NEW_USER}" == "kibanaserver" ]]; then
  echo "ERRO: não use nomes reservados (admin/kibanaserver)"; exit 1
fi

# Senha + validação simples
read -rs -p "Nova senha para ${NEW_USER}: " NEW_PASS; echo
read -rs -p "Confirme a senha: " NEW_PASS2; echo
[[ "${NEW_PASS}" == "${NEW_PASS2}" ]] || { echo "ERRO: senhas não conferem"; exit 1; }
if ! [[ ${#NEW_PASS} -ge 8 && "$NEW_PASS" =~ [A-Z] && "$NEW_PASS" =~ [a-z] && "$NEW_PASS" =~ [0-9] && "$NEW_PASS" =~ [^A-Za-z0-9] ]]; then
  echo "ERRO: senha fraca (mín. 8, com maiúscula, minúscula, dígito e especial)"; exit 1
fi

# Lista roles disponíveis
echo "== Lendo roles disponíveis..."
ROLES_JSON="$(curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" "${INDEXER_URL}/_plugins/_security/api/roles")"
if [[ -z "${ROLES_JSON}" ]]; then
  echo "ERRO: não consegui listar roles da Security API"; exit 1
fi

# Constrói lista de roles (chaves do JSON)
mapfile -t ROLES < <(python3 - <<'PY' 2>/dev/null
import sys,json
data=json.load(sys.stdin)
# filtra internas chatas se quiser; aqui mantemos todas
print("\n".join(sorted(data.keys())))
PY
<<< "${ROLES_JSON}"
)

if [[ ${#ROLES[@]} -eq 0 ]]; then
  echo "ERRO: nenhuma role encontrada"; exit 1
fi

echo "== Escolha a role para o usuário =="
i=1
for r in "${ROLES[@]}"; do
  printf "%2d) %s\n" "$i" "$r"
  ((i++))
done
while :; do
  read -rp "Número da role: " CH
  [[ "$CH" =~ ^[0-9]+$ ]] || { echo "Digite um número"; continue; }
  (( CH>=1 && CH<=${#ROLES[@]} )) || { echo "Fora do intervalo"; continue; }
  ROLE="${ROLES[CH-1]}"
  break
done
echo "Selecionado: ${ROLE}"

# 1) Cria/atualiza internal user (a API aceita plain 'password' e faz hash)
echo "== Criando/atualizando usuário '${NEW_USER}'..."
CREATE_RESP="$(curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" \
  -H 'Content-Type: application/json' \
  -X PUT "${INDEXER_URL}/_plugins/_security/api/internalusers/${NEW_USER}" \
  -d "{\"password\":\"${NEW_PASS}\"}")" || true

# 2) Lê o rolesmapping atual da ROLE, adiciona o usuário à lista 'users' e PUT de volta
echo "== Mapeando '${NEW_USER}' na role '${ROLE}'..."
RM_JSON="$(curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" \
  "${INDEXER_URL}/_plugins/_security/api/rolesmapping/${ROLE}")"

# Atualiza JSON mantendo já existentes
NEW_RM_JSON="$(python3 - <<'PY'
import sys,json,os
import argparse
parser=argparse.ArgumentParser()
parser.add_argument("--role", required=True)
parser.add_argument("--user", required=True)
args=parser.parse_args()

raw=sys.stdin.read().strip()
if not raw:
    # caso a role não exista (improvável), aborta
    print("")
    sys.exit(0)
data=json.loads(raw)
role=args.role
# estrutura vem como {"role": {...}}
rm=data.get(role, {})
users=set(rm.get("users", []))
users.add(args.user)
rm["users"]=sorted(users)
# preserva backend_roles/hosts se existirem
out={role: rm}
print(json.dumps(out))
PY
--role "${ROLE}" --user "${NEW_USER}" <<< "${RM_JSON}"
)"

if [[ -z "${NEW_RM_JSON}" ]]; then
  echo "ERRO: não consegui processar o roles mapping para '${ROLE}'"; exit 1
fi

# Aplica mapping atualizado
curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" \
  -H 'Content-Type: application/json' \
  -X PUT "${INDEXER_URL}/_plugins/_security/api/rolesmapping/${ROLE}" \
  -d "${NEW_RM_JSON}" >/dev/null

# 3) Teste básico: checa se usuário aparece no mapping
CHECK="$(curl -sk -u "${ADMIN_USER}:${ADMIN_PASS}" "${INDEXER_URL}/_plugins/_security/api/rolesmapping/${ROLE}" \
  | grep -q "\"${NEW_USER}\"" && echo OK || echo FAIL)"
[[ "${CHECK}" == "OK" ]] || { echo "AVISO: não confirmei o mapping (verifique no Dashboard > Security)"; }

echo
echo "✅ Usuário '${NEW_USER}' criado e mapeado para a role '${ROLE}'."
echo "   - Faça login no Dashboard com: ${NEW_USER} / <sua-senha>"
echo "   - Para testar via API: curl -sk -u ${NEW_USER}:'<senha>' ${INDEXER_URL}/_cluster/health | head -c 120 && echo"