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
5. Build and Push Docker Image

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

 ## Troubleshooting PVC and Pending Pods

 - Faced issues with PVCs stuck in Pending and pods not starting due to volume problems. To resolve this:

  - Verified PVCs were properly bound to PersistentVolumes (PVs).
  
  - Ensured the StorageClass used the correct AWS EBS CSI driver provisioner.
  
  - Annotated the EBS CSI driver service account with the correct IAM role for AWS permissions.
  
  - Created and verified the IAM OIDC provider to enable secure role assumption.
  
  - Checked pod events (kubectl describe pod) for volume errors.
  
  - Confirmed cluster nodes were Ready and had enough capacity.
  
  - Validated PVC and PV access modes and sizes matched.
  
  - Restarted CSI driver pods to fix any provisioning timeouts or issues.

##  Lessons Learned

- EKS setup requires **precise IAM**, especially for CSI drivers
- Compared to Azure (which I’m more familiar with), AWS permissions and service account linking are more error-prone and time-consuming
- Realized the importance of **automated validation steps** and **cloud-native troubleshooting tools** (e.g  `kubectl describe`,)
- StorageClass configuration and compatibility between PVCs and PVs can cause subtle provisioning issues
- Restarting controller pods (like CSI drivers) can resolve transient AWS API or provisioning failures



##  Summary

This project demonstrates the ability to:

- Work with Terraform to provision cloud infrastructure
- Build and deploy containerized apps
- Debug complex cloud-native issues 
