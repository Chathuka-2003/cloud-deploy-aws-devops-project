# 🚀 CloudDeploy — AWS DevOps Deployment Platform

> **Production-style AWS DevOps project demonstrating automated CI/CD, containerized application deployment, Infrastructure as Code, AWS IAM/OIDC security, Amazon ECR, EC2, and AWS Systems Manager.**

[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue)](https://github.com/Chathuka-2003/cloud-deploy-aws-devops-project/actions)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED)](https://www.docker.com/)
[![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC)](https://www.terraform.io/)
[![Nginx](https://img.shields.io/badge/Nginx-Reverse%20Proxy-009639)](https://nginx.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 📌 Overview

**CloudDeploy** is an AWS-based DevOps deployment platform designed to demonstrate a complete modern application delivery workflow.

The project takes source code from a developer's local machine, pushes it to GitHub, automatically builds and tests the application through GitHub Actions, creates Docker images, pushes those images to Amazon ECR, and deploys the latest version to an AWS EC2 instance using AWS Systems Manager.

The deployed application consists of:

* A containerized frontend
* A containerized backend API
* Nginx reverse proxy
* Docker
* Amazon ECR
* AWS EC2
* AWS Systems Manager
* Terraform-managed infrastructure
* GitHub Actions CI/CD
* GitHub OIDC authentication with AWS IAM
* Automated deployment health checks

The goal is to demonstrate how a production-style DevOps pipeline can automate the complete journey from **source code → container image → cloud infrastructure → running application**.

---

# 🏗️ Architecture

## High-Level Architecture

<img width="1280" height="720" alt="CloudDeploy_animated" src="https://github.com/user-attachments/assets/9446a468-b662-4101-a9c0-80e7d3a3c43e" />


# 🔄 End-to-End DevOps Flow

The complete deployment lifecycle is:

```text
Developer
    │
    │ git push
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ├── Checkout source code
    │
    ├── Setup Node.js
    │
    ├── Install dependencies
    │
    ├── Run application checks
    │
    ├── Configure AWS credentials
    │       │
    │       └── GitHub OIDC → AWS IAM
    │
    ├── Login to Amazon ECR
    │
    ├── Build backend Docker image
    │
    ├── Build frontend Docker image
    │
    ├── Push images to ECR
    │
    ├── Trigger AWS SSM deployment
    │
    ▼
AWS EC2
    │
    ├── Pull backend image
    ├── Pull frontend image
    ├── Stop old containers
    ├── Remove old containers
    ├── Start backend container
    └── Start frontend container
    │
    ▼
Nginx
    │
    ├── /       → Frontend
    │
    └── /api/*  → Backend
    │
    ▼
Application
    │
    ▼
Automated Health Check
    │
    ├── Nginx
    ├── Backend container
    ├── Frontend container
    ├── /
    └── /api/health
```

---

# 🧰 Technology Stack

| Category                | Technology            |
| ----------------------- | --------------------- |
| Frontend                | HTML, CSS, JavaScript |
| Frontend Server         | Nginx                 |
| Backend                 | Node.js               |
| Backend Runtime         | Node.js               |
| Containerization        | Docker                |
| Container Orchestration | Docker Compose        |
| Reverse Proxy           | Nginx                 |
| Source Control          | Git / GitHub          |
| CI/CD                   | GitHub Actions        |
| Container Registry      | Amazon ECR            |
| Compute                 | Amazon EC2            |
| Remote Deployment       | AWS Systems Manager   |
| Authentication          | GitHub OIDC + AWS IAM |
| Infrastructure as Code  | Terraform             |
| Cloud Provider          | AWS                   |
| Operating System        | Ubuntu 24.04          |
| Region                  | `us-east-1`           |

---

# 📁 Project Structure

```text
cloud-deploy-aws-devops-project/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── backend/
│   └── Dockerfile
│
├── frontend/
│   ├── Dockerfile
│   └── index.html
│
├── nginx/
│   └── nginx.conf
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── vpc.tf
│   ├── security-group.tf
│   ├── ec2.tf
│   ├── ecr.tf
│   ├── iam.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
│
├── docker-compose.yml
├── .gitignore
└── README.md
```

---

# 🖥️ Application Components

## Frontend

The frontend is a static web application served through Nginx.

It provides the CloudDeploy dashboard interface and communicates with the backend through the `/api` route.

Example:

```text
GET /
```

The frontend is containerized using Docker.

---

## Backend

The backend is a Node.js API service.

Available endpoints:

```text
GET /api/hello
GET /api/health
```

Example health response:

```json
{
  "status": "UP"
}
```

Example application response:

```json
{
  "message": "Hello from CloudDeploy Backend!",
  "status": "success"
}
```

---

# 🌐 Nginx Reverse Proxy

Nginx provides the public entry point for the application.

The architecture uses:

```text
Internet
   │
   │ HTTP :80
   ▼
Host Nginx
   │
   ├── /api/*
   │       │
   │       ▼
   │   Backend
   │   :3001
   │
   └── /*
           │
           ▼
       Frontend
         :8080
```

### Routing

| Request       | Destination        |
| ------------- | ------------------ |
| `/`           | Frontend container |
| `/api/health` | Backend container  |
| `/api/hello`  | Backend container  |

This keeps the frontend and backend behind a single public endpoint.

---

# 🐳 Docker Architecture

The project uses separate containers for the frontend and backend.

```text
                 Docker Engine
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
    ┌───────────────┐   ┌───────────────┐
    │   Frontend    │   │    Backend    │
    │   Container   │   │   Container   │
    │               │   │               │
    │ Nginx :80     │   │ Node.js :8080 │
    └───────────────┘   └───────────────┘
```

### Host port mapping

```text
Frontend:
Host :8080 → Container :80

Backend:
Host :3001 → Container :8080
```

Host Nginx then exposes the application through:

```text
Port 80
```

---

# ☁️ AWS Infrastructure

The AWS infrastructure is managed using Terraform.

## VPC

The project creates a dedicated VPC:

```text
CIDR: 10.0.0.0/16
```

---

## Public Subnet

A public subnet is used for the EC2 instance:

```text
CIDR: 10.0.1.0/24
Availability Zone: us-east-1a
```

---

## EC2

The application runs on an Ubuntu 24.04 EC2 instance.

The instance hosts:

* Docker
* AWS CLI
* AWS Systems Manager Agent
* Nginx
* Frontend container
* Backend container

---

## Security Group

The EC2 security group controls inbound network traffic.

Required application access:

```text
TCP 80 → HTTP
```

SSH access:

```text
TCP 22 → SSH
```

For production environments, SSH should be restricted to trusted IP addresses or removed in favor of AWS Systems Manager.

---

# 🔐 Security Architecture

Security is a major part of this project.

## GitHub OIDC

GitHub Actions does not use long-lived AWS access keys.

Instead:

```text
GitHub Actions
      │
      │ OIDC token
      ▼
GitHub OIDC Provider
      │
      ▼
AWS IAM Role
      │
      │ temporary credentials
      ▼
AWS Services
```

This eliminates the need to store permanent AWS credentials in GitHub secrets.

---

# 👤 IAM Roles

Two important IAM roles are used.

## GitHub Actions Role

```text
CloudDeployGitHubActionsRole
```

Used by GitHub Actions to interact with AWS.

Primary permissions include:

* Amazon ECR authentication
* Docker image push
* AWS Systems Manager deployment

---

## EC2 Role

```text
clouddeploy-ec2-role
```

Attached to the EC2 instance.

The EC2 role allows the instance to:

* Pull images from Amazon ECR
* Communicate with AWS Systems Manager

No static AWS access keys are required on the EC2 server.

---

# 📦 Amazon ECR

Two repositories store the application's Docker images.

```text
clouddeploy-backend

clouddeploy-frontend
```

Images are tagged using the Git commit SHA.

Example:

```text
clouddeploy-backend:<commit-sha>

clouddeploy-frontend:<commit-sha>
```

A `latest` tag is also pushed for convenience.

The commit-based tag provides traceability between:

```text
Git commit
      ↓
Docker image
      ↓
ECR
      ↓
EC2 deployment
```

---

# 🚀 CI/CD Pipeline

The CI/CD pipeline is defined in:

```text
.github/workflows/ci.yml
```

The pipeline runs automatically when changes are pushed to the main branch.

## Pipeline stages

### 1. Checkout

GitHub Actions retrieves the repository source code.

```text
actions/checkout
```

---

### 2. Node.js Setup

The pipeline configures Node.js for backend operations.

---

### 3. Dependency Installation

Backend dependencies are installed before deployment.

---

### 4. AWS Authentication

GitHub Actions authenticates to AWS using:

```text
GitHub OIDC
        ↓
AWS IAM Role
```

---

### 5. ECR Login

GitHub Actions authenticates with Amazon ECR.

---

### 6. Docker Build

The pipeline builds:

```text
Backend Docker Image
Frontend Docker Image
```

---

### 7. Docker Push

Images are pushed to Amazon ECR using:

```text
<commit-sha>
latest
```

---

### 8. Deployment

AWS Systems Manager sends deployment commands to the EC2 instance.

The EC2 instance:

```text
docker pull
    ↓
stop old containers
    ↓
remove old containers
    ↓
start new containers
```

---

### 9. Health Check

After deployment, GitHub Actions verifies:

```text
Nginx
Backend container
Frontend container
Frontend endpoint
Backend health endpoint
```

The deployment is considered successful only if the health checks pass.

---

# 🔄 Deployment Strategy

The application is deployed using commit-based Docker image tags.

For example:

```text
Git commit:
b7b3a46

Backend:
clouddeploy-backend:b7b3a46

Frontend:
clouddeploy-frontend:b7b3a46
```

This provides deployment traceability.

You can identify exactly which Git commit produced a running application version.

---

# 🩺 Health Checks

The deployment pipeline performs automated verification after deployment.

Checks include:

```text
✓ Nginx is active
✓ Backend container is running
✓ Frontend container is running
✓ Frontend endpoint responds
✓ Backend /api/health responds
```

Backend health endpoint:

```text
/api/health
```

Expected response:

```json
{
  "status": "UP"
}
```

---

# 💻 Local Development

## Prerequisites

Install:

* Git
* Docker
* Docker Compose
* Node.js
* AWS CLI
* Terraform

---

## Clone the repository

```bash
git clone https://github.com/Chathuka-2003/cloud-deploy-aws-devops-project.git

cd cloud-deploy-aws-devops-project
```

---

## Run with Docker Compose

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker ps
```

---

## Access the application

Frontend:

```text
http://localhost:8080
```

Backend:

```text
http://localhost:3001
```

Backend health:

```bash
curl http://localhost:3001/api/health
```

Expected:

```json
{"status":"UP"}
```

---

# 🏗️ Terraform Deployment

Terraform is located in:

```text
terraform/
```

Initialize Terraform:

```bash
cd terraform
terraform init
```

Validate:

```bash
terraform validate
```

Format:

```bash
terraform fmt
```

Review the infrastructure plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

View outputs:

```bash
terraform output
```

---

# 🧹 Terraform Cleanup

To destroy Terraform-managed infrastructure:

```bash
terraform destroy
```

> ⚠️ Review the Terraform plan carefully before destroying AWS infrastructure.

Amazon ECR repositories are referenced by Terraform and were intentionally created separately. Do not destroy or recreate them unless that is specifically intended.

---

# 🔑 GitHub Configuration

The repository requires an AWS role variable for GitHub Actions.

Repository variable:

```text
AWS_ROLE_ARN
```

Example value:

```text
arn:aws:iam::<AWS_ACCOUNT_ID>:role/CloudDeployGitHubActionsRole
```

The workflow uses this variable to authenticate through GitHub OIDC.

No long-lived AWS access keys should be stored in the repository.

---

# 🧪 Testing

## Backend health

```bash
curl http://localhost:3001/api/health
```

Expected:

```json
{
  "status": "UP"
}
```

---

## Backend hello endpoint

```bash
curl http://localhost:3001/api/hello
```

Expected:

```json
{
  "message": "Hello from CloudDeploy Backend!",
  "status": "success"
}
```

---

## Frontend

```bash
curl http://localhost:8080/
```

---

## Production endpoint

Once deployed:

```text
http://<EC2-PUBLIC-IP>/
```

Backend health through Nginx:

```text
http://<EC2-PUBLIC-IP>/api/health
```

---

# 🔍 Useful AWS Commands

Check EC2:

```bash
aws ec2 describe-instances \
  --region us-east-1
```

Check ECR repositories:

```bash
aws ecr describe-repositories \
  --region us-east-1
```

Check SSM-managed instances:

```bash
aws ssm describe-instance-information \
  --region us-east-1
```

Check current AWS identity:

```bash
aws sts get-caller-identity
```

---

# 🖥️ EC2 Operations

SSH access:

```bash
ssh -i clouddeploy-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Check Docker:

```bash
docker ps
```

Check Nginx:

```bash
sudo systemctl status nginx
```

Test Nginx configuration:

```bash
sudo nginx -t
```

Reload Nginx:

```bash
sudo systemctl reload nginx
```

Check backend:

```bash
curl http://localhost:3001/api/health
```

Check frontend:

```bash
curl http://localhost:8080/
```

---

# 🛠️ Troubleshooting

## Docker containers are not running

Check:

```bash
docker ps -a
```

View logs:

```bash
docker logs clouddeploy-backend
docker logs clouddeploy-frontend
```

---

## Backend health check fails

Check the backend:

```bash
docker logs clouddeploy-backend
```

Test directly:

```bash
curl http://localhost:3001/api/health
```

---

## Frontend is unavailable

Check:

```bash
docker ps
```

Then:

```bash
curl http://localhost:8080/
```

Check Nginx:

```bash
sudo nginx -t
sudo systemctl status nginx
```

---

## Nginx returns 502

Check whether the backend is running:

```bash
docker ps
```

Test:

```bash
curl http://localhost:3001/api/health
```

Check Nginx configuration:

```bash
sudo nginx -t
```

Check logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

---

## SSM deployment fails

Check the instance:

```bash
aws ssm describe-instance-information \
  --region us-east-1
```

The instance should appear as:

```text
PingStatus: Online
```

Check the SSM agent:

```bash
sudo snap services amazon-ssm-agent
```

Check the EC2 IAM role:

```bash
aws sts get-caller-identity
```

---

# 📊 Monitoring

The current project includes deployment health verification through GitHub Actions and AWS Systems Manager.

Future production enhancements can include:

* Amazon CloudWatch
* CloudWatch Logs
* CloudWatch Alarms
* CPU monitoring
* Application metrics
* Centralized container logs
* Deployment notifications

---

# 🔒 Production Security Improvements

The current project demonstrates secure AWS authentication using GitHub OIDC.

For a real production environment, additional improvements are recommended:

### Network

* Restrict SSH access
* Prefer SSM over SSH
* Add HTTPS
* Use a domain name
* Use TLS certificates
* Consider private subnets
* Use an Application Load Balancer

### IAM

* Apply least-privilege permissions
* Restrict ECR repositories
* Restrict SSM permissions
* Restrict GitHub OIDC trust conditions

### Secrets

* Never commit credentials
* Use AWS Secrets Manager or Parameter Store
* Avoid static AWS access keys

### Deployment

* Add automatic rollback
* Add deployment approval for production
* Use blue/green or rolling deployments
* Add container image vulnerability scanning

---

# 📈 Future Improvements

The project can be extended with:

* [ ] HTTPS using ACM
* [ ] Custom domain
* [ ] Application Load Balancer
* [ ] Route 53
* [ ] CloudWatch monitoring
* [ ] CloudWatch Logs
* [ ] Automated rollback
* [ ] Blue/Green deployments
* [ ] Docker image vulnerability scanning
* [ ] Multi-environment support
* [ ] Staging environment
* [ ] Production environment
* [ ] Terraform remote state
* [ ] Terraform modules
* [ ] AWS Secrets Manager
* [ ] Database integration
* [ ] Auto Scaling
* [ ] ECS/EKS deployment
* [ ] Deployment notifications

---

# 🎯 DevOps Concepts Demonstrated

This project demonstrates practical knowledge of:

### Version Control

```text
Git
GitHub
Branching
Commits
Pull/Push workflow
```

### CI/CD

```text
GitHub Actions
Automated builds
Automated testing
Docker image publishing
Automated deployment
Health verification
```

### Containers

```text
Docker
Dockerfiles
Docker Compose
Container networking
Image tagging
Container lifecycle management
```

### AWS

```text
EC2
ECR
IAM
VPC
Security Groups
SSM
OIDC
```

### Infrastructure as Code

```text
Terraform
AWS provider
Variables
Outputs
Resource dependencies
Infrastructure provisioning
```

### Security

```text
IAM least privilege
GitHub OIDC
Temporary credentials
No static AWS credentials on EC2
Security Groups
```

---

# 🧠 What This Project Demonstrates

The most important aspect of CloudDeploy is that it connects multiple DevOps technologies into a single automated workflow.

Instead of manually logging into an EC2 server and deploying an application, the workflow becomes:

```text
Write Code
    ↓
Git Commit
    ↓
Git Push
    ↓
GitHub Actions
    ↓
Automated Build
    ↓
Docker Images
    ↓
Amazon ECR
    ↓
AWS Systems Manager
    ↓
EC2
    ↓
Docker Containers
    ↓
Nginx
    ↓
Live Application
    ↓
Automated Health Check
```

This demonstrates the core principle of **automation throughout the software delivery lifecycle**.

---

# 📋 Project Status

| Component               | Status                |
| ----------------------- | --------------------- |
| Frontend                | ✅ Complete            |
| Backend API             | ✅ Complete            |
| Docker                  | ✅ Complete            |
| Docker Compose          | ✅ Complete            |
| Nginx Reverse Proxy     | ✅ Complete            |
| Amazon ECR              | ✅ Complete            |
| EC2                     | ✅ Complete            |
| IAM                     | ✅ Complete            |
| GitHub OIDC             | ✅ Complete            |
| GitHub Actions          | ✅ Complete            |
| AWS SSM Deployment      | ✅ Complete            |
| Terraform               | ✅ Complete            |
| Automated Health Checks | ✅ Complete            |
| Production Dashboard    | ✅ Complete            |
| HTTPS                   | 🔄 Future Enhancement |
| CloudWatch Monitoring   | 🔄 Future Enhancement |
| Automated Rollback      | 🔄 Future Enhancement |

---

# 👨‍💻 Author

**Chathuka**

GitHub:

https://github.com/Chathuka-2003

Repository:

https://github.com/Chathuka-2003/cloud-deploy-aws-devops-project

---

# 📄 License

This project is available under the MIT License.

See `LICENSE` for more information.

---

# ⭐ If You Found This Project Useful

If this project helped you understand AWS, Docker, Terraform, or CI/CD, consider giving the repository a ⭐ on GitHub.

---

## 🚀 CloudDeploy

**From Git Push → Automated Build → ECR → SSM → EC2 → Docker → Nginx → Live Application.**
