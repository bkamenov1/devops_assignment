# DevOps Challenge – EKS Infrastructure with Kubernetes App Deployment

This project demonstrates how to deploy a containerized Python application with a PostgreSQL database on a Kubernetes cluster hosted in Amazon Elastic Kubernetes Service (EKS). The infrastructure is provisioned using Terraform, the application is containerized with Docker, and Kubernetes manifests are used to deploy and manage the app components.

# Key technologies used:

- **Terraform** for provisioning AWS resources (VPC, EKS, ECR, etc.)
- **Docker** for containerizing the Python app
- **Kubernetes (EKS)** for deploying the app and database
- **Amazon ECR** for hosting Docker images


## 📌 Project Structure

```text
devops-challenge/
├── terraform/                    # Terraform infrastructure code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── k8s/                          # Kubernetes manifests
│   ├── postgres-deployment.yaml
│   ├── app-deployment.yaml
│   └── secrets.yaml
├── app/                          # Application code
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app.py
├── scripts/                      # Helper scripts
│   └── build_push.sh
└── README.md                     # Documentation
```
# Deployment Steps

1. **Clone the repository** with the project code and infrastructure files.

2. **Configure AWS CLI** with your credentials:
```bash
aws configure
```

3. **Initialize Terraform** inside the `terraform/` folder:
```bash
terraform init
```

4. **Apply Terraform plan** to create infrastructure (VPC, EKS cluster, node groups, IAM roles, OIDC provider):
```bash
terraform apply
```
5. Build and Push Docker Image:
```bash
docker build
docker tag 
docker push 
```
6. **Update kubeconfig** to connect `kubectl` to the new EKS cluster:
```bash
aws eks update-kubeconfig --name my-cluster --region eu-north-1

```

7. **Deploy PostgreSQL with PVC** using your manifest:
```bash
kubectl apply -f k8s/postgres-deployment.yaml
```

8. **Deploy your application pods**:
```bash
kubectl apply -f k8s/app-deployment.yaml
```

9. **Verify all pods are running and PVCs are bound:**
```bash
kubectl get pods
kubectl get pvc
```

10. **Troubleshoot if needed:** check pod events and logs:
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```
Restart CSI driver pods if volume provisioning fails or pods stay pending.


## What is provisioned

- **Terraform successfully provisions the entire infrastructure on AWS**, including:
  - VPC, subnets, IAM roles
  - EKS Cluster and managed node groups
  - ECR repository for Docker images

- **Docker image built, pushed to ECR and pulled by K8s nodes**

- **Kubernetes manifests are applied**:
  - PostgreSQL StatefulSet with PVC
  - Application Deployment using the custom Docker image
  - Kubernetes services to expose both components
  - The EKS clusters nodes were successfully created and running.
