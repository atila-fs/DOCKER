# === FLUENT BIT === #

# Adicionar o repositório do Fluent Bit
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

# Criar um namespace para o Fluent Bit
kubectl create namespace fluent-bit

# Instalar o Fluent Bit
helm install fluent-bit fluent/fluent-bit -n fluent-bit --set backend.type=es --set backend.es.host=opensearch-client

# Verificar o serviço
kubectl get pods -n fluent-bit
kubectl get svc -n fluent-bit