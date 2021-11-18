#!/bin/bash

## Terraform init and apply 
cd ../VPC
terraform init
# change it to apply later
terraform plan -var-file="env/$1.tfvars" -var aws_region="$2" -var eks_cluster_name="$3"

## Image creation
cd ../App 
docker image build -t mable-app:0.0.1 .

## Depoying application
aws eks --region $2 update-kubeconfig --name $3
cd ../k8s
kubectl apply -f deployment.yaml


