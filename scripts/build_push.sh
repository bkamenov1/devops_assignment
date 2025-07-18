#!/bin/bash
set -e
aws eks update-kubeconfig --region eu-north-1 --name my-cluster
kubectl apply -f ../k8s/secrets.yaml
kubectl apply -f ../k8s/postgres-deployment.yaml
kubectl apply -f ../k8s/app-deployment.yaml
echo "Deployed. Get LoadBalancer: kubectl get svc app"