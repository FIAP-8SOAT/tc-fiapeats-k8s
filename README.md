# tc-fiapeats-k8s

Este repositório contém as configurações necessárias para provisionar e gerenciar um ambiente Kubernetes no Amazon EKS utilizando **Terraform**.

## Requisitos
Antes de iniciar, certifique-se de ter os seguintes requisitos instalados e configurados:

- **Terraform** >= 1.0.0
- **AWS CLI** configurado com suas credenciais
- **kubectl** para interagir com o cluster EKS

## Estrutura do Projeto
```
/
|-- main.tf            # Arquivo principal do Terraform
|-- variables.tf       # Variáveis do Terraform
|-- eks_files.yaml     # Manifests Kubernetes para configurações no cluster
|-- outputs.tf         # Outputs do Terraform
|-- README.md          # Documentação
```

## Como Usar
### 1. Criar o Ambiente
Para inicializar o Terraform e provisionar os recursos:

```bash
terraform init
```

```bash
terraform apply -auto-approve
```

Isso irá criar o cluster EKS e todos os recursos associados.

---

### 2. Aplicar as Configurações no Cluster EKS
Depois que o ambiente estiver provisionado, utilize o `kubectl` para aplicar os arquivos de configuração:

```bash
kubectl apply -f eks_files.yaml
```

- Certifique-se de que o **kubectl** está configurado com o `kubeconfig` correto.
- Utilize `kubectl get nodes` para validar que o cluster está ativo.

---

### 3. Destruir o Ambiente
Para remover todos os recursos provisionados pelo Terraform:

```bash
terraform destroy -auto-approve
```

> **Atenção:** Esta ação irá apagar todo o ambiente provisionado, incluindo o cluster EKS e recursos associados.

---

## Validação
Para verificar se o cluster está ativo e funcional:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

Caso haja algum problema, verifique os logs e status dos recursos:

```bash
kubectl describe nodes
kubectl logs <nome-do-pod>
```

## Referências
- [Documentação do Terraform](https://www.terraform.io/docs)
- [Documentação do AWS EKS](https://aws.amazon.com/eks/)
- [Documentação do Kubectl](https://kubernetes.io/docs/reference/kubectl/)
