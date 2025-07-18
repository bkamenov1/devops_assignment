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

## What is provisioned

- **Terraform successfully provisions the entire infrastructure on AWS**, including:
  - VPC, subnets, IAM roles
  - EKS Cluster and managed node groups
  - ECR repository for Docker images
- **Docker image is built and pushed to ECR**
- **Kubernetes manifests are applied**:
  - PostgreSQL StatefulSet with PVC
  - Application Deployment using the custom Docker image
  - Kubernetes services to expose both components
  - The EKS clusters nodes were successfully created and running.

## Current Issues

Despite correct setup of infrastructure and EKS:

- **Pods remain in `Pending` or `CrashLoopBackOff`** status:
  - PostgreSQL: Fails to bind PersistentVolumeClaim
  - App: Crashes with no logs returned
- **EBS CSI driver cannot create volumes** due to missing or misconfigured IAM/OIDC integration
  - Error: `No OpenIDConnect provider found in your account`
  - Attempts to set up IAM OIDC provider ran into AWS CLI or permission issues
- **Manual investigation** confirmed:
  - PVCs can't provision volumes
  - Pods are crashing, possibly due to startup errors or missing environment dependencies

## Attempts at Fixing

- Annotated service accounts with correct IAM role for EBS CSI driver
- Verified OIDC URL and attempted to create a provider using AWS CLI
- IAM policies for EKS and nodes were correctly attached
- Docker image built successfully and pulled by K8s nodes

##  Lessons Learned

- EKS setup requires **precise IAM**, especially for CSI drivers
- Compared to Azure (which I’m more familiar with), AWS permissions and service account linking are more error-prone and time-consuming
- Realized the importance of **automated validation steps** and **cloud-native troubleshooting tools** (e.g  `kubectl describe`,)


##  Summary

This project demonstrates the ability to:

- Work with Terraform to provision cloud infrastructure
- Build and deploy containerized apps
- Debug complex cloud-native issues 
