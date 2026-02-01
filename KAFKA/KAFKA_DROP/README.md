# ################################################################################################################################################################################# #
# Gerar o secret do Ingress
# PASSO 1 
# Mover o .crt e .key do certificado utilizado no ingress para o diretório configurado

# PASSO 2 
# Rodar o comando no terminal para criar o secret
kubectl create secret tls my-tls-secret --cert=/opt/k3s/ssl/crt.crt --key=/opt/k3s/ssl/key.key -n kafka-drop

# ################################################################################################################################################################################# #
# Gerar a senha e o secret do Middleware Ingress
# PASSO 1
# Rodar o comando no terminal para criar a senha e usuário
htpasswd -nb [USERNAME] [PASSWORD]
# Exemplo de output
dba:$apr1$5HAUONhj$OrYePQa609cyXw4iQFECl0
# OBS: A senha vai ser sem criptografia

# PASSO 2 
# Criar o secret para o middleware ingress do Kafka-drop
kubectl create secret generic kafka-drop-auth-secret --from-literal=username=[USERNAME] --from-literal=password=[PASSWORD] --type=kubernetes.io/basic-auth -n kafka-drop

# ################################################################################################################################################################################# #