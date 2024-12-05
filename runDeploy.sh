#!/bin/bash

set -e  # Interrompe o script em caso de erro
set -x  # Exibe os comandos no terminal para depuração

REGION="us-east-1"
CLUSTER_NAME="eks-cluster"
EKS_FILES="eks_files.yaml"

# Inicializar e aplicar o Terraform
terraform init
terraform plan
terraform apply -auto-approve

# Obter os valores de saída do Terraform
EKS_ENDPOINT=$(terraform output -raw eks_cluster_endpoint)
EKS_CA_CERT=$(terraform output -raw eks_cluster_ca_certificate)

# Configurar kubeconfig para o cluster EKS
echo "Configurando o acesso ao cluster EKS..."
aws --profile fiapeats eks --region $REGION update-kubeconfig --name $CLUSTER_NAME

# Validar a conexão com o cluster
echo "Validando a conexão com o cluster EKS..."
kubectl get nodes || { echo "Erro: Não foi possível conectar ao cluster EKS."; exit 1; }

# Aplicar os manifestos Kubernetes
echo "Aplicando manifestos Kubernetes..."
kubectl apply -f ./k8s --recursive|| { echo "Erro ao aplicar os manifestos Kubernetes."; exit 1; }

# Exibir os Pods em todos os namespaces
echo "Exibindo os Pods no cluster..."
kubectl get pods --all-namespaces

echo "Configuração concluída com sucesso: Cluster EKS e manifestos Kubernetes aplicados!"
