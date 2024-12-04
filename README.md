# tc-fiapeats-k8s


### Criar o ambiente
```bash
terraform init
```
```bash
terraform apply -auto-approve
```


### aplicar as configs no eks
```bash
kubectl apply -f eks_files.yaml
```


### destruir o ambiente
```bash
terraform destroy -auto-approve
```