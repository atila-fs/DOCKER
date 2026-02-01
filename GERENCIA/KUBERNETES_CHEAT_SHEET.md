# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 📘 REFERÊNCIA RÁPIDA – KUBERNETES COMUM EM CLUSTERS PADRÕES                                                                           
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 🧩 COMPONENTES COMUNS DO CLUSTER                                                                                                      
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧠 CoreDNS
Serviço DNS interno do cluster. Resolve nomes como svc.cluster.local e permite comunicação entre pods e serviços. Substituiu o kube-dns.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔀 kube-proxy
Responsável pelo roteamento de tráfego dentro do cluster via iptables ou ipvs. Faz o tráfego chegar aos serviços corretos.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🌐 Traefik (Ingress Controller)
Balanceador de carga L7. Roteia requisições HTTP/S externas para os serviços internos. Alternativa ao NGINX Ingress.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📡 kube-apiserver
Interface principal da API do Kubernetes. Todos os comandos kubectl se comunicam com ele. Valida, autentica e processa requisições.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🗄️ etcd
Banco de dados chave-valor onde todo o estado do cluster é armazenado: pods, configs, secrets, etc.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧩 kube-scheduler
Decide em qual nó um novo pod será executado com base em critérios como recursos, afinidades, tolerâncias e restrições.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
👷 kube-controller-manager
Gerencia controladores como deployment, replicaSet, node etc. Garante que o estado atual do cluster corresponda ao desejado.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📊 metrics-server
Coleta métricas de CPU e memória de pods e nodes. Necessário para kubectl top e Horizontal Pod Autoscaler (HPA).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📉 coredns-autoscaler (opcional)
Escala automaticamente as réplicas do CoreDNS conforme a carga do cluster (útil com autoscaling).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🖥️ dashboard (opcional)
Interface web para visualizar, monitorar e interagir com recursos do cluster Kubernetes.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🌐 calico / flannel / cilium (CNI)
Plugins de rede que conectam os pods entre si. Responsáveis pelo tráfego de rede dentro do cluster (escolhido na instalação).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📥 Ingress / Ingress Controller
Define regras de roteamento HTTP/S. Controladores como Traefik ou NGINX aplicam essas regras para expor apps.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🚫 default backend
Página padrão retornada quando nenhuma rota no Ingress corresponde à requisição (ex: 404 de fallback).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# ⚙️ COMANDOS DE GERENCIA VIA CLI (kubectl) 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📦 GERAL
kubectl get pods --all-namespaces                                   # Ver todos os pods de todos os namespaces  
kubectl get all                                                     # Tudo que for possível no namespace atual  
kubectl get all -A                                                  # Tudo em todos os namespaces  
kubectl get nodes                                                   # Ver todos os nós do cluster  
kubectl get svc                                                     # Ver os serviços (services)  
kubectl get deployment                                              # Ver deployments  
kubectl get namespace                                               # Ver todos os namespaces  
kubectl get configmap                                               # Ver configmaps  
kubectl get secret                                                  # Ver secrets  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔍 DEBUG / INSPEÇÃO
kubectl describe pod <pod>                                          # Detalhes completos do pod  
kubectl describe svc <serviço>                                      # Detalhes de um service  
kubectl logs <pod>                                                  # Ver logs de um pod  
kubectl logs -f <pod>                                               # Seguir logs em tempo real  
kubectl logs <pod> -c <container>                                   # Logs de um container específico  
kubectl logs -n <namespace> <pod>                                   # Logs especificando namespace  
kubectl exec -it <pod> -- /bin/bash                                 # Acessar o container com shell  
kubectl exec -n <namespace> -it <pod> -- /bin/sh                    # Exec com namespace  
kubectl top pod                                                     # Uso de CPU/Memória (requer metrics-server)  
kubectl top node                                                    # Uso de CPU/Memória por nó  
kubectl get events --sort-by=.metadata.creationTimestamp            # Eventos recentes  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🎮 CONTROLE DE RECURSOS
kubectl apply -f <arquivo.yaml>                                     # Aplicar um recurso  
kubectl delete -f <arquivo.yaml>                                    # Deletar um recurso  
kubectl delete pod <pod>                                            # Deletar um pod  
kubectl scale deployment <nome> --replicas=3                        # Escalar replicas de um deployment  
kubectl rollout restart deployment <nome>                           # Reiniciar um deployment  
kubectl rollout status deployment <nome>                            # Ver status de rollout  
kubectl edit deployment <nome>                                      # Editar um deployment ao vivo  
kubectl edit configmap <nome>                                       # Editar um configmap ao vivo  
kubectl edit svc <nome>                                             # Editar um service  
kubectl delete configmap <nome>                                     # Deletar configmap  
kubectl delete svc <nome>                                           # Deletar service  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧠 INFO & CONTEXTO
kubectl config get-contexts                                         # Ver contextos do kubeconfig  
kubectl config use-context <context>                                # Mudar contexto atual  
kubectl config view                                                 # Ver kubeconfig atual  
kubectl version --short                                             # Versão do client e server  
kubectl api-resources                                               # Ver todos os tipos de recursos disponíveis  
kubectl get crds                                                    # Ver Custom Resource Definitions  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧰 OUTROS ÚTEIS
kubectl explain <recurso>                                           # Explica a estrutura de um recurso  
kubectl explain pod.spec.containers                                 # Explica uma seção específica  
kubectl port-forward <pod> 8080:80                                  # Redirecionar porta local para um pod  
kubectl port-forward svc/<svc> 8080:80                              # Redirecionar porta local para um service  
kubectl cp <arquivo-local> <pod>:/caminho                           # Copiar arquivo para dentro do pod  
kubectl cp <pod>:/caminho <arquivo-local>                           # Copiar arquivo de dentro do pod  
kubectl label pod <pod> chave=valor                                 # Adicionar/editar label em um pod  
kubectl annotate pod <pod> chave=valor                              # Adicionar anotação  
kubectl cordon <nó>                                                 # Marcar nó como "não agendável"  
kubectl uncordon <nó>                                               # Voltar nó para agendável  
kubectl drain <nó> --ignore-daemonsets --delete-emptydir-data       # Esvaziar nó para manutenção  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 🧠 DICAS RÁPIDAS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧠 1. Pod não sobe / CrashLoopBackOff
Verifica os logs:
kubectl logs <pod>  
kubectl logs <pod> -c <container>  # se tiver mais de um container

Describe para ver eventos de erro:
kubectl describe pod <pod>

Geralmente é:
1. Comando errado no command: ou args;
2. Variável de ambiente faltando;
3. Volume mal montado;
4. Porta em uso ou não exposta;
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔍 2. Alterou um ConfigMap mas nada mudou?
ConfigMap não atualiza pods automaticamente.

Você precisa forçar um restart:
kubectl rollout restart deployment <deployment>
ou
kubectl delete pod <pod>  # ele vai ser recriado com config nova
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🚫 3. "connection refused" entre pods?
Verifica se o Service está criado e correto:
kubectl get svc

Testa de dentro do pod:
kubectl exec -it <pod> -- curl http://<service>:<porta>
Lembra que o nome do serviço é o DNS interno (servico.namespace.svc.cluster.local)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧩 4. Ingress não funciona / 404?
Verifica se o Ingress Controller está rodando (Traefik, NGINX etc):
kubectl get pods -n kube-system

Verifica se a rota do Ingress está certa:
kubectl describe ingress <nome>

Testa o IP externo / port-forward se estiver em cluster local:
kubectl port-forward svc/traefik 8080:80 -n kube-system
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📦 5. Nada aparece com kubectl get all?
Lembra que isso só mostra recursos do namespace atual.
Veja todos os namespaces:
kubectl get all -A

Ou troca o namespace:
kubectl config set-context --current --namespace=<ns>
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔄 6. Deployment não atualiza?
Às vezes, kubectl apply -f não detecta mudança (ex: mesma imagem com tag latest).
Força o rollout:
kubectl rollout restart deployment <nome>
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧼 7. Quer resetar rápido um pod com erro?
kubectl delete pod <pod>
Ele vai ser recriado se fizer parte de um deployment ou replicaset.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📂 8. Precisa ver o YAML real de algo?
kubectl get pod <nome> -o yaml
kubectl get svc <nome> -o yaml
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧪 9. Quer testar rapidinho alguma coisa?
Cria um pod de debug com alpine ou busybox:
kubectl run -it --rm debug --image=alpine -- sh
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 📄 YAMLs BÁSICOS PARA USO FREQUENTE
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📦 Deployment básico
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: meu-app
  template:
    metadata:
      labels:
        app: meu-app
    spec:
      containers:
      - name: app
        image: nginx:stable
        ports:
        - containerPort: 80
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #        
🔄 Service para o deployment
apiVersion: v1
kind: Service
metadata:
  name: meu-app-service
spec:
  selector:
    app: meu-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🌐 Ingress básico
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: meu-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: meuapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: meu-app-service
            port:
              number: 80
⚠️ Requer controller de Ingress instalado. Ex: NGINX Ingress Controller.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 📦 USANDO HELM (SE UTILIZADO NO CLUSTER)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔍 Buscar charts disponíveis
helm search repo nginx
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔧 Instalar um chart
helm install meu-nginx bitnami/nginx --values meu-valores.yaml
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🔁 Atualizar release
helm upgrade meu-nginx bitnami/nginx --values meu-valores.yaml
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🗑️ Remover release
helm uninstall meu-nginx
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
🧪 Renderizar sem aplicar (debug)
helm template meu-nginx bitnami/nginx --values meu-valores.yaml
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
📁 Estrutura de um chart Helm simples
meu-chart/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    └── service.yaml
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #