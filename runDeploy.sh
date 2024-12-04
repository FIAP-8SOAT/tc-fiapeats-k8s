#!/bin/bash
terraform init
terraform plan
terraform apply -auto-approve
aws eks --region us-east-1 update-kubeconfig --name <cluster-name>
kubectl apply -f eks_files.yaml
