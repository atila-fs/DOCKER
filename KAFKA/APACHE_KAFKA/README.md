# === APACKE KAFKA === #

# Instalação do Helm no cluster K3s #
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Adicionar o repositório do Kafka (Bitnami) #
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Criar um namespace para o Kafka # 
kubectl create namespace kafka

# Instalar o Kafka #
helm install kafka bitnami/kafka -n kafka   --set persistence.enabled=false   --set auth.enabled=false   --set replicaCount=3   --set listeners.client.protocol=PLAINTEXT   --set listeners.external.protocol=PLAINTEXT   --set service.type=ClusterIP

# Verificar o serviço #
kubectl get pods -n kafka
kubectl get svc -n kafka

# Criar um pod de teste para validar o funcionamento do Kafka #

# Criar um pod temporario #
kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:4.0.0-debian-12-r7 --namespace kafka --command -- sleep infinity

# Conectar no pod #
kubectl exec --tty -i kafka-client --namespace kafka -- bash

# Comando para simular o PRODUCER #
kafka-console-producer.sh \
--bootstrap-server kafka.kafka.svc.cluster.local:9092 \
--topic test

# Comando para simular o CONSUMER #
kafka-console-consumer.sh \
--bootstrap-server kafka.kafka.svc.cluster.local:9092 \
--topic test \
--from-beginning